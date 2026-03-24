/* XIControllerB v1.0 by Sunghwan1234 */

#Requires AutoHotkey v2.0
#Include XInput.ahk
/**
 * State, LeftTrigger, RightTrigger, LeftShoulder, RightShoulder, LeftThumb, RightThumb, ThumbLX, ThumbLY, ThumbRX, ThumbRY,
 * DPadUp, DPadDown, DPadLeft, DPadRight, A, B, X, Y, Guide, Back, Start
 * @param id Controller ID (0-3)
 * @returns An object containing the state of the controller. Returns -1 if the controller is not connected.
 */
GetButtons(id) {
    State := XInput_GetState(id)
    if !State ; If the controller is not connected, return an empty object
        return -1
    return {
        State: State,
        LeftTrigger: State.bLeftTrigger,
        RightTrigger: State.bRightTrigger,
        LeftShoulder: (State.wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER) ? 1 : 0,
        RightShoulder: (State.wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER) ? 1 : 0,
        LeftThumb: (State.wButtons & XINPUT_GAMEPAD_LEFT_THUMB) ? 1 : 0,
        RightThumb: (State.wButtons & XINPUT_GAMEPAD_RIGHT_THUMB) ? 1 : 0,

        DPadUp: (State.wButtons & XINPUT_GAMEPAD_DPAD_UP) ? 1 : 0,
        DPadDown: (State.wButtons & XINPUT_GAMEPAD_DPAD_DOWN) ? 1 : 0,
        DPadLeft: (State.wButtons & XINPUT_GAMEPAD_DPAD_LEFT) ? 1 : 0,
        DPadRight: (State.wButtons & XINPUT_GAMEPAD_DPAD_RIGHT) ? 1 : 0,

        A: (State.wButtons & XINPUT_GAMEPAD_A) ? 1 : 0,
        B: (State.wButtons & XINPUT_GAMEPAD_B) ? 1 : 0,
        X: (State.wButtons & XINPUT_GAMEPAD_X) ? 1 : 0,
        Y: (State.wButtons & XINPUT_GAMEPAD_Y) ? 1 : 0,

        Guide: (State.wButtons & XINPUT_GAMEPAD_GUIDE) ? 1 : 0,
        Back: (State.wButtons & XINPUT_GAMEPAD_BACK) ? 1 : 0,
        Start: (State.wButtons & XINPUT_GAMEPAD_START) ? 1 : 0,

        ThumbLX: State.sThumbLX,
        ThumbLY: State.sThumbLY,
        ThumbRX: State.sThumbRX,
        ThumbRY: State.sThumbRY
    }
}
/* 
    All States (Key : A = KeyA | B : Key = BKey, A/B : Key = AKey/BKey)
    LT: Left Trigger (0-255) | RT: Right Trigger (0-255)
    LS/LB: Left Shoulder/Bumper | RS/RB: Right Shoulder/Bumper
    Key : A/B/X/Y/Guide/Back/Start | A/B/X/Y Key | A/B/X/Y
    Guide: Xbox Button | Back: left | Start: right
    DPad : Up/Down/Left/Right
    Stick : L/R : X/Y/C (XY goes to -32768 - 32767)
    LC/StickLC: Left Click | RC/StickRC: Right Click
*/
Get(id) {
    b := GetButtons(id)
    return JoinObjects(b,{
        State: b.State,
        LT: b.LeftTrigger,
        RT: b.RightTrigger,
        LS: b.LeftShoulder,
        RS: b.RightShoulder,
        LB: b.LeftShoulder,
        RB: b.RightShoulder,

        LC: b.LeftThumb,
        RC: b.RightThumb,

        Up: b.DPadUp,
        Down: b.DPadDown,
        Left: b.DPadLeft,
        Right: b.DPadRight,
        U: b.DPadUp,
        D: b.DPadDown,
        L: b.DPadLeft,
        R: b.DPadRight,

        AKey: b.A,
        BKey: b.B,
        XKey: b.X,
        YKey: b.Y,

        Home: b.Guide,
        XBox: b.Guide,
        Tabs: b.Back,
        Hamburger: b.Start,
        Menu: b.Start,
        
        KeyA: b.A,
        KeyB: b.B,
        KeyX: b.X,
        KeyY: b.Y,
        KeyGuide: b.Guide,
        KeyBack: b.Back,
        KeyStart: b.Start,

        StickLC: b.LeftThumb,
        StickRC: b.RightThumb,
        StickLX: b.ThumbLX,
        StickLY: b.ThumbLY,
        StickRX: b.ThumbRX,
        StickRY: b.ThumbRY,
    })
}
GetMap(id) {
    newMap := Map() ; Create a new, empty Map
    for key, value in Get(id).OwnProps() {
        newMap.Set(key, value) ; Add each key-value pair to the Map
    }
    return newMap
}
/** Get stick's xy within -clamp to clamp */
GetSticks(id, clamp) {
    State := XInput_GetState(id)
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
Set(id, L, R) {
    XInput_SetState(id, L, R)
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
/** thank you gemini */
JoinObjects(objTarget, objSource) {
    res := objTarget.Clone()  ; Clone the target object to avoid modifying the original
    for k, v in objSource.OwnProps() {
        res.%k% := v          ; Add each property from the source to the result
    }
    return res
}