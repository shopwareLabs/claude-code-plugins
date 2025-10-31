# Codex Debugger

An escalation protocol plugin for Claude Code that automatically consults OpenAI's Codex (GPT-5) when you're stuck debugging after three failed attempts.

## What It Does

When Claude Code gets stuck trying to fix the same problem three times with no progress, this plugin automatically invokes a specialized agent that consults Codex for fresh analytical perspective.

**Why it helps**: Getting a completely fresh perspective from a different AI model (GPT-5 with high reasoning effort) often reveals blind spots, missed root causes, or alternative approaches that break debugging impasses.

**Progressive escalation**: Codex → User. If Codex consultation doesn't resolve the issue after three more attempts, you'll be notified.

## Quick Start

### Prerequisites

**Codex CLI and Authentication** (required):

For installation and authentication instructions, see the [official Codex CLI documentation](https://developers.openai.com/codex/).

You'll need an OpenAI account with access to Codex (typically included with ChatGPT Plus/Pro/Team subscriptions).

### Installation

```bash
/plugin install codex-debugger@shopware-plugins
```

**IMPORTANT**: After installing the plugin, you MUST restart Claude Code for the MCP server to initialize.

### Verification

Verify that Codex is properly configured:

```bash
/codex-check
```

This command performs a comprehensive pre-flight check and provides troubleshooting steps if issues are found.

**Example output when ready:**

```
Codex Pre-Flight Check Results
==============================

✓ Codex CLI: Installed (version 2.1.0)
✓ MCP Server: Registered and accessible
✓ Authentication: Valid
✓ API Access: Codex available

Status: Ready for use

The codex-debugger plugin is fully operational.
```

## Usage

### Automatic Escalation

The plugin works automatically. When Claude Code is stuck after three failed attempts with no progress, it will:

1. Recognize the "running in circles" pattern
2. Invoke the `codex-escalation` agent
3. Run pre-flight check to verify Codex MCP server is accessible
4. Gather complete context (goal, attempts, errors, relevant code)
5. Consult Codex (GPT-5) with high reasoning effort for concrete recommendations
6. Synthesize insights from both perspectives
7. Implement solution based on the analysis

You don't need to do anything - the escalation happens automatically.

### What Triggers Escalation

The agent is invoked when you're **running in circles**:

- Same error persists after three different fix approaches
- Fixes that solve nothing or reintroduce previous errors
- No new information gained from attempts

**Examples that trigger escalation:**
- Test fails identically after three different fixes
- Build error persists despite three solutions
- Same runtime error after three approaches

**Examples that do NOT trigger escalation:**
- Fixing error A reveals error B, then fixing B reveals error C (progress!)
- Each attempt reduces test failures (improvement!)
- Each fix provides new diagnostic information (learning!)

### Multi-Turn Conversations

If Codex needs clarification or additional information, the agent automatically continues the conversation:

1. Codex asks a clarifying question and provides a `conversationId`
2. Agent gathers the requested information
3. Agent continues the conversation using the `conversationId`
4. Process repeats until a complete solution is provided

**Note**: Some Codex versions have a known issue where `conversationId` may not be returned. In these cases, the agent performs single-turn consultation, which still provides analysis and recommendations but cannot support follow-up questions.

## Example Escalation Session

Here's what you'll see when escalation triggers:

```
Attempt 1: Fixing TypeError in user authentication...
❌ Error: TypeError: Cannot read property 'id' of undefined
   at authenticateUser (auth.js:42)

Attempt 2: Adding null check for user object...
❌ Error: TypeError: Cannot read property 'id' of undefined
   at authenticateUser (auth.js:42)

Attempt 3: Checking database query return value...
❌ Error: TypeError: Cannot read property 'id' of undefined
   at authenticateUser (auth.js:42)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 Escalation Protocol Triggered

I've attempted to fix this issue three times with no progress.
Invoking codex-escalation agent for fresh perspective...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Running pre-flight check...
✓ Codex MCP server accessible

Gathering context...
✓ Read auth.js
✓ Read user.model.js
✓ Collected error traces
✓ Summarized failed attempts

Consulting Codex (GPT-5) for analysis...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Codex Analysis Received

Root cause: The database query returns null when user not found,
but the code assumes it always returns a user object. The null
checks added in attempts 1-2 were placed AFTER the property access.

Recommended fix: Add early return check immediately after query,
before any property access.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Synthesis: Codex identified what I missed - I was adding null checks
but in the wrong place. The property access happens before my checks.

Implementing solution...
✓ Added early return check at line 38
✓ Tests passing

✓ Problem resolved!
```

## About Codex

This plugin uses **OpenAI Codex (GPT-5)** configured with **high reasoning effort** to provide deep analytical perspective when debugging challenges arise. Codex is consulted through the Model Context Protocol (MCP), which allows Claude to request concrete solutions and recommendations while maintaining full decision-making autonomy.

**Key principle**: Codex provides actionable recommendations with detailed reasoning, but the agent remains the decision-maker, validating and implementing suggestions using its own judgment.

## Common Issues

### MCP Server Not Starting

**Symptom**: After installing, `/mcp` doesn't show the `codex` server

**Solutions**:
1. Run `/codex-check` to diagnose the issue
2. Verify Codex CLI is installed: `codex --version`
3. **Restart Claude Code** (required after installation)
4. Check authentication: `codex login`

### "Command not found: codex"

**Symptom**: Error about `codex` command not being found

**Solution**:
```bash
# Install Codex CLI
npm install -g @openai/codex

# Restart Claude Code after installation
```

### Authentication Errors

**Symptom**: Codex MCP server fails with authentication errors

**Solution**:
```bash
# Re-authenticate
codex login

# Verify your OpenAI account has Codex access
# (included with ChatGPT Plus/Pro/Team subscriptions)
```

## License

MIT
