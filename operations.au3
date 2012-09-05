#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#Tidy_Parameters=/sf
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include "consts.au3"
#include "interf.au3"
#include "logs.au3"

Func ClearAllArt()
	_LogFuncS("ClearAllArt()")
	OpenCMDDialog()
	$res = ExecCMD(107, "DA," & $Pass)
	CloseCMDDialog()
	_LogFuncF("ClearAllArt()=" & $res)
	Return $res
EndFunc   ;==>ClearAllArt

Func CloseFisc()
	_LogFuncS("CloseFisc()")
	OpenCMDDialog()
	$res = ExecCMD(56)
	CloseCMDDialog()
	_LogFuncF("CloseFisc()=" & $res)
	Return $res
EndFunc   ;==>CloseFisc

Func DiagLine($cs = "")
	_LogFuncS("DiagLine(" & $cs & ")")
	OpenCMDDialog()
	$res = ExecCMD(90, $cs)
	CloseCMDDialog()
	_LogFuncF("DiagLine()=" & $res)
	Return $res
EndFunc   ;==>DiagLine

Func DoDiag()
	_LogFuncS("DoDiag()")
	OpenCMDDialog()
	;Z-отчет
	$res = ExecCMD(71)
	CloseCMDDialog()
	_LogFuncF("DoDiag()=" & $res)
	Return $res
EndFunc   ;==>DoDiag

Func DoX()
	_LogFuncS("DoX()")
	OpenCMDDialog()
	;Z-отчет
	$res = ExecCMD(69, $Pass & ",2")
	CloseCMDDialog()
	_LogFuncF("DoX()=" & $res)
	Return $res
EndFunc   ;==>DoX

Func DoZ()
	_LogFuncS("DoZ()")
	OpenCMDDialog()
	;Z-отчет
	$res = ExecCMD(69, $Pass & ",0")
	CloseCMDDialog()
	_LogFuncF("DoZ()=" & $res)
	Return $res
EndFunc   ;==>DoZ

Func GetTime()
	_LogFuncS("GetTime()")
	OpenCMDDialog()
	;прочитать время
	$res = ExecCMD(62)
	CloseCMDDialog()
	_LogFuncF("GetTime()=" & $res)
	Return $res
EndFunc   ;==>GetTime

Func HFreadln($row)
	_LogFuncS("HFreadln(" & $row & ")")
	OpenCMDDialog()
	If $row >= 0 And $row <= 7 Then
		$res = ExecCMD(43, "I" & $row)
	Else
		ExitScript("$row < 0 Or $row > 7")
	EndIf
	CloseCMDDialog()
	Return $res
EndFunc   ;==>HFreadln

Func HFwriteln($text, $row)
	_LogFuncS("HFwriteln(" & $text & "," & $row & ")")
	OpenCMDDialog()
	If $row >= 0 And $row <= 7 Then
		$res = ExecCMD(43, $row & $text)
	Else
		ExitScript("$row < 0 Or $row > 7")
	EndIf
	CloseCMDDialog()
	_LogFuncF("HFwriteln()=" & $res)
	Return $res
EndFunc   ;==>HFwriteln

Func OpenFisc($OpNum = 1, $P = $Pass, $PlaceNum = 1)
	_LogFuncS("OpenFisc(" & $OpNum & "," & $P & "," & $PlaceNum & ")")
	OpenCMDDialog()
	;внос
	$res = ExecCMD(48, $OpNum & "," & $P & "," & $PlaceNum & ",I")
	CloseCMDDialog()
	_LogFuncF("OpenFisc()=" & $res)
	Return $res
EndFunc   ;==>OpenFisc

Func OpenReturn($OpNum = 1, $P = $Pass, $PlaceNum = 1)
	_LogFuncS("OpenReturn(" & $OpNum & "," & $P & "," & $PlaceNum & ")")
	OpenCMDDialog()
	;внос
	$res = ExecCMD(85, $OpNum & "," & $P & "," & $PlaceNum & ",I")
	CloseCMDDialog()
	_LogFuncF("OpenReturn()=" & $res)
	Return $res
