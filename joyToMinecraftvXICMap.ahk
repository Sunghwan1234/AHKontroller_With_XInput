#Requires AutoHotkey v2.0
#Include <XICMap>
#SingleInstance
XInput_Init
InstallMouseHook

F10::ExitApp
Esc::ExitApp
'::ExitApp

w := Gui("Disabled AlwaysOnTop","JTMC")
w.AddText(,"Using XICMap")
w.Move(,,100,100)
w.Show()

c := XICMAP(FindController())
c.BindMouse()
c.BindMovement()
c.Bind("Y", "E")
c.Bind("A","Space")
Loop {
    c.ApplyBindings()
    Sleep 16
}