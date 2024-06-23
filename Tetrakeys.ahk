#Requires AutoHotkey v2.0-a

; Ensure single mutex. Use [Prompt] switch to prompt for options
#SingleInstance Force

; Use default Windows response to built-in responses to keyboard shortcutsm, e.g. [Alt]+[<-]
SendMode "Input"

; Default matching behavior for searches using WinTitle, e.g. WinWait
SetTitleMatchMode 2
InstallKeybdHook
; InstallMouseHook

; Include the following libraries
#Include ".\FLOW\lib\aux_hotkeys.ahk"
#Include ".\FLOW\lib\aux_hotstrings.ahk"
#Include ".\FLOW\lib\aux_alerts.ahk"
#Include ".\FLOW\lib\aux_hotclix.ahk"
#Include ".\FLOW\lib\WiseGui.ahk"

; Get Launch/Reload Time
LaunchTime := FormatTime()

/*
+-----------------------------------+
|     GLOBAL SCOPE VARIABLES        |
+-----------------------------------+
*/
process_theme := ""
app_icon := ".\FLOW\icons\icons8-coffeex-to-go.ico"
tray_icon_normal := ".\FLOW\icons\flow-sl-normal.ico"
; tray_icon_normal := ".\FLOW\icons\flow-sl-normal-1_1.ico"
tray_icon_pause_all := ".\FLOW\icons\flow-sl-pause.ico"
tray_icon_pause_hotkeys := ".\FLOW\icons\flow-sl-pause.ico"
tray_icon_pause_hotstrings := ".\FLOW\icons\flow-sl-pause-hs.ico"
tray_icon_suspend := ".\FLOW\icons\flow-sl-suspend.ico"
; toggle_sound_file_startrun := ".\FLOW\sounds\00_restart.wav"
; toggle_sound_file_startrun := A_Windir "\Media\Ring06.wav"
toggle_sound_file_startrun := A_Windir "\Media\Windows Unlock.wav"
toggle_sound_file_enabled := ".\FLOW\sounds\01_enable.wav"
toggle_sound_file_disabled := ".\FLOW\sounds\01_disable.wav"
sound_file_start := ".\FLOW\sounds\start-13691.wav"
sound_file_stop := ".\FLOW\sounds\stop-13692.wav"

traymenu_icon_checked := ".\FLOW\icons\flow_checked.ico"
traymenu_icon_unchecked := ".\FLOW\icons\flow_unchecked.ico"

regkey_sticky_keys := "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys"


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
; ===================> TESTING ONLY <===================
; DisplayShorcutKeys("FLOW Shortcut Keys Reference", "1", Tray, 10)
; ===================> TESTING ONLY <===================

