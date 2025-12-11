#Requires AutoHotkey v2.0-beta.6
#Include <XInput>
#SingleInstance
XInput_Init
InstallMouseHook
/* End Config. */

Window := Gui("+AlwaysOnTop", "Controller Test Script")
Window.AddText("w200", "AHKontroller XInputTester")
tDisplay := Window.AddEdit("Section w200 h100 +ReadOnly")

`::ExitApp
Esc::ExitApp

/** The GUI for a controller. */
class ControllerGUI {
    __New(id) {
        this.id := id
        this.bCont := Window.AddGroupBox("xs+0 ys+120 Section w200 h120", "Xbox Controller " A_Index)
        this.bCont.GetPos(&gbX, &gbY)

        ; Triggers and bumpers
        this.uLT := Window.AddProgress("xs+10 ys+15 w50 h10 Range0-255","LT")
        this.uLS := Window.AddButton("xs+10 ys+25 w50 h20","LS")
        this.uRT := Window.AddProgress("xs+140 ys+15 w50 h10 Range0-255","RT") ; 200(w)-10(border)-50(w) = 140x
        this.uRS := Window.AddButton("xs+140 ys+25 w50 h20","RS")
        
        ; Sticks
        this.uStickW := 18
        this.uStickH := 26

        this.uLStickcX := gbX+28
        this.uLStickcY := gbY+50
        this.uLStick := Window.AddText("xs+28 ys+50 w" this.uStickW " h" this.uStickH " BackgroundTrans","○")
        this.uLStick.SetFont("s20")

        this.uRStickcX := gbX+190-60
        this.uRStickcY := gbY+60+20
        this.uRStick := Window.AddText("xs+140 ys+70 w" this.uStickW " h" this.uStickH " BackgroundTrans","○")
        this.uRStick.SetFont("s20")

        ; Buttons
        this.uYy := 45
        this.uAya := 25

        this.uButtonH := 20

        this.uA := Window.AddRadio("Group xs+155 ys+" this.uYy+this.uAya " w25 h" this.uButtonH,"A") ; Bottom
        this.uB := Window.AddRadio("Group xs+180 ys+" this.uYy+this.uAya/2 " w25 h" this.uButtonH,"B") ; Right
        this.uX := Window.AddRadio("Group xs+130 ys+" this.uYy+this.uAya/2 " w25 h" this.uButtonH,"X") ; Left
        this.uY := Window.AddRadio("Group xs+155 ys+" this.uYy " w25 h" this.uButtonH,"Y") ; Top
        
        ; Arrows

        this.DPadW := 15
        this.DPadH := 15

        this.uDPadCenterX := 70
        this.uDPadCenterY := 85

        this.uDPadUp := Window.AddButton("xs+" (this.uDPadCenterX) " ys+" (this.uDPadCenterY - this.DPadH) " w" this.DPadW " h" this.DPadH,"↑")
        this.uDPadDown := Window.AddButton("xs+" (this.uDPadCenterX) " ys+" (this.uDPadCenterY + this.DPadH) " w" this.DPadW " h" this.DPadH,"↓")
        this.uDPadLeft := Window.AddButton("xs+" (this.uDPadCenterX - this.DPadW) " ys+" (this.uDPadCenterY) " w" this.DPadW " h" this.DPadH,"←")
        this.uDPadRight := Window.AddButton("xs+" (this.uDPadCenterX + this.DPadW) " ys+" (this.uDPadCenterY) " w" this.DPadW " h" this.DPadH,"→")

        ; Central Keys

        this.uXBox := Window.AddRadio("Group xs+94 ys+20 w10 h20","")
        this.uBack := Window.AddRadio("Group xs+70 ys+25 w10 h20","")
        this.uStart := Window.AddRadio("Group xs+118 ys+25 w10 h20","")
    }
    Update() {
        State := XInput_GetState(this.id)
        LT := State.bLeftTrigger
        RT := State.bRightTrigger
        LS := State.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER
        RS := State.wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER

        LC := State.wButtons & XINPUT_GAMEPAD_LEFT_THUMB
        RC := State.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB
        All := State.wButtons
        tDisplay.Value .= "Controller " (this.id+1) ": " All " |LX" State.sThumbLX " LY" State.sThumbLY " |RX" State.sThumbRX " RY" State.sThumbRY "`n" 

        DPadUp := State.wButtons & XINPUT_GAMEPAD_DPAD_UP
        DPadDown := State.wButtons & XINPUT_GAMEPAD_DPAD_DOWN
        DPadLeft := State.wButtons & XINPUT_GAMEPAD_DPAD_LEFT
        DPadRight := State.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT

        AKey := State.wButtons & XINPUT_GAMEPAD_A
        BKey := State.wButtons & XINPUT_GAMEPAD_B
        XKey := State.wButtons & XINPUT_GAMEPAD_X
        YKey := State.wButtons & XINPUT_GAMEPAD_Y

        Guide := State.wButtons & XINPUT_GAMEPAD_GUIDE
        Back := State.wButtons & XINPUT_GAMEPAD_BACK
        Start := State.wButtons & XINPUT_GAMEPAD_START


        tDisplay.Value .= "  Back: " Back " Guide: " Guide " Start: " Start "`n" 

        this.uLT.Value := LT
        this.uRT.Value := RT
        this.uLS.Enabled := !LS
        this.uRS.Enabled := !RS

        this.uLStick.Move(this.uLStickcX + (State.sThumbLX / 32768) * 5, this.uLStickcY - (State.sThumbLY / 32768) * 5)
        this.uRStick.Move(this.uRStickcX + (State.sThumbRX / 32768) * 5, this.uRStickcY - (State.sThumbRY / 32768) * 5)
        if (LC and this.uLStick.Text = "○") {
            this.uLStick.Text := "●"
        } else if (!LC and this.uLStick.Text = "●") {
            this.uLStick.Text := "○"
        }
        if (RC and this.uRStick.Text = "○") {
            this.uRStick.Text := "●"
        } else if (!RC and this.uRStick.Text = "●") {
            this.uRStick.Text := "○"
        }
        XInput_SetState(this.id, LT*128, RT*128)

        this.uA.Value := AKey?1:0
        this.uB.Value := Bkey?1:0
        this.uX.Value := XKey?1:0
        this.uY.Value := YKey?1:0

        this.uDPadUp.Enabled := !DPadUp
        this.uDPadDown.Enabled := !DPadDown
        this.uDPadLeft.Enabled := !DPadLeft
        this.uDPadRight.Enabled := !DPadRight

        this.uXBox.Value := Guide?1:0
        this.uBack.Value := Back?1:0
        this.uStart.Value := Start?1:0
    }

}
ControllerGUIs := []

; Auto-detect the controller number if called for:
Loop 4 { ; Query each controller number to find out which ones exist.
    if XInput_GetState(A_Index-1) {
        ControllerGUIs.Push(ControllerGUI(A_Index-1))
        ControllerGUIs[A_Index].Update()
    }
}

Window.Show
; Main loop
Loop {
    tDisplay.Value := ""
    Loop ControllerGUIs.Length {
        ControllerGUIs[A_Index].Update()
    }

    Sleep 20
}

