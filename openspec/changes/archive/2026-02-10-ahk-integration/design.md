## Context

The English Assistant CLI currently requires manual text copying and terminal commands for translation. Users working across Windows applications (browsers, editors, documents) need a faster, less disruptive way to translate text. AutoHotkey v2.0 provides Windows UI Automation (UIA) integration that can capture selected text from any application without clipboard manipulation.

**Current State:**
- CLI requires: `npm run cli "text to translate"`
- User workflow: Copy text → Switch to terminal → Paste → Run command → Copy result
- CLI stdout outputs only the translated text (or error message)
- Project root contains `cli/`, `server/`, `shared/`, `web/`, `database/`

**Constraints:**
- AutoHotkey is Windows-only; CLI remains cross-platform
- Must not modify existing CLI behavior or exit codes
- AHK scripts must work regardless of project installation location
- User's example script uses UIA-v2 library (requires bundling or documentation)
- Users may want to bind their own hotkeys using their preferred keyboard manager

## Goals / Non-Goals

**Goals:**
- Enable command-line text capture and translation from any Windows application
- Allow integration with any keyboard manager or launcher
- Display translation results in a borderless GUI at cursor position
- Maintain existing CLI interface unchanged (stdout/exit codes)
- Support portable project installations (no hardcoded paths)
- Allow future extensibility for interactive actions (buttons, copy, etc.)
- Provide test mode for automation and verification

**Non-Goals:**
- Cross-platform support (AHK is Windows-specific)
- Two-way communication (CLI→AHK beyond stdout)
- Persistent background service (script runs on-demand)
- Modifying the Node.js CLI output format
- Built-in hotkey registration (delegated to keyboard managers)

## Decisions

### AHK File Structure

**Decision:** Place all `.ahk` files in `cli/` directory alongside CLI entry point.

**Rationale:**
- AHK scripts are CLI integration tools, logically belong with `cli/index.ts`
- Single location for all translation entry points
- Existing `cli/` structure already supports multiple files

**Alternatives Considered:**
- `cli/ahk/` subdirectory - Adds unnecessary nesting for 2-3 files
- Root directory scripts - Clutters project root, not self-contained

### UIA Library Distribution

**Decision:** Include UIA-v2 library in `cli/UIA-v2/` as git-tracked files.

**Rationale:**
- User's example script depends on this library
- Bundling ensures version compatibility
- No external dependency management for AHK ecosystem
- Small library size (~50-100KB)

**Alternatives Considered:**
- Require user to download - Adds setup friction, version mismatches
- Git submodule - Overcomplicated for small dependency
- Inline UIA code - Too large, loses library benefits

### Invocation Method

**Decision:** Use command line invocation with AutoHotkey64.exe interpreter.

**Rationale:**
- Allows integration with any keyboard manager or launcher
- Users can bind their preferred hotkeys
- Script runs on-demand, no persistent background process
- Supports command line arguments (--test, --select-all) for flexibility

**Alternatives Considered:**
- Built-in hotkey (F3) - Less flexible, requires users to adapt to our choice
- Persistent background service - Overkill for simple translation workflow
- GUI-based launcher - Adds complexity, not needed for this use case

### Command Line Arguments

**Decision:** Support `--test "<text>"` and `--select-all` flags.

**Rationale:**
- `--test` enables testing and automation without UIA dependencies
- `--select-all` allows auto-selection of all text before capture
- Flexible for different workflows (manual selection vs. auto-select)
- Test mode outputs to stdout for verification

**Alternatives Considered:**
- No arguments - Less flexible, harder to test
- Configuration file - Overkill for simple flags
- Environment variables - Less discoverable, harder to use

### CLI Invocation Method

**Decision:** Use `RunWait` with temp files for CLI communication.

**Rationale:**
- Avoids shell escaping issues with special characters
- UTF-8 encoding preserved via temp file write/read
- `RunWait` with "Hide" option prevents window flashing
- Simpler than shell.Exec() for stdout capture

**Code Pattern:**
```ahk
FileAppend(text, tempInputFile, "UTF-8")
RunWait('cmd /c cd /d "' . projectRoot . '" && npm run cli --silent -- "' . tempInputFile . '" > "' . tempOutputFile . '" 2>&1', , "Hide")
output := FileRead(tempOutputFile, "UTF-8")
```

**Alternatives Considered:**
- shell.Exec() with stdout polling - More complex, window flashing issues
- Direct argument passing - Shell escaping problems with quotes, special chars

### GUI Implementation

**Decision:** Use a borderless AHK Gui window for result display.

**Rationale:**
- Native AHK Gui controls, no external dependencies
- Allows future extensibility - can add buttons, links, or other controls
- Borderless + always-on-top for minimal visual footprint
- No keyboard focus stealing (`+AlwaysOnTop` without `+Owner` focus)
- Shows only translated text (clean, simple display)
- Positions at cursor for visibility
- Stays visible until user clicks outside (no timer needed)
- Clicks inside GUI can be handled for future actions