DisplayShorcutKeys(ItemName, ItemPos, Tray, Popup_Seconds := 0)
{
  /*
  MsgBox "You selected " ItemName " (position " ItemPos ")"
  HelpMessage := "
      (
      [CTRL]+[ALT]+[WIN]+[R]::`t reload this script`n
      [CTRL]+[ALT]+[Win]+[E]::`tedit this script`n
      [CTRL]+[Win]+[B]::`tinsert a bullet point`n
      [LShift]+[RShift]+[T]::`trun Terminal`n
      [LShift]+[RShift]+[CTRL]+[T]::`trun Terminal as Admin`n
      [LShift]+[RShift]+[N]::`trun Notepad `n
      )"
  MsgBox HelpMessage, "FLOW Shortcut Keys", "Iconi 4096"
  */
  img_alt_key := ".\FLOW\keys\alt_key.ico"
  img_ctrl_key := ".\FLOW\keys\ctrl_key.ico"
  img_lshift_key := ".\FLOW\keys\shiftl_key.png"
  img_rshift_key := ".\FLOW\keys\shiftr_key.png"
  img_b_key := ".\FLOW\keys\b_key.ico"
  img_e_key := ".\FLOW\keys\e_key.ico"
  img_n_key := ".\FLOW\keys\n_key.ico"
  img_r_key := ".\FLOW\keys\r_key.ico"
  img_t_Key := ".\FLOW\keys\t_key.ico"
  img_win_key := ".\FLOW\keys\win_key.ico"

  SKey_Ref_UI := Gui("+MinSize600x400", "FLOW - Core Shortcut Keys")
  SKey_Ref_UI.Opt("+AlwaysOnTop -SysMenu +Theme +MinSize600x400")  ; +Owner avoids a taskbar button.
  ; SKey_Ref_UI.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")  ; +Owner avoids a taskbar button.

  ; Column 1 - Descriptions
  SKey_Ref_UI.SetFont("s13 q0 norm", "Calibri")
  SKey_Ref_UI.Add("Text", "Section w180", "Reload this script")
  SKey_Ref_UI.Add("Text", "w180", "Edit this script")
  SKey_Ref_UI.Add("Text", "w180", "Toggle Non-Core HotKeys")
  SKey_Ref_UI.Add("Text", "w180", "Toggle Non-Core HotStrings")
  SKey_Ref_UI.Add("Text", "w180", "Run Terminal")
  SKey_Ref_UI.Add("Text", "w180", "Run Terminal as Admin")
  SKey_Ref_UI.Add("Text", "w180", "Run Notepad")

  ; Column 2 - Hotkeys
  SKey_Ref_UI.SetFont("s10 q0 norm", "Cascadia Mono")

  ; New Column. Reload this script => [CTRL]+[ALT]+[WIN]+[R]
  SKey_Ref_UI.Add("Picture", "ys Section h28 w-1 ", img_ctrl_key) ; x+4 to start at 4,0 after the last control
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_win_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_alt_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_r_key)

  ; Edit this script => [CTRL]+[ALT]+[WIN]+[E]
  SKey_Ref_UI.Add("Picture", "xs h28 w-1 ", img_ctrl_key) ; xs to start at 0,0 in the next row
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_win_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_alt_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_e_key)

  ; Toggle Non-Core HotKeys => [CTRL]+[ALT]+[WIN]+[K]
  SKey_Ref_UI.Add("Picture", "xs h28 w-1 ", img_ctrl_key) ; xs to start at 0,0 in the next row
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_win_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_alt_key)
  ; SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_e_key)

  ; Toggle Non-Core HotStrings => [CTRL]+[ALT]+[WIN]+[S]
  SKey_Ref_UI.Add("Picture", "xs h28 w-1 ", img_ctrl_key) ; xs to start at 0,0 in the next row
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_win_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_alt_key)
  ; SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_e_key)

  ; Insert a bullet point
  SKey_Ref_UI.Add("Picture", "xs h28 w-1 ", img_ctrl_key) ; xs to start at 0,0 in the next row
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_win_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_b_key)

  ; Run Terminal => [LShift]+[RShift]+[T]
  SKey_Ref_UI.Add("Picture", "xs h28 w-1 ", img_lshift_key) ; xs to start at 0,0 in the next row
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_rshift_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_t_key)

  ; Run Terminal in Elevated window => [LShift]+[RShift]+[CTRL]+[T]
  SKey_Ref_UI.Add("Picture", "xs h28 w-1 ", img_lshift_key) ; xs to start at 0,0 in the next row
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_rshift_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_ctrl_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_t_key)

  ; Run Notepad => [LShift]+[RShift]+[N]
  SKey_Ref_UI.Add("Picture", "xs h28 w-1 ", img_lshift_key) ; xs to start at 0,0 in the next row
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_rshift_key)
  SKey_Ref_UI.Add("Picture", "h28 w-1 x+4", img_n_key)

  ; CLOSE Button
  ; SKey_Ref_UI.Add("Text",, "")

  SKey_Ref_UI.SetFont("s10 q0 norm", "Calibri")
  SKey_Ref_UI.Add("Button", "Section xm w100 x150", "Close").OnEvent("Click", About_Close)

  ; Show window in the center of the main screen
  SKey_Ref_UI.Show("Center")

  If (Popup_Seconds > 0)
  {
    Sleep Popup_Seconds * 1000
    SKey_Ref_UI.Destroy()
  }

  About_Close(*)
  {
    SKey_Ref_UI.Opt("-Disabled")  ; Re-enable the main window (must be done prior to the next step).
    SKey_Ref_UI.Destroy()  ; Destroy the about box.
  }
}