EndFunc   ;==>OpenReturn

Func PaymentStatus()
	_LogFuncS("PaymentStatus()")
	OpenCMDDialog()
	$res = ExecCMD(110, "")
	_LogFuncF("PaymentStatus()=" & $res)
	CloseCMDDialog()
EndFunc   ;==>PaymentStatus

Func PRbyDate($f, $l)
	_LogFuncS("PRbyDate(" & $f & "," & $l & ")")
	OpenCMDDialog()
	;периодический отчет по дате
	$res = ExecCMD(79, $Pass & "," & $f & "," & $l)
	CloseCMDDialog()
	_LogFuncF("PRbyDate()=" & $res)
	Return $res
EndFunc   ;==>PRbyDate

Func PRbyNum($f, $l)
	_LogFuncS("PRbyNum(" & $f & "," & $l & ")")
	OpenCMDDialog()
	;периодический отчет по номеру
	$res = ExecCMD(95, $Pass & "," & $f & "," & $l)
	CloseCMDDialog()
	_LogFuncF("PRbyNum()=" & $res)
	Return $res
EndFunc   ;==>PRbyNum

Func SellArt($ArtNum, $Count = 1, $DC = 0, $DCmode = 0)
	_LogFuncS("SellArt(" & $ArtNum & "," & $Count & "," & $DC & "," & $DCmode & ")")
	OpenCMDDialog()
	If $DC = 0 Then
		$Discount = ""
	ElseIf $DCmode Then
		$Discount = ";" & $DC
	Else
		$Discount = "," & $DC
	EndIf
	$res = ExecCMD(52, $ArtNum & "*" & $Count & $Discount)
	CloseCMDDialog()
	_LogFuncF("SellArt()=" & $res)
	Return $res
EndFunc   ;==>SellArt

Func ServIn($amount)
	_LogFuncS("ServIn(" & $amount & ")")
	OpenCMDDialog()
	;внос
	$res = ExecCMD(70, $amount)
	CloseCMDDialog()
	_LogFuncF("ServIn()=" & $res)
	Return $res
EndFunc   ;==>ServIn

Func ServOut($amount)
	_LogFuncS("ServOut(" & $amount & ")")
	$amount = -$amount
	$res = ServIn($amount)
	_LogFuncF("ServOut()=" & $res)
EndFunc   ;==>ServOut

Func SetArt($Num, $ItemName, $Price, $TaxG = "А", $Grup = 1)
	_LogFuncS("SetArt(" & $Num & "," & $ItemName & "," & $Price & "," & $TaxG & "," & $Grup & ")")
	OpenCMDDialog()
	$res = ExecCMD(107, "P" & $TaxG & $Num & "," & $Grup & "," & $Price & "," & $Pass & "," & $ItemName)
	CloseCMDDialog()
	_LogFuncF("SetArt()=" & $res)
	Return $res
EndFunc   ;==>SetArt

Func SetTime($day, $mon, $year, $dd, $mm, $ss = 0)
	_LogFuncS("SetTime(" & $day & "," & $mon & "," & $year & "," & $dd & "," & $mm & "," & $ss & ")")
	OpenCMDDialog()
	$datetime = ""
	sprintf($datetime, "%02d-%02d-%02d %02d:%02d", $day, $mon, $year, $dd, $mm)
	;задаем время
	$res = SetTimeStr($datetime)
	;$res = ExecCMD(61, $datetime)
	CloseCMDDialog()
	_LogFuncF("SetTime()=" & $res)
	Return $res
EndFunc   ;==>SetTime

