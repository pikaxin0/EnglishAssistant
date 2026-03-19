## 1. Theme and Appearance Changes

- [x] 1.1 Update Translate.ahk background color from dark (#202020) to light (#FFFFFF)
- [x] 1.2 Update Translate.ahk normal text color from light (#FFFFFF) to dark (#202020)
- [x] 1.3 Update Translate.ahk error text color to red (#D32F2F)
- [x] 1.4 Update TranslateTest.ahk with matching light theme colors

## 2. Window Sizing Improvements

- [x] 2.1 Update window width calculation to use 120 character maximum (960 pixels)
- [x] 2.2 Implement character width constant (8 pixels per character for Segoe UI s10)
- [x] 2.3 Update guiWidth calculation: `Min(960, Max(200, calculatedWidth))`
- [x] 2.4 Update window height calculation to adapt to line count (lineHeight × 20 pixels + padding)
- [x] 2.5 Implement line height constant (20 pixels per line for Segoe UI s10)
- [x] 2.6 Update guiHeight calculation: `Min(600, Max(80, (lineCount × 20) + padding))`

## 3. Loading Animation Implementation

- [x] 3.1 Add global loading step counter variable
- [x] 3.2 Create UpdateLoadingGui function with animated dots logic
- [x] 3.3 Set timer for 200ms interval to update loading animation
- [x] 3.4 Clean up timer when translation completes

## 4. GUI Dismissal Implementation

- [x] 4.1 Remove click-outside monitoring timer (SetTimer(CheckClickOutside, 0))
- [x] 4.2 Remove CheckClickOutside function
- [x] 4.3 Register ESC key hotkey with ~Escape prefix for passthrough
- [x] 4.4 Register middle-mouse-button hotkey with ~MButton prefix for passthrough
- [x] 4.5 Update GuiClosed event handler to trigger on ESC key or middle-mouse-button
- [x] 4.6 Remove scriptShouldExit setting from click-outside logic

## 5. GUI Lifecycle Updates

- [x] 5.1 Update ShowGui to remove click-outside timer setup
- [x] 5.2 Update DestroyTranslatingGui to clean up animation timer
- [x] 5.3 Verify scriptShouldExit flag works with ESC key and middle-mouse-button dismissal

## 6. Documentation Updates

- [x] 6.1 Update README.md to reflect light theme and ESC key/middle-mouse-button dismissal
- [x] 6.2 Update CLAUDE.md with new dismissal methods (ESC and middle-mouse-button instead of click-outside)
- [x] 6.3 Update any references to dark theme in documentation
- [x] 6.4 Add note about 120 character line width limit

## 7. Command Line Testing

- [x] 7.1 Test --test flag with new light theme colors
- [x] 7.2 Verify script syntax with //ErrorStdOut flag
- [x] 7.3 Test stdout output with --test flag
