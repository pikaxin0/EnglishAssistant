# AHK Text Capture Capability

## Purpose

Enables AutoHotkey scripts to capture selected text from Windows applications using UI Automation (UIA). This provides seamless text extraction without clipboard manipulation, supporting a wide range of applications including browsers, text editors, and modern Windows apps.

## Requirements

### Requirement: UI Automation text capture

The system SHALL use Windows UI Automation (UIA) to capture text selected by the user in any application.

#### Scenario: Capture via TextPattern

- **WHEN** user triggers the script and the focused element supports TextPattern
- **THEN** the system retrieves the selected text using TextPattern.GetSelection()
- **AND** the text is returned as a string

#### Scenario: Capture via ValuePattern fallback

- **WHEN** TextPattern is not available or returns no selection
- **THEN** the system attempts to retrieve text via ValuePattern
- **AND** the focused element's Value property is returned

#### Scenario: Capture via Name property fallback

- **WHEN** neither TextPattern nor ValuePattern yield text
- **THEN** the system attempts to retrieve the focused element's Name property
- **AND** the Name property is returned as fallback text

### Requirement: Command line invocation

The system SHALL be invoked via command line for integration with keyboard managers.

#### Scenario: Direct invocation

- **WHEN** the AutoHotkey script is executed from command line or keyboard manager
- **THEN** the script immediately begins text capture and translation workflow
- **AND** no hotkey registration is required

#### Scenario: Keyboard manager integration

- **WHEN** a keyboard manager or launcher invokes the script
- **THEN** the script executes the translation workflow
- **AND** the user can bind any hotkey they prefer in their keyboard manager

### Requirement: Select-all flag support

The system SHALL support an optional `--select-all` flag to auto-select all text before capturing.

#### Scenario: --select-all flag provided

- **WHEN** the script is invoked with `--select-all` flag
- **THEN** the system sends Ctrl+A keyboard input before text capture
- **AND** waits 50ms for the selection to complete
- **AND** then proceeds with UIA text capture

#### Scenario: --select-all flag omitted

- **WHEN** the script is invoked without `--select-all` flag
- **THEN** the system proceeds directly to UIA text capture
- **AND** no keyboard input is sent

### Requirement: Test mode flag support

The system SHALL support a `--test` flag to bypass UIA text capture.

#### Scenario: --test flag with text

- **WHEN** the script is invoked with `--test "<text>"`
- **THEN** the system uses the provided text directly
- **AND** UIA text capture is completely bypassed
- **AND** the provided text is used for translation

#### Scenario: --test flag with --select-all

- **WHEN** both `--test` and `--select-all` flags are provided
- **THEN** the `--test` text takes precedence
- **AND** the `--select-all` flag is ignored (no UIA capture needed)

### Requirement: Error handling for failed capture

The system SHALL gracefully handle cases where text capture fails.

#### Scenario: No focused element

- **WHEN** the script is executed and no UI element has keyboard focus
- **THEN** the system displays a brief error message
- **AND** no translation attempt is made
- **AND** the script exits after the error message is dismissed

#### Scenario: Empty text selection

- **WHEN** the script is executed but no text is selected in the focused element
- **THEN** the system displays a message indicating no text was detected
- **AND** the message includes supported application types
- **AND** mentions the `--test` flag for testing
- **AND** no translation attempt is made

#### Scenario: UI Automation unavailable

- **WHEN** UI Automation is not available or throws an exception
- **THEN** the system displays an error message with the exception details
- **AND** the script exits after the error message is dismissed

### Requirement: Application compatibility

The system SHALL capture text from a wide range of Windows applications.

#### Scenario: Standard text editors

- **WHEN** text is selected in Notepad, Notepad++, Wordpad, or similar editors
- **THEN** the selected text is captured successfully

#### Scenario: Web browsers

- **WHEN** text is selected in Chrome, Edge, Firefox, or other UIA-compatible browsers
- **THEN** the selected text is captured successfully

#### Scenario: Modern Windows apps

- **WHEN** text is selected in UWP or modern Windows applications with UIA support
- **THEN** the selected text is captured successfully

### Requirement: Single instance enforcement

The system SHALL ensure only one instance of the AutoHotkey script runs at a time.

#### Scenario: Script already running

- **WHEN** a user attempts to start the AutoHotkey script while another instance is running
- **THEN** the new instance replaces the old instance
- **AND** no duplicate hotkey registrations occur

### Requirement: AutoHotkey version requirement

The system SHALL require AutoHotkey v2.0 or later.

#### Scenario: Version check

- **WHEN** the script is executed
- **THEN** the script requires AutoHotkey v2.0 syntax and features
- **AND** execution fails with a clear error message if run with v1.1