Func SetTimeS($date, $hh, $mm, $ss, $ds = 0)
	_LogFuncS("SetTimeS(" & $date & "," & $hh & "," & $mm & "," & $ss & "," & $ds & ")")
	If $hh < 0 Then $hh = 0
	If $mm < 0 Then $mm = 0
	If $ss < 0 Then $ss = 0
	If $ds < 0 Then $ds = 0
	$DoNotSetTimeFlag = False
	$CurrentSec = 0
	$ss2 = 0
	$deltaSec = $ds
	If $ss <= $deltaSec Then
		$ss2 = 60
		$mm -= 1
		If $mm < 0 Then
			$mm = 59
			$hh -= 1
			If $hh < 0 Then
				$hh = 0
				$mm = 0
				$ss = $deltaSec + 1
			EndIf
		EndIf
	EndIf
	OpenCMDDialog()
	$datetime = ""
	sprintf($datetime, "%s %02d:%02d:%02d", $date, $hh, $mm, $ss)
	;задаем время
	;$res = ExecCMD(61, $datetime)
	$CurrentDT = GetTime()
	$countdown = $ss + $ss2 - $deltaSec + 1
	If StringTrimRight($CurrentDT, 2) = StringTrimRight($datetime, 2) Then
		$CurrentSec = StringRight($CurrentDT, 2)
		$countdown -= $CurrentSec
		$DoNotSetTimeFlag = True
	EndIf
	$res = ""
	If Not $DoNotSetTimeFlag Or $countdown < 0 Then $res = SetTimeStr($datetime)
	$begin = TimerInit()
	;ждем секунды
	Local $i, $sec, $oldsec = ''
	If $countdown > 0 Then
		Do
			$sec = Int(TimerDiff($begin) / 1000)
			If $sec <> $oldsec Then
				$oldsec = $sec
				$i = Int(100 * (TimerDiff($begin) / (1000 * ($countdown))))
				If $i > 100 Then $i = 100
				WinSetTitle($CommandExecWinName, "", $CommandExecWinName & " " & $countdown + 1 - Int(TimerDiff($begin) / 1000) & " секунд " & $i & "%")
			EndIf
		Until $i = 100
	EndIf
	WinSetTitle($CommandExecWinName, "", $CommandExecWinName)
	CloseCMDDialog()
	_LogFuncF("SetTimeS()=" & $res)
	Return $res
EndFunc   ;==>SetTimeS

Func SetTimeStr($s)
	_LogFuncS("SetTimeStr(" & $s & ")")
	OpenCMDDialog()
	;задаем время
	$res = ExecCMD(61, $s)
	CloseCMDDialog()
	_LogFuncF("SetTimeStr()=" & $res)
	Return $res
EndFunc   ;==>SetTimeStr

Func SetTimeStrS($datetime, $dsec = 0)
	_LogFuncS("SetTimeStrS(" & $datetime & "," & $dsec & ")")
	$date = StringTrimRight($datetime, 9)
	$time = StringTrimLeft($datetime, 9)
	$h = StringTrimRight($time, 6)
	$m = StringTrimRight(StringTrimLeft($time, 3), 3)
	$s = StringTrimLeft($time, 6)
	$res = SetTimeS($date, $h, $m, $s, $dsec)
	_LogFuncF("SetTimeStrS()=" & $res)
	Return $res
EndFunc   ;==>SetTimeStrS

Func Total($amount = 0, $Mode = "P")
	_LogFuncS("Total(" & $amount & "," & $Mode & ")")
	OpenCMDDialog()
	If $amount > 0 Then
		$param = "\t" & $Mode & $amount
	Else
		$param = ""
	EndIf
	$res = ExecCMD(53, $param)
	CloseCMDDialog()
	_LogFuncF("Total()=" & $res)
	Return $res
EndFunc   ;==>Total

Func ZeroCheck()
	_LogFuncS("ZeroCheck()")
	OpenFisc()
	Total()
	CloseFisc()
	_LogFuncF("ZeroCheck()")
EndFunc   ;==>ZeroCheck
