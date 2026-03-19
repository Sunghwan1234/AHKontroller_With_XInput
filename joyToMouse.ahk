#Include <XIGUI>
#SingleInstance
#UseHook
XIGUI_Init
InstallMouseHook 
/** End of config */

F10::ExitApp
`::ExitApp

Controller := XIController(FindController())

MouseSpeed := 0.001  ; Adjust this value to change the mouse speed
DeadzoneL := 1025  ; Adjust this value to set the deadzone for the left stick
DeadzoneR := 0  ; Adjust this value to set the deadzone for the right stick
ScrollSpeed := 100
ScrollDelay := 3
ScrollTimer := 0

XIGUI.AddText(,"joyToMouse Active. Press F10 or `` to close this window.")
en := XIGUI.AddCheckbox("ReadOnly Section")
txt := XIGUI.AddEdit("ReadOnly xs+50 ys")
dzc := XIGUI.AddGroupBox("Section xs","Deadzones")
dzl := XIGUI.AddSlider("Range0-2048 ToolTip xs+10 ys+20", DeadzoneL)
dzr := XIGUI.AddSlider("Range0-2048 ToolTip xs+10 ys+50", DeadzoneR)

XIGUI.Move(,,,600)

enabled := true
Loop {
    XIGUI_Update
    CState := Controller.Get()
    RT := CState.RT
    LT := CState.LT
    LC := CState.LC

    DeadzoneL := dzl.Value

    if (enabled) {
        if (RT>0 || CState.RS) && GetKeyState('LButton')=0
            MouseClick 'Left' , , , , , 'Down'
        else if !(RT>0 || CState.RS) && GetKeyState('LButton')=1
            MouseClick 'Left' , , , , , 'Up'

        if (LT>0 || CState.AKey) && GetKeyState('RButton')=0
            MouseClick 'Right' , , , , , 'Down'
        else if !(LT>0 || CState.AKey) && GetKeyState('RButton')=1
            MouseClick 'Right' , , , , , 'Up'

        if (CState.Up)
            Send("{Up DownTemp}")
        if (CState.Down)
            Send "{Down DownTemp}"
        if (CState.Left)
            Send "{Left DownTemp}"
        if (CState.Right)
            Send "{Right DownTemp}"

        

        scroll := 100-ScrollSpeed*Abs(CState.StickLY/32767)
        ScrollDelay := 5-5*Abs(Cstate.StickLY/32767)

        if (CState.StickLY>DeadzoneL) {
            if (ScrollTimer<=0) {
                MouseClick 'WU' ,,,,scroll
            }
        } else if (CState.StickLY<-DeadzoneL) {
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
        txt.Value := CState.StickLY

        MouseMoveX := CState.StickRX * MouseSpeed
        MouseMoveY := -CState.StickRY * MouseSpeed ; Invert Y-axis
        ; Move the mouse
        MouseMove MouseMoveX, MouseMoveY, 1, 'R'


        Sleep 16
        if (CState.Guide) {
            enabled:=false
        }
    } else {
        if (CState.Start) {
            enabled:=true
        }
    }
    en.Value := enabled
}
