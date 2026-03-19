## 1. Setup and Dependencies

- [x] 1.1 Copy UIA-v2 library to `cli/UIA-v2/` directory from source or official repository
- [x] 1.2 Create main AHK script file `cli/Translate.ahk` with `#Requires`, `#SingleInstance`, and library include
- [x] 1.3 Test AHK script syntax and ensure it loads without errors

## 2. Text Capture Implementation

- [x] 2.1 Implement command line invocation (no hotkey registration)
- [x] 2.2 Add TextPattern.GetSelection() for primary text capture
- [x] 2.3 Add ValuePattern fallback for text boxes and combo boxes
- [x] 2.4 Add Name property fallback as last resort
- [x] 2.5 Implement error handling for no focused element and empty selection
- [x] 2.6 Add error GUIs for UIA exceptions with user-friendly messages
- [x] 2.7 Add `--select-all` flag to send Ctrl+A before text capture

## 3. CLI Bridge Implementation

- [x] 3.1 Implement project root detection using `A_ScriptDir` parent directory
- [x] 3.2 Use temp files for CLI communication (input/output)
- [x] 3.3 Implement `RunWait` call to `npm run cli` with "Hide" option
- [x] 3.4 Read output from temp file after CLI execution
- [x] 3.5 Handle CLI exit codes (0 for success, non-zero for error)
- [x] 3.6 Add Node.js/npm availability check at script startup with error message
- [x] 3.7 Add `--test` flag for testing without UIA text capture
- [x] 3.8 Add stdout output in test mode using `FileAppend(text, "*")`

## 4. User Interface Implementation

- [x] 4.1 Create borderless Gui window with `+AlwaysOnTop -Caption` options
- [x] 4.2 Add Text control to display translation result with dark theme (#202020 bg, light text)
- [x] 4.3 Position Gui at cursor coordinates with small offset
- [x] 4.4 Add "Translating..." loading Gui during CLI execution
- [x] 4.5 Implement "translation in progress" flag to block duplicate executions
- [x] 4.6 Handle click-outside to dismiss Gui (use Gui Close event or global click monitoring)
- [x] 4.7 Ensure clicks inside Gui are captured for future button/control handling
- [x] 4.8 Handle screen edge positioning for Gui visibility
- [x] 4.9 Implement Gui destroy/recreate logic for overlapping translations
- [x] 4.10 Implement script lifecycle management (scriptShouldExit flag with waiting loop)

## 5. Documentation

- [x] 5.1 Update README.md with AutoHotkey installation instructions
- [x] 5.2 Document command line invocation (keyboard manager integration)
- [x] 5.3 Document `--test` and `--select-all` command line flags
- [x] 5.4 Document GUI dismiss behavior (click outside to dismiss)
- [x] 5.5 List compatible applications (Notepad, browsers, modern Windows apps)
- [x] 5.6 Add troubleshooting section for common issues (Node.js not in PATH, UIA unavailable)
- [x] 5.7 Add note about Windows-only availability for AHK integration
- [x] 5.8 Update CLAUDE.md with AHK testing procedures and common syntax pitfalls

## 6. Testing and Verification

- [ ] 6.1 Test text capture from Notepad with short single-line text
- [ ] 6.2 Test text capture from browser (Chrome/Edge) with multi-line text
- [ ] 6.3 Test text capture from Wordpad with special characters and quotes
- [ ] 6.4 Test error handling when no text is selected
- [ ] 6.5 Test success GUI display and persistence (no auto-dismiss)
- [ ] 6.6 Test error GUI display and persistence (no auto-dismiss)
- [ ] 6.7 Test click-outside dismiss (GUI closes, click passes through)
- [ ] 6.8 Test click-inside keeps GUI visible (for future button support)
- [ ] 6.9 Test GUI positioning at cursor
- [ ] 6.10 Test GUI does not steal keyboard focus (can continue typing)
- [ ] 6.11 Test with JSON, code snippets, and other edge case text
- [ ] 6.12 Test that CLI remains functional when invoked directly (no regression)
- [ ] 6.13 Test portable installation (move project to different directory)
- [ ] 6.14 Test `--test` flag with various text inputs
- [ ] 6.15 Test `--select-all` flag with text boxes
- [ ] 6.16 Test script exit behavior (script exits after GUI is dismissed)
- [ ] 6.17 Test stdout output in test mode
