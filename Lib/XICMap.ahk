#Requires AutoHotkey v2.0
#Include XIController.ahk ; XIController already includes xinput

/** XICMAP v1.0 by Sunghwan1234 */
class XICMAP {
    __New(id) {
        this.xic := XIController(id)
        this.binds := Map()
        this.bindCP := Map()
        this.bindC := Map()
        this.mouse := 0
        this.mouseButtons := 0
        this.scroll := Map()
        this.click := 0
        this.movement := 0
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
    Bind(cKey, kKey, once:=0) {
        if (!this.xic.Get().HasOwnProp(cKey)) {
            MsgBox cKey " does not exist!"
            return -1
        }
        if once {
            this.bindCP[cKey] := 0
            this.bindC[cKey] := kKey
        } else {
            this.binds[cKey] := kKey
        }
        return 1
    }
    Unbind(cKey) {
        if (this.binds.Has(cKey))
            this.binds.Delete(cKey)
    }
    /**
     * Bind the mouse to a joystick. You must do InstallMouseHook before.
     * @param joystick Left 0 or Right 1
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
    UnbindMouse() {
        this.mouse := 0
    }
    /**
     * Bind Mouse Buttons.
     * @param L 
     * @param R 
     */
    BindMouseButtons(L:="RT",R:="LT", M:=0) {
        this.mouseButtons:={
            L:L,
            R:R,
            M:M
        }
    }
    UnbindMouseButtons() {
        this.mouseButtons := 0
    }
    /**
     * Binds a key to a mousescroll.
     * @param kKey Keyboard Key
     * @param scrollAmount 
     * @param once 
     */
    BindKeyScroll(kKey, scrollAmount, once:=0) {
        this.scroll[kKey] := {
            scrollAmount:scrollAmount, 
            once:once,
            pressed:0
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
     * @param joystick Left 0 or Right 1
     * @param u Forward/Up
     * @param l Left
     * @param d Backward/Down
     * @param r Right
     * @param deadzone 
     */
    BindMovement(joystick:=0,u:="w",l:="a",d:="s",r:="d",deadzone:=10000) {
        this.movement := {
            joystick:joystick,
            u:u,
            d:d,
            l:l,
            r:r,
            deadzone:deadzone
        }
    }
    UnbindMovement() {
        this.movement := 0
    }
    /**
     * Applies all bindings. Use this in a loop.
     */
    ApplyBindings() {
        mouse := this.mouse
        mouseButtons := this.mouseButtons
        movement := this.movement
        State := this.xic.Get()
        StateMap := this.xic.GetMap()

        for cKey, kKey in this.binds {
            if (State.GetOwnPropDesc(cKey).Value) {
                Send("{" kKey " Down}")
            } else if GetKeyState(kKey) {
                Send("{" kKey " Up}")
            }
        }
        for cKey, kKey in this.bindC {
            if (StateMap[cKey] && !this.bindCP[cKey]) {
                Send kKey
                this.bindCP[cKey] := 1
            } else if (!StateMap[cKey]) {
                this.bindCP[cKey] := 0
            }
        }
        if (mouse) {
            if mouse.joystick {
                StickX := State.StickRX
                StickY := State.StickRY
            } else {
                StickX := State.StickLX
                StickY := State.StickLY
            }
            MouseMoveX := StickX * mouse.speed
            MouseMoveY := -StickY * mouse.speed ; Invert Y-axis
            ; Move the mouse
            MouseMove MouseMoveX, MouseMoveY, 1, 'R'
        }
        if (mouseButtons) {
            if State.GetOwnPropDesc(mouseButtons.L).Value>0 && GetKeyState('LButton')=0
                MouseClick 'L' , , , , , 'Down'
            else if State.GetOwnPropDesc(mouseButtons.L).Value=0 && GetKeyState('LButton')=1
                MouseClick 'L' , , , , , 'Up'
            if State.GetOwnPropDesc(mouseButtons.R).Value>0 && GetKeyState('RButton')=0
                MouseClick 'R' , , , , , 'Down'
            else if State.GetOwnPropDesc(mouseButtons.R).Value=0 && GetKeyState('RButton')=1
                MouseClick 'R' , , , , , 'Up'
        }
        for kKey, value in this.scroll {
            if value.once {
                if StateMap[kKey] && !value.pressed {
                    if (value.scrollAmount<0)
                        Send "{WheelUp}"
                    else
                        Send "{WheelDown}"
                    value.pressed := 1
                } else if !StateMap[kKey] {
                    value.pressed := 0
                }
            } else {
                if StateMap[kKey] {
                    if (value.scrollAmount<0)
                        Send "{WheelUp}"
                    else
                        Send "{WheelDown}"
                }
            }
        }
        if (movement) {
            if movement.joystick {
                StickX := State.StickRX
                StickY := State.StickRY
            } else {
                StickX := State.StickLX
                StickY := State.StickLY
            }
            if StickY > movement.deadzone
                Send "{" movement.u " Down}"
            else if GetKeyState(movement.u)
                Send "{" movement.u " Up}"
            if StickY < -movement.deadzone
                Send "{" movement.d " Down}"
            else if GetKeyState(movement.d)
                Send "{" movement.d " Up}"
            if StickX < -movement.deadzone
                Send "{" movement.l " Down}"
            else if GetKeyState(movement.l)
                Send "{" movement.l " Up}"
            if StickX > movement.deadzone
                Send "{" movement.r " Down}"
            else if GetKeyState(movement.r)
                Send "{" movement.r " Up}"
        }
    }
    ApplyBind(cKey, kKey, once:=0) {
        if once {
            if (this.xic.GetMap()[cKey]) {
                Send("{" kKey " Down}")
            } else if GetKeyState(kKey) {
                Send("{" kKey " Up}")
            }
        } else {
            if (this.xic.GetMap()[cKey] && !this.bindCP[cKey]) {
                Send kKey
                this.bindCP[cKey] := 1
            } else if (!this.xic.GetMap()[cKey]) {
                this.bindCP[cKey] := 0
            }
        }
    }
    stringBinds() {
        delimiter_kv := ":", delimiter_pair := ","
        output := ""
        for key, value in this.binds {
            ; Append key-value pair
            output .= key . delimiter_kv . value
            output .= delimiter_pair
        }
        for key, value in this.bindC {
            ; Append key-value pair
            output .= key . delimiter_kv . value
            output .= delimiter_pair
        }
        return output
    }
}