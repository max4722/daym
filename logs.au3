#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#Tidy_Parameters=/sf
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include "consts.au3"

Global $LogDepth = 0
Global $LogDataStampEn = 1

Func _Log($s, $d = 0)
	$LSS = $LogSpaceSymbol1
	If Not $Loging Then
		$sp = ""
		$pre = 0
		If $d < 0 Then $pre = $d
		For $i = 1 To $LogDepth + $pre
			$sp &= $LSS
		Next
		If $LogDataStampEn Then
			$datastamp = @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC & ": "
		Else
			$datastamp = "              "
		EndIf
		$out = $datastamp & $sp & $s & @CRLF
		ConsoleWrite($out)
	EndIf
	$LogDepth += $d
EndFunc   ;==>_Log

Func _LogFuncF($fn)
	_Log("} ;" & $fn, -1)
EndFunc   ;==>_LogFuncF

Func _LogFuncS($fn)
	;_Log($fn & @CRLF & $OldSp & "              {", 1)
	_Log($fn & " {", 1)
EndFunc   ;==>_LogFuncS
