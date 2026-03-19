/** joyToMinecraft vXICMap1.1 */
#Requires AutoHotkey v2.0
#Include <XICMap>
#SingleInstance
XInput_Init
InstallMouseHook

F10::ExitApp
Esc::ExitApp
'::ExitApp

w := Gui("Disabled","JTMC")
w.AddText(,"Using XICMap")
w.Move(,,150,300)
/** Current Implemented Features:
 *  Movement: WASD(StickL) Space(A) Shift(X) R(StickLC)
 *  Mouse: StickR
 *  Inventory: E(Y)
 *  Slot Switching: L/R Shoulder
 *  Mouse Clicks: LClick(RB) RClick(LB)
 *  Throw: Q(Down)
 *  Menu: Right button of Xbox: Start/Menu/Hamburger
 *  F3: Left Button of XBox: Back
 * Not Yet Implemented:
 * Better Shifting, Offhand(Not on 1.8), InvSlot(DPad), Gamemode
 * Cheats: Autoclick, KeepHolding, LootAll
 */

c := XICMAP(FindController())
c.BindMouse()
c.BindMovement()
c.BindMouseButtons()
c.BindKeyScroll("LB",-1,1)
c.BindKeyScroll("RB",1,1)
c.Bind("Y", "e", 1)
c.Bind("A","space")
c.Bind("X","shift")
c.Bind("LC","r")
c.Bind("D","q")

c.Bind("Start","``",1)
c.Bind("Back","{F3}",1)

e := w.AddEdit("ReadOnly w100", "Edit")
e.Value := c.stringBinds()
w.Show()
Loop {
    c.ApplyBindings()
    Sleep 16
}