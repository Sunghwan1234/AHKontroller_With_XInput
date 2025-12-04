#Include <XInput>
#SingleInstance
XInput_Init()

InstallMouseHook 

G := Gui("+Resize", "XInput Test")
G.Add("Text", "w200 h40", "Press LT and RT to control the vibration motors.")

E := G.Add("Edit", "w200 h200 +ReadOnly")
G.Show()

`::ExitApp
NumBefore := -1
Num := 1
LSOn := 0
RSOn := 0
YOn := 0

MouseSpeed := 0.001  ; Adjust this value to change the mouse speed

Loop {
    Loop 4 {
        if State := XInput_GetState(A_Index-1) {
            LT := State.bLeftTrigger
            RT := State.bRightTrigger
            LS := State.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER
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

            if State.sThumbLY > 10000
                Send "{w Down}"
            else if GetKeyState("w")=1
                Send "{w Up}"
            if State.sThumbLY < -10000
                Send "{s Down}"
            else if GetKeyState("s")=1
                Send "{s Up}"
            if State.sThumbLX < -10000
                Send "{a Down}"
            else if GetKeyState("a")=1
                Send "{a Up}"
            if State.sThumbLX > 10000
                Send "{d Down}"
            else if GetKeyState("d")=1
                Send "{d Up}"

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

            XInput_SetState(A_Index-1, LT*128, RT*128)

            E.Value := "Controller " A_Index-1 "`n" A " " YOn
        }
    }
    Sleep 20
}
