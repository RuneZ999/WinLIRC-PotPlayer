; WinLIRC Client Updated 
; http://www.autohotkey.com
; This script receives notifications from WinLIRC whenever you press
; a button on your remote control.

; Here are the steps to use this script:
; 1) Configure WinLIRC to recognize your remote control and its buttons.
;    WinLIRC is at http://winlirc.sourceforge.net
; 2) Edit the WinLIRC path, address, and port in the CONFIG section below.
; 3) Launch this script. It will start the WinLIRC server if needed.
; 4) Press some buttons on your remote control. A small window will
;    appear showing the name of each button as you press it.
; 5) Configure your buttons to send keystrokes and mouse clicks to
;    PotPlayer. See the examples below.

; This script requires AutoHotkey 1.0.38.04 or later.
; HISTORY OF CHANGES
; 2020:
; Fixed for working with Unicode version too (why871)
; Added controls for PotPlayer
; Added GUI at key pressed, make sure that PotPlayer has AlwaysOnTop disabled
; March 2, 2007:
; - Improved reliability via "Critical" in ReceiveData().
; October 5, 2005:
; - Eliminated Winsock warning dialog "10054" upon system shutdown/logoff.
; - Added option "DelayBetweenButtonRepeats" to throttle the repeat speed.

; -------------------------------------------------
; CONFIGURATION SECTION: Set your preferences here.
; -------------------------------------------------
; Some remote controls repeat the signal rapidly while you're holding down
; a button. This makes it difficult to get the remote to send only a single
; signal. The following setting solves this by ignoring repeated signals
; until the specified time has passed. 200 is often a good setting.  Set it
; to 0 to disable this feature.
DelayBetweenButtonRepeats = 200

; Specify the path to WinLIRC, such as C:\WinLIRC\winlirc.exe
WinLIRC_Path = C:\UTILS\WinLIRC\winlirc.exe

; Specify WinLIRC's address and port. The most common are 127.0.0.1 (localhost) and 8765.
WinLIRC_Address = 127.0.0.1
WinLIRC_Port = 8765

SetTitleMatchMode, 2 ; Partial title matching
#singleinstance force ; Single instance enforced, replaces the old instance automatically
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

; Set icon of script in tray same as PotPlayer
; Set FileName to target the PotPlayerExecutable
; 64-bit -> C:\Program Files\DAUM\PotPlayer\PotPlayerMini64.exe
; 32-bit -> C:\Program Files (x86)\DAUM\PotPlayer\PotPlayerMini.exe
FileName := "C:\Program Files\DAUM\PotPlayer\PotPlayerMini64.exe"
ptr := A_PtrSize =8 ? "ptr" : "uint"   ;for AHK Basic
hIcon := DllCall("Shell32\ExtractAssociatedIcon" (A_IsUnicode ? "W" : "A"), ptr, DllCall("GetModuleHandle", ptr, 0, ptr), str, FileName, "ushort*", lpiIcon, ptr)   ;only supports 32x32
Menu, Tray, Icon, HICON:*%hIcon%
Menu, Tray, Tip, PotPlayer WinLIRC Reciver

; Do not change the following two lines. Skip them and continue below.
Gosub WinLIRC_Init
return

; --------------------------------------------
; ASSIGN ACTIONS TO THE BUTTONS ON YOUR REMOTE
; --------------------------------------------
; Configure your remote control's buttons below. Use WinLIRC's names
; for the buttons, which can be seen in your WinLIRC config file
; (.cf file) -- or you can press any button on your remote and the
; script will briefly display the button's name in a small window.
; 
; Below are some examples. Feel free to revise or delete them to suit
; your preferences.


