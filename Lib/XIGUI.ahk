/* XIGUI v1.2 by Sunghwan1234 */
#Requires AutoHotkey v2.0-beta.6
#Include XIController.ahk ; Was built on XIC v1.0
#SingleInstance
/* End Config. */

XIGUI := Gui("", "XIGUI Window")
XIGUI.AddText("w200", "AHKontroller XIGUI")
tDisplay := XIGUI.AddEdit("Section w200 h100 +ReadOnly")

/** The GUI for a controller. */
class ControllerGUI {
    __New(id) {
        this.id := id
        ; place groupboxes stacked vertically based on controller id (0..3)
        y := 125
        this.bCont := XIGUI.AddGroupBox("xm+0 ys+" y " Section w200 h120", "Xbox Controller " (this.id+1))
        this.bCont.GetPos(&gbX, &gbY)

        ; Triggers and bumpers
        this.uLT := XIGUI.AddProgress("xs+10 ys+15 w50 h10 Range0-255","LT")
        this.uLS := XIGUI.AddButton("xs+10 ys+25 w50 h20","LS")
        this.uRT := XIGUI.AddProgress("xs+140 ys+15 w50 h10 Range0-255","RT") ; 200(w)-10(border)-50(w) = 140x
        this.uRS := XIGUI.AddButton("xs+140 ys+25 w50 h20","RS")
        
        ; Sticks
        this.uStickW := 18
        this.uStickH := 26

        this.uLStickcX := gbX+28
        this.uLStickcY := gbY+50
        this.uLStick := XIGUI.AddText("xs+28 ys+50 w" this.uStickW " h" this.uStickH " BackgroundTrans","◎")
        this.uLStick.SetFont("s20")

        this.uRStickcX := gbX+190-60
        this.uRStickcY := gbY+60+20
        this.uRStick := XIGUI.AddText("xs+140 ys+70 w" this.uStickW " h" this.uStickH " BackgroundTrans","◎")
        this.uRStick.SetFont("s20")

        ; Buttons
        this.uYy := 45
        this.uAya := 25

        this.uButtonH := 20

        this.uA := XIGUI.AddRadio("Group xs+155 ys+" this.uYy+this.uAya " w25 h" this.uButtonH,"A") ; Bottom
        this.uB := XIGUI.AddRadio("Group xs+180 ys+" this.uYy+this.uAya/2 " w25 h" this.uButtonH,"B") ; Right
        this.uX := XIGUI.AddRadio("Group xs+130 ys+" this.uYy+this.uAya/2 " w25 h" this.uButtonH,"X") ; Left
        this.uY := XIGUI.AddRadio("Group xs+155 ys+" this.uYy " w25 h" this.uButtonH,"Y") ; Top
        
        ; Arrows

        this.DPadW := 15
        this.DPadH := 15

        this.uDPadCenterX := 70
        this.uDPadCenterY := 85

        this.uDPadUp := XIGUI.AddButton("xs+" (this.uDPadCenterX) " ys+" (this.uDPadCenterY - this.DPadH) " w" this.DPadW " h" this.DPadH,"↑")
        this.uDPadDown := XIGUI.AddButton("xs+" (this.uDPadCenterX) " ys+" (this.uDPadCenterY + this.DPadH) " w" this.DPadW " h" this.DPadH,"↓")
        this.uDPadLeft := XIGUI.AddButton("xs+" (this.uDPadCenterX - this.DPadW) " ys+" (this.uDPadCenterY) " w" this.DPadW " h" this.DPadH,"←")
        this.uDPadRight := XIGUI.AddButton("xs+" (this.uDPadCenterX + this.DPadW) " ys+" (this.uDPadCenterY) " w" this.DPadW " h" this.DPadH,"→")

        ; Central Keys
        this.uXBox := XIGUI.AddRadio("Group xs+94 ys+20 w10 h20","")
        this.uBack := XIGUI.AddRadio("Group xs+70 ys+25 w10 h20","")
        this.uStart := XIGUI.AddRadio("Group xs+118 ys+25 w10 h20","")
        XIGUI.AddText("xs ys+128 Section", "--------------")
    }
    /** Update GUI With ControllerObj */
    Update(ControllerObj) {
        CState := ControllerObj.Get()
        if !CState {
            this.bCont.Text := "Xbox Controller " (this.id+1) " (Disconnected)"
            return
        } else {
            this.bCont.Text := "Xbox Controller " (this.id+1)
        }

        StickLX := Floor(CState.StickLX/327.67)
        StickLY := Floor(CState.StickLY/327.67)
        StickRX := Floor(CState.StickRX/327.67)
        StickRY := Floor(CState.StickRY/327.67)

        tDisplay.Value .= "Controller " (this.id+1) " |LX" StickLX " LY" StickLY " |RX" StickRX " RY" StickRY "`n" 

        tDisplay.Value .= "  Back: " CState.Back " Guide: " CState.Guide " Start: " CState.Start "`n"

        this.uLT.Value := CState.LT
        this.uRT.Value := CState.RT
        this.uLS.Enabled := !CState.LS
        this.uRS.Enabled := !CState.RS

        this.uLStick.Move(this.uLStickcX + (CState.StickLX / 32768) * 5, this.uLStickcY - (CState.StickLY / 32768) * 5)
        this.uRStick.Move(this.uRStickcX + (CState.StickRX / 32768) * 5, this.uRStickcY - (CState.StickRY / 32768) * 5)

        StickDZ := 32767/10000 * 100 * 1 ; Deadzone value

        if (CState.StickLC and (this.uLStick.Text = "◎" || this.uLStick.Text = "◍")) {
            this.uLStick.Text := "◉"
        } else if (!CState.StickLC) {
            if (Abs(CState.StickLX) > StickDZ || Abs(CState.StickLY) > StickDZ) {
                this.uLStick.Text := "◍"
            } else {
                this.uLStick.Text := "◎" ; ⨀●◍◉◎○◌○◌◍◎◉◯◙◚
            }
        }
        if (CState.StickRC and (this.uRStick.Text = "◎" || this.uRStick.Text = "◍")) {
            this.uRStick.Text := "◉"
        } else if (!CState.StickRC) {
            if (Abs(CState.StickRX) > StickDZ || Abs(CState.StickRY) > StickDZ) {
                this.uRStick.Text := "◍"
            } else {
                this.uRStick.Text := "◎"
            }
        }

        this.uA.Value := CState.AKey?1:0
        this.uB.Value := CState.BKey?1:0
        this.uX.Value := CState.XKey?1:0
        this.uY.Value := CState.YKey?1:0

        this.uDPadUp.Enabled := !CState.DPadUp
        this.uDPadDown.Enabled := !CState.DPadDown
        this.uDPadLeft.Enabled := !CState.DPadLeft
        this.uDPadRight.Enabled := !CState.DPadRight

        this.uXBox.Value := CState.Guide?1:0
        this.uBack.Value := CState.Back?1:0
        this.uStart.Value := CState.Start?1:0
    }
} ; class ControllerGUI
Controllers := [0,0,0,0]
ControllerGUIs := [0,0,0,0]

XIGUI_Init() {
    XInput_Init
    ; Auto-detect the controller number if called for:
    Loop 4 { ; Query each controller number to find out which ones exist.
        if XInput_GetState(A_Index-1) {
            Controllers[A_Index] := XIController(A_Index-1)
            ControllerGUIs[A_Index] := ControllerGUI(A_Index-1)
        }
    }

    XIGUI.Show()
}

/** Call this per loop to update the GUIs */
XIGUI_Update() {
    global Controllers, ControllerGUIs
    tDisplay.Value := ""
    ; For Each Controller Slot
    Loop 4 {
        Cindex := A_Index - 1
        State := XInput_GetState(Cindex)
        if State {
            ; New Controller connected
            if !ControllerGUIs[A_Index] {
                Controllers[A_Index] := XIController(Cindex)
                ControllerGUIs[A_Index] := ControllerGUI(Cindex)
                XIGUI.Move(,,,200 + A_Index*125) ; refresh GUI after adding controls
            }
        }
        if ControllerGUIs[A_Index] {
            ControllerGUIs[A_Index].Update(Controllers[A_Index])
        }
    }
}