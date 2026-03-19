#Requires AutoHotkey v2.0
#SingleInstance Off
#include UIA-v2\Lib\UIA.ahk
#ErrorStdOut
#Warn All, StdOut

; ============================================
; CONFIGURATION
; ============================================
; Ensure all coordinates are consistent (Screen relative)
CoordMode "Mouse", "Screen"
CoordMode "Caret", "Screen"

; Global state
global isTranslating := false
global resultGui := ""
global translatingGui := ""
global translatingTextControl := ""
global loadingStep := 0
global elementX := 0
global elementY := 0
global elementH := 0
; GUI bounds for click detection
global guiX := 0
global guiY := 0
global guiWidth := 0
global guiHeight := 0
global guiHwnd := 0  ; Handle of result GUI for click detection

; ============================================
; Command Line Argument Parsing
; ============================================
global useTestText := false
global testText := ""
global selectAllFirst := false

for arg in A_Args {
    if (arg == "--select-all") {
        selectAllFirst := true
    } else if (arg == "--test") {
        useTestText := true
    } else if (useTestText && testText == "") {
        testText := arg
    }
}

Persistent

; Global ESC kill switch
~Escape::ExitApp()

; Monitor middle mouse button clicks at window level
OnMessage(0x0207, "WM_MBUTTONDOWN") {
    global guiHwnd, resultGui

    ; wParam low word = button: 1=left, 2=middle, 4=right
    button := wParam & 0xFFFF

    ; Only handle middle button clicks
    if (button != 2)
        return

    ; Check if click is on our GUI window
    if (guiHwnd != 0)
        DismissGui()
}

Main()

; ============================================
; Main Function
; ============================================
Main() {
    global elementX, elementY, elementH

    ; Reset coordinates
    elementX := 0
    elementY := 0
    elementH := 0

    if (isTranslating) {
        ShowGui("Translation in progress...", "loading")
        return
    }

    try {
        selectedText := ""

        if (useTestText) {
            selectedText := testText
            MouseGetPos(&elementX, &elementY) ; Fallback for test mode
        } else {
            if (selectAllFirst) {
                Send "^a"
                Sleep 50 
            }

            focusedEl := UIA.GetFocusedElement()

            if (!focusedEl) {
                ExitApp()  ; No focused element, just exit
            }

            ; Try TextPattern (Browsers, Word, Editors) - best way to get actual selection
            try {
                textPattern := focusedEl.TextPattern
                if (textPattern) {
                    selectionArray := textPattern.GetSelection()
                    if (selectionArray.Length > 0) {
                        selectedText := selectionArray[1].GetText()
                    }
                }
            }

            ; Fallback: Try ValuePattern with SelectionRange check
            ; Some apps need this but we must verify there's an actual selection
            if (!selectedText) {
                try {
                    valuePattern := focusedEl.ValuePattern
                    if (valuePattern) {
                        ; Try to get selection via TextRange if available
                        try {
                            textRange := focusedEl.GetTextRange()
                            if (textRange) {
                                selectedText := textRange.GetText()
                            }
                        }
                        ; Last resort: use Value (may get entire content, but some apps need this)
                        if (!selectedText) {
                            fullValue := focusedEl.Value
                            ; Only use if value seems reasonable (not extremely long)
                            if (StrLen(fullValue) > 0 && StrLen(fullValue) < 10000) {
                                selectedText := fullValue
                            }
                        }
                    }
                }
            }

            ; Get caret position for GUI placement
            if CaretGetPos(&cx, &cy) {
                elementX := cx
                elementY := cy
                elementH := 20
            }
            else {
                MouseGetPos(&elementX, &elementY)
            }
        
        }

        if (selectedText != "") {
            TranslateText(selectedText)
        } else {
            ExitApp()  ; No text detected, just exit
        }

    } catch Error as e {
        ExitApp()  ; Error occurred, just exit
    }
}

; ============================================
; Translation Functions
; ============================================
TranslateText(text) {
    global isTranslating

    if (!IsNodeJsAvailable()) {
        ShowGui("Node.js/npm not found.", "error")
        return
    }

    isTranslating := true
    ShowTranslatingGui()

    projectRoot := A_ScriptDir "\.."
    tempOutputFile := A_Temp "\english_assistant_output_" . A_TickCount . ".txt"

    ; Escape text for command-line: escape quotes and percent signs
    escapedText := StrReplace(text, '"', '""')
    escapedText := StrReplace(escapedText, '%', '%%')

    try {
        ; Pass text directly as argument instead of temp file
        cmd := 'cmd /c cd /d "' . projectRoot . '" && npm run cli --silent -- "' . escapedText . '" > "' . tempOutputFile . '" 2>&1'
        RunWait(cmd, , "Hide")

        output := ""
        if FileExist(tempOutputFile) {
            output := FileRead(tempOutputFile, "UTF-8")
            output := Trim(output, " `t`n`r")
        } else {
            output := "Error: No output file generated."
        }

        try FileDelete(tempOutputFile)

        DestroyTranslatingGui()
        isTranslating := false

        if (output != "") {
            if (useTestText) {
                FileAppend(output . "`n", "*")
            }
            ShowGui(output, "success")
        } else {
            ShowGui("Translation returned empty result.", "error")
        }

    } catch Error as e {
        try FileDelete(tempOutputFile)
        DestroyTranslatingGui()
        isTranslating := false
        ShowGui("Error running translation:`n`n" . e.Message, "error")
    }
}

