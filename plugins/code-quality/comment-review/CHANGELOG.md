# Changelog

## [1.0.0] - 2025-10-22

Initial release.

### Skill - Comment Reviewing
- Comment review following "why not what" principle with five-category action system (Remove, Improve, Keep, Flag, Condense)
- Intelligent comment type detection (implementation vs API documentation) with multi-language support
- Git integration with consistency checking and pre-edit validation
- Project-specific configuration via `.reviewrc.md` with adaptive output formats
- Special cases handling (legacy code, algorithms, generated code)

### Commands
- `/comment-review` - Review and improve comments with smart scope detection
- `/comment-check` - Analyze comment quality (read-only)
- Support for files, directories, --git flag, commits, ranges, and commit lists
