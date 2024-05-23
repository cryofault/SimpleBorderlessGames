;Simple Borderless Games
;Copyright (C) 2024 Parker Hindman

;This program is free software: you can redistribute it and/or modify
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation, either version 3 of the License.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program.  If not, see <http://www.gnu.org/licenses/>.

#singleinstance force

GoSub initconfig
IniRead, prevhotkeyborder, config.ini, Hotkeys, border-hotkey
IniRead, prevhotkeyposition, config.ini, Hotkeys, position-hotkey
IniRead, prevhotkeyboth, config.ini, Hotkeys, both-hotkey
IniRead, posx, config.ini, Coordinates, posx
IniRead, posy, config.ini, Coordinates, posy
IniRead, sizew, config.ini, Coordinates, sizew
IniRead, sizeh, config.ini, Coordinates, sizeh
IniRead, AutoStart, config.ini, General, AutoStart

Menu,Tray,NoStandard
Menu,Tray,Add,&AutoStart,ContextMenu
Menu,Tray,Add,&Config,ContextMenu
Menu,Tray,Add,E&xit,ContextMenu

Hotkey, %prevhotkeyborder%, border
Hotkey, %prevhotkeyposition%, position
Hotkey, %prevhotkeyboth%, both

if AutoStart = 1
{
  Menu,Tray,Check,&AutoStart
}

Return

;;;;;;;;;;;;

initconfig:
ifnotexist config.ini
{
FileInstall, setup.png, setup.png
Gui 3:Add, Picture,x0 y0 w800 h400 , setup.png
Gui 3:Show, w800 h400, Test GUI Window
IniWrite, !h, config.ini, Hotkeys, border-hotkey
IniWrite, !f, config.ini, Hotkeys, position-hotkey
IniWrite, !g, config.ini, Hotkeys, both-hotkey
SysGet, primarydis, MonitorPrimary
SysGet, defres, MonitorWorkArea, 1
IniWrite, %defresLeft%, config.ini, Coordinates, posx
IniWrite, %defresTop%, config.ini, Coordinates, posy
IniWrite, %defresRight%, config.ini, Coordinates, sizew
IniWrite, %defresBottom%, config.ini, Coordinates, sizeh
IniWrite, 0, config.ini, General, AutoStart
return
}

