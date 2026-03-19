## ADDED Requirements

### Requirement: Invoke Node.js CLI from AutoHotkey

The system SHALL invoke the Node.js CLI with captured text as an argument.

#### Scenario: Execute CLI command

- **WHEN** text is successfully captured by the UIA integration
- **THEN** the system executes `npm run cli` with the captured text passed via temp file
- **AND** the captured text is written to a temp file and the temp file path is passed to the CLI

#### Scenario: Escape special characters

- **WHEN** the captured text contains quotes, backslashes, or other shell-special characters
- **THEN** the text is written to a UTF-8 encoded temp file
- **AND** the CLI receives the exact text that was captured via file read

### Requirement: Capture CLI stdout output

The system SHALL capture the stdout output from the Node.js CLI execution.

#### Scenario: Successful translation output

- **WHEN** the CLI successfully translates text
- **THEN** the system reads the translated text from the output temp file
- **AND** the captured text is passed to the result display

#### Scenario: Error output

- **WHEN** the CLI encounters an error and outputs an error message to stdout
- **THEN** the system captures the error message from the output temp file
- **AND** the error message is displayed to the user

### Requirement: Detect CLI exit code

The system SHALL check the CLI process exit code to determine success or failure.

#### Scenario: Exit code 0

- **WHEN** the CLI exits with code 0
- **THEN** the system treats the execution as successful
- **AND** the stdout content is displayed as the translation result

#### Scenario: Non-zero exit code

- **WHEN** the CLI exits with a non-zero code (e.g., 1 for error)
- **THEN** the system treats the execution as failed
- **AND** the stdout content (error message) is displayed as an error

### Requirement: Working directory handling

The system SHALL execute the CLI from the project root directory.

#### Scenario: Execute from project root

- **WHEN** the AutoHotkey script invokes the CLI
- **THEN** the working directory is set to the project root containing package.json
- **AND** the CLI can access all its dependencies and shared modules

#### Scenario: Portable project location

- **WHEN** the project is moved to a different directory
- **THEN** the AutoHotkey script automatically detects the new project root
- **AND** CLI invocation works without script modification

### Requirement: Asynchronous execution handling

The system SHALL handle the CLI execution asynchronously without blocking.

#### Scenario: Non-blocking CLI call

- **WHEN** the CLI is invoked (which may take several seconds for AI translation)
- **THEN** the AutoHotkey script waits for completion
- **AND** subsequent script executions are blocked until current translation completes

#### Scenario: Translation in progress indicator

- **WHEN** a CLI translation is in progress and the script is executed again
- **THEN** the system displays a "translation in progress" message
- **AND** the new translation request is ignored

### Requirement: Node.js runtime detection

The system SHALL verify that Node.js is available before attempting CLI invocation.

#### Scenario: Node.js not found

- **WHEN** the AutoHotkey script attempts to invoke the CLI and Node.js is not installed
- **THEN** the system displays a clear error message
- **AND** the message includes instructions to install Node.js
- **AND** no CLI invocation is attempted

### Requirement: Command line argument support

The system SHALL accept command line arguments for flexible invocation.

#### Scenario: --test flag

- **WHEN** the script is invoked with `--test "<text>"`
- **THEN** the system uses the provided text directly for translation
- **AND** UIA text capture is bypassed
- **AND** the translation result is output to stdout in addition to GUI display

#### Scenario: --select-all flag

- **WHEN** the script is invoked with `--select-all` flag
- **THEN** the system sends Ctrl+A before capturing text
- **AND** all text in the focused element is selected and captured

#### Scenario: Combined flags

- **WHEN** the script is invoked with both `--test` and `--select-all` flags
- **THEN** the `--test` text takes precedence
- **AND** the `--select-all` flag is ignored (no UIA capture needed)

### Requirement: Script lifecycle management

The system SHALL keep the script running until the GUI is dismissed.

#### Scenario: Script exit on GUI close

- **WHEN** the translation result GUI is displayed
- **THEN** the script continues running until the GUI is dismissed
- **AND** the script exits when the user clicks outside the GUI or closes it

#### Scenario: Script exit flag

- **WHEN** the GUI is dismissed (close button or click-outside)
- **THEN** a global exit flag is set to true
- **AND** the main waiting loop detects the flag and allows the script to exit

### Requirement: Stdout output in test mode

The system SHALL output translation results to stdout when in test mode.

#### Scenario: Test mode stdout

- **WHEN** the script is invoked with `--test` flag
- **THEN** the translation result is written to stdout using `FileAppend`
- **AND** the output includes a newline character
- **AND** the result is also displayed in the GUI for visual confirmation

### Requirement: Hidden CLI execution

The system SHALL execute the CLI command hidden without showing command prompt windows.

#### Scenario: RunWait with Hide option

- **WHEN** invoking the CLI via RunWait
- **THEN** the "Hide" option is used to prevent command window flashing
- **AND** no visible windows appear during CLI execution
