## MODIFIED Requirements

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

## REMOVED Requirements

### Requirement: Left-click dismiss

**Reason:** Replaced by ESC key and middle-mouse-button dismiss for more intentional, discoverable interaction. Left-click is preserved for potential future interactive controls.

**Migration:** Users should press ESC key or click middle mouse button to dismiss the GUI instead of clicking outside. The click-outside detection timer-based monitoring is removed.
