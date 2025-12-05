; END OF CONFIG SECTION. Do not make changes below this point unless
; you wish to alter the basic functionality of the script.

Window := Gui("+AlwaysOnTop", "Controller Test Script")
Window.Add("Text", "w300", "Note: For Xbox controller 2013 and newer (anything newer than the Xbox 360 controller), this script can only detect controller events if a window it owns is active (like this one).")
tDisplay := Window.Add("Edit", "w300 h50 +ReadOnly")
tDisplay2 := Window.Add("Edit","w300 h80 +ReadOnly")

; Auto-detect the controller number if called for:
if ControllerNumber <= 0
{
    Loop 16  ; Query each controller number to find out which ones exist.
    {
        if GetKeyState(A_Index "JoyName")
        {
            ControllerNumber := A_Index
            bCont := Window.Add("GroupBox","Section w300 h150", "Controller " A_Index)
            bLT := Window.AddProgress("xs+10 ys+15 w50 h10","LT")
            bLB := Window.AddButton("xs+10 ys+25 w50 h20","LB")
            bRT := Window.AddProgress("xs+240 ys+15 w50 h10","RT") ; 300(w)-10(border)-50(w) = 240x
            bRB := Window.AddButton("xs+240 ys+25 w50 h20","RB")

            break
        }
    }
    if ControllerNumber <= 0
    {
        tDisplay.Value := "The system does not appear to have any controllers."
        return
    }
}
Window.Show()
#SingleInstance
c_buttons := GetKeyState(ControllerNumber "JoyButtons")
c_name := GetKeyState(ControllerNumber "JoyName")
c_info := GetKeyState(ControllerNumber "JoyInfo")
Loop {
    all_buttons := ""
    buttons_down := ""
    bLB.Enabled := true
    Loop c_buttons {
        key_state := GetKeyState(ControllerNumber "Joy" A_Index)
        if key_state {
            buttons_down .= " " A_Index
            switch A_Index {
                case 5: bLB.Enabled := false
            }
        }
        all_buttons .= "Key " A_Index " : " key_state " | "
    }
    
    all_buttons .= "R:" GetKeyState(ControllerNumber "JoyR") "  "
    all_buttons .= "U:" GetKeyState(ControllerNumber "JoyU") "  "
    all_buttons .= "V:" GetKeyState(ControllerNumber "JoyV") "  "
    all_buttons .= "X:" GetKeyState(ControllerNumber "JoyX") "  "
    all_buttons .= "Y:" GetKeyState(ControllerNumber "JoyY") "  "
    all_buttons .= "Z:" GetKeyState(ControllerNumber "JoyZ") "  "

    bLT.Value := GetKeyState(ControllerNumber "Joy1")
    tDisplay.Value := "Controller " ControllerNumber " | " buttons_down
    tDisplay2.Value := all_buttons
    Sleep 100
}
Exit