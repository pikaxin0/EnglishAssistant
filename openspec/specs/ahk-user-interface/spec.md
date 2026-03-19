# AHK User Interface Capability

## Purpose

Provides a borderless, non-intrusive GUI for displaying translation results from AutoHotkey scripts. The GUI appears at the cursor position, uses a light theme, and can be dismissed by pressing ESC key or clicking the middle mouse button. Designed for future extensibility with interactive controls.

## Requirements

### Requirement: Borderless GUI display for translation result

The system SHALL display the translation result in a borderless AHK Gui window.

#### Scenario: Successful translation GUI

- **WHEN** the CLI returns a successful translation
- **THEN** a borderless Gui appears at the cursor position showing the translated text
- **AND** the Gui remains visible until dismissed by user action

#### Scenario: Error GUI

- **WHEN** the CLI returns an error message
- **THEN** a borderless Gui appears at the cursor position showing the error message
- **AND** the Gui is visually distinct (e.g., different background color or "Error: " prefix)

### Requirement: GUI content

The system SHALL display the translated text in the Gui window.

#### Scenario: Text display

- **WHEN** the translation result is displayed
- **THEN** the Gui shows the translated text
- **AND** original text is NOT shown (Gui shows only translation)
- **AND** text is readable with appropriate font and colors

#### Scenario: Multi-line text

- **WHEN** the translation result contains multiple lines
- **THEN** the Gui displays the full text with line breaks preserved
- **AND** the Gui height adjusts to fit content

### Requirement: GUI positioning

The system SHALL position the Gui at the mouse cursor location.

#### Scenario: Cursor position

- **WHEN** the Gui is displayed
- **THEN** the Gui appears at the current cursor position with small offset
- **AND** the Gui does not obscure the cursor or selected text

#### Scenario: Screen edge handling

- **WHEN** the cursor is near a screen edge
- **THEN** the Gui adjusts position to remain fully visible on screen

### Requirement: GUI appearance

The system SHALL provide a clean, minimal appearance for the Gui using a light theme.

#### Scenario: Borderless window

- **WHEN** the Gui is displayed
- **THEN** the window has no title bar, borders, or controls
- **AND** only the content is visible

#### Scenario: Always-on-top

- **WHEN** the Gui is displayed
- **THEN** the window stays above other applications
- **AND** the Gui does not steal keyboard focus

#### Scenario: Light theme

- **WHEN** the Gui is displayed
- **THEN** the background uses a white or off-white color (e.g., #FFFFFF or #F5F5F5)
- **AND** text uses a dark color for contrast (e.g., #202020 or #333333)
- **AND** error text uses a distinct red color (e.g., #D32F2F)

#### Scenario: Window width sizing

- **WHEN** the Gui is displayed
- **THEN** the window width is calculated to display approximately 120 characters per line maximum
- **AND** the minimum width is 200 pixels
- **AND** the maximum width is 960 pixels (120 chars × 8 pixels/char)

#### Scenario: Window height sizing

- **WHEN** the Gui is displayed with multi-line text content
- **THEN** the window height is calculated based on the number of lines in the translation result
- **AND** each line accounts for approximately 20 pixels of height
- **AND** padding is added to the calculated height
- **AND** the minimum height is 80 pixels
- **AND** the maximum height is 600 pixels

### Requirement: Loading indicator

The system SHALL show animated visual feedback while translation is in progress.

#### Scenario: Animated progress GUI during translation

- **WHEN** the CLI is executing (which may take 2-5 seconds)
- **THEN** a borderless Gui appears showing animated loading text (e.g., "Translating" with pulsing dots)
- **AND** the animation updates approximately every 200ms to show activity
- **AND** the Gui remains visible until the translation completes
- **AND** the Gui is replaced by the result or error Gui when complete

### Requirement: GUI dismiss

The system SHALL dismiss the Gui when the user presses the ESC key or clicks the middle mouse button.

#### Scenario: ESC key to dismiss

- **WHEN** the user presses the ESC key while the Gui is visible
- **THEN** the Gui is immediately hidden
- **AND** the script exits cleanly

#### Scenario: Middle-mouse-button click to dismiss

- **WHEN** the user clicks the middle mouse button while the Gui is visible
- **THEN** the Gui is immediately hidden
- **AND** the script exits cleanly

#### Scenario: ESC key passthrough

- **WHEN** the user presses the ESC key to dismiss the Gui
- **THEN** the ESC key press is also passed through to the underlying application
- **AND** the application can handle its own ESC key behavior

#### Scenario: Middle-mouse-button passthrough

- **WHEN** the user clicks the middle mouse button to dismiss the Gui
- **THEN** the middle mouse button click is also passed through to the underlying application
- **AND** the application can handle its own middle mouse button behavior

#### Scenario: Other keys/buttons do not dismiss

- **WHEN** the user presses any key other than ESC while the Gui is visible
- **THEN** the Gui remains visible
- **AND** the key press is passed through to the underlying application

#### Scenario: Left/right mouse clicks do not dismiss

- **WHEN** the user clicks the left or right mouse button while the Gui is visible
- **THEN** the Gui remains visible
- **AND** the mouse click is passed through to the underlying application

### Requirement: Non-intrusive behavior

The system SHALL minimize disruption to the user's workflow.

#### Scenario: No focus stealing

- **WHEN** the Gui appears and disappears
- **THEN** keyboard focus remains with the active application
- **AND** the user can continue typing immediately

#### Scenario: Overlapping GUIs

- **WHEN** the user triggers a new translation while a Gui is visible
- **THEN** the old Gui is destroyed and replaced by the new one
- **AND** no duplicate GUIs appear

#### Scenario: Persistent display

- **WHEN** no user action is taken
- **THEN** the Gui remains visible indefinitely
- **AND** the Gui does not disappear on its own

### Requirement: Extensibility for future actions

The system SHALL support adding interactive elements to the Gui in the future.

#### Scenario: Control support

- **WHEN** the Gui is created
- **THEN** the Gui structure allows adding buttons, links, or other controls
- **AND** controls can be added without redesigning the entire Gui
