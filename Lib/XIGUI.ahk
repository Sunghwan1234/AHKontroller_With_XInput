#Requires AutoHotkey v2.0-beta.6
#Include <XInput>
#SingleInstance
XInput_Init
InstallMouseHook
/* End Config. */

class Controller {
    __New(id) {
        this.id := id
    }
    Get() {
        State := XInput_GetState(this.id)
        if !State ; If the controller is not connected, return an empty object
            return {}

        return {
            state: State,
            LT: State.bLeftTrigger,
            RT: State.bRightTrigger,
            LS: (State.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER) ? 1 : 0,
            RS: (State.wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER) ? 1 : 0,
            LC: (State.wButtons & XINPUT_GAMEPAD_LEFT_THUMB) ? 1 : 0,
            RC: (State.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB) ? 1 : 0,
            DPadUp: (State.wButtons & XINPUT_GAMEPAD_DPAD_UP) ? 1 : 0,
            DPadDown: (State.wButtons & XINPUT_GAMEPAD_DPAD_DOWN) ? 1 : 0,
            DPadLeft: (State.wButtons & XINPUT_GAMEPAD_DPAD_LEFT) ? 1 : 0,
            DPadRight: (State.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT) ? 1 : 0,
            AKey: (State.wButtons & XINPUT_GAMEPAD_A) ? 1 : 0,
            BKey: (State.wButtons & XINPUT_GAMEPAD_B) ? 1 : 0,
            XKey: (State.wButtons & XINPUT_GAMEPAD_X) ? 1 : 0,
            YKey: (State.wButtons & XINPUT_GAMEPAD_Y) ? 1 : 0,
            Guide: (State.wButtons & XINPUT_GAMEPAD_GUIDE) ? 1 : 0,
            Back: (State.wButtons & XINPUT_GAMEPAD_BACK) ? 1 : 0,
            Start: (State.wButtons & XINPUT_GAMEPAD_START) ? 1 : 0
        }
    }
}

Window := Gui("+AlwaysOnTop", "XIGUI Window")
Window.AddText("w200", "AHKontroller XIGUI")
tDisplay := Window.AddEdit("Section w200 h100 +ReadOnly")

/** The GUI for a controller. */
class ControllerGUI {
    __New(id) {
        this.id := id
        this.Controller := new Controller(id)

        this.DPadW := 30
        this.DPadH := 15

        this.uDPadCenterX := 70
        this.uDPadCenterY := 85

        Window := Gui("+AlwaysOnTop", "Controller GUI")
        this.Window := Window

        ; D-Pad Buttons
        this.uDPadUp := Window.AddButton("xs+" (this.uDPadCenterX) " ys+" (this.uDPadCenterY - this.DPadH) " w" this.DPadW " h" this.DPadH, "↑")
        this.uDPadDown := Window.AddButton("xs+" (this.uDPadCenterX) " ys+" (this.uDPadCenterY + this.DPadH) " w" this.DPadW " h" this.DPadH, "↓")
        this.uDPadLeft := Window.AddButton("xs+" (this.uDPadCenterX - this.DPadW) " ys+" (this.uDPadCenterY) " w" this.DPadW " h" this.DPadH, "←")
        this.uDPadRight := Window.AddButton("xs+" (this.uDPadCenterX + this.DPadW) " ys+" (this.uDPadCenterY) " w" this.DPadW " h" this.DPadH, "→")

        ; Central Keys
        this.uXBox := Window.AddRadio("Group xs+94 ys+20 w10 h20", "")
        this.uBack := Window.AddRadio("Group xs+70 ys+25 w10 h20", "")
        this.uStart := Window.AddRadio("Group xs+118 ys+25 w10 h20", "")

        ; Display Area
        this.tDisplay := Window.AddEdit("xs+10 ys+120 w200 h100 ReadOnly", "")

        Window.Show()
    }

    Update() {
        Buttons := this.Controller.Get()
        if !Buttons {
            this.tDisplay.Value := "Controller not connected."
            return
        }

        ; Update D-Pad buttons
        this.uDPadUp.Value := Buttons.DPadUp
        this.uDPadDown.Value := Buttons.DPadDown
        this.uDPadLeft.Value := Buttons.DPadLeft
        this.uDPadRight.Value := Buttons.DPadRight

        ; Update central keys
        this.uXBox.Value := Buttons.Guide
        this.uBack.Value := Buttons.Back
        this.uStart.Value := Buttons.Start

        ; Update display area
        this.tDisplay.Value := "Controller " (this.id + 1) ":`n"
        this.tDisplay.Value .= "LT: " Buttons.LT " | RT: " Buttons.RT "`n"
        this.tDisplay.Value .= "DPad: Up=" Buttons.DPadUp " Down=" Buttons.DPadDown " Left=" Buttons.DPadLeft " Right=" Buttons.DPadRight "`n"
        this.tDisplay.Value .= "Buttons: A=" Buttons.AKey " B=" Buttons.BKey " X=" Buttons.XKey " Y=" Buttons.YKey "`n"
    }
}

XIGUI_Init() {
    ControllerGUIs := []
    ; Auto-detect the controller number if called for:
    Loop 4 { ; Query each controller number to find out which ones exist.
        if XInput_GetState(A_Index-1) {
            ControllerGUIs.Push(ControllerGUI(A_Index-1))
            ControllerGUIs[A_Index].Update()
        }
    }

    Window.Show()
}

; Main loop
Loop {
    global ControllerGUIs
    tDisplay.Value := ""
    Loop ControllerGUIs.Length {
        ControllerGUIs[A_Index].Update()
    }

    Sleep 20
}