DisplayAbout(*)
{
  ; MsgBox "You selected " ItemName " (position " ItemPos ")"
  HelpMessage := "
    (
        [CTRL]+[ALT]+[WIN]+[R]::`treload this script`n
        [CTRL]+[ALT]+[Win]+[E]::`tedit this script`n
        [CTRL]+[Win]+[B]::`tinsert a bullet point in any document`n
        [LShift]+[RShift]+[T]::`trun Terminal`n
        [LShift]+[RShift]+[CTRL]+[T]::`trun Terminal as Admin`n
        [LShift]+[RShift]+[N]::`trun Notepad `n
    )"
  MsgBox HelpMessage, "FLOW Shortcut Keys"
}

ShowListLines(*)
{
  ListLines
}

OpenScriptDir(*)
{
  Run A_ScriptDir
}

ShowHelp(*)
{
  ; Open the regular help file
  ; Determine AutoHotkey's location:
  if A_AhkPath
    SplitPath A_AhkPath, , &ahk_dir
  else if FileExist("..\..\AutoHotkey.chm")
    ahk_dir := "..\.."
  else if FileExist(A_ProgramFiles "\AutoHotkey\AutoHotkey.chm")
    ahk_dir := A_ProgramFiles "\AutoHotkey"
  else
  {
    MsgBox "Could not find the AutoHotkey folder."
    return
  }
  Run ahk_dir "\AutoHotkey.chm"
  ; Run A_ProgramFiles "\AutoHotkey\v2\AutoHotkey.chm"

  Return
}
ReloadAndReturn(*)
{
  Reload
  Return
}

EditAndReturn(*)
{
  Edit
  Return
}

EndScript(*)
{
  ExitApp
}

ToggleAuxHotstrings(*)
{
  global Aux_HotStringSupport := !Aux_HotStringSupport
  if (Aux_HotStringSupport = true) {
    IndicateToggle("Auxillary HotStrings", "hotkeys", true, true, true)
    trayitem_toggle_hstrings_icon := traymenu_icon_checked
  } else {
    IndicateToggle("Auxillary HotStrings", "hotkeys", false, true, true)
    trayitem_toggle_hstrings_icon := traymenu_icon_unchecked
  }

  Tray.SetIcon(trayitem_toggle_hstrings, trayitem_toggle_hstrings_icon)
}

ToggleAuxHotkeys(*)
{
  global Aux_HotKeySupport := !Aux_HotKeySupport
  if (Aux_HotKeySupport = true) {
    IndicateToggle("Auxillary HotKeys", "hotstrings", true, true, true)
    trayitem_toggle_hkeys_icon := traymenu_icon_checked
  } else {
    IndicateToggle("Auxillary HotKyes", "hotstrings", false, true, true)
    trayitem_toggle_hkeys_icon := traymenu_icon_unchecked
  }

  Tray.SetIcon(trayitem_toggle_hkeys, trayitem_toggle_hkeys_icon)
}

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
    trayitem_runatstartup_icon := traymenu_icon_unchecked
  }
  Else
  {
    ; ICO issue fixed. See https://learn.microsoft.com/en-us/answers/questions/1162419/shortcut-icon-blank-when-ico-file-is-located-on-a
    ; RegWrite(1, "REG_DWORD", "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer", "EnableShellShortcutIconRemotePath" )
    ; TODO - if ICO is not in C: drive, copy the icon to the C:\temp folder before creating the shortcut
    FileCreateShortcut(A_AhkPath, this_script_shorcut, A_ScriptDir, A_ScriptFullPath, "A script", A_ScriptDir tray_icon_normal, , ,)
    trayitem_runatstartup_icon := traymenu_icon_checked
  }
  Tray.SetIcon(trayitem_runatstartup, trayitem_runatstartup_icon)
}

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


