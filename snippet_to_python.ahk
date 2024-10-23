
{ ; Ctrl + Alt + 1
    if WinExist("ahk_class Cascadia Window"){
    ; Activate the Windows Terminal window
        WinActivate
        Sleep(100)
        Send("echo 'Hello, World!'")}
}
