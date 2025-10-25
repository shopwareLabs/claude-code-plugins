#!/usr/bin/env bash
# Edit validation utilities for comment-reviewing skill
# Pre-validates Edit tool inputs to reduce failures

set -euo pipefail

# Validate that a file exists and is readable
# Args:
#   $1 - File path
# Exit code: 0 if valid, 1 if not
validate_file_exists() {
    local file_path="$1"

    if [[ -z "$file_path" ]]; then
        echo "ERROR: No file path provided" >&2
        return 1
    fi

    if [[ ! -f "$file_path" ]]; then
        echo "ERROR: File does not exist: $file_path" >&2
        return 1
    fi

    if [[ ! -r "$file_path" ]]; then
        echo "ERROR: File is not readable: $file_path" >&2
        return 1
    fi

    return 0
}

# Check if a string exists in a file (for Edit tool old_string validation)
# Args:
#   $1 - File path
#   $2 - Search string
# Returns: Line number(s) where string was found (empty if not found)
# Exit code: 0 if found, 1 if not found, 2 if multiple matches
find_string_in_file() {
    local file_path="$1"
    local search_string="$2"

    if ! validate_file_exists "$file_path"; then
        return 1
    fi

    if [[ -z "$search_string" ]]; then
        echo "ERROR: No search string provided" >&2
        return 1
    fi

    # Use grep to find exact matches with line numbers
    local matches
    if ! matches=$(grep -Fn "$search_string" "$file_path" 2>/dev/null); then
        echo "ERROR: String not found in file: $file_path" >&2
        echo "Search string: $search_string" >&2
        return 1
    fi

    # Count number of matches
    local match_count
    match_count=$(echo "$matches" | wc -l | tr -d ' ')

    if [[ "$match_count" -gt 1 ]]; then
        echo "WARNING: String appears $match_count times in file (Edit requires unique match)" >&2
        echo "$matches" >&2
        return 2
    fi

    # Return line number of unique match
    echo "$matches" | cut -d: -f1
    return 0
}

# Check if Edit operation would be valid
# Args:
#   $1 - File path
#   $2 - Old string (to be replaced)
#   $3 - New string (replacement)
# Exit code: 0 if valid, 1 if invalid, 2 if ambiguous (multiple matches)
validate_edit_operation() {
    local file_path="$1"
    local old_string="$2"
    local new_string="$3"

    if ! validate_file_exists "$file_path"; then
        return 1
    fi

    if [[ -z "$old_string" ]]; then
        echo "ERROR: No old_string provided" >&2
        return 1
    fi

    if [[ -z "$new_string" ]]; then
        echo "ERROR: No new_string provided" >&2
        return 1
    fi

    if [[ "$old_string" == "$new_string" ]]; then
        echo "ERROR: old_string and new_string are identical" >&2
        return 1
    fi

    # Check if old_string exists in file
    local result
    if ! result=$(find_string_in_file "$file_path" "$old_string" 2>&1); then
        echo "$result" >&2
        return 1
    fi

    # Check for multiple matches (warning, but not fatal)
    local exit_code=$?
    if [[ $exit_code -eq 2 ]]; then
        echo "SUGGESTION: Add more context around the string to make it unique" >&2
        return 2
    fi

    echo "✓ Edit validation passed - unique match found at line: $result"
    return 0
}

# Suggest a more unique string by adding context lines
# Args:
#   $1 - File path
#   $2 - Search string
#   $3 - Number of context lines before and after (default: 2)
# Returns: Suggested string with context on stdout
# Exit code: 0 on success, 1 on error
suggest_unique_string() {
    local file_path="$1"
    local search_string="$2"
    local context_lines="${3:-2}"

    if ! validate_file_exists "$file_path"; then
        return 1
    fi

    # Find line number
    local line_num
    if ! line_num=$(grep -Fn "$search_string" "$file_path" 2>/dev/null | head -1 | cut -d: -f1); then
        echo "ERROR: String not found in file" >&2
        return 1
    fi

    # Get context lines
    local start_line=$((line_num - context_lines))
    [[ $start_line -lt 1 ]] && start_line=1

    local end_line=$((line_num + context_lines))

    echo "SUGGESTION: Use this string with context for unique matching:"
    echo "---"
    sed -n "${start_line},${end_line}p" "$file_path"
    echo "---"
    return 0
}

# Check if file is writable (for Edit tool)
# Args:
#   $1 - File path
# Exit code: 0 if writable, 1 if not
validate_file_writable() {
    local file_path="$1"

    if ! validate_file_exists "$file_path"; then
        return 1
    fi

    if [[ ! -w "$file_path" ]]; then
        echo "ERROR: File is not writable: $file_path" >&2
        return 1
    fi

    return 0
}

# Detect if file is likely generated/lock file (should skip editing)
# Args:
#   $1 - File path
# Exit code: 0 if should skip, 1 if safe to edit
should_skip_file() {
    local file_path="$1"

    # Check for common generated file patterns
    local skip_patterns=(
        "\.generated\."
        "vendor/"
        "node_modules/"
        "dist/"
        "build/"
        "\.lock$"
        "package-lock\.json"
        "composer\.lock"
        "yarn\.lock"
    )

    for pattern in "${skip_patterns[@]}"; do
        if [[ "$file_path" =~ $pattern ]]; then
            echo "WARNING: File appears to be generated/vendor/lock file: $file_path" >&2
            echo "Recommend skipping this file" >&2
            return 0
        fi
    done

    # Check for @generated marker in first 10 lines
    if head -10 "$file_path" 2>/dev/null | grep -q "@generated"; then
        echo "WARNING: File contains @generated marker: $file_path" >&2
        echo "Recommend skipping this file" >&2
        return 0
    fi

    return 1
}

# Main entry point for testing (optional)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Edit Validation Utilities - Available Functions:"
    echo "  validate_file_exists <file>"
    echo "  find_string_in_file <file> <string>"
    echo "  validate_edit_operation <file> <old_string> <new_string>"
    echo "  suggest_unique_string <file> <string> [context_lines]"
    echo "  validate_file_writable <file>"
    echo "  should_skip_file <file>"
    echo ""
    echo "Usage: source this file in your script and call functions directly"
fi