; ToggleTestEnable(*)
; {
;   Tray.ToggleEnable("TestToggleEnable")
; }

; TestDefault(*)
; {
;   if Tray.Default = "TestDefault"
;     Tray.Default := ""
;   else
;     Tray.Default := "TestDefault"
; }

SuspendHotkeys(*)
{
  Suspend -1 ; toggle suspend

  if A_IsSuspended = true
    TraySetIcon ".\FLOW\FLOW_tray_dark_pause.ico"
  else
    Tray.Default := "TestDefault"
}

LaunchCalculator(*)
{
  ; Single Instance condition. Do not create a new process and used the last one created
  If WinExist("Calculator", "Calculator")
  {
    WinActivate
    WinShow
    Return
  }
  Else
  {
    Run "calc.exe"
    WinWait "Calculator"
    WinActivate
  }
}

LaunchTerminal(*)
{
  If WinExist("ahk_exe WindowsTerminal.exe")
  {
    WinActivate
    WinShow
    Return
  }
  Else
  {
    Run "wt.exe -w 0 new-tab --title (ツ)_/¯{Terminal} --suppressApplicationTitle", , , &wt_pid
    Sleep 1000
    If WinExist("ahk_exe WindowsTerminal.exe") or WinExist("ahk_title Terminal")
    {
      WinActivate
      WinShow
    }
    Return
  }
}

/*
╔══════════════════════════════════════════════════════════════╗
║       KEY HOTKEY DEFINITIONS: CORE FUNCTIONALITY             ║
║   Not affected by ToggleAuxHotkeys and ToggleAuxHotstrings   ║
╚══════════════════════════════════════════════════════════════╝
*/

; ┌─────────────────────────────┐
; │ [RCtrl]x2 to run Calculator │
; └─────────────────────────────┘
; Detects when a key has been double-pressed (similar to double-click). KeyWait is used to
; stop the keyboard's auto-repeat feature from creating an unwanted double-press when you
; hold down the RControl key to modify another key. It does this by keeping the hotkey's
; thread running, which blocks the auto-repeats by relying upon #MaxThreadsPerHotkey being
; at its default setting of 1. For a more elaborate script that distinguishes between
; single, double and triple-presses, see SetTimer example #3.
~RControl::
{
  if (A_PriorHotkey != "~RControl" or A_TimeSincePriorHotkey > 400)
  {
    ; Too much time between presses, so this isn't a double-press.
    KeyWait "RControl"
    return
  }

  ; A double-press of the RControl key has occurred.
  LaunchCalculator()
}


; ┌───────────────────────────────────────┐
; │ [LShift]+[RShift]+[t] to run Terminal │
; └───────────────────────────────────────┘
; RShift & t::
; {
;     ; [LShift]+[RShift]+[t] to run an elevated Terminal process
;     If GetKeyState("LShift", "P") && GetKeyState("RShift", "P") && GetKeyState("Ctrl", "P")
;     {
;         ; MsgBox "Run wt.exe as Admin"
;         Run "*RunAs wt.exe -w 0 new-tab --title Terminal(Admin) --suppressApplicationTitle"
;         exit ; return will only exit the current condition
;     }

;     If GetKeyState("LShift", "P") && GetKeyState("RShift", "P")
;     {
;         If WinExist("ahk_exe WindowsTerminal.exe")
;         {
;             WinActivate
;             WinShow
;             Return
;         }
;         Else
;         {
;             Run "wt.exe -w 0 new-tab --title Terminal --suppressApplicationTitle", , , &wt_pid
;             Sleep 1000
;             If WinExist("ahk_exe WindowsTerminal.exe") or WinExist("ahk_title Terminal")
;                 {
;                     WinActivate
;                     WinShow
;                 }
;             Return
;         }
;     }
;     Else
;     {
;         Send "T" ; This is to respond to [RShift}+[T]; otherwise, nothing will be sent
;     }
; }
/*
+-------------------------------------------------------+
|  [Ctrl]+[Alt]+[T] for Terminal                        |
|  [Ctrl]+[Alt]+[Shift]+[T] for Terminal in Admin Mode  |
+-------------------------------------------------------+
*/
LAlt & t::
{
  ; [Ctrl]+[Alt]+[T] to run Terminal
  If GetKeyState("LShift", "P") && GetKeyState("Alt", "P") && GetKeyState("LCtrl", "P")
  {
    ; MsgBox "Run wt.exe as Admin"  ; DEBUG
    Run "*RunAs wt.exe -w 0 new-tab --title Terminal(Admin) --suppressApplicationTitle"
    exit ; return will only exit the current condition
  }

  If GetKeyState("LCtrl", "P") && GetKeyState("LAlt", "P")
  {
    LaunchTerminal()
  }
  Else
  {
    Send "T" ; This is to respond to [RShift}+[T]; otherwise, nothing will be sent
  }
}

