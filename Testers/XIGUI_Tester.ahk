#Requires AutoHotkey v2.0
#Include ../Lib/XIGUI.ahk
#SingleInstance
XIGUI_Init

`::ExitApp
Esc::ExitApp

Loop
    XIGUI_Update
    Sleep 16 ; ~60 FPS


