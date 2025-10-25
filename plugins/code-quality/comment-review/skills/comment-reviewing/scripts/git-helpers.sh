#!/usr/bin/env bash
# Git utility functions for comment-reviewing skill
# Provides reliable, error-handled git operations for scope detection

set -euo pipefail

# Detect the main branch name (main, master, trunk, or custom)
# Returns: Branch name on stdout
# Exit code: 0 on success, 1 on error
detect_main_branch() {
    local main_branch=""

    # Try to detect from symbolic-ref (most reliable)
    if main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'); then
        echo "$main_branch"
        return 0
    fi

    # Fallback: Check common branch names
    for branch in main master trunk; do
        if git rev-parse --verify "origin/$branch" >/dev/null 2>&1; then
            echo "$branch"
            return 0
        fi
    done

    # Fallback: Check local branches
    for branch in main master trunk; do
        if git rev-parse --verify "$branch" >/dev/null 2>&1; then
            echo "$branch"
            return 0
        fi
    done

    echo "ERROR: Could not detect main branch. Please specify branch explicitly." >&2
    return 1
}

# Validate that a commit reference exists
# Args:
#   $1 - Commit reference (SHA, HEAD~N, branch name, etc.)
# Returns: Commit SHA on stdout if valid
# Exit code: 0 if valid, 1 if invalid
validate_commit() {
    local commit_ref="$1"

    if [[ -z "$commit_ref" ]]; then
        echo "ERROR: No commit reference provided" >&2
        return 1
    fi

    if ! git rev-parse --verify "$commit_ref" >/dev/null 2>&1; then
        echo "ERROR: Invalid commit reference: $commit_ref" >&2
        return 1
    fi

    # Return the full SHA
    git rev-parse "$commit_ref"
    return 0
}

# Get list of changed files for git diff or commit range
# Args:
#   $1 - Scope type: "branch", "commit", "commit-range"
#   $2 - Reference (branch name, commit SHA, or range)
#   $3 - Optional: End reference for range
# Returns: List of changed file paths on stdout (one per line)
# Exit code: 0 on success, 1 on error
get_changed_files() {
    local scope_type="$1"
    local ref1="$2"
    local ref2="${3:-}"

    case "$scope_type" in
        branch)
            # Compare branch against current HEAD
            if ! git diff "$ref1...HEAD" --name-only 2>/dev/null; then
                echo "ERROR: Failed to get changed files for branch diff: $ref1...HEAD" >&2
                return 1
            fi
            ;;

        commit)
            # Single commit - get files changed in that commit
            if ! git diff-tree --no-commit-id --name-only -r "$ref1" 2>/dev/null; then
                echo "ERROR: Failed to get changed files for commit: $ref1" >&2
                return 1
            fi
            ;;

        commit-range)
            # Range of commits - get all files changed between them
            if [[ -z "$ref2" ]]; then
                echo "ERROR: Commit range requires two references" >&2
                return 1
            fi
            if ! git diff "$ref1^..$ref2" --name-only 2>/dev/null; then
                echo "ERROR: Failed to get changed files for range: $ref1^..$ref2" >&2
                return 1
            fi
            ;;

        commit-list)
            # List of commits - get all unique files changed across all commits
            local commits=($ref1)  # Split space-separated list into array
            local all_files=()

            for commit in "${commits[@]}"; do
                # Validate commit
                if ! validate_commit "$commit" >/dev/null 2>&1; then
                    echo "ERROR: Invalid commit in list: $commit" >&2
                    return 1
                fi

                # Get files for this commit and add to array
                while IFS= read -r file; do
                    all_files+=("$file")
                done < <(git diff-tree --no-commit-id --name-only -r "$commit" 2>/dev/null)
            done

            # Deduplicate and output
            printf '%s\n' "${all_files[@]}" | sort -u
            ;;

        *)
            echo "ERROR: Unknown scope type: $scope_type. Use 'branch', 'commit', 'commit-range', or 'commit-list'" >&2
            return 1
            ;;
    esac

    return 0
}

# Get diff content for commits (for analyzing added/modified lines)
# Args:
#   $1 - Scope type: "branch", "commit", "commit-range"
#   $2 - Reference (branch name, commit SHA, or range)
#   $3 - Optional: End reference for range
# Returns: Git diff content on stdout
# Exit code: 0 on success, 1 on error
get_diff_content() {
    local scope_type="$1"
    local ref1="$2"
    local ref2="${3:-}"

    case "$scope_type" in
        branch)
            # Compare branch against current HEAD
            if ! git diff "$ref1...HEAD" 2>/dev/null; then
                echo "ERROR: Failed to get diff for branch: $ref1...HEAD" >&2
                return 1
            fi
            ;;

        commit)
            # Single commit - show changes in that commit
            if ! git show "$ref1" 2>/dev/null; then
                echo "ERROR: Failed to get diff for commit: $ref1" >&2
                return 1
            fi
            ;;

        commit-range)
            # Range of commits - get all changes between them
            if [[ -z "$ref2" ]]; then
                echo "ERROR: Commit range requires two references" >&2
                return 1
            fi
            if ! git diff "$ref1^..$ref2" 2>/dev/null; then
                echo "ERROR: Failed to get diff for range: $ref1^..$ref2" >&2
                return 1
            fi
            ;;

        commit-list)
            # List of commits - show changes for each commit
            local commits=($ref1)  # Split space-separated list into array

            for commit in "${commits[@]}"; do
                # Validate commit
                if ! validate_commit "$commit" >/dev/null 2>&1; then
                    echo "ERROR: Invalid commit in list: $commit" >&2
                    return 1
                fi

                # Show changes for this commit
                if ! git show "$commit" 2>/dev/null; then
                    echo "ERROR: Failed to get diff for commit: $commit" >&2
                    return 1
                fi
            done
            ;;

        *)
            echo "ERROR: Unknown scope type: $scope_type. Use 'branch', 'commit', 'commit-range', or 'commit-list'" >&2
            return 1
            ;;
    esac

    return 0
}

# Parse commit range from user input (e.g., "last 3 commits" -> "HEAD~2..HEAD")
# Args:
#   $1 - User input string
# Returns: Commit range on stdout
# Exit code: 0 on success, 1 on error
parse_commit_range() {
    local input="$1"

    # Match "last N commits" or "last N"
    if [[ "$input" =~ last[[:space:]]+([0-9]+) ]]; then
        local count="${BASH_REMATCH[1]}"
        local start=$((count - 1))
        echo "HEAD~${start}..HEAD"
        return 0
    fi

    # Match "commit1..commit2" range
    if [[ "$input" =~ ([a-f0-9]+|HEAD[~^0-9]*)\.\.([a-f0-9]+|HEAD[~^0-9]*) ]]; then
        echo "$input"
        return 0
    fi

    echo "ERROR: Could not parse commit range from: $input" >&2
    echo "Expected format: 'last N commits' or 'commit1..commit2'" >&2
    return 1
}

# Check if we're in a git repository
# Exit code: 0 if in repo, 1 if not
check_git_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "ERROR: Not in a git repository" >&2
        return 1
    fi
    return 0
}

# Main entry point for testing (optional)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Git Helpers - Available Functions:"
    echo "  detect_main_branch"
    echo "  validate_commit <ref>"
    echo "  get_changed_files <type> <ref1> [ref2]"
    echo "  get_diff_content <type> <ref1> [ref2]"
    echo "  parse_commit_range <input>"
    echo "  check_git_repo"
    echo ""
    echo "Usage: source this file in your script and call functions directly"
fi
