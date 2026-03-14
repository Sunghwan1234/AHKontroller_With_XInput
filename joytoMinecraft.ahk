/* JTMC v1.2 by Sunghwan1234 */

#Include <XInput>
#Include <XIController>
#SingleInstance
XInput_Init
InstallMouseHook

F10::ExitApp

G := Gui("+Resize Disabled", "JoyToMinecraft")
G.Add("Text", "w200 h40", "JoyToMinecraft Active. Press F10 or the Top button on your controller to Exit")
E := G.Add("Edit", "w200 h100 +ReadOnly")
G.Show()

Controller := XIController(FindController())

SlotBefore := -1
Slot := 1
LSOn := 0
RSOn := 0
YOn := 0

MouseSpeed := 0.001  ; Adjust this value to change the mouse speed

Loop {
    State := Controller.Get()

    /** Current Implemented Features:
     *  Movement: WASD(StickL) Jump(A) Shift(X) Sprint(StickLC)
     *  Camera: StickR, Slow(StickRC)
     *  Inventory: E
     *  Slot Switching: L/R Shoulder
     *  Actions: LClick(RB) RClick(LB)
     *  Throw: Left button of XBox: Tabs/Back
     *  Menu: Right button of Xbox: Start/Menu/Hamburger
     *  Quit: XBox button or Guide
     * 
     * Not Yet Implemented:
     * Better Shifting, Offhand(Not on 1.8), InvSlot(DPad)
     * Cheats: Autoclick, KeepHolding, LootAll
     */

    LT := State.LT
    RT := State.RT
    LS := State.LS
    RS := State.RS
    LC := State.LC
    RC := State.RC

    if State.StickLY > 10000
        Send "{w Down}"
    else if GetKeyState("w")=1
        Send "{w Up}"
    if State.StickLY < -10000
        Send "{s Down}"
    else if GetKeyState("s")=1
        Send "{s Up}"
    if State.StickLX < -10000
        Send "{a Down}"
    else if GetKeyState("a")=1
        Send "{a Up}"
    if State.StickLX > 10000
        Send "{d Down}"
    else if GetKeyState("d")=1
        Send "{d Up}"

    if State.AKey
        Send "{Space Down}"
    else if GetKeyState("Space")=1
        Send "{Space Up}"
    if State.YKey && YOn = 0 {
        YOn := 1
        Send 'e'
    } else if !State.YKey && YOn = 1 {
        YOn := 0
    }
    if (State.XKey) {
        Send "{Shift Down}"
    } else if (GetKeyState("Shift")) {
        Send "{Shift Up}"
    }
    if (State.Tabs) {
        Send "{Q Down}"
    } else if (GetKeyState("Q")) {
        Send "{Q Up}"
    }

    if (State.Menu) {
        Send "{Escape Down}"
    } else if (GetKeyState("Escape")) {
        Send "{Escape Up}"
    }

    if RT>0 && GetKeyState('LButton')=0
        MouseClick 'Left' , , , , , 'Down'
    else if RT=0 && GetKeyState('LButton')=1
        MouseClick 'Left' , , , , , 'Up'
    if LT>0 && GetKeyState('RButton')=0
        MouseClick 'R' , , , , , 'Down'
    else if LT=0 && GetKeyState('RButton')=1
        MouseClick 'R' , , , , , 'Up'
    if LC && GetKeyState("R") = 0
        Send "{R Down}"
    else if !LC && GetKeyState("R")=1
        Send "{R Up}"
    if RC
        MouseSpeed := 0.0005
    else
        MouseSpeed := 0.001
    if (LS) {
        if LSOn = 0 {
            LSOn := 1
            if Slot = 0
                Slot := 9
            else Slot -= 1
        }
    } else LSOn := 0
    if (RS) {
        if RSOn = 0 {
            RSOn := 1
            if Slot = 9
                Slot := 0
            else Slot += 1
        }
    } else RSOn := 0
    
    if SlotBefore != Slot
        Send Slot
    SlotBefore := Slot

    ; Left thumbstick controls view (mouse movement)
    MouseMoveX := State.StickRX * MouseSpeed
    MouseMoveY := -State.StickRY * MouseSpeed  ; Invert Y-axis for natural movement
    ; Move the mouse
    MouseMove MouseMoveX, MouseMoveY, 1, 'R'

    Controller.Set(LT*64, RT*64)

    Sleep 20

    if (State.Home) {
        ExitApp
    }
}