/*
╭───────────────────────────────────────────────────────────────╮
│ CAPS LOCK Genius!                                             │
│
│ Double tap to toggle the Caps Lock feature.                   │
│ Hold down the Caps Lock key as a modifier to trigger hotkeys. │
│                                                               │
╰───────────────────────────────────────────────────────────────╯
*/
; CapsLock:: {
;   KeyWait "CapsLock" ; Wait forever until Capslock is released.
;   KeyWait "CapsLock", "D T0.2" ; ErrorLevel = 1 if CapsLock not down within 0.2 seconds.

;   if (A_PriorKey = "CapsLock") ; Is a double tap on CapsLock?
;   {
;     SetCapsLockState !GetKeyState("CapsLock", "T")
;   }
;   return
; }

;================================================================================================
; Hot keys with CapsLock modifier. See https://autohotkey.com/docs/Hotkeys.htm#combo
;================================================================================================
; Get DEFINITION of selected word.
; CapsLock & d:: {
;   ClipboardGet()
;   Run, http: // www.google.com / search ? q = define + %clipboard% ; Launch with contents of clipboard
;     ClipboardRestore()
;     Return
;       }

;   ; GOOGLE the selected text.
;   CapsLock & g:: {
;     ClipboardGet()
;     Run, http: // www.google.com / search ? q = %clipboard% ; Launch with contents of clipboard
;       ClipboardRestore()
;       Return
;         }

;     ; Do THESAURUS of selected word
;     CapsLock & t:: {
;       ClipboardGet()
;       Run http: // www.thesaurus.com / browse / %Clipboard% ; Launch with contents of clipboard
;       ClipboardRestore()
;       Return
;     }

;     ; Do WIKIPEDIA of selected word
;     CapsLock & w:: {
;       ClipboardGet()
;       Run, https: // en.wikipedia.org / wiki / %clipboard% ; Launch with contents of clipboard
;       ClipboardRestore()
;       Return
;     }


;     ClipboardGet()
;     {
;       OldClipboard := ClipboardAll ;Save existing clipboard.
;       Clipboard := ""
;       Send, ^ c ;Copy selected test to clipboard
;       ClipWait 0
;       If ErrorLevel
;       {
;         MsgBox, No Text Selected !
;           Return
;       }
;     }

;     ClipboardRestore()
;     {
;       Clipboard := OldClipboard
;     }

/*
╭────────────────────────────╮
│  QWIK KEYS (QWIKEY)        │
│  [Ctrl]+[Alt]+[Win] + [?]  │
├────────────────────────────┴───────────────────────╮
│  [QWIKEY]+[K]    Toggle Aux Hotkeys                │
│  [QWIKEY]+[S]    Toggle Aux Hotsrings              │
│  [QWIKEY]+[R]    Reload this app                   │
│  [QWIKEY]+[E]    Edit this AHK (default editor)    │
│  [QWIKEY]+[F2]   AutoHotKey Help File              │
╰────────────────────────────────────────────────────╯
*/
; [Ctrl]+[Alt]+[Win]+[K]: Toggle Aux Hotkeys
^#!k:: {
  ToggleAuxHotkeys()
}

