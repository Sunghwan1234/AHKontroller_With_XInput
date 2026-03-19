/* XIController v1.2 by Sunghwan1234 */

#Requires AutoHotkey v2.0
#Include XInput.ahk
/*
    XIController Class
    Use FindController() To find the first controller.

    All States (Key : A = KeyA | B : Key = BKey, A/B : Key = AKey/BKey)
    LT: Left Trigger (0-255) | RT: Right Trigger (0-255)
    LS/LB: Left Shoulder/Bumper | RS/RB: Right Shoulder/Bumper
    Key : A/B/X/Y/Guide/Back/Start | A/B/X/Y Key | A/B/X/Y
    Guide: Xbox Button | Back: left | Start: right
    DPad : Up/Down/Left/Right
    Stick : L/R : X/Y/C (XY goes to -32768 - 32767)
    LC/StickLC: Left Click | RC/StickRC: Right Click

    GetSticks(clamp): Clamps the stick values to the desired clamp. The NEGATIVE value will go UNDER the clamp!!!
*/
class XIController {
    __New(id) {
        this.id := id
    }
    /*
     */
    Get() {
        State := XInput_GetState(this.id)
        if !State ; If the controller is not connected, return an empty object
            return -1

        return {
            State: State,
            LT: State.bLeftTrigger,
            RT: State.bRightTrigger,
            LS: (State.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER) ? 1 : 0,
            RS: (State.wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER) ? 1 : 0,
            LB: (State.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER) ? 1 : 0,
            RB: (State.wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER) ? 1 : 0,

            LC: (State.wButtons & XINPUT_GAMEPAD_LEFT_THUMB) ? 1 : 0,
            RC: (State.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB) ? 1 : 0,

            DPadUp: (State.wButtons & XINPUT_GAMEPAD_DPAD_UP) ? 1 : 0,
            DPadDown: (State.wButtons & XINPUT_GAMEPAD_DPAD_DOWN) ? 1 : 0,
            DPadLeft: (State.wButtons & XINPUT_GAMEPAD_DPAD_LEFT) ? 1 : 0,
            DPadRight: (State.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT) ? 1 : 0,
            Up: (State.wButtons & XINPUT_GAMEPAD_DPAD_UP) ? 1 : 0,
            Down: (State.wButtons & XINPUT_GAMEPAD_DPAD_DOWN) ? 1 : 0,
            Left: (State.wButtons & XINPUT_GAMEPAD_DPAD_LEFT) ? 1 : 0,
            Right: (State.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT) ? 1 : 0,
            U: (State.wButtons & XINPUT_GAMEPAD_DPAD_UP) ? 1 : 0,
            D: (State.wButtons & XINPUT_GAMEPAD_DPAD_DOWN) ? 1 : 0,
            L: (State.wButtons & XINPUT_GAMEPAD_DPAD_LEFT) ? 1 : 0,
            R: (State.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT) ? 1 : 0,

            AKey: (State.wButtons & XINPUT_GAMEPAD_A) ? 1 : 0,
            BKey: (State.wButtons & XINPUT_GAMEPAD_B) ? 1 : 0,
            XKey: (State.wButtons & XINPUT_GAMEPAD_X) ? 1 : 0,
            YKey: (State.wButtons & XINPUT_GAMEPAD_Y) ? 1 : 0,
            Guide: (State.wButtons & XINPUT_GAMEPAD_GUIDE) ? 1 : 0,
            Back: (State.wButtons & XINPUT_GAMEPAD_BACK) ? 1 : 0,
            Start: (State.wButtons & XINPUT_GAMEPAD_START) ? 1 : 0,

            Home: (State.wButtons & XINPUT_GAMEPAD_GUIDE) ? 1 : 0,
            XBox: (State.wButtons & XINPUT_GAMEPAD_GUIDE) ? 1 : 0,
            Tabs: (State.wButtons & XINPUT_GAMEPAD_BACK) ? 1 : 0,
            Hamburger: (State.wButtons & XINPUT_GAMEPAD_START) ? 1 : 0,
            Menu: (State.wButtons & XINPUT_GAMEPAD_START) ? 1 : 0,
            
            KeyA: (State.wButtons & XINPUT_GAMEPAD_A) ? 1 : 0,
            KeyB: (State.wButtons & XINPUT_GAMEPAD_B) ? 1 : 0,
            KeyX: (State.wButtons & XINPUT_GAMEPAD_X) ? 1 : 0,
            KeyY: (State.wButtons & XINPUT_GAMEPAD_Y) ? 1 : 0,
            KeyGuide: (State.wButtons & XINPUT_GAMEPAD_GUIDE) ? 1 : 0,
            KeyBack: (State.wButtons & XINPUT_GAMEPAD_BACK) ? 1 : 0,
            KeyStart: (State.wButtons & XINPUT_GAMEPAD_START) ? 1 : 0,

            A: (State.wButtons & XINPUT_GAMEPAD_A) ? 1 : 0,
            B: (State.wButtons & XINPUT_GAMEPAD_B) ? 1 : 0,
            X: (State.wButtons & XINPUT_GAMEPAD_X) ? 1 : 0,
            Y: (State.wButtons & XINPUT_GAMEPAD_Y) ? 1 : 0,

            StickLC: State.wButtons & XINPUT_GAMEPAD_LEFT_THUMB ? 1 : 0,
            StickRC: State.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB ? 1 : 0,
            StickLX: State.sThumbLX,
            StickLY: State.sThumbLY,
            StickRX: State.sThumbRX,
            StickRY: State.sThumbRY,

            ThumbLX: State.sThumbLX,
            ThumbLY: State.sThumbLY,
            ThumbRX: State.sThumbRX,
            ThumbRY: State.sThumbRY
            
        }
    }
    GetMap() {
        newMap := Map() ; Create a new, empty Map
        for key, value in this.Get().OwnProps() {
            newMap.Set(key, value) ; Add each key-value pair to the Map
        }
        return newMap
    }
    /** Get stick's xy within -clamp to clamp */
    GetSticks(clamp) {
        State := XInput_GetState(this.id)
        if !State
            return -1

        return {
            LX: State.sThumbLX/(32767/clamp),
            LY: State.sThumbLY/(32767/clamp),
            RX: State.sThumbRX/(32767/clamp),
            RY: State.sThumbRY/(32767/clamp)
        }
    }
    /** 0~65535 */
    Set(L, R) {
        XInput_SetState(this.id, L, R)
    }
}
/**
 * Finds the first controller detected.
 * Returns the index of the controller. -1 if could not be found.
 */
FindController() {
    Loop 4 {
        if XInput_GetState(A_Index-1) {
            return A_Index-1
        }
    }
    return -1
}