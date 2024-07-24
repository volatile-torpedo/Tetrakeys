#Requires AutoHotkey v2.0

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
  Tray := A_TrayMenu ; For convenience.
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

  ; trayitem_runatstartup := "Run at Startup"

  ; trayitem_runatstartup_icon := traymenu_icon_unchecked

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
  Tray.SetIcon(trayitem_flow_ref, trayitem_flow_ref_icon)

  Tray.Add(trayitem_reload, ReloadAndReturn)
  Tray.SetIcon(trayitem_reload, trayitem_reload_icon)

  Tray.Add(trayitem_edit, EditAndReturn)
  Tray.SetIcon(trayitem_edit, trayitem_edit_icon)

  ; Enable Hotstrings as the default value
  Tray.Add(trayitem_toggle_hstrings, ToggleAuxHotstrings)
  global Aux_HotStringSupport := true
  ; Tray.Check(trayitem_toggle_hstrings)
  Tray.SetIcon(trayitem_toggle_hstrings, trayitem_toggle_hstrings_icon)

  ; Enable HotKeys as the default value
  Tray.Add(trayitem_toggle_hkeys, ToggleAuxHotkeys)
  global Aux_HotKeySupport := true
  ; Tray.Check(trayitem_toggle_hkeys)
  Tray.SetIcon(trayitem_toggle_hkeys, trayitem_toggle_hkeys_icon)

  Tray.Add(trayitem_runatstartup, ToggleRunAtStartup)
  Tray.SetIcon(trayitem_runatstartup, trayitem_runatstartup_icon)

  Tray.Add() ; separator
  ; Tray.Add(trayitem_debug, ShowListLines)
  DebugMenu := Menu()
  Tray.Add(trayitem_debug, DebugMenu)
  Tray.SetIcon(trayitem_debug, trayitem_debug_icon)
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
  Tray.SetIcon(trayitem_ahkhelp, trayitem_ahkhelp_icon)

  Tray.Add() ; separator

  Tray.Add(trayitem_exit, EndScript)
  Tray.SetIcon(trayitem_exit, trayitem_exit_icon)

  Tray.Add() ; separator

  Tray.Add(trayitem_about, DisplayAbout)
  Tray.SetIcon(trayitem_about, trayitem_about_icon)

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

; ===================> TESTING ONLY <===================
; DisplayShorcutKeys("FLOW Shortcut Keys Reference", "1", Tray, 10)
; ===================> TESTING ONLY <===================
