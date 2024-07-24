#Requires AutoHotkey v2.0

; Ensure single mutex. Use [Prompt] switch to prompt for options
#SingleInstance Force

; Use default Windows response to built-in responses to keyboard shortcutsm, e.g. [Alt]+[<-]
SendMode "Input"

; Default matching behavior for searches using WinTitle, e.g. WinWait
SetTitleMatchMode 2
InstallKeybdHook
; InstallMouseHook

; Include the following libraries
#Include ".\lib\aux_hotkeys.ahk"
#Include ".\lib\aux_hotstrings.ahk"
#Include ".\lib\aux_alerts.ahk"
#Include ".\lib\aux_hotclix.ahk"
#include ".\lib\aux_chords.ahk"
#Include ".\lib\WiseGui.ahk"
#Include ".\lib\tray_menu.ahk"
#Include ".\FLOW\lib\aux_hotkeys.ahk"
#Include ".\FLOW\lib\aux_hotstrings.ahk"
#Include ".\FLOW\lib\aux_alerts.ahk"
#Include ".\FLOW\lib\aux_hotclix.ahk"
#Include ".\FLOW\lib\WiseGui.ahk"

; Get Launch/Reload Time
LaunchTime := FormatTime()

/*
╭────────────────────────╮
│ GLOBAL SCOPE VARIABLES │
╰────────────────────────╯
*/
global process_theme := ""
global app_ico := ".\FLOW\icons\icons8-coffeex-to-go.ico"
global toggle_sound_file_startrun := A_Windir "\Media\Windows Unlock.wav"
global toggle_sound_file_enabled := ".\FLOW\sounds\01_enable.wav"
global toggle_sound_file_disabled := ".\FLOW\sounds\01_disable.wav"
global sound_file_start := ".\FLOW\sounds\start-13691.wav"
global sound_file_stop := ".\FLOW\sounds\stop-13692.wav"
global regkey_sticky_keys := "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys"


DisplayTrayMenu()

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


;╭───────────────────────────────────────────────────────╮
;│  [Ctrl]+[Alt]+[T] for Terminal                        │
;│  [Ctrl]+[Alt]+[Shift]+[T] for Terminal in Admin Mode  │
;╰───────────────────────────────────────────────────────╯

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

;╭─────────────────────────────────────────────────────────╮
;│  Tetrakey modes & chords                                │
;│  1. Hit the [CapsLock]+[?] To enter the MODE            │
;│  2. Hit the other [key] to complete the CHORD           │
;├─────────────────────────────────────────────────────────┤
;│  MODES:                                                 │
;│  [b] BROWSE WEB     Qwik access to fav sites            │
;│  [o] OPEN APP       Qwik access to apps                 │
;│  [p] POWERTOYS      Shortcuts to PowerToys utils        │
;│  [c] CLIP UTILs     Qwik utils on the selected text     │
;│  [u] UTILITIES      Qwik access to utilities            │
;├─────────────────────────────────────────────────────────┤
;│  [QWIKEY]+[O], [b]   OPEN APP: Bitwarden                │
;│  [QWIKEY]+[O], [c]   OPEN APP: ✓ VS Code                │
;│  [QWIKEY]+[O], [d]   OPEN APP: Dev Tools                │
;│  [QWIKEY]+[O], [h]   OPEN APP: Dev Home                 │
;│  [QWIKEY]+[O], [n]   OPEN APP: ✓ Notepad                │
;│  [QWIKEY]+[O], [p]   OPEN APP: ✓ Epic Pen               │
;│  [QWIKEY]+[O], [w]   OPEN APP: Terminal (WSL)           │
;│                                                         │
;│  [QWIKEY]+[b], [c]   BROWSE: chat.openai.com            │
;│  [QWIKEY]+[b], [d]   BROWSE: dev.azure.com              │
;│  [QWIKEY]+[b], [g]   BROWSE: github.com                 │
;│  [QWIKEY]+[b], [i]   BROWSE: icons8.com                 │
;│  [QWIKEY]+[b], [p]   BROWSE: portal.azure.com           │
;│  [QWIKEY]+[b], [y]   BROWSE: youtube.com                │
;│                                                         │
;╰─────────────────────────────────────────────────────────╯


; ╭────────────────────────────────╮
; │  [Tetra]+[O]. OPEN App Mode    │
; ╰────────────────────────────────╯
KeyWaitAny(*)
{
  ih := InputHook("B L1 T4 M", "{Esc}{Enter}{Tab}")
  ih.KeyOpt("abcdefghijklmnopqrstuvwxyz1234567890", "E")  ; End
  ih.Start()
  ih.Wait()

  return ih.EndKey  ; Return the key name
}

CapsLock & o::
{
  ; If GetKeyState("CapsLock", "P")
  ; {
  ;   ; Open App Mode, then follow it with another key to complete the CHORD
  retKeyHook := KeyWaitAny()
  MsgBox "You pressed " retKeyHook, "Tetrakeys", "T5 4096"
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
  ; }
  ; Else
  ; {
  ;   Send "O" ; This is to respond to [LShift}+[o]; otherwise, nothing will be sent
  ; }
}

; [Win]+[F] to open the File Explorer in the user's Documents folder
#f:: {
  Run "explorer.exe ~"
}