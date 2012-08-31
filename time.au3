#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#Tidy_Parameters=/sf
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include "consts.au3"
#include "interf.au3"
#include "operations.au3"
#include "logs.au3"

Func SetRandTime($date1, $lotime = "22:00:00", $hitime = "23:00:00", $ds = 0)
	_LogFuncS("SetRandTime(" & $date1 & "," & $lotime & "," & $hitime & "," & $ds & ")")
	Dim $time2;
	;WaitForWin ()
	;OpenCMDDialog ()
	;читаем время yy-mm-dd hh:mm:ss
	$time1 = GetTime()
	;читаем дату из диалогов ввода
	;If $date1 = "" Then $date1 = StringTrimRight($time1, 9)
	;$date1 = InputBox("Дата", "дата", $date1, "", -1, -1, 0, 0)
	If @error = 1 Then ExitScript()
	$yd = StringTrimRight($date1, 6)
	$md = StringTrimRight(StringTrimLeft($date1, 3), 3)
	$dd = StringTrimLeft($date1, 6)
	;устанавливаем диапазон время для случайного генерирования
	;от
	;$lotime = InputBox("Время", "от", $lotime, "", -1, -1, 0, 0)
	;If @error = 1 Then ExitScript()
	;до
	;$hitime = InputBox("Время", "до", $hitime, "", -1, -1, 0, 0)
	;If @error = 1 Then ExitScript()
	;парсим чч:мм:сс
	$hl = StringTrimRight($lotime, 6)
	$ml = StringTrimRight(StringTrimLeft($lotime, 3), 3)
	$sl = StringTrimLeft($lotime, 6)
	$hh = StringTrimRight($hitime, 6)
	$mh = StringTrimRight(StringTrimLeft($hitime, 3), 3)
	$sh = StringTrimLeft($hitime, 6)
	;выбираем случайное в диапазоне
	$secf = Random(toSec($hl, $ml, $sl), toSec($hh, $mh, $sh), 1)
	$secdiff = toSec($hh, $mh, $sh) - toSec($hl, $ml, $sl)
	;преобразуем в формат времени гг-мм-дд чч:мм:сс
	$t = toTime($secf)
	SetTimeS($date1, $t[0], $t[1], $t[2], $ds)
	_LogFuncF("SetRandTime()")
EndFunc   ;==>SetRandTime

Func toSec($h, $m, $s)
	_LogFuncS("toSec(" & $h & "," & $m & "," & $s & ")")
	$res = 60 * (60 * Number($h) + Number($m)) + Number($s)
	_LogFuncF("toSec()=" & $res)
	Return $res
EndFunc   ;==>toSec

Func toTime($s)
	_LogFuncS("toTime(" & $s & ")")
	$h = Int($s / 3600)
	$m = Int(Mod($s, 3600) / 60)
	$s = $s - 3600 * $h - 60 * $m
	Dim $res[3] = [$h, $m, $s]
	_LogFuncF("toTime()=" & $res)
	Return $res
EndFunc   ;==>toTime
