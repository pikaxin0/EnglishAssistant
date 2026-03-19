## Why

The current CLI translation tool requires users to manually copy text, switch to a terminal, and run the command. This workflow is inefficient for users who want quick translations from any Windows application. An AutoHotkey script would enable seamless text capture and translation via command line invocation, allowing integration with any keyboard manager or launcher. This provides flexibility for users to bind their preferred hotkey while maintaining the core translation functionality.

## What Changes

- Add AutoHotkey v2.0 scripts to the `cli/` directory
- Implement UI Automation (UIA) integration to capture selected text from any Windows application
- Create a command-line invocable script that accepts `--test` and `--select-all` flags
- Display translation results in a non-intrusive borderless GUI at cursor position
- Include UIA library dependency for AHK scripts
- Add installation and configuration documentation for AHK integration
- Add stdout output mode for testing and automation

## Capabilities

### New Capabilities
- `ahk-text-capture`: Capability to capture selected text from Windows applications using UI Automation
- `ahk-cli-bridge`: Capability to invoke the Node.js CLI from AutoHotkey and display results
- `ahk-user-interface`: Capability to display translation results in a user-friendly borderless GUI
- `ahk-cli-arguments`: Capability to accept command line arguments (--test, --select-all) for flexible invocation
- `ahk-test-mode`: Capability to output translation to stdout for testing and automation

### Modified Capabilities
- None - this change adds new functionality without modifying existing CLI behavior

## Impact

- **New files**: `cli/*.ahk` (AutoHotkey scripts), `cli/UIA-v2/` (UIA library dependency)
- **Documentation**: Updates to README.md with AHK installation and usage instructions
- **Dependencies**: AutoHotkey v2.0 (user-side requirement, not npm)
- **Cross-platform**: AHK integration is Windows-specific; CLI remains cross-platform
- **Integration**: Works with any keyboard manager or launcher via command line invocation
