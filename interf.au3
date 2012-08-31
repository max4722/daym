#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#Tidy_Parameters=/sf
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include "consts.au3"
#include "logs.au3"

Global $DCMDstate = 0
Global $DataFN = ""
Global $OldSec = 0

Func CloseCMDDialog()
	_LogFuncS("CloseCMDDialog()")
	;закрываем диалог команд
	If $SafeModeFlag Then
		If GetCMDstate() Then
			_LogFuncF("CloseCMDDialog()")
			Return
		EndIf
		WaitForConnected()
		WaitForW($CommandExecWinName)
		Send("{ALTDOWN}{F4}{ALTUP}")
	EndIf
	_LogFuncF("CloseCMDDialog()")
EndFunc   ;==>CloseCMDDialog

Func DebugMsg($msg, $flag = 4096, $timeout = 0)
	;_LogFuncS("DebugMsg(" & $msg & "," & $flag & "," & $timeout & ")")
	$res = MsgBox($flag, "Debug", $msg, $timeout)
	;_LogFuncF("DebugMsg() = " & $res)
	Return $res
EndFunc   ;==>DebugMsg

Func DisableCMDclose()
	_LogFuncS("DisableCMDclose()")
	$DCMDstate = 1
	_LogFuncF("DisableCMDclose()")
EndFunc   ;==>DisableCMDclose

Func EnableCMDclose()
	_LogFuncS("EnableCMDclose()")
	$DCMDstate = 0
	_LogFuncF("EnableCMDclose()")
EndFunc   ;==>EnableCMDclose

Func ExecCMD($CMD, $DATA = "")
	_LogFuncS("ExecCMD(" & $CMD & "," & $DATA & ")")
	WaitForConnected()
	WaitForW($CommandExecWinName)
	ControlSetText($CommandExecWinName, "", "TEdit3", $CMD)
	ControlSetText($CommandExecWinName, "", "TEdit2", $DATA)
	Do
		WaitForButon()
		ControlClick($CommandExecWinName, "", "TButton2")
		WaitForButon()
		$status = GetErrStatus()
		If $status <> 0 Then
			$button = DebugMsg("Ошибка при выполнении команды" & @CRLF & $CMD & @CRLF & $DATA, 4096 + 6)
			If $button = 2 Then ExitScript("$button = 2")
			If $button = 11 Then $status = 0
		EndIf
	Until $status = 0
	$res = ControlGetText($CommandExecWinName, "", "TEdit1")
	_LogFuncF("ExecCMD() = " & $res)
	Return $res
EndFunc   ;==>ExecCMD

Func ExitScript($ExitText = "")
	_LogFuncS("ExitScript(" & $ExitText & ")")
	;EnableCMDclose()
	;CloseCMDDialog()
	WinSetOnTop($CommandExecWinName, "", 0)
	If $ExitText <> "" Then _Log("!!! " & $ExitText & " !!!")
	_LogFuncF("ExitScript()")
	ConsoleWrite("Exiting." & @CRLF)
	Exit
EndFunc   ;==>ExitScript

Func GetCMDstate()
	_LogFuncS("GetCMDstate()")
	_LogFuncF("GetCMDstate()=" & $DCMDstate)
	Return $DCMDstate
EndFunc   ;==>GetCMDstate

Func GetErrStatus()
	Dim $pix
	Dim $sym0[5][9] = [[0, 1, 1, 1, 1, 1, 1, 1, 0],[1, 0, 0, 0, 0, 0, 0, 0, 1],[1, 0, 0, 0, 0, 0, 0, 0, 1],[1, 0, 0, 0, 0, 0, 0, 0, 1],[0, 1, 1, 1, 1, 1, 1, 1, 0]]
	Dim $scan = ""
	_LogFuncS("GetErrStatus()")
	$res = 0
	$x_shift = 77
	$y_shift = 86
	$hwnd = WinGetHandle($CommandExecWinName)
	If $hwnd = -1 Then ExitScript("$hwnd = -1")
	WinSetOnTop($CommandExecWinName, "", 1)
	For $j = 0 To 8
		For $i = 0 To 4
			$pix = 0
			$colr = PixelGetColor($x_shift + $i, $y_shift + $j, $hwnd)
			If $colr = 0 Then $pix = 1
			If $pix <> $sym0[$i][$j] Then $res = 1
			#cs
				If $pix Then
				$scan = $scan & "*"
				Else
				$scan = $scan & "."
				EndIf
			#ce
			;If $res Then ExitLoop
		Next
		$scan = $scan & @CRLF
		;If $res Then ExitLoop
	Next
	;DebugMsg($scan)
	_LogFuncF("GetErrStatus()=" & $res)
	Return $res
EndFunc   ;==>GetErrStatus

Func IsConnected()
	_LogFuncS("IsConnected()")
	If ControlGetText($MainWindowName, "", "TButton5") = "Disconnect" Then
		$res = 1
	Else
		$res = 0
	EndIf
	_LogFuncF("IsConnected()=" & $res)
	Return $res
EndFunc   ;==>IsConnected

Func OpenCMDDialog()
	_LogFuncS("OpenCMDDialog()")
	If $SafeModeFlag Then
		WaitForConnected()
		If Not WinActive($CommandExecWinName) Then
			$PrevState = GetCMDstate()
			EnableCMDclose()
			CloseCMDDialog()
			WaitForW($MainWindowName)
			Send("{ALT}{RIGHT 2}{ENTER}")
			If $PrevState Then DisableCMDclose()
		EndIf
		WaitForW($CommandExecWinName)
	EndIf
	_LogFuncF("OpenCMDDialog()")
EndFunc   ;==>OpenCMDDialog

Func sprintf(ByRef $s, $format, $var1, $var2 = -1, $var3 = -1, $var4 = -1, $var5 = -1)
	_LogFuncS("sprintf($s," & $format & "," & $var1 & "," & $var2 & "," & $var3 & "," & $var4 & "," & $var5 & ")")
	If $var2 = -1 Then
		$s = StringFormat($format, $var1)
	Else
		$s = StringFormat($format, $var1, $var2, $var3, $var4, $var5)
	EndIf
	_LogFuncF("sprintf() $s=" & $s)
EndFunc   ;==>sprintf

Func WaitForButon($WinName = $CommandExecWinName, $BN = "TButton2")
	_LogFuncS("WaitForButon(" & $WinName & "," & $BN & ")")
	While Not ControlCommand($WinName, "", $BN, "IsEnabled", "")
		Sleep($GlobalDelay)
	WEnd
	_LogFuncF("WaitForButon()")
EndFunc   ;==>WaitForButon

Func WaitForConnected()
	_LogFuncS("WaitForConnected()")
	While Not IsConnected()
		Sleep($GlobalDelay)
	WEnd
	_LogFuncF("WaitForConnected()")
EndFunc   ;==>WaitForConnected

Func WaitForW($WinName)
	_LogFuncS("WaitForW(" & $WinName & ")")
	WaitForConnected()
	WinWait($WinName)
	If $SafeModeFlag Then
		While Not WinActive($WinName)
			WinActivate($WinName)
			Sleep($GlobalDelay)
		WEnd
	EndIf
	_LogFuncF("WaitForW()")
EndFunc   ;==>WaitForW
