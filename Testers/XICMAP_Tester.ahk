#Requires AutoHotkey v2.0
#Include ../Lib/XICMap.ahk
#SingleInstance
XInput_Init

F10::ExitApp
Esc::ExitApp
`::ExitApp

w := Gui("Disabled AlwaysOnTop","XICMAP_Tester")
w.AddText(,"XIMAP")
w.Move(,,100,100)
w.Show()

c := XICMAP(FindController())
c.Bind("A", "A")
Loop {
    c.ApplyBindings()
    Sleep 16
}

; 