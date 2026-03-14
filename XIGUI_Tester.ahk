#Requires AutoHotkey v2.0
#Include <XIGUI>
#SingleInstance
XIGUI_Init

`::ExitApp
Esc::ExitApp

Loop
    XIGUI_Update
    Sleep 16 ; ~60 FPS


