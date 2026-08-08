#Requires AutoHotkey v2.0
#SingleInstance Force

; Windows Terminal cannot re-arm its own "ctrl+enter" keybinding while Ctrl
; stays held (repeated taps fall through to a plain Enter). This global
; hotkey intercepts Ctrl+Enter at the OS level instead and forwards it as
; Ctrl+H, which Windows Terminal passes through untouched as a raw 0x08 byte
; -- exactly what the <C-h> mapping in nvim's treesitter.lua expects.
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
^Enter::SendInput("{Blind}{h}")
#HotIf

; Safety net: if Ctrl ever ends up "stuck" down at the OS level (observed
; after rapid repeated Ctrl+Enter -> Ctrl+H forwarding above), force an
; explicit release the moment the physical key actually comes up. This has
; to be unconditional (no #HotIf/WinActive guard) -- if focus moves away
; from Windows Terminal before the physical Ctrl key-up happens, a
; Terminal-scoped hotkey never fires and the stuck state leaks into
; whatever app has focus.
~Ctrl Up::SendInput("{Ctrl up}")

; The "send selected text to the REPL pane" action (switch pane, paste, run,
; switch back) also lives in this same persistent process rather than being
; launched as a separate one-shot AutoHotkey.exe per invocation: running two
; AutoHotkey processes at once was found to disrupt this script's keyboard
; hook, silently dropping later Ctrl+Enter presses. nvim signals this script
; via a trigger file instead of spawning a new process.
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
