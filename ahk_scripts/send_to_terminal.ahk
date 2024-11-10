
!v:: {
    activeWindow := WinActive()

    if WinExist("ahk_exe WindowsTerminal.exe") {
        Send("!{Right}")
        Send("^+v{Enter}")
        Send("!{Left}")
    }
}
