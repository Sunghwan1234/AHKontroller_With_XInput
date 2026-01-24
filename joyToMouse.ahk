#Include <XInput>
#Include <XIController>
#SingleInstance
XInput_Init
InstallMouseHook 
/** End of config */

F10::ExitApp
`::ExitApp

Controller := XIController(FindController())

MouseSpeed := 0.001  ; Adjust this value to change the mouse speed
ScrollSpeed := 100
ScrollDelay := 3
ScrollTimer := 0

Window := Gui("Disabled","Hello")
Window.AddText(,"joyToMouse Active.")
Window.AddText(,"Press F10 to close this window.")
txt := Window.AddEdit("ReadOnly")
Window.Show()

Loop {
    CState := Controller.Get()
    RT := CState.RT
    LT := CState.LT
    LC := CState.LC

    if (RT>0 || CState.RS) && GetKeyState('LButton')=0
        MouseClick 'Left' , , , , , 'Down'
    else if !(RT>0 || CState.RS) && GetKeyState('LButton')=1
        MouseClick 'Left' , , , , , 'Up'

    if (LT>0 || CState.AKey) && GetKeyState('RButton')=0
        MouseClick 'Right' , , , , , 'Down'
    else if !(LT>0 || CState.AKey) && GetKeyState('RButton')=1
        MouseClick 'Right' , , , , , 'Up'

    scroll := 100-ScrollSpeed*Abs(CState.StickLY/32767)
    ScrollDelay := 5-5*Abs(Cstate.StickLY/32767)

    if (CState.StickLY>0) {
        if (ScrollTimer<=0) {
            MouseClick 'WU' ,,,,scroll
        }
    } else if (CState.StickLY<0) {
        if (ScrollTimer<=0) {
            MouseClick 'WD' ,,,,scroll
        }
    }
    if (!CState.StickLY || ScrollTimer<=0) { ; Stick Inactive
        ScrollTimer := ScrollDelay
    } else if (CState.StickLY) {
        ScrollTimer--
    }
    txt.Value := scroll

    MouseMoveX := CState.StickRX * MouseSpeed
    MouseMoveY := -CState.StickRY * MouseSpeed ; Invert Y-axis
    ; Move the mouse
    MouseMove MouseMoveX, MouseMoveY, 1, 'R'


    Sleep 16
}