;PARSE ID
idparse:
WinGet, activeprocess, ProcessName, A
exeid = ahk_exe %activeprocess%
stringReplace, exeid, exeid, %A_Space%,,All
stringReplace, exeid, exeid, %A_Tab%,,All
stringReplace, exeid, exeid, .,,All
stringReplace, exeid, exeid, ],,All
stringReplace, exeid, exeid, [,,All
stringReplace, exeid, exeid, (,,All
stringReplace, exeid, exeid, ),,All
stringReplace, exeid, exeid, !,,All
stringReplace, exeid, exeid, @,,All
stringReplace, exeid, exeid, #,,All
stringReplace, exeid, exeid, $,,All
stringReplace, exeid, exeid, ^,,All
stringReplace, exeid, exeid, &,,All
stringReplace, exeid, exeid, *,,All
stringReplace, exeid, exeid, -,,All
stringReplace, exeid, exeid, +,,All
stringReplace, exeid, exeid, _,,All
stringReplace, exeid, exeid, =,,All
return

;REMOVE BORDERS
border:
GoSub idparse
if (toggle%exeid% != 1)
{
;remove borders
WinGetPos, x, y, w, h, A
WinSet, Style, -0xC00000, A
WinSet, Style, -0x00400000L, A
WinSet, Style, -0x800000, A
WinSet, Style, -0x40000, A
;edge case border fix
if (vboth != 1)
{
WinMove,A,,-100,-100,100,100
WinMove,A,,x,y,w,h 
}
toggle%exeid% = 1
return
;
}

if (toggle%exeid% = 1) 
{
WinSet, Style, +0xC00000, A
WinSet, Style, +0x00400000L, A
WinSet, Style, +0x800000, A
WinSet, Style, +0x40000, A
toggle%exeid% = 0
return
;
}
return

;POSITION/RESIZE WINDOW
position:
GoSub idparse
if (togglepos%exeid% != 1)
{
WinGetPos, x%exeid%, y%exeid%, w%exeid%, h%exeid%, A
WinMove,A,,%posx%,%posy%,%sizew%,%sizeh%
togglepos%exeid% = 1
return
;
}

if (togglepos%exeid% = 1) 
{
WinMove,A,,x%exeid%,y%exeid%,w%exeid%,h%exeid% 
togglepos%exeid% = 0
return
;
}
return

;REMOVE BORDERS AND POSITION/RESIZE WINDOW
both:
vboth = 1
if (toggle%exeid% = 0) && (togglepos%exeid% = 1)
{
vboth = 0
GoSub border
}
else if (toggle%exeid% = 1) && (togglepos%exeid% = 0)
{
GoSub position
}
else
{
GoSub border
GoSub position
}
vboth = 0
return


;GUI
ContextMenu:
If (A_ThisMenuItem="&Config")
{
Gui 1: Font, s11
Gui 1: Font, bold
Gui 1:Add, text,y7, Hotkeys:
Gui 1: Font, s9
Gui 1: Font, normal
Gui 1:Add, text,y+13, • Toggle Window Borders:
Gui 1:Add, text,y+20, • Toggle Window Position:
Gui 1:Add, text,y+20, • Toggle Position + Borders:
Gui 1:Add, Button, w110 x180 y30, border
GuiControl, 1:, border, Bind Hotkey
Gui 1:Add, Button, w110 y+10, position
GuiControl,, position, Bind Hotkey
Gui 1:Add, Button, w110 y+10, both
GuiControl,, both, Bind Hotkey
Gui 1:Add, Button, w280 x10 y+10, coordinates
GuiControl,, coordinates, Set Size/Position for Window Position Toggle
Gui 1:Show,,Simple Borderless Games
Return

;;;Set Hotkeys
Buttonborder:
Gui 2:Destroy
ChosenHotkey= 
Gui 2:Add, text,, Enter hotkey and press 'done'.
Gui 2:Add, text,, Previous Hotkey: %prevhotkeyborder%
Gui 2:Add, Hotkey, vChosenHotkey, %ChosenHotkey%
Gui 2:Add, button, gdone, Done
Gui 2:Show
whichbutton=border
return

Buttonposition:
Gui 2:Destroy
ChosenHotkey= 
Gui 2:Add, text,, Enter hotkey and press 'done'. 
Gui 2:Add, text,x10 y20, Previous Hotkey: %prevhotkeyposition%
Gui 2:Add, Hotkey, vChosenHotkey, %ChosenHotkey%
Gui 2:Add, button, gdone, Done
Gui 2:Show
whichbutton=position
return

Buttonboth:
Gui 2:Destroy
ChosenHotkey= 
Gui 2:Add, text,, Enter hotkey and press 'done'.
Gui 2:Add, text,, Previous Hotkey: %prevhotkeyboth%
Gui 2:Add, Hotkey, vChosenHotkey, %ChosenHotkey%
Gui 2:Add, button, gdone, Done
Gui 2:Show
whichbutton=both
return

done:
gui, submit

; if no current hotkey, quit
if ChosenHotkey= 
{
  Gui 2:Destroy
  return
}

; save hotkey if updated
if prevhotkeyborder != %ChosenHotkey% 
{
  if prevhotkeyposition != %ChosenHotkey%
  {
    if prevhotkeyboth != %ChosenHotkey%
    {
      IniWrite, %ChosenHotkey%, config.ini, Hotkeys, %whichbutton%-hotkey
      Hotkey, %prevhotkeyborder%, OFF
      Hotkey, %prevhotkeyposition%, OFF
      Hotkey, %prevhotkeyboth%, OFF
      IniRead, prevhotkeyborder, config.ini, Hotkeys, border-hotkey
      IniRead, prevhotkeyposition, config.ini, Hotkeys, position-hotkey
      IniRead, prevhotkeyboth, config.ini, Hotkeys, both-hotkey
      Hotkey, %prevhotkeyborder%, border
      Hotkey, %prevhotkeyposition%, position
      Hotkey, %prevhotkeyboth%, both
      Hotkey, %prevhotkeyborder%, ON
      Hotkey, %prevhotkeyposition%, ON
      Hotkey, %prevhotkeyboth%, ON
      return
    }
  }
}
else
{
  msgbox >Setting Hotkey Failed: Duplicate Hotkey<
  return
}


Buttoncoordinates:
posx=
posy=
sizew=
sizeh= 
inputbox, tempposx, X Coordinate, Insert X Coordinate For Top Left Corner In Pixels (Ex: 1280):,,380,140
if tempposx != 
{
IniWrite, %tempposx%, config.ini, Coordinates, posx
}
inputbox, tempposy, Y Coordinate, Insert Y Coordinate For Top Left Corner In Pixels (Ex: 720):,,380,140
if tempposy != 
{
IniWrite, %tempposy%, config.ini, Coordinates, posy
}
inputbox, tempsizew, Window Width, Insert Width For Window In Pixels (Ex.1920):,,380,140
if tempsizew != 
{
IniWrite, %tempsizew%, config.ini, Coordinates, sizew
}
inputbox, tempsizeh, Window Height, Insert Height For Window In Pixels (Ex.1080):,,380,140
if tempsizeh != 
{
IniWrite, %tempsizeh%, config.ini, Coordinates, sizeh
}
IniRead, posx, config.ini, Coordinates, posx
IniRead, posy, config.ini, Coordinates, posy
IniRead, sizew, config.ini, Coordinates, sizew
IniRead, sizeh, config.ini, Coordinates, sizeh


2GuiEscape:
Gui 2:Destroy
return
2GuiClose:
Gui 2:Destroy
return
Quitter:
Gui 2:Destroy
return
}

If (A_ThisMenuItem="&AutoStart")
{
IniRead, AutoStart, config.ini, General, AutoStart
  if AutoStart != 1
  {
    Menu,Tray,Check,&AutoStart
    IniWrite, 1, config.ini, General, AutoStart
    FileCreateShortcut, %A_ScriptDir%\Simple Borderless Games.exe, %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Simple Borderless Games.lnk, %A_ScriptDir%\
  }
  Else
  {
    Menu,Tray,Uncheck,&AutoStart
    IniWrite, 0, config.ini, General, AutoStart
    FileDelete, %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Simple Borderless Games.lnk
  }
}

If (A_ThisMenuItem="E&xit")
  ExitApp
