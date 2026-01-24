#Include <XInput>
#Include <XIController>
#SingleInstance
XInput_Init
InstallMouseHook 
/** End of config */

F10::ExitApp

Controller := XIController(FindController())

MouseSpeed := 0.001  ; Adjust this value to change the mouse speed
ScrollSpeed := 0.001


Loop {
    CState := Controller.Get()
    RT := CState.RT
    LT := CState.LT
    LC := CState.LC

    if (RT>0 || CState.RS) && GetKeyState('LButton')=0
        MouseClick 'Left' , , , , , 'Down'
    else if !(RT>0 || CState.RS) && GetKeyState('LButton')=1
        MouseClick 'Left' , , , , , 'Up'
    if LT>0 && GetKeyState('RButton')=0
        MouseClick 'R' , , , , , 'Down'
    else if LT=0 && GetKeyState('RButton')=1
        MouseClick 'R' , , , , , 'Up'

    if (CState.StickLY>0) {
        MouseClick 'WU' ,,,,ScrollSpeed*CState.StickLY/32767
    } else if (CState.StickLY<0) {
        MouseClick 'WD' ,,,,ScrollSpeed*CState.StickLY/32767
    }

    MouseMoveX := CState.StickRX * MouseSpeed
    MouseMoveY := -CState.StickRY * MouseSpeed ; Invert Y-axis
    ; Move the mouse
    MouseMove MouseMoveX, MouseMoveY, 1, 'R'


    Sleep 16
}