IsNodeJsAvailable() {
    try {
        exitCode := RunWait("cmd /c where npm", , "Hide")
        return (exitCode == 0)
    } catch {
        return false
    }
}

; ============================================
; GUI Functions
; ============================================
ShowGui(text, type := "success") {
    global resultGui, elementX, elementY, elementH

    if (IsObject(resultGui)) {
        try resultGui.Destroy()
        resultGui := ""
    }

    if (elementX == 0 && elementY == 0) {
        MouseGetPos(&elementX, &elementY)
    }

    resultGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Translation Result")
    resultGui.BackColor := "FFFFFF"

    textLines := StrSplit(text, "`n")
    lineCount := textLines.Length
    charWidth := 8
    maxCharsPerLine := 120
    maxWidth := maxCharsPerLine * charWidth

    calculatedWidth := 0
    for _, line in textLines {
        lineWidth := StrLen(line) * charWidth
        if (lineWidth > calculatedWidth)
            calculatedWidth := lineWidth
    }
    guiWidth := Min(maxWidth, Max(200, calculatedWidth + 40))
    lineHeight := 20
    guiHeight := Min(600, Max(80, (lineCount * lineHeight) + 40))

    ; ============================================================
    ; POSITION CALCULATION (ABOVE TEXT)
    ; ============================================================
    guiX := elementX
    ; Position ABOVE: Element Y - GUI Height - Padding
    guiY := elementY - guiHeight - 15
    
    ; Boundary Check: If top of GUI is off-screen (< 0), flip to BELOW
    if (guiY < 0) {
        guiY := elementY + (elementH > 0 ? elementH : 20) + 10
    }
    
    ; Right Edge Check
    if (guiX + guiWidth > A_ScreenWidth)
        guiX := A_ScreenWidth - guiWidth - 10
    ; ============================================================

    textColor := (type == "error") ? "D32F2F" : "202020"
    displayText := (type == "error") ? "Error: " . text : text

    resultGui.SetFont("s10", "Segoe UI")
    resultGui.Add("Text", "x20 y20 w" . (guiWidth - 40) . " h" . (guiHeight - 40) . " c" . textColor, displayText)
    resultGui.OnEvent("Close", (*) => GuiClosed())
    resultGui.Show("x" . guiX . " y" . guiY . " w" . guiWidth . " h" . guiHeight)
    guiHwnd := resultGui.Hwnd  ; Store handle for click detection
}

ShowTranslatingGui() {
    global translatingGui, translatingTextControl, loadingStep, elementX, elementY, elementH

    if (elementX == 0 && elementY == 0) {
        MouseGetPos(&elementX, &elementY)
    }

    translatingGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Translating...")
    translatingGui.BackColor := "FFFFFF"

    guiWidth := 150
    guiHeight := 50

    ; Position ABOVE
    guiX := elementX
    guiY := elementY - guiHeight - 15

    ; Flip if off-screen
    if (guiY < 0) {
        guiY := elementY + (elementH > 0 ? elementH : 20) + 10
    }
    
    if (guiX + guiWidth > A_ScreenWidth)
        guiX := A_ScreenWidth - guiWidth - 10

    translatingGui.SetFont("s10", "Segoe UI")
    translatingTextControl := translatingGui.Add("Text", "x20 y15 w110 c202020", "Translating.")

    translatingGui.Show("x" . guiX . " y" . guiY . " w" . guiWidth . " h" . guiHeight)

    loadingStep := 0
    SetTimer(UpdateLoadingGui, 200)
}

DestroyTranslatingGui() {
    global translatingGui 
    SetTimer(UpdateLoadingGui, 0)
    if (IsObject(translatingGui)) {
        try translatingGui.Destroy()
        translatingGui := ""
    }
}

GuiClosed() {
    global resultGui, guiHwnd
    guiHwnd := 0  ; Reset GUI handle
    if (IsObject(resultGui)) {
        resultGui.Destroy()
    }
    ExitApp()
}

DismissGui(*) {
    global resultGui, guiHwnd
    if (!IsObject(resultGui)) {
        return
    }
    guiHwnd := 0  ; Reset handle first
    resultGui.Destroy()
    resultGui := ""
    ExitApp()
}

UpdateLoadingGui() {
    global loadingStep, translatingGui, translatingTextControl
    if (!IsObject(translatingGui) || !IsObject(translatingTextControl)) {
        SetTimer(UpdateLoadingGui, 0)
        return
    }
    loadingStep++
    numDots := Mod(loadingStep, 4)
    dots := ""
    loop numDots {
        dots .= "."
    }
    translatingTextControl.Text := "Translating" . dots
}