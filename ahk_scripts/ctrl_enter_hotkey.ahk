#Requires AutoHotkey v2.0
#SingleInstance Force

; Ctrl+Enter in Windows Terminal -> Ctrl+H.
; Check the physical Ctrl state on every Enter press so Ctrl can remain held
; while Enter is tapped repeatedly.
#HotIf WinActive("ahk_exe WindowsTerminal.exe") && GetKeyState("Ctrl", "P")
$*Enter::{
    SendInput("{Blind}h")
}
#HotIf


; Persistent trigger used by Neovim to send selected text to the REPL pane.
TriggerFile := EnvGet("TEMP") . "\nvim_repl_trigger.tmp"
global LastTrigger := ""

SendToRepl() {
    Send("!{Right}")
    Send("^+v{Enter}")
    Send("!{Left}")
}

CheckReplTrigger() {
    global LastTrigger, TriggerFile

    if !FileExist(TriggerFile)
        return

    content := ""

    try {
        content := FileRead(TriggerFile)
    } catch {
        return
    }

    if (content != "" && content != LastTrigger) {
        LastTrigger := content
        SendToRepl()
    }
}

SetTimer(CheckReplTrigger, 40)
