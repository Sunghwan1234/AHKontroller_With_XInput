#Requires AutoHotkey v2.0
#Include XIController.ahk ; XIController already includes xinput

/** XICMAP */
class XICMAP {
    __New(id) {
        this.xic := XIController(id)
        this.binds := Map()
        this.mouse := unset
        this.mouseButtons := unset
        this.click := unset
        this.movement := unset
    }
    Get() {
        this.xic.Get()
    }
    Set() {
        this.xic.Set()
    }
    /**
     * Bind a controller key to a keyboard key.
     * Method 0: Hold & Release (Instant)
     * Method 1: Key-Repeat (After holding it repeats) (WIP)
     */
    Bind(cKey, kKey, method:=0) {
        if (!this.xic.Get().HasOwnProp(cKey)) {
            MsgBox cKey " does not exist!"
            return -1
        }
        this.binds[cKey] := kKey
        return 1
    }
    /**
     * Bind the mouse to a joystick. You must do InstallMouseHook before.
     * @param joystick Left -1 or Right 1
     * @param speed 
     * @param deadzone
     */
    BindMouse(joystick:=1, speed:="0.001", deadzone:="256") {
        this.mouse := {
            joystick: joystick,
            speed: speed,
            deadzone: deadzone
        }
    }
    /**
     * Bind Mouse Buttons.
     * @param L 
     * @param R 
     */
    BindMouseButtons(L:="RT",R:="LT", M:=unset) {
        this.mouseButtons:={
            L:L,
            R:R,
            M:M
        }
    }
    /**
     * Bind clicks on a mouse. Clicks mean it only executes once.
     * @param leftClick 
     * @param rightClick 
     */
    BindClick(leftClick:="RT",rightClick:="LT", middleClick:=unset) {
        this.click := {
            leftClick:leftClick,
            rightClick:rightClick,
            middleClick:middleClick
        }
    }
    /**
     * Bind a joystick to movement, such as wasd.
     * @param joystick Left -1 or Right 1
     * @param u Forward/Up
     * @param l Left
     * @param d Backward/Down
     * @param r Right
     * @param deadzone 
     */
    BindMovement(joystick:=-1,u:="W",l:="A",d:="S",r:="D",deadzone:=10000) {
        this.movement := {
            joystick:joystick,
            u:u,
            d:d,
            l:l,
            r:r,
            deadzone:deadzone
        }
    }
    /**
     * Applies all bindings. Use this in a loop.
     */
    ApplyBindings() {
        State := this.xic.Get()
        for ckey, kKey in this.binds {
            if (State.GetOwnPropDesc(cKey).Value) {
                Send("{" kKey " Down}")
            } else {
                Send("{" kKey " Up}")
            }
        }
        if IsSet(mouse) {
            MouseMoveX := State.StickRX * mouse.speed
            MouseMoveY := -State.StickRY * mouse.speed ; Invert Y-axis
            ; Move the mouse
            MouseMove MouseMoveX, MouseMoveY, 1, 'R'
        }
        if IsSet(mouseButtons) {
            if State.GetOwnPropDesc(mouseButtons.L)>0 && GetKeyState('LButton')=0
                MouseClick 'L' , , , , , 'Down'
            else if State.GetOwnPropDesc(mouseButtons.L)=0 && GetKeyState('LButton')=1
                MouseClick 'L' , , , , , 'Up'
            if State.GetOwnPropDesc(mouseButtons.R)>0 && GetKeyState('RButton')=0
                MouseClick 'R' , , , , , 'Down'
            else if State.GetOwnPropDesc(mouseButtons.R)=0 && GetKeyState('RButton')=1
                MouseClick 'R' , , , , , 'Up'
        }
        if IsSet(movement) {
            MSgBox "IM MOVING"
            if movement.joystick {
                StickX := State.StickRX
                StickY := State.StickRY
            } else {
                StickX := State.StickLX
                StickY := State.StickLY
            }
            if StickY > movement.deadzone
                Send "{" movement.u " Down}"
            else if GetKeyState(movement.n)=1
                Send "{" movement.u " Up}"
            if StickY < -movement.deadzone
                Send "{" movement.d " Down}"
            else if GetKeyState(movement.s)=1
                Send "{" movement.d " Up}"
            if StickX < -movement.deadzone
                Send "{" movement.l " Down}"
            else if GetKeyState(movement.l)=1
                Send "{" movement.l " Up}"
            if StickX > movement.deadzone
                Send "{" movement.r " Down}"
            else if GetKeyState(movement.r)=1
                Send "{" movement.r " Up}"
        }
        
    }
}