OK:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {space}
	guidisp("Play Pause",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

UP:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {up}
	guidisp("Volume Up",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

DOWN:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {down}
	guidisp("Volume Down",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

LEFT:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {left}
	guidisp("5 Sec. Backward",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

RIGHT:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {right}
	guidisp("5 Sec. Forward",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

3:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {e}
	guidisp("Brightness 1% Increase",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

1:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {q}
	guidisp("Brightness Reset",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

2:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {w}
	guidisp("Brightness 1% Decrease",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

RED:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {space}
	WinMinimize, PotPlayer
	guidisp("Boss Key",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

7:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {PgUp}
	guidisp("Play Previous Item",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

9:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {PgDn}
	guidisp("Play Next Item",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

GREEN:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {return}
	guidisp("Fullscreen Toggle (keep AR)",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

MUTE:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send {m}
	guidisp("Mute Volume",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

POWER:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	WinClose, PotPlayer
	guidisp("Quit PotPlayer",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

4:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send #+{left}
	guidisp("Move To Next Desktop (to the left)",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

6:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send #+{right}
	guidisp("Move To Next Desktop (to the right)",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

-/--:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send  !{l}
	guidisp("Cycle Subtitle",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return

A/B:
IfWinExist, PotPlayer
{
	WinActivate, PotPlayer
	WinGetPos, X, Y, Width, Height, PotPlayer
	Send  {F4}
	guidisp("Stop",X, Y)
}
else
{
	guidisp("Pot Player NOT running",0, 0)
}
return


; The examples above give a feel for how to accomplish common tasks.
; To learn the basics of AutoHotkey, check out the Quick-start Tutorial
; at http://www.autohotkey.com/docs/Tutorial.htm

; ----------------------------
; END OF CONFIGURATION SECTION
; ----------------------------
; Do not make changes below this point unless you want to change the core
; functionality of the script.

WinLIRC_Init:
OnExit, ExitSub  ; For connection cleanup purposes.

; Launch WinLIRC if it isn't already running:
Process, Exist, winlirc.exe
if not ErrorLevel  ; No PID for WinLIRC was found.
{
	IfNotExist, %WinLIRC_Path%
	{
		MsgBox The file "%WinLIRC_Path%" does not exist. Please edit this script to specify its location.
		ExitApp
	}
	Run %WinLIRC_Path%
	Sleep 200  ; Give WinLIRC a little time to initialize (probably never needed, just for peace of mind).
}

; Connect to WinLIRC (or any type of server for that matter):
socket := ConnectToAddress(WinLIRC_Address, WinLIRC_Port)
if socket = -1  ; Connection failed (it already displayed the reason).
	ExitApp

; Find this script's main window:
Process, Exist  ; This sets ErrorLevel to this script's PID (it's done this way to support compiled scripts).
DetectHiddenWindows On
ScriptMainWindowId := WinExist("ahk_class AutoHotkey ahk_pid " . ErrorLevel)
DetectHiddenWindows Off

; When the OS notifies the script that there is incoming data waiting to be received,
; the following causes a function to be launched to read the data:
NotificationMsg = 0x5555  ; An arbitrary message number, but should be greater than 0x1000.
OnMessage(NotificationMsg, "ReceiveData")

; Set up the connection to notify this script via message whenever new data has arrived.
; This avoids the need to poll the connection and thus cuts down on resource usage.
FD_READ = 1     ; Received when data is available to be read.
FD_CLOSE = 32   ; Received when connection has been closed.
if DllCall("Ws2_32\WSAAsyncSelect", "UInt", socket, "UInt", ScriptMainWindowId, "UInt", NotificationMsg, "Int", FD_READ|FD_CLOSE)
{
	MsgBox % "WSAAsyncSelect() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
	ExitApp
}
return



ConnectToAddress(IPAddress, Port)
; This can connect to most types of TCP servers, not just WinLIRC.
; Returns -1 (INVALID_SOCKET) upon failure or the socket ID upon success.
{
	VarSetCapacity(wsaData, 400)
	result := DllCall("Ws2_32\WSAStartup", "UShort", 0x0002, "UInt", &wsaData) ; Request Winsock 2.0 (0x0002)
	; Since WSAStartup() will likely be the first Winsock function called by this script,
	; check ErrorLevel to see if the OS has Winsock 2.0 available:
	if ErrorLevel
	{
		MsgBox WSAStartup() could not be called due to error %ErrorLevel%. Winsock 2.0 or higher is required.
		return -1
	}
	if result  ; Non-zero, which means it failed (most Winsock functions return 0 upon success).
	{
		MsgBox % "WSAStartup() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
		return -1
	}

	AF_INET = 2
	SOCK_STREAM = 1
	IPPROTO_TCP = 6
	socket := DllCall("Ws2_32\socket", "Int", AF_INET, "Int", SOCK_STREAM, "Int", IPPROTO_TCP)
	if socket = -1
	{
		MsgBox % "socket() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
		return -1
	}

	; Prepare for connection:
	SizeOfSocketAddress = 16
	VarSetCapacity(SocketAddress, SizeOfSocketAddress)
	InsertInteger(2, SocketAddress, 0, AF_INET)   ; sin_family
	InsertInteger(DllCall("Ws2_32\htons", "UShort", Port), SocketAddress, 2, 2)   ; sin_port
	; InsertInteger(DllCall("Ws2_32\inet_addr", "Str", IPAddress), SocketAddress, 4, 4) ; sin_addr.s_addr
	InsertInteger(DllCall("Ws2_32\inet_addr", "AStr", IPAddress), SocketAddress, 4, 4)   ; FIX FOR WORKING WITH UNICODE AHK @why871

	; Attempt connection:
	if DllCall("Ws2_32\connect", "UInt", socket, "UInt", &SocketAddress, "Int", SizeOfSocketAddress)
	{
		MsgBox % "connect() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError") . ". Is WinLIRC running?"
		return -1
	}
	return socket  ; Indicate success by returning a valid socket ID rather than -1.
}



ReceiveData(wParam, lParam)
; By means of OnMessage(), this function has been set up to be called automatically whenever new data
; arrives on the connection.  It reads the data from WinLIRC and takes appropriate action depending
; on the contents.
{
	Critical  ; Prevents another of the same message from being discarded due to thread-already-running.
	socket := wParam
	ReceivedDataSize = 4096  ; Large in case a lot of data gets buffered due to delay in processing previous data.

	VarSetCapacity(ReceivedData, ReceivedDataSize, 0)  ; 0 for last param terminates string for use with recv().
	ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", socket, "Str", ReceivedData, "Int", ReceivedDataSize, "Int", 0)
	if ReceivedDataLength = 0  ; The connection was gracefully closed, probably due to exiting WinLIRC.
		ExitApp  ; The OnExit routine will call WSACleanup() for us.
	if ReceivedDataLength = -1
	{
		WinsockError := DllCall("Ws2_32\WSAGetLastError")
		if WinsockError = 10035  ; WSAEWOULDBLOCK, which means "no more data to be read".
			return 1
		if WinsockError <> 10054 ; WSAECONNRESET, which happens when WinLIRC closes via system shutdown/logoff.
			; Since it's an unexpected error, report it.  Also exit to avoid infinite loop.
			MsgBox % "recv() indicated Winsock error " . WinsockError
		ExitApp  ; The OnExit routine will call WSACleanup() for us.
	}
	; Otherwise, process the data received. Testing shows that it's possible to get more than one line
	; at a time (even for explicitly-sent IR signals), which the following method handles properly.
	; Data received from WinLIRC looks like the following example (see the WinLIRC docs for details):
	; 0000000000eab154 00 NameOfButton NameOfRemote
	ReceivedData := StrGet(&ReceivedData,"cp0") ; FIX FOR WORKING WITH UNICODE AHK @why871
	Loop, parse, ReceivedData, `n, `r
	{
		if A_LoopField in ,BEGIN,SIGHUP,END  ; Ignore blank lines and WinLIRC's start-up messages.
			continue
		ButtonName =  ; Init to blank in case there are less than 3 fields found below.
		Loop, parse, A_LoopField, %A_Space%  ; Extract the button name, which is the third field.
			if A_Index = 3
				ButtonName := A_LoopField
		global DelayBetweenButtonRepeats  ; Declare globals to make them available to this function.
		static PrevButtonName, PrevButtonTime, RepeatCount  ; These variables remember their values between calls.
		if (ButtonName != PrevButtonName || A_TickCount - PrevButtonTime > DelayBetweenButtonRepeats)
		{
			if IsLabel(ButtonName)  ; There is a subroutine associated with this button.
				Gosub %ButtonName%  ; Launch the subroutine.
			else ; Since there is no associated subroutine, briefly display which button was pressed.
			{
				if (ButtonName == PrevButtonName)
					RepeatCount += 1
				else
					RepeatCount = 1
				SplashTextOn, 150, 20, Button from WinLIRC, %ButtonName% (%RepeatCount%)
				SetTimer, SplashOff, 3000  ; This allows more signals to be processed while displaying the window.
			}
			PrevButtonName := ButtonName
			PrevButtonTime := A_TickCount
		}
	}
	return 1  ; Tell the program that no further processing of this message is needed.
}



SplashOff:
SplashTextOff
SetTimer, SplashOff, Off
return



InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4)
; The caller must ensure that pDest has sufficient capacity.  To preserve any existing contents in pDest,
; only pSize number of bytes starting at pOffset are altered in it.
{
	Loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
		DllCall("RtlFillMemory", "UInt", &pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF)
}

guidisp(text, x, y){
	Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption
	Gui, Color, ffffff ;changes background color
	Gui, Font, 000000 s20 wbold, Verdana ;changes font color, size and font
	Gui, Add, Text, x0 y0, %text% ;the text to display
	x := x + 10 ; Offest x
	y := y + 40 ; Offset y
	Length := StrLen(text)
	Length := Length * 19
	;Gui, Show, w210 h35 x%x% y%y% NoActivate
	Gui, Show, w%Length% h35 x%x% y%y% NoActivate

	sleep, 700
	Gui, Destroy
}


ExitSub:  ; This subroutine is called automatically when the script exits for any reason.
; MSDN: "Any sockets open when WSACleanup is called are reset and automatically
; deallocated as if closesocket was called."
DllCall("Ws2_32\WSACleanup")
ExitApp