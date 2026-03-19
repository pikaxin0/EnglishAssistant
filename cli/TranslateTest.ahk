#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================
; Test Script for English Assistant CLI
; Run this script to test translation with hardcoded text
; This bypasses UIA text capture for testing
; ============================================

; Run the test immediately
Main()

; ============================================
; Main Test Function
; ============================================
Main() {
    try {
        ShowGui("Translating...", "loading")

        ; Test text
        testText := "Hello, this is a test translation"

        ; Get project root (parent of cli directory)
        projectRoot := A_ScriptDir "\.."

        ; Generate temp file paths
        tempInputFile := A_Temp "\english_assistant_test_input.txt"
        tempOutputFile := A_Temp "\english_assistant_test_output.txt"

        ; Write input text to temp file
        if FileExist(tempInputFile)
            FileDelete(tempInputFile)
        FileAppend(testText, tempInputFile, "UTF-8")

        ; Build the command
        cmd := 'cmd /c cd /d "' . projectRoot . '" && npm run cli --silent -- "' . tempInputFile . '" > "' . tempOutputFile . '" 2>&1'

        ; Run hidden and wait for completion
        RunWait(cmd, , "Hide")

        ; Read the result
        output := ""
        if FileExist(tempOutputFile) {
            output := FileRead(tempOutputFile, "UTF-8")
            output := Trim(output, " `t`n`r")
        } else {
            output := "Error: No output file generated."
        }

        ; Clean up files
        try FileDelete(tempInputFile)
        try FileDelete(tempOutputFile)

        ; Display result
        if (output != "") {
            ShowGui("Original: " . testText . "`n`nTranslation: " . output, "success")
        } else {
            ShowGui("Translation failed - no output", "error")
        }

    } catch Error as e {
        ShowGui("Error:`n`n" . e.Message, "error")
    }
}

; ============================================
; Simple GUI for test output
; ============================================
ShowGui(text, type := "success") {
    static testGui := ""

    if (IsObject(testGui)) {
        try {
            testGui.Destroy()
        }
        testGui := ""
    }

    MouseGetPos(&mouseX, &mouseY)

    testGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Translation Test")
    testGui.BackColor := "FFFFFF"

    textColor := (type == "error") ? "D32F2F" : "202020"

    testGui.SetFont("s10", "Segoe UI")
    testGui.Add("Text", "x20 y20 w560 h400 c" . textColor, text)

    testGui.OnEvent("Close", (*) => testGui := "")

    testGui.Show("x100 y100 w600 h420")
}
