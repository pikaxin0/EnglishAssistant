## Why

The current AHK translation GUI uses a dark theme that may not match all user preferences. The window size calculation can result in text that's too wide to read comfortably, and the loading indicator is static, making it unclear if the script is working or stuck. Additionally, the click-outside-to-dismiss behavior can be unintuitive and lead to accidental dismissals. These improvements will enhance usability and visual clarity.

## What Changes

- **BREAKING**: Change GUI theme from dark (#202020 background) to light (white/off-white background)
- Change window sizing to limit maximum width to ~120 characters per line
- Add animated loading indicator (spinner or progress animation) while Node.js CLI executes
- Change dismissal behavior from click-outside to ESC key press
- Update text colors for light theme contrast (dark text on light background)

## Capabilities

### New Capabilities
None - this change modifies existing AHK UI behavior only

### Modified Capabilities
- `ahk-user-interface`: Modifying GUI appearance, sizing, loading indicator, and dismissal behavior

## Impact

- **Modified files**: `cli/Translate.ahk` (GUI theming, sizing, animation, and key handling)
- **Modified files**: `cli/TranslateTest.ahk` (matching GUI updates for consistency)
- **Documentation**: Update README.md and CLAUDE.md with new dismissal method (ESC key)
- **User experience**: Light mode improves visibility in bright environments, better text wrapping improves readability, animated loading provides clearer feedback, ESC key dismissal is more intentional and discoverable
