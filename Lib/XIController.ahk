#Requires AutoHotkey v2.0
#Include XInput.ahk

class XIController {
    __New(id) {
        this.id := id
    }
    Get() {
        State := XInput_GetState(this.id)
        if !State ; If the controller is not connected, return an empty object
            return -1

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
            Start: (State.wButtons & XINPUT_GAMEPAD_START) ? 1 : 0,
            StickLC: State.wButtons & XINPUT_GAMEPAD_LEFT_THUMB ? 1 : 0,
            StickRC: State.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB ? 1 : 0,
            StickLX: State.sThumbLX,
            StickLY: State.sThumbLY,
            StickRX: State.sThumbRX,
            StickRY: State.sThumbRY
        }
    }
    ; TODO: make restricted getsticks
    /**  */
    GetSticks(clamp) {
        State := XInput_GetState(this.id)
        if !State
            return -1

        return {
            StickLX: State.sThumbLX,
            StickLY: State.sThumbLY,
            StickRX: State.sThumbRX,
            StickRY: State.sThumbRY
        }
    }
    /** 0~65535 */
    Set(L, R) {
        XInput_SetState(this.id, L, R)
    }
}