#Requires AutoHotkey v2.0-beta.6
#Include <XInput>
#SingleInstance
XInput_Init
InstallMouseHook
/* End Config. */

Window := Gui("+AlwaysOnTop", "Controller Test Script")
Window.Add("Text", "w300", "Note: For Xbox controller 2013 and newer (anything newer than the Xbox 360 controller), this script can only detect controller events if a window it owns is active (like this one).")
tDisplay := Window.Add("Edit", "w300 h50 +ReadOnly")
tDisplay2 := Window.Add("Edit","w300 h80 +ReadOnly")

`::ExitApp
Esc::ExitApp
c_id := -1

; Auto-detect the controller number if called for:
if c_id < 0 {
    Loop 4 { ; Query each controller number to find out which ones exist.
        if XInput_GetState(A_Index-1) {
            c_id := A_Index-1
            bCont := Window.Add("GroupBox","Section w300 h150", "Controller " A_Index)
            uLT := Window.AddProgress("xs+10 ys+15 w50 h10 Range0-255","LT")
            uLS := Window.AddButton("xs+10 ys+25 w50 h20","LS")
            uRT := Window.AddProgress("xs+240 ys+15 w50 h10 Range0-255","RT") ; 300(w)-10(border)-50(w) = 240x
            uRS := Window.AddButton("xs+240 ys+25 w50 h20","RS")

            break
        }
    }
    if c_id < 0 {
        tDisplay.Value := "The system does not appear to have any controllers."
        return
    }
}
Window.Show
Loop {
    State := XInput_GetState(c_id)
    LT := State.bLeftTrigger
    RT := State.bRightTrigger
    LS := State.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER
    RS := State.wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER

    LC := State.wButtons & XINPUT_GAMEPAD_LEFT_THUMB
    RC := State.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB
    A := State.wButtons
    tDisplay.Value := A

    DPadUp := State.wButtons & XINPUT_GAMEPAD_DPAD_UP
    DPadDown := State.wButtons & XINPUT_GAMEPAD_DPAD_DOWN
    DPadLeft := State.wButtons & XINPUT_GAMEPAD_DPAD_LEFT
    DPadRight := State.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT
    AKey := State.wButtons & XINPUT_GAMEPAD_A
    YKey := State.wButtons & XINPUT_GAMEPAD_Y

    uLT.Value := LT
    uRT.Value := RT

    triggers := DPadUp
    tDisplay2.Value := triggers

    XInput_SetState(c_id, LT*128, RT*128)

    /*
    if AKey = 4096
        Send "{Space Down}"
    else if GetKeyState("Space")=1
        Send "{Space Up}"
    if YKey = 32768 && YOn = 0 {
        YOn := 1
        Send 'e'
    } else if YKey = 0 && YOn = 1 {
        YOn := 0
    }
    if RT>0 && GetKeyState('LButton')=0
        MouseClick 'Left' , , , , , 'Down'
    else if RT=0 && GetKeyState('LButton')=1
        MouseClick 'Left' , , , , , 'Up'
    if LT>0 && GetKeyState('RButton')=0
        MouseClick 'R' , , , , , 'Down'
    else if LT=0 && GetKeyState('RButton')=1
        MouseClick 'R' , , , , , 'Up'
    if LC = 64 && GetKeyState("R") = 0
        Send "{R Down}"
    else if LC = 0 && GetKeyState("R")=1
        Send "{R Up}"
    if RC = 128
        MouseSpeed := 0.0005
    else
        MouseSpeed := 0.001
    if LS = 256 {
        if LSOn = 0 {
            LSOn := 1
            if Num = 0
                Num := 9
            else Num -= 1
        }
    } else LSOn := 0
    if RS = 512 {
        if RSOn = 0 {
            RSOn := 1
            if Num = 9
                Num := 0
            else Num += 1
        }
    } else RSOn := 0
    
    if NumBefore != Num
        Send Num
    NumBefore := Num

    ; Left thumbstick controls view (mouse movement)
    MouseMoveX := State.sThumbRX * MouseSpeed
    MouseMoveY := -State.sThumbRY * MouseSpeed  ; Invert Y-axis for natural movement
    ; Move the mouse
    MouseMove MouseMoveX, MouseMoveY, 1, 'R'
    */

    Sleep 20
}

