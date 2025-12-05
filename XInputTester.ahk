#Requires AutoHotkey v2.0-beta.6
#Include <XInput>
#SingleInstance
XInput_Init
InstallMouseHook
/* End Config. */

Window := Gui("+AlwaysOnTop", "Controller Test Script")
Window.Add("Text", "w200", "Note: For Xbox controller 2013 and newer (anything newer than the Xbox 360 controller), this script can only detect controller events if a window it owns is active (like this one).")
tDisplay := Window.Add("Edit", "w200 h50 +ReadOnly")

`::ExitApp
Esc::ExitApp

/** The GUI for a controller. */
class ControllerGUI {
    __New(id) {
        this.id := id
        this.bCont := Window.AddGroupBox("Section w200 h120", "Controller " A_Index)
        this.bCont.GetPos(&gbX, &gbY)
        this.uLT := Window.AddProgress("xs+10 ys+15 w50 h10 Range0-255","LT")
        this.uLS := Window.AddButton("xs+10 ys+25 w50 h20","LS")
        this.uRT := Window.AddProgress("xs+140 ys+15 w50 h10 Range0-255","RT") ; 200(w)-10(border)-50(w) = 140x
        this.uRS := Window.AddButton("xs+140 ys+25 w50 h20","RS")
        
        ; Sticks
        this.uLStickcX := gbX+28
        this.uLStickcY := gbY+50
        this.uLStick := Window.AddText("xs+28 ys+50 w25 h26 BackgroundTrans","○")
        this.uLStick.SetFont("s20")

        this.uRStickcX := gbX+190-50
        this.uRStickcY := gbY+60+20
        this.uRStick := Window.AddText("xs+140 ys+80 w25 h26 BackgroundTrans","○")
        this.uRStick.SetFont("s20")
    }
    Update() {
        State := XInput_GetState(this.id)
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
    Loop ControllerGUIs.Length {
        ControllerGUIs[A_Index].Update()
    }

    Sleep 20
}

