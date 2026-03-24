#Requires AutoHotkey v2.0
#Include ../Lib/XICMap.ahk
#SingleInstance
XInput_Init
InstallMouseHook

F10::ExitApp
Esc::ExitApp
'::ExitApp

w := Gui("Disabled","ioGame")
w.AddText(,"Using XICMap")
w.Move(,,150,200)

c := XICMAP(FindController())
c.BindAbsoluteMouse(1,128)
c.BindMouseButtons()

on := false
Loop {
    if (on) {
        c.ApplyBindings()
    }
    if (c.xic.Get().Start) {
        on:= false
    }
    if (c.xic.Get().Back) {
        on:=true
    }
    Sleep 16
}