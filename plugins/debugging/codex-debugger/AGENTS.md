@README.md

## Directory & File Structure

```
plugins/debugging/codex-debugger/
├── README.md
├── CHANGELOG.md
├── LICENSE
├── .mcp.json                               # MCP server configuration
├── agents/
│   └── codex-escalation.md                 # Main escalation protocol agent
└── commands/
    └── codex-check.md                      # Pre-flight verification command
```

## Components

- **Agent**: `agents/codex-escalation.md`
- **Command**: `commands/codex-check.md`
- **MCP Server**: `.mcp.json`

## Key Navigation Points

### Finding Specific Functionality

| Task | Primary File | Key Concepts |
|------|--------------|--------------|
| Modify escalation trigger conditions | `agents/codex-escalation.md` | Lines 22-60 "Recognition Patterns" |
| Add/modify validation steps | `agents/codex-escalation.md` | Step 0 (pre-flight), Step 1 (context validation) |
| Adjust Codex consultation format | `agents/codex-escalation.md` | Step 2 "Format Your Prompt" section |
| Change implementation strategy | `agents/codex-escalation.md` | Step 3 "Implement and Validate Solution" |
| Modify second-level escalation | `agents/codex-escalation.md` | Step 5 "Second-Level Escalation" |
| Update pre-flight check logic | `commands/codex-check.md` | Steps 1-5 verification sequence |
| Configure Codex model/parameters | `.mcp.json` | `args` array (model, reasoning effort) |
| Add new agent tools | `agents/codex-escalation.md` | Line 4 `tools:` frontmatter |


## When to Modify What

**Changing when escalation triggers** → Edit `agents/codex-escalation.md` description (line 3) and "Recognition Patterns" section (lines 22-60)

**Adding context gathering steps** → Edit `agents/codex-escalation.md` Step 1 "Required Information" (lines 123-148)

**Modifying Codex prompt template** → Edit `agents/codex-escalation.md` Step 2 "Format Your Prompt" (lines 150-175)

**Adjusting Codex model or reasoning effort** → Edit `.mcp.json` args array (lines 5-10)

**Adding pre-flight validation checks** → Edit `commands/codex-check.md` Steps 1-5 (lines 9-94)

**Changing escalation to user behavior** → Edit `agents/codex-escalation.md` Step 5 (lines 265-290)

**Updating Known Issues documentation** → Edit `agents/codex-escalation.md` "Known Issues & Workarounds" section (lines 290-296)


## Integration Points

### MCP Server Configuration

- **Server name**: `codex`
- **Tools provided**: `mcp__codex__codex`, `mcp__codex__codex-reply`
- **Model**: GPT-5 with high reasoning effort (`gpt-5`, `model_reasoning_effort=high`)
- **Command**: `codex mcp-server`
- **Configuration**: `.mcp.json` in plugin root
- **Installation requirement**: Must restart Claude Code after installing plugin

### External Dependencies

**Codex CLI** (required):
- Install: `npm install -g @openai/codex` or `brew install codex`
- Authentication: `codex login`
- Verification: `/codex-check` command

**OpenAI Account** (required):
- ChatGPT Plus/Pro/Team subscription typically required for Codex access
- Provides GPT-5 model access

### Invocation Pattern

- **Automatic**: Agent is model-invoked when main Claude detects "running in circles" pattern
- **Manual verification**: `/codex-check` command for setup diagnostics
- **Architecture**: Agent runs in separate context window for fresh perspective

## Related Documentation

- **User guide**: [README.md](./README.md)
- **Installation**: [README.md](./README.md#quick-start)
- **Agent implementation**: [agents/codex-escalation.md](./agents/codex-escalation.md)
- **Pre-flight verification**: [commands/codex-check.md](./commands/codex-check.md)
- **MCP configuration**: [.mcp.json](./.mcp.json)
- **Changelog**: [CHANGELOG.md](./CHANGELOG.md)
- **Codex CLI docs**: https://developers.openai.com/codex/