**Alternatives Considered:**
- ToolTip command - Simpler but not extensible (cannot add controls later)
- Gui dialog with title bar - More intrusive, larger footprint
- Windows Toast notifications - Requires additional Windows API calls, limited customization
- MessageBox - Blocks input, too intrusive for quick translations

### Working Directory Detection

**Decision:** AHK script infers project root from its own location using `A_ScriptDir`.

**Rationale:**
- Script runs from `cli/`, so project root is `..` (parent directory)
- Works with portable installations and symbolic links
- No environment variables or configuration files needed

**Code Pattern:**
```ahk
projectRoot := A_ScriptDir "\.."
workingDir := projectRoot
```

### Script Lifecycle Management

**Decision:** Script keeps running until GUI is dismissed via click-outside or close button.

**Rationale:**
- GUI must remain visible for user to read translation
- Script exits when user dismisses GUI (no background process)
- Clean one-shot execution model
- Uses global `scriptShouldExit` flag with waiting loop

**Code Pattern:**
```ahk
global scriptShouldExit := false
Main()

while (!scriptShouldExit) {
    Sleep 100
}
```

**Alternatives Considered:**
- Persistent background process - Overkill, uses resources unnecessarily
- Immediate exit after GUI show - GUI would disappear immediately

### Stdout Output in Test Mode

**Decision:** Output translation to stdout when `--test` flag is used.

**Rationale:**
- Enables testing and automation workflows
- Allows output capture in CI/CD or scripts
- `FileAppend(text, "*")` writes to stdout in AHK v2
- GUI still shows for visual confirmation

**Alternatives Considered:**
- No stdout output - Harder to test, no automation support
- Always output to stdout - Clutters normal GUI usage

### Single Instance Handling

**Decision:** Use `#SingleInstance Force` to replace existing instance on restart.

**Rationale:**
- Simplest user experience during development/testing
- No stale state from previous runs
- Matches user's example script pattern

**Alternatives Considered:**
- Multiple instance detection with warning - Adds complexity, rarely needed
- Unique instance per execution - Not useful for this use case

## Risks / Trade-offs

### Risk: UIA Compatibility

**Risk:** Some applications may not support UI Automation, leading to failed text capture.

**Mitigation:**
- Fallback to ValuePattern and Name property (as in user's example)
- Clear error messages listing supported application types
- Documentation of known compatible applications
- `--test` flag for testing without UIA dependencies

### Risk: Special Character Handling

**Risk:** Text with quotes, newlines, or shell metacharacters may break CLI invocation.

**Mitigation:**
- Use temp files for input/output (handles all characters correctly)
- UTF-8 encoding preserves international characters
- Add comprehensive testing with edge cases (JSON, code, etc.)

### Risk: Node.js Not in PATH

**Risk:** User may have Node.js installed but `npm` command not in system PATH.

**Mitigation:**
- Detect Node.js/npm availability at script startup
- Provide clear error message with installation/PATH configuration instructions
- Document PATH requirement in README

### Risk: Translation Latency

**Risk:** AI API translation takes 2-5 seconds, during which user may invoke script again.

**Mitigation:**
- Implement simple "translating in progress" flag to block duplicate requests
- Show minimal loading indicator
- Ignore subsequent script executions with feedback

### Trade-off: Windows-Only

**Trade-off:** AHK integration is Windows-specific, excluding macOS/Linux users.

**Rationale:**
- CLI remains fully functional on all platforms
- Target audience for this feature is Windows users (AHK ecosystem)
- Alternative platforms would need different automation tools (e.g., Automator on macOS)

## Migration Plan

**Deployment Steps:**
1. Add `.ahk` scripts to `cli/` directory
2. Include UIA-v2 library in `cli/UIA-v2/`
3. Update README.md with AHK installation and usage instructions
4. Update CLAUDE.md with testing procedures and common pitfalls

**Rollback Strategy:**
- Delete `cli/*.ahk` files and `cli/UIA-v2/` directory
- No changes to existing code, so zero rollback risk

**User Migration:**
- Existing CLI users unaffected (opt-in feature)
- New users follow AHK setup instructions in README
- Users bind their preferred hotkey in their keyboard manager

## Open Questions

1. **UIA Library Version:** Which specific version of UIA-v2 should be bundled? (Check user's example for version indicator)

2. **Future Actions:** What interactive controls should be added to the GUI? (e.g., Copy button, Re-translate button, Speak button) - For now, GUI displays text only, dismissed by clicking outside.

3. **Additional Arguments:** Should other command line arguments be added? (e.g., `--copy` to copy result to clipboard, `--no-gui` to suppress GUI) - Recommend: Add as user requests arise.
