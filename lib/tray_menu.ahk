#Requires AutoHotkey v2.0

; ╭───────────╮
; │ VARIABLES │
; ╰───────────╯
tray_icon_normal            := ".\FLOW\icons\flow-sl-normal.ico"
tray_icon_pause_all         := ".\FLOW\icons\flow-sl-pause.ico"
tray_icon_pause_hotkeys     := ".\FLOW\icons\flow-sl-pause.ico"
tray_icon_pause_hotstrings  := ".\FLOW\icons\flow-sl-pause-hs.ico"
tray_icon_suspend           := ".\FLOW\icons\flow-sl-suspend.ico"
traymenu_icon_checked       := ".\FLOW\icons\flow_checked.ico"
traymenu_icon_unchecked     := ".\FLOW\icons\flow_unchecked.ico"

; custom tray menu items
trayitem_flow_ref             := "FLOW Shortcut Keys"
trayitem_flow_ref_ico         := ".\FLOW\icons\flow-sl-normal.ico"
trayitem_flow_ref_ico         := ".\FLOW\icons\flow_keeb.ico"
trayitem_about                := "About FLOW Streamline"
trayitem_about_ico            := ".\FLOW\icons\flow-sl-normal.ico"
trayitem_reload               := "&Reload Script`t[Ctrl+Win+Alt]+[R]"
trayitem_reload_ico           := ".\FLOW\icons\flow_reload.ico"
trayitem_toggle_hstrings      := "Aux Hot&Strings`t[Ctrl+Win+Alt]+[S]"
trayitem_toggle_hstrings_ico  := traymenu_icon_checked
trayitem_toggle_hkeys         := "Aux Hot&Keys`t[Ctrl+Win+Alt]+[K]"
trayitem_toggle_hkeys_ico     := traymenu_icon_checked
trayitem_debug                := "Debug Tools"
trayitem_debug_ico            := ".\FLOW\icons\flow_debug.ico"
trayitem_ahkhelp              := "AutoHotkey Help`t[Ctrl+Win+Alt]+[F2]"
trayitem_ahkhelp_ico          := ".\FLOW\icons\flow_help.ico"
trayitem_exit                 := "E&xit FLOW Streamline"
trayitem_exit_ico             := ".\FLOW\icons\flow_stop.ico"
trayitem_edit                 := "E&dit Script`t[Ctrl+Win+Alt]+[E]"
trayitem_edit_ico             := ".\FLOW\icons\flow_edit.ico"
trayitem_runatstartup         := "Run at Startup"

this_script_shorcut    := A_Startup "\" SubStr(A_ScriptName, 1, StrLen(A_ScriptName) - 4) ".lnk"
If (FileExist(this_script_shorcut))
{
  trayitem_runatstartup_ico := traymenu_icon_checked
}
Else
{
  trayitem_runatstartup_ico := traymenu_icon_unchecked
}


; ╭───────────────────────╮
; │  Build the Tray menu  │
; ╰───────────────────────╯

