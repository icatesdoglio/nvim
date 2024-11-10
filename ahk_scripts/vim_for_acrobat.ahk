#Requires AutoHotkey v2.0

; Define a global flag to track whether we're in search mode
searchMode := false

; Hotkey to manually toggle search mode
^/:: {
    searchMode := !searchMode
    if (searchMode) {
        Suspend(1) ; Disable Vim-like keys (search mode)
    } else {
        Suspend(0) ; Enable Vim-like keys (normal mode)
    }
}

#HotIf WinActive("ahk_class AcrobatSDIWindow") ; Keep the class for Acrobat's main window

; Define gg mapping
gPressed := false
g:: {
    if gPressed {
        Send("^Home") ; Go to the top of the document
        gPressed := false
    } else {
        gPressed := true
        SetTimer(() => gPressed := false, -300) ; Reset gPressed if second g isn't pressed within 300ms
    }
}

; +g (Shift + g) for end of document
+g::Send("^End")

; j/k for down/up
j::Send("{Down}")
k::Send("{Up}")

; h/l for left/right
h::Send("{Left}")
l::Send("{Right}")

; Ctrl + d/u for page down/up
^d::Send("{PgDn}")
^u::Send("{PgUp}")


#HotIf
