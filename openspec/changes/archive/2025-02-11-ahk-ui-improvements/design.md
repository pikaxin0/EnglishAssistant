## Context

The current AHK translation GUI uses a dark theme (#202020 background) with light text. The window sizing is based on character count estimates which can result in text that's too wide for comfortable reading. The loading indicator is a static "Translating..." message, which doesn't provide clear visual feedback that the script is actively working. The dismissal mechanism relies on clicking outside the GUI, which can be unintuitive and lead to accidental closures.

**Current State:**
- Dark theme: `BackColor := "202020"`, text color `"FFFFFF"` (white) / `"FF6B6B"` (error red)
- Window width: calculated as `Min(600, Max(200, maxWidth + 40))` where maxWidth is `StrLen(line) * 8`
- Loading: Static Gui with "Translating..." text
- Dismissal: Click-outside detection with timer-based monitoring

**Constraints:**
- Must maintain AutoHotkey v2.0 compatibility
- Must keep GUI responsive during Node.js CLI execution
- Must preserve non-intrusive behavior (no focus stealing)
- Must work with existing script lifecycle (scriptShouldExit flag)

## Goals / Non-Goals

**Goals:**
- Switch to light theme for better visibility in bright environments
- Implement intelligent text wrapping with ~120 characters per line maximum
- Add animated loading indicator (spinner or pulsing effect) during CLI execution
- Change dismissal to ESC key press for more intentional, discoverable interaction

**Non-Goals:**
- Changing GUI positioning logic (keep at cursor with screen edge handling)
- Modifying the translation CLI or its output
- Adding configurable themes (single light theme only)
- Implementing timeout-based auto-dismissal

## Decisions

### Theme Colors

**Decision:** Use light theme with off-white background and dark text.

**Rationale:**
- Off-white background (e.g., `#F5F5F5` or `#FFFFFF`) reduces eye strain in bright environments
- Dark text (e.g., `#202020` or `#333333`) provides better contrast than light-on-dark for many users
- Error text in red (`#D32F2F` or similar) maintains visual distinction

**Colors:**
- Background: `#FFFFFF` (pure white)
- Normal text: `#202020` (nearly black)
- Error text: `#D32F2F` (material design red)

**Alternatives Considered:**
- Medium gray background - Less clean, harder to match with system themes
- Configurable themes - Adds complexity, not required for initial improvement
- System theme detection - Would require Windows API calls, overkill for this use case

### Text Wrapping and Window Sizing

**Decision:** Calculate window width based on ~120 character maximum and height based on line count.

**Rationale:**
- 120 characters per line is a standard readable width (from typography research)
- Window height should adapt to content to show full translation without excessive empty space
- AutoHotkey Gui doesn't support automatic text wrapping, so we must size the window appropriately
- Using `Segoe UI` font at size 10, approximate character width is 7-8 pixels, line height is ~20 pixels

**Calculation:**
```ahk
; Width calculation
charWidth := 8  ; Approximate pixels per character for Segoe UI s10
maxCharsPerLine := 120
maxWidth := maxCharsPerLine * charWidth  ; 960 pixels maximum
guiWidth := Min(maxWidth, Max(200, calculatedWidth))

; Height calculation
lineHeight := 20  ; Approximate pixels per line for Segoe UI s10
lineCount := textLines.Length
guiHeight := Min(600, Max(80, (lineCount * lineHeight) + padding))
```

**Alternatives Considered:**
- Fixed width/height - Too rigid, doesn't adapt to content
- Character-based wrapping - Not natively supported in AHK Gui without complex text measurement
- Multi-line Gui with line breaks - Adds complexity for minimal benefit

### Loading Animation

**Decision:** Use a pulsing/rotating text indicator to show activity during CLI execution.

**Rationale:**
- True progress bars are not possible since CLI execution time is variable and unknown
- Animated dots or rotating characters provide clear "something is happening" feedback
- Simple to implement with AHK's `SetTimer` and text manipulation

**Implementation:**
```ahk
global loadingStep := 0
loadingText := "Translating"
; Update with: loadingText . StrRep(".", Mod(loadingStep, 4))
; Increment loadingStep in timer callback
```

**Alternatives Considered:**
- Progress bar with percentage - Not feasible, CLI doesn't report progress
- Spinning icon graphic - Requires external image file, adds dependency
- No animation at all - Leaves user uncertain if script is stuck

### Dismissal Mechanism

**Decision:** Use ESC key press and middle-mouse-button click to dismiss the GUI.

**Rationale:**
- ESC key is a standard, discoverable dismissal pattern in Windows applications
- Middle-mouse-button provides an intuitive click-based dismissal option
- More intentional than click-outside, reduces accidental closures
- Removes need for timer-based click monitoring (simpler, less resource usage)
- Keyboard and mouse friendly, aligns with accessibility standards

**Implementation:**
```ahk
; Register hotkeys after GUI is shown
~Escape:: {
    global resultGui
    if (IsObject(resultGui)) {
        scriptShouldExit := true
        resultGui.Destroy()
        resultGui := ""
    }
}

~MButton:: {
    global resultGui
    if (IsObject(resultGui)) {
        scriptShouldExit := true
        resultGui.Destroy()
        resultGui := ""
    }
}
```

**Alternatives Considered:**
- Keep click-outside - Accidental closures, less discoverable
- Close button - Adds visual clutter, not typical for borderless windows
- Timer-based auto-dismiss - Interrupts reading, frustrating for longer translations
- Left-click to dismiss - Would interfere with potential future interactive controls

### Animation Implementation

**Decision:** Use SetTimer to update loading text with animated dots during CLI execution.

**Rationale:**
- Simple, built-in AHK mechanism
- Low CPU overhead compared to more complex animations
- Text-based animation matches the minimal GUI aesthetic

**Pattern:**
```ahk
global loadingStep := 0
SetTimer(UpdateLoadingGui, 200)  ; Update every 200ms

UpdateLoadingGui() {
    global loadingStep, translatingGui
    loadingStep++
    dots := StrRep(".", Mod(loadingStep, 4))
    ; Update Gui text with "Translating" + dots
}
```

**Alternatives Considered:**
- Animated GIF/image - Requires external file, adds complexity
- Progress bar - Not feasible without knowing total execution time
- No animation - Leaves uncertainty about script state

## Risks / Trade-offs

### Risk: Light theme may have visibility issues in some environments

**Risk:** In very bright environments or with certain monitor settings, white background may cause glare.

**Mitigation:**
- Use off-white rather than pure white if needed (e.g., `#F5F5F5`)
- Ensure text contrast ratio meets accessibility guidelines (4.5:1 minimum)

### Risk: Fixed character width may not match actual font rendering

**Risk:** The 8-pixel character width estimate may not match actual Segoe UI rendering across different Windows versions or DPI settings.

**Mitigation:**
- Test on different Windows versions and DPI settings
- If issues arise, consider using a more conservative width (e.g., 100 characters)
- Could implement dynamic width calculation using `Gui.Add("Text")` with sample text and measuring

### Risk: ESC key may conflict with application shortcuts

**Risk:** Some applications may use ESC for their own purposes (e.g., closing dialogs, canceling operations).

**Mitigation:**
- ESC hotkey in AHK uses `~Escape` prefix, which passes the key through to the active application
- This means both the GUI dismissal AND the application's ESC behavior occur
- This is acceptable as the GUI is dismissed anyway when the user wants to interact with the app

### Trade-off: Removed click-outside dismissal

**Trade-off:** Users accustomed to click-outside dismissal may find ESC key less intuitive initially.

**Rationale:**
- ESC is a standard Windows pattern, more discoverable than click-outside
- Reduces accidental closures from unintended clicks
- Simpler implementation (no timer monitoring)

## Migration Plan

**Deployment Steps:**
1. Update `cli/Translate.ahk` with new theme colors and sizing logic
2. Implement loading animation with SetTimer
3. Replace click-outside monitoring with ESC key hotkey
4. Update `cli/TranslateTest.ahk` with matching GUI changes for consistency
5. Update documentation (README.md, CLAUDE.md) with new dismissal method

**Rollback Strategy:**
- Revert changes to `cli/Translate.ahk` and `cli/TranslateTest.ahk`
- Restore previous documentation
- No database or CLI changes, so zero data rollback risk

**User Migration:**
- Users may need to learn new dismissal method (ESC key instead of click-outside)
- Update error messages and help text to mention ESC key dismissal
- Consider adding a brief note in the GUI initially (e.g., "Press ESC to dismiss")

## Open Questions

1. **Exact character width:** Should we use 8 pixels per character or measure actual font rendering? If measurement shows significant deviation, adjust calculation.

2. **Animation speed:** 200ms update interval for loading dots - should this be faster/slower? Test with actual CLI execution times.

3. **Loading text format:** "Translating..." with animated dots vs. other format (e.g., spinner characters, pulsing text)? User preference testing.