DisplayTrayMenu()
{
  /*
  ╒═══════════════════════════════════════════════════════════════════════╕
  │ Custom menu items                                                     │
  ╞═══════════════════════════════════════════════════════════════════════╡
  │ Reference: https://www.autohotkey.com/docs/v2/lib/Menu.htm#ExTray     │
  └───────────────────────────────────────────────────────────────────────┘
  */

  ; Startup sound
  SoundPlay toggle_sound_file_startrun
  ; SoundPlay "*16"

  ; Light/Dark Theme-safe colored Tray Icon
  TraySetIcon tray_icon_normal

  ; Set the Tray icon tooltip
  global Tray := A_TrayMenu ; For convenience.
  IconTipString := "
    (
      FLOW Shortcut Keys
      Last Run: `s
    )" LaunchTime "
    (
      `nScript: `s
    )" A_ScriptFullPath
  A_IconTip := IconTipString

  ; Delete the standard items. Not Required unless replacing
  Tray.Delete()

  ; Create custom tray menu items
  trayitem_flow_ref := "FLOW Shortcut Keys"
  trayitem_flow_ref_icon := ".\FLOW\icons\flow-sl-normal.ico"
  trayitem_flow_ref_icon := ".\FLOW\icons\flow_keeb.ico"

  trayitem_about := "About FLOW Streamline"
  trayitem_about_icon := ".\FLOW\icons\flow-sl-normal.ico"
  ; trayitem_about_icon := ".\FLOW\icons\flow_coffee2go.ico"

  trayitem_reload := "&Reload Script`t[Ctrl+Win+Alt]+[R]"
  trayitem_reload_icon := ".\FLOW\icons\flow_reload.ico"

  trayitem_toggle_hstrings := "Aux Hot&Strings`t[Ctrl+Win+Alt]+[S]"
  trayitem_toggle_hstrings_icon := traymenu_icon_checked

  trayitem_toggle_hkeys := "Aux Hot&Keys`t[Ctrl+Win+Alt]+[K]"
  trayitem_toggle_hkeys_icon := traymenu_icon_checked

  trayitem_debug := "Debug Tools"
  trayitem_debug_icon := ".\FLOW\icons\flow_debug.ico"

  trayitem_ahkhelp := "AutoHotkey Help`t[Ctrl+Win+Alt]+[F2]"
  trayitem_ahkhelp_icon := ".\FLOW\icons\flow_help.ico"

  trayitem_exit := "E&xit FLOW Streamline"
  trayitem_exit_icon := ".\FLOW\icons\flow_stop.ico"

  trayitem_edit := "E&dit Script`t[Ctrl+Win+Alt]+[E]"
  trayitem_edit_icon := ".\FLOW\icons\flow_edit.ico"

  trayitem_runatstartup := "Run at Startup"
  global this_script_shorcut := A_Startup "\" SubStr(A_ScriptName, 1, StrLen(A_ScriptName) - 4) ".lnk"
  If (FileExist(this_script_shorcut))
  {
    trayitem_runatstartup_icon := traymenu_icon_checked
  }
  Else
  {
    trayitem_runatstartup_icon := traymenu_icon_unchecked
  }

  ; Define the menu items
  Tray.Add(trayitem_flow_ref, DisplayShorcutKeys)
  Tray.SetIcon(trayitem_flow_ref, trayitem_flow_ref_ico)

  Tray.Add(trayitem_reload, ReloadAndReturn)
  Tray.SetIcon(trayitem_reload, trayitem_reload_ico)

  Tray.Add(trayitem_edit, EditAndReturn)
  Tray.SetIcon(trayitem_edit, trayitem_edit_ico)

  ; Enable Hotstrings as the default value
  Tray.Add(trayitem_toggle_hstrings, ToggleAuxHotstrings)
  global Aux_HotStringSupport := true
  ; Tray.Check(trayitem_toggle_hstrings)
  Tray.SetIcon(trayitem_toggle_hstrings, trayitem_toggle_hstrings_ico)

  ; Enable HotKeys as the default value
  Tray.Add(trayitem_toggle_hkeys, ToggleAuxHotkeys)
  global Aux_HotKeySupport := true
  ; Tray.Check(trayitem_toggle_hkeys)
  Tray.SetIcon(trayitem_toggle_hkeys, trayitem_toggle_hkeys_ico)

  Tray.Add(trayitem_runatstartup, ToggleRunAtStartup)
  Tray.SetIcon(trayitem_runatstartup, trayitem_runatstartup_ico)

  Tray.Add() ; separator
  ; Tray.Add(trayitem_debug, ShowListLines)
  DebugMenu := Menu()
  Tray.Add(trayitem_debug, DebugMenu)
  Tray.SetIcon(trayitem_debug, trayitem_debug_ico)
  DebugMenu.Add("Key & Mouse Button History", ShowListLines)
  DebugMenu.Add("Coming: KeyHistory", ShowListLines)
  DebugMenu.Disable("Coming: KeyHistory")
  DebugMenu.Add("Coming: ListHotKeys", ShowListLines)
  DebugMenu.Disable("Coming: ListHotKeys")
  DebugMenu.Add("Coming: ListVars", ShowListLines)
  DebugMenu.Disable("Coming: ListVars")
  DebugMenu.Add("Coming: WindowsSpy", ShowListLines)
  DebugMenu.Disable("Coming: WindowsSpy")
  DebugMenu.Add("Coming: Browse This Directory", OpenScriptDir)

  Tray.Add(trayitem_ahkhelp, ShowHelp)
  Tray.SetIcon(trayitem_ahkhelp, trayitem_ahkhelp_ico)

  Tray.Add() ; separator

  Tray.Add(trayitem_exit, EndScript)
  Tray.SetIcon(trayitem_exit, trayitem_exit_ico)

  Tray.Add() ; separator

  Tray.Add(trayitem_about, DisplayAbout)
  Tray.SetIcon(trayitem_about, trayitem_about_ico)

  ; Tray.Add("TestToggleEnable", ToggleTestEnable)
  ; Tray.Add("Windows Spy", TestDefault)
  ; Tray.Add() ; separator
  ; Tray.Add("Suspend All", SuspendHotkeys)
  ; Tray.Add("Exit", EndScript )


  ; Set the default menu item for double-clicking the tray icon
  Tray.Default := trayitem_flow_ref

  ; Make the tray menu show when the tray icon is also left-clicked
  OnMessage 0x404, Received_AHK_NOTIFYICON
  Received_AHK_NOTIFYICON(wParam, lParam, nMsg, hwnd) {
    if lParam = 0x202 { ; WM_LBUTTONUP
      A_TrayMenu.Show
      return 1
    }
  }
}

; ╭─────────────────────────────────────────────────────────────────────╮
; │  Enable or Disable Auxillary hotkeys defined in AUX_HOTSTRINGS.AHK  │
; ╰─────────────────────────────────────────────────────────────────────╯
ToggleAuxHotstrings(*)
{
  global Aux_HotStringSupport := !Aux_HotStringSupport
  if (Aux_HotStringSupport = true) {
    IndicateToggle("Auxillary HotStrings", "hotkeys", true, true, true)
    trayitem_toggle_hstrings_ico := traymenu_icon_checked
  } else {
    IndicateToggle("Auxillary HotStrings", "hotkeys", false, true, true)
    trayitem_toggle_hstrings_ico := traymenu_icon_unchecked
  }

  Tray.SetIcon(trayitem_toggle_hstrings, trayitem_toggle_hstrings_ico)
}

; ╭──────────────────────────────────────────────────────────────────╮
; │  Enable or Disable Auxillary hotkeys defined in AUX_HOTKEYS.AHK  │
; ╰──────────────────────────────────────────────────────────────────╯
ToggleAuxHotkeys(*)
{
  global Aux_HotKeySupport := !Aux_HotKeySupport
  if (Aux_HotKeySupport = true) {
    IndicateToggle("Auxillary HotKeys", "hotstrings", true, true, true)
    trayitem_toggle_hkeys_ico := traymenu_icon_checked
  } else {
    IndicateToggle("Auxillary HotKyes", "hotstrings", false, true, true)
    trayitem_toggle_hkeys_ico := traymenu_icon_unchecked
  }

  Tray.SetIcon(trayitem_toggle_hkeys, trayitem_toggle_hkeys_ico)
}

; ╭─────────────────────────────────────────────────╮
; │  This will allow the script to run at startup.  │
; ╰─────────────────────────────────────────────────╯
ToggleRunAtStartup(*)
{

  ; DEBUG
  global this_script_shorcut := A_Startup "\" SubStr(A_ScriptName, 1, StrLen(A_ScriptName) - 4) ".lnk"
  ; MsgBox (
  ; "A_Startup: " A_Startup
  ; "`n`nA_ScriptDir: " A_ScriptDir
  ; "`n`nA_ScriptFullPath: " A_ScriptFullPath
  ; "`n`nA_ScriptName: " A_ScriptName
  ; "`n`nA_AhkPath: " A_AhkPath
  ; "`n`nnSubstring: " SubStr(A_ScriptName, 1, StrLen(A_ScriptName) - 4)
  ; )

  run A_Startup
  If (FileExist(this_script_shorcut))
  {
    FileDelete(this_script_shorcut)
    trayitem_runatstartup_ico := traymenu_icon_unchecked
  }
  Else
  {
    ; ICO issue fixed. See https://learn.microsoft.com/en-us/answers/questions/1162419/shortcut-icon-blank-when-ico-file-is-located-on-a
    ; RegWrite(1, "REG_DWORD", "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer", "EnableSOcShortcutIconRemotePath" )
    ; TODO - if ICO is not in C: drive, copy the icon to the C:\temp folder before creating the shortcut
    FileCreateShortcut(A_AhkPath, this_script_shorcut, A_ScriptDir, A_ScriptFullPath, "A script", A_ScriptDir tray_icon_normal, , ,)
    trayitem_runatstartup_ico := traymenu_icon_checked
  }
  Tray.SetIcon(trayitem_runatstartup, trayitem_runatstartup_ico)
}

; ╭──────────────────────────────────────────────────────────────────────╮
; │  Update the Tray Menu UI to indicate if a feature is enabled or not  │
; ╰──────────────────────────────────────────────────────────────────────╯
IndicateToggle(FLOWFeatureName, FLOWFeature, IsEnabled := false, DisplayChange := false, PlaySound := false)
{
  ; FLOWFeatureName is a string that indicates the FLOW feature being toggled

  ; FLOWFeature is an Evaluated string that indicates the FLOW feature being toggled
  ; Acceptable values (based on variable names): "hotkeys", "hotstrings", "all"

  ; IsEnabled is a boolean that indicates whether the FLOW feature is enabled or disabled
  if (Aux_HotStringSupport = false) and (Aux_HotKeySupport = false) {
    ; Both features are off
    FLOWFeature := "all"
    TraySetIcon tray_icon_pause_%FLOWFeature% ; Set the normal icon
  }

  ; PlaySound parameter is a boolean that indicates whether to play a sound when toggling
  if (PlaySound = true) {
    if (IsEnabled = true) {
      ; SoundPlay toggle_sound_file_enabled
      SoundPlay "*16"
    } else {
      ; SoundPlay toggle_sound_file_disabled
      SoundPlay "*48"
    }
  }

  ; DisplayChange parameter is a boolean that indicates whether to display a message when toggling
  if (DisplayChange = true) {
    if (IsEnabled = true) {
      gui_message := FLOWFeatureName " Enabled"
      gui_theme := "Success"
      TraySetIcon tray_icon_normal
    } else {
      gui_message := FLOWFeatureName " Disabled"
      gui_theme := "Warning"
      TraySetIcon tray_icon_pause_%FLOWFeature%
    }

    WiseGui(FLOWFeature
      , "Theme:       " gui_theme
      , "MainText:    " gui_message
      , "Transparency: 192"
      , "Show:         SlideWest@400ms"
      , "Hide:         SlideEast@400ms"
      , "Move:         -10, -1"
      , "Timer:        2500"
    )
  }
}

; ╭───────────────────────╮
; │  Suspend all hotkeys  │
; ╰───────────────────────╯
SuspendHotkeys(*)
{
  Suspend -1 ; toggle suspend

  if A_IsSuspended = true
    TraySetIcon ".\FLOW\FLOW_tray_dark_pause.ico"
  else
    Tray.Default := "TestDefault"
}