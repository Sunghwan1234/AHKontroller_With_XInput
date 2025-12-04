Esc::ExitApp
ControllerNumber := 0

; END OF CONFIG SECTION. Do not make changes below this point unless
; you wish to alter the basic functionality of the script.

Window := Gui("+AlwaysOnTop", "Controller Test Script")
Window.Add("Text", "w300", "Note: For Xbox controller 2013 and newer (anything newer than the Xbox 360 controller), this script can only detect controller events if a window it owns is active (like this one).")
tDisplay := Window.Add("Edit", "w300 h100 +ReadOnly")

; Auto-detect the controller number if called for:
if ControllerNumber <= 0
{
    Loop 16  ; Query each controller number to find out which ones exist.
    {
        if GetKeyState(A_Index "JoyName")
        {
            ControllerNumber := A_Index
            bCont := Window.Add("GroupBox","Section w300 h150", "Controller " A_Index)
            bLB := Window.AddButton("xp+10 yp+20","0")
            bLB.
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
    buttons_down := ""
    Loop c_buttons {
        if GetKeyState(ControllerNumber "Joy" A_Index)
            buttons_down .= " " A_Index
    }
    tDisplay.Value := "Controller " ControllerNumber " | " buttons_down
    Sleep 100
}
Exit