; [Ctrl]+[Alt]+[Win]+[S]: Toggle Aux Hotstrings
^#!s:: {
  ToggleAuxHotstrings()
}

; [Ctrl]+[Alt]+[Win]+[R] to Reload this script
^#!r:: {
  ReloadAndReturn()
}

; [Ctrl]+[Alt]+[Win]+[E] to edit this script
^!#e:: {
  EditAndReturn()
}

; [Ctrl]+[Alt]+[Win]+[F2] to open the AutoHotkey Help File
^!#F2:: {
  ShowHelp()
}

; [Ctrl]+[Alt]+[Win]+[F12] to go to sleep mode
^!#F12:: {
  Run "rundll32.exe powrprof.dll,SetSuspendState 0,1,0"
}

/*
╭───────────────────────────────────────────────────────╮
│  QWIKEY modes & chords                                │
│  Hit the [QWIKEY]+[?] To enter the MODE, then         │
│  follow it with another key to complete the CHORD.    │
├───────────────────────────────────────────────────────┤
│  MODES:                                               │
│  [b] BROWSE WEB     Qwik access to fav sites          │
│  [o] OPEN APP       Qwik access to apps               │
│  [p] POWERTOYS      Shortcuts to PowerToys utils      │
│  [c] CLIP UTILs     Qwik utils on the selected text   │
│  [u] UTILITIES      Qwik access to utilities          │
├───────────────────────────────────────────────────────┤
│  [QWIKEY]+[O], [b]   OPEN APP: Bitwarden              │
│  [QWIKEY]+[O], [c]   OPEN APP: ✓ VS Code              │
│  [QWIKEY]+[O], [d]   OPEN APP: Dev Tools              │
│  [QWIKEY]+[O], [h]   OPEN APP: Dev Home               │
│  [QWIKEY]+[O], [n]   OPEN APP: ✓ Notepad              │
│  [QWIKEY]+[O], [p]   OPEN APP: ✓ Epic Pen             │
│  [QWIKEY]+[O], [w]   OPEN APP: Terminal (WSL)         │
│                                                       │
│  [QWIKEY]+[b], [c]   BROWSE: chat.openai.com          │
│  [QWIKEY]+[b], [d]   BROWSE: dev.azure.com            │
│  [QWIKEY]+[b], [g]   BROWSE: github.com               │
│  [QWIKEY]+[b], [i]   BROWSE: icons8.com               │
│  [QWIKEY]+[b], [p]   BROWSE: portal.azure.com         │
│  [QWIKEY]+[b], [y]   BROWSE: youtube.com              │
│                                                       │
╰───────────────────────────────────────────────────────╯
*/

; ╭────────────────────────────────╮
; │  [QWIKEY]+[O]. OPEN App Mode   │
; ╰────────────────────────────────╯
LAlt & o::
{
  If GetKeyState("LCtrl", "P") && GetKeyState("LAlt", "P")
  {
    ; Open App Mode, then follow it with another key to complete the CHORD
    retKeyHook := KeyWaitAny()

    Switch retKeyHook
    {
      Case "b":
        Run "bitwarden"
      Case "c":
        Run "code.cmd"
      Case "n":
        Run "notepad.exe"
      Case "o":
      Case "p":
        Run EnvGet("ProgramFiles(x86)") "\Epic Pen\EpicPen.exe"
      Case "D":
        Run "devtools"
      Case "H":
        Run "devhome"
      Default:
        ; do nothing
    }
  }
  Else
  {
    Send "O" ; This is to respond to [LShift}+[o]; otherwise, nothing will be sent
  }
}

KeyWaitAny(*)
{
  ih := InputHook("B L1 T2.5", "{Esc}{Enter}{Tab}")
  ih.KeyOpt("{All}", "E")  ; End
  ih.Start()
  ih.Wait()

  return ih.EndKey  ; Return the key name
}

; [Win]+[F] to open the File Explorer in the user's Documents folder
#f:: {
  Run "explorer.exe ~"
}