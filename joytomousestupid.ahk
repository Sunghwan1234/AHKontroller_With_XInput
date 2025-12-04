#Requires AutoHotkey v2.0
#Include <XInput>
#SingleInstance
Esc::ExitApp

XInput_Init()

InstallMouseHook 

G := Gui("+Resize", "XInput Test")
G.Add("Text", "w200 h40", "Press LT and RT to control the vibration motors.")
E := G.Add("Edit", "w200 h200 +ReadOnly")
G.Show()

MouseSpeed := 0.0001  ; Adjust this value to change the mouse speed

loop {
    Loop 4 {
        if State := XInput_GetState(A_Index-1) {
            LT := State.bLeftTrigger
            RT := State.bRightTrigger
            LS := State.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER = 256
            RS := State.wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER
            LC := State.wButtons & XINPUT_GAMEPAD_LEFT_THUMB
            RC := State.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB
            A := State.wButtons

            DPadUp := State.wButtons & 0x0001
            DPadDown := State.wButtons & 0x0002
            DPadLeft := State.wButtons & 0x0004
            DPadRight := State.wButtons & 0x0008
            AKey := State.wButtons & XINPUT_GAMEPAD_A
            YKey := State.wButtons & XINPUT_GAMEPAD_Y

            XInput_SetState(A_Index-1, LT*128, RT*128)

            E.Value := "Controller " A_Index-1 "`n" A " LT " LS

            ; Left thumbstick controls view (mouse movement)
            MouseMoveX := State.sThumbLY * MouseSpeed
            MouseMoveY := State.sThumbLX * MouseSpeed  ; Invert Y-axis for natural movement
            ; Move the mouse
            MouseMove MouseMoveX, MouseMoveY, 1, 'R'

            if LS && GetKeyState('LButton')=0
                MouseClick 'Left' , , , , , 'Down'
            else if !LS && GetKeyState('LButton')=1
                MouseClick 'Left' , , , , , 'Up'
            if LT>0 && GetKeyState('RButton')=0
                MouseClick 'R' , , , , , 'Down'
            else if LT=0 && GetKeyState('RButton')=1
                MouseClick 'R' , , , , , 'Up'


        }
    }
}