#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#Tidy_Parameters=/sf
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <Array.au3>
#include "consts.au3"
#include "operations.au3"
#include "sort.au3"
#include "logs.au3"
#include "time.au3"
Dim $arr[30]
Global $SalesAll, $PaysAll, $SalesAll_r, $PaysAll_r
Global $A, $B, $V, $G, $D
Global $A_r, $B_r, $V_r, $G_r, $D_r
Global $GOTIVKA_r, $CARD_r, $CREDIT_r, $CHECK_r
Global $GOTIVKA, $CARD, $CREDIT, $CHECK
Global $TIME1, $TIME2, $TIME3
Global $VNOS, $VNOS2
Global $VUNOS, $VUNOS2, $VUNOS3, $VUNOS4
Global $filedir = "."
Global $initFN = ""
Dim $FileList[100]
Global $FileListCount = 0
Global $FPsoftVer = ""
Global $FPchecksum = ""
Global $FPswitches = ""
Global $FPcountryCode = ""
Global $FPserial = ""
Global $FPfiscN = ""
Global $HFfilename = ""

Func BackupHF()
	_LogFuncS("BackupHF()")
	;#cs
	$HeadStr = "Сохр. тек. шапку"
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then
		$counter = ""
		Do
			$filename = StringTrimLeft($FPserial, 3) & "_" & "old" & $counter & ".FPH"
			If $counter = "" Then $counter = 1
			$counter += 1
		Until Not FileExists($filename)
		$file = FileOpen($filename, 2)

		If $file = -1 Then
			ExitScript("File open error!")
		EndIf

		For $i = 0 To 7
			$rd = HFreadln($i)
			If $rd <> "" Then FileWriteLine($file, $i & "," & $rd)
		Next
		FileClose($file)
	EndIf
	;#ce
	_LogFuncF("BackupHF()")
EndFunc   ;==>BackupHF

Func CheckData($OFmode = 0)
	_LogFuncS("CheckData(" & $OFmode & ")")
	$SalesAll = ""
	$SalesAll_r = ""
	sprintf($SalesAll, "%1.2f", Number($A) + Number($B) + Number($V) + Number($G) + Number($D))
	_Log("$SalesAll = " & $SalesAll)
	sprintf($SalesAll_r, "%1.2f", Number($A_r) + Number($B_r) + Number($V_r) + Number($G_r) + Number($D_r))
	_Log("$SalesAll_r = " & $SalesAll_r)
	If $OFmode = 0 Then
		$GOTIVKAin = ""
		$GOTIVKAout = ""
		sprintf($GOTIVKAin, "%1.2f", Number($GOTIVKA) + Number($VNOS) + Number($VNOS2))
		_Log("$GOTIVKAin = " & $GOTIVKAin)
		sprintf($GOTIVKAout, "%1.2f", Number($GOTIVKA_r) + Number($VUNOS) + Number($VUNOS2) + Number($VUNOS3) + Number($VUNOS4))
		_Log("$GOTIVKAout = " & $GOTIVKAout)
		$PaysAll = ""
		$PaysAll_r = ""
		sprintf($PaysAll, "%1.2f", Number($GOTIVKA) + Number($CARD) + Number($CREDIT) + Number($CHECK))
		_Log("$PaysAll = " & $PaysAll)
		sprintf($PaysAll_r, "%1.2f", Number($GOTIVKA_r) + Number($CARD_r) + Number($CREDIT_r) + Number($CHECK_r))
		_Log("$PaysAll_r = " & $PaysAll_r)
		;проверка исходных данных продаж
		If $SalesAll <> $PaysAll Then
			$HeadStr = "Исходные данные продаж"
			ShowInfo($HeadStr, $SalesAll & @CRLF & $PaysAll, "ERROR", 0, 0)
			ExitScript("$SalesAll <> $PaysAll")
		EndIf
		;проверка исходных данных возвратов
		If $SalesAll_r <> $PaysAll_r Then
			$HeadStr = "Исходные данные возвратов"
			ShowInfo($HeadStr, $SalesAll_r & @CRLF & $PaysAll_r, "ERROR", 0, 0)
			ExitScript("$SalesAll_r <> $PaysAll_r")
		EndIf
		If $GOTIVKAin < $GOTIVKAout Then
			$HeadStr = "Вынос будет больше чем есть в кассе"
			ShowInfo($HeadStr, $GOTIVKAin & @CRLF & $GOTIVKAout, "ERROR", 0, 0)
			ExitScript("$GOTIVKAin < $GOTIVKAout")
		EndIf
	EndIf
	_LogFuncF("CheckData()")
EndFunc   ;==>CheckData

Func CheckDataOF()
	_LogFuncS("CheckDataOF()")
	CheckData(1)
	_LogFuncF("CheckDataOF()")
EndFunc   ;==>CheckDataOF

Func DiagMajor()
	_LogFuncS("DiagMajor()")
	;X-отчет
	$HeadStr = "Диагностика"
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then DoDiag()
	_LogFuncF("DiagMajor()")
EndFunc   ;==>DiagMajor

Func GetDiagInfo()
	_LogFuncS("GetDiagInfo()")
	$HeadStr = "Диаг. инфо"
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then
		$line = DiagLine(1)
		$res = StringRegExp($line, '(?:[^",]+|"[^"]*")++', 3)
		_Log("$res = " & $res)
		If UBound($res) = 0 Then ExitScript("UBound($res) = 0")
		$FPsoftVer = $res[0]
		$FPchecksum = $res[1]
		$FPswitches = $res[2]
		$FPcountryCode = $res[3]
		$FPserial = $res[4]
		$FPfiscN = $res[5]
		_Log("$FPsoftVer = " & $FPsoftVer)
		_Log("$FPchecksum = " & $FPchecksum)
		_Log("$FPswitches = " & $FPswitches)
		_Log("$FPcountryCode = " & $FPcountryCode)
		_Log("$FPserial = " & $FPserial)
		_Log("$FPfiscN = " & $FPfiscN)
	EndIf
	_LogFuncF("GetDiagInfo()")
EndFunc   ;==>GetDiagInfo

Func Init()
	_LogFuncS("Init()")
	InitConsts()
	Opt("MouseCoordMode", 2)
	Opt("PixelCoordMode", 2)
	;WinSetOnTop($CommandExecWinName, "", 1)
	InitCounters()
	LoadOptions()
	DisableCMDclose()
	_LogFuncF("Init()")
EndFunc   ;==>Init

Func InitConsts()
	_LogFuncS("InitConsts()")
	$Pass = "0000"
	$DialogOpenWinName = "[CLASS:#32770]"
	$DialogPassWinName = "[CLASS:TPwdDialog]"
	$CommandExecWinName = "Execute a command"
	$LogSpaceSymbol1 = " "
	$LogSpaceSymbol2 = " "
	$ShowInfoEnebled = 0
	$ShowInfoDelay = 0 ;сек
	$GlobalDelay = 50 ;мс
	$TIME1_shift = 2
	$TIME2_shift = 6
	$TIME3_shift = 4
	$MaxOpenFileTry = 3
	$MainWindowName = "Fiscal printer FPU-550 test"
	$SafeModeFlag = 0
	$Loging = 0
	_LogFuncF("InitConsts()")
EndFunc   ;==>InitConsts

Func InitCounters()
	_LogFuncS("InitCounters()")
	$A = "0.00"
	$B = "0.00"
	$V = "0.00"
	$G = "0.00"
	$D = "0.00"
	$A_r = "0.00"
	$B_r = "0.00"
	$V_r = "0.00"
	$G_r = "0.00"
	$D_r = "0.00"
	$GOTIVKA_r = "0.00"
	$CARD_r = "0.00"
	$CREDIT_r = "0.00"
	$CHECK_r = "0.00"
	$GOTIVKA = "0.00"
	$CARD = "0.00"
	$CREDIT = "0.00"
	$CHECK = "0.00"
	$TIME1 = "00-00-00 00:00:00"
	$TIME2 = "00-00-00 00:00:00"
	$TIME3 = "00-00-00 00:00:00"
	$VNOS = "0.00"
	$VNOS2 = "0.00"
	$VUNOS = "0.00"
	$VUNOS2 = "0.00"
	$VUNOS3 = "0.00"
	$VUNOS4 = "0.00"
	_LogFuncF("InitCounters()")
EndFunc   ;==>InitCounters

Func LoadDataFromFile($OldMode = 0)
	_LogFuncS("LoadDataFromFile(" & $OldMode & ")")
	If $OldMode Then
		If $arr[0] <> "" Then sprintf($A, "%1.2f", Number($arr[0]) + Number($arr[1]))
		If $arr[2] <> "" Then $B = $arr[2]
		If $arr[3] <> "" Then $V = $arr[3]
		If $arr[4] <> "" Then $G = $arr[4]
		If $arr[5] <> "" Then $D = $arr[5]
		If $arr[6] <> "" Then $A_r = $arr[6]
		If $arr[7] <> "" Then $B_r = $arr[7]
		If $arr[8] <> "" Then $V_r = $arr[8]
		If $arr[9] <> "" Then $G_r = $arr[9]
		If $arr[10] <> "" Then $D_r = $arr[10]
	Else
		If $arr[0] <> "" Then $A = $arr[0]
		If $arr[1] <> "" Then $B = $arr[1]
		If $arr[2] <> "" Then $V = $arr[2]
		If $arr[3] <> "" Then $G = $arr[3]
		If $arr[4] <> "" Then $D = $arr[4]
		If $arr[5] <> "" Then $A_r = $arr[5]
		If $arr[6] <> "" Then $B_r = $arr[6]
		If $arr[7] <> "" Then $V_r = $arr[7]
		If $arr[8] <> "" Then $G_r = $arr[8]
		If $arr[9] <> "" Then $D_r = $arr[9]
		If $arr[10] <> "" Then $GOTIVKA = $arr[10]
		If $arr[11] <> "" Then $CARD = $arr[11]
		If $arr[12] <> "" Then $CREDIT = $arr[12]
		If $arr[13] <> "" Then $CHECK = $arr[13]
		If $arr[14] <> "" Then $GOTIVKA_r = $arr[14]
		If $arr[15] <> "" Then $CARD_r = $arr[15]
		If $arr[16] <> "" Then $CREDIT_r = $arr[16]
		If $arr[17] <> "" Then $CHECK_r = $arr[17]
		If $arr[18] <> "" Then $VNOS = $arr[18]
		If $arr[19] <> "" Then $TIME1 = $arr[19]
		If $arr[20] <> "" Then $TIME2 = $arr[20]
		If $arr[21] <> "" Then $VUNOS = $arr[21]
		If $arr[22] <> "" Then $VUNOS2 = $arr[22]
		If $arr[23] <> "" Then $VNOS2 = $arr[23]
		If $arr[24] <> "" Then $VUNOS3 = $arr[24]
		If $arr[25] <> "" Then $TIME3 = $arr[25]
		If $arr[26] <> "" Then $VUNOS4 = $arr[26]
		If $arr[27] <> "" Then $HFfilename = $arr[27]
	EndIf
	_Log( _
			"  " & _
			"$A = " & $A & _
			"$B = " & $B & _
			"$V = " & $V & _
			"$G = " & $G & _
			"$D = " & $D & _
			"$A_r = " & $A_r & _
			"$B_r = " & $B_r & _
			"$V_r = " & $V_r & _
			"$G_r = " & $G_r & _
			"$D_r = " & $D_r & _
			"$GOTIVKA = " & $GOTIVKA & _
			"$CARD = " & $CARD & _
			"$CREDIT = " & $CREDIT & _
			"$CHECK = " & $CHECK & _
			"$GOTIVKA_r = " & $GOTIVKA_r & _
			"$CARD_r = " & $CARD_r & _
			"$CREDIT_r = " & $CREDIT_r & _
			"$CHECK_r = " & $CHECK_r & _
			"$VNOS = " & $VNOS & _
			"$TIME1 = " & $TIME1 & _
			"$TIME2 = " & $TIME2 & _
			"$VUNOS = " & $VUNOS & _
			"$VUNOS2 = " & $VUNOS2 & _
			"$VNOS2 = " & $VNOS2 & _
			"$VUNOS3 = " & $VUNOS3 & _
			"$TIME3 = " & $TIME3 & _
			"$VUNOS4 = " & $VUNOS4 _
			)
	_LogFuncF("LoadDataFromFile()")
EndFunc   ;==>LoadDataFromFile

Func LoadDataFromFileOld()
	_LogFuncS("LoadDataFromFileOld()")
	LoadDataFromFile(1)
	_LogFuncF("LoadDataFromFileOld()")
EndFunc   ;==>LoadDataFromFileOld

Func LoadOptions()
	Local $p0 = "", $p1 = "", $p2 = "", $p3 = ""
	_LogFuncS("LoadOptions()")
	$ParamCount = $CmdLine[0]
	_Log("$ParamCount = " & $ParamCount)
	If $ParamCount = 0 Then
		_LogFuncF("LoadOptions()")
		Return
	EndIf
	For $i = 1 To $ParamCount
		$p = $CmdLine[$i]
		$len = StringLen($p)
		_Log("$len = " & $len)
		;DebugMsg($p)
		If $len > 0 Then $p0 = StringLeft($p, 1)
		If $len > 1 Then $p1 = StringRight(StringLeft($p, 2), 1)
		If $len > 2 Then $p2 = StringRight(StringLeft($p, 3), 1)
		If $len > 3 Then $p3 = StringRight(StringLeft($p, 4), 1)
		_Log("$i = " & $i & " $p = " & $p & "  $p0 = " & $p0 & ", $p1 = " & $p1 & ",$p2 = " & $p2 & ",$p3 = " & $p3)
		;_ArrayDisplay($p)
		If $p0 = '-' Then
			Select
				Case $len = 2 And $p1 = 'i'
					$ShowInfoEnebled = 1
				Case $len = 2 And $p1 = 'h'
					ShowHelpInfo()
					ExitScript("$len = 2 And $p1 = 'h'")
				Case $len = 2 And $p1 = 's'
					$SafeModeFlag = 1
				Case $len > 3 And $p1 = 'f' And $p2 = '='
					$res = StringTrimLeft($p, 3)
					$initFN = $res
					_Log("$initFN = " & $initFN)
				Case $len > 3 And $p1 = 'd' And $p2 = '='
					$res = StringTrimLeft($p, 3)
					If IsInt(Number($res)) And $res >= 0 Then
						$ShowInfoDelay = $res
						_Log("$ShowInfoDelay = " & $ShowInfoDelay)
					EndIf
				Case $len > 4 And $p1 = 't' And $p2 = '1' And $p3 = '='
					$res = StringTrimLeft($p, 4)
					_Log("$res = " & $res)
					If IsInt(Number($res)) And $res >= 0 Then
						$TIME1_shift = $res
						_Log("$TIME1_shift = " & $TIME1_shift)
					EndIf
				Case $len > 4 And $p1 = 't' And $p2 = '2' And $p3 = '='
					$res = StringTrimLeft($p, 4)
					_Log("$res = " & $res)
					If IsInt(Number($res)) And $res >= 0 Then
						$TIME2_shift = $res
						_Log("$TIME2_shift = " & $TIME2_shift)
					EndIf
				Case $len = 2 And $p1 = 'l'
					$Loging = 1
					_Log("$Loging = " & $Loging)
			EndSelect
		EndIf
	Next
	_LogFuncF("LoadOptions()")
EndFunc   ;==>LoadOptions

Func MakeReturns($OFmode = 0, $artshift = 0)
	;пробить чек возврата
	_LogFuncS("MakeReturns(" & $OFmode & ")")
	$HeadStr = "чек возврата"
	If $OFmode Then
		$s = $SalesAll_r
	Else
		$s = "К выплате: " & $SalesAll_r
		$s &= @CRLF & "---------"
		$s = "Готівка = " & $GOTIVKA_r
		$s &= @CRLF & "Картка = " & $CARD_r
		$s &= @CRLF & "Кредит = " & $CREDIT_r
		$s &= @CRLF & "Чек = " & $CHECK_r
	EndIf
	If $SalesAll_r <> "0.00" And ShowInfo($HeadStr, $s, "выполнить?", 0x1001) <> 2 Then
		OpenReturn()
		If $A_r <> "0.00" Then SellArt($artshift + 6)
		If $B_r <> "0.00" Then SellArt($artshift + 7)
		If $V_r <> "0.00" Then SellArt($artshift + 8)
		If $G_r <> "0.00" Then SellArt($artshift + 9)
		If $D_r <> "0.00" Then SellArt($artshift + 10)
		If $OFmode Then
			Total()
		Else
			If $GOTIVKA_r <> "0.00" Then Total($GOTIVKA_r, "P")
			If $CARD_r <> "0.00" Then Total($CARD_r, "D")
			If $CREDIT_r <> "0.00" Then Total($CREDIT_r, "N")
			If $CHECK_r <> "0.00" Then Total($CHECK_r, "C")
		EndIf
		CloseFisc()
	EndIf
	_LogFuncF("MakeReturns()")
EndFunc   ;==>MakeReturns

Func MakeReturnsOF()
	_LogFuncS("MakeReturnsOF(")
	MakeReturns(1)
	_LogFuncF("MakeReturnsOF()")
EndFunc   ;==>MakeReturnsOF

Func MakeSales($OFmode = 0, $artshift = 0)
	;пробить чек
	_LogFuncS("MakeSales(" & $OFmode & ")")
	$HeadStr = "чек"
	If $OFmode Then
		$s = $SalesAll
	Else
		$s = "К оплате: " & $SalesAll
		$s &= @CRLF & "---------"
		$s &= @CRLF & "Готівка = " & $GOTIVKA
		$s &= @CRLF & "Картка = " & $CARD
		$s &= @CRLF & "Кредит = " & $CREDIT
		$s &= @CRLF & "Чек = " & $CHECK
	EndIf
	If $SalesAll <> "0.00" And ShowInfo($HeadStr, $s, "выполнить?", 0x1001) <> 2 Then
		OpenFisc()
		If $A <> "0.00" Then SellArt($artshift + 1)
		If $B <> "0.00" Then SellArt($artshift + 2)
		If $V <> "0.00" Then SellArt($artshift + 3)
		If $G <> "0.00" Then SellArt($artshift + 4)
		If $D <> "0.00" Then SellArt($artshift + 5)
		If $OFmode Then
			Total()
		Else
			If $GOTIVKA <> "0.00" Then Total($GOTIVKA, "P")
			If $CARD <> "0.00" Then Total($CARD, "D")
			If $CREDIT <> "0.00" Then Total($CREDIT, "N")
			If $CHECK <> "0.00" Then Total($CHECK, "C")
		EndIf
		CloseFisc()
	EndIf
	_LogFuncF("MakeSales()")
EndFunc   ;==>MakeSales

Func MakeSalesOF()
	_LogFuncS("MakeSalesOF()")
	MakeSales(1)
	_LogFuncF("MakeSalesOF()")
EndFunc   ;==>MakeSalesOF

Func MakeZero()
	;Нулевые чеки
	_LogFuncS("startign MakeZero()")
	$HeadStr = "Нулевой чек"
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then
		ZeroCheck()
		ZeroCheck()
	EndIf
	_LogFuncF("MakeZero()")
EndFunc   ;==>MakeZero

Func OpenFileArt(ByRef $ar, $offs = 1001)
	Local $file, $s, $res, $var, $line, $FN = "", $DataFN = ""
	_LogFuncS("OpenFileArt($ar," & $offs & ")")
	If $FileListCount = 0 Then
		InitCounters()
		$message = "Открыть"
		$HeadStr = "Файл данных"
		If $initFN <> "" Then
			$FN = $initFN
			$initFN = ""
		EndIf
		If $FN = "" Then
			$i = 0
			Do
				If $i = $MaxOpenFileTry Then
					_LogFuncF("OpenFileArt() = 0")
					Return 0
				EndIf
				$FN = FileOpenDialog($message, $filedir, "Articles (*.art)", 1 + 4)
				_Log("$FN = " & $FN)
				$i += 1
			Until Not @error
		EndIf
		;DebugMsg($FN)
		$var = StringReplace($FN, "|", ",")
		$res = StringRegExp($var, '(?:[^",]+|"[^"]*")++', 3)
		If @error Then
			_LogFuncF("OpenFileArt() = 0")
			Return 0
		EndIf
		;DebugMsg($res[0])
		$FileListCount = UBound($res) - 1
		;DebugMsg("$FileListCount = " & $FileListCount)
		;DebugMsg("$FileListCount = " & $FileListCount)
		If $FileListCount = 0 Then
			$FileListCount = 1
			$FileList[0] = $res[0]
			$s = $FileList[0]
		Else
			$s = ""
			For $i = 0 To $FileListCount - 1 Step 1
				$FileList[$i] = $res[0] & "\" & $res[$i + 1]
				$s = $FileList[$i] & @CRLF & $s
			Next
			_Quicksort($FileList, 0, $FileListCount, 1)
		EndIf
		;DebugMsg($s)
	EndIf
	_Log("$FileListCount = " & $FileListCount)
	$DataFN = $FileList[$FileListCount - 1]
	_Log("$DataFN = " & $DataFN)
	$HeadStr = "Открыть файл"
	If ShowInfo($HeadStr, $DataFN, "выполнить?", 0x1001) = 2 Then
		_LogFuncF("OpenFileArt() = 0")
		Return 0
	EndIf
	$file = FileOpen($DataFN, 0)
	If @error Then
		_LogFuncF("OpenFileArt() = 0")
		Return 0
	EndIf
	; Read in lines of text until the EOF is reached
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		;MsgBox(0, "Line read:", $line)
		$res = StringRegExp($line, '(?:[^",]+|"[^"]*")++', 3)
		If UBound($res) = 0 Then ContinueLoop
		;DebugMsg(Int($res[0]) & @CRLF & $res[2])
		$num = Int($res[0]) - $offs
		If $num >= 0 And $num < 30 Then
			If StringLeft($res[2], 1) == '"' Then
				$ar[$num] = StringTrimRight(StringTrimLeft($res[2], 1), 1)
			Else
				$ar[$num] = $res[2]
			EndIf
		EndIf
	WEnd
	FileClose($file)
	$FileListCount -= 1
	_LogFuncF("OpenFileArt() = 1")
	Return 1
EndFunc   ;==>OpenFileArt

Func PR($n1, $n2)
	;периодический отчет
	_LogFuncS("PR(" & $n1 & "," & $n2 & ")")
	$HeadStr = "Периодический отчет по номеру от " & $n1 & " до " & $n2
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then PRbyNum($n1, $n2)
	_LogFuncF("PR()")
EndFunc   ;==>PR

Func PRd($d1, $d2)
	;периодический отчет
	_LogFuncS("PRd(" & $d1 & "," & $d2 & ")")
	$HeadStr = "Периодический отчет по номеру от " & $d1 & " до " & $d2
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then PRbyDate($d1, $d2)
	_LogFuncF("PRd()")
EndFunc   ;==>PRd

Func PrepairDate($t)
	_LogFuncS("PrepairDate(" & $t & ")")
	$HeadStr = "Перевод даты в обычном режиме"
	If $t <> "" And ShowInfo($HeadStr, $t, "выполнить?", 0x1001) <> 2 Then
		$date = StringTrimRight($t, 9)
		$ddest = StringTrimRight($date, 6)
		If $ddest < 1 Or $ddest > 31 Then ExitScript("$ddest < 1 Or $ddest > 31")
		$mdest = StringTrimRight(StringTrimLeft($date, 3), 3)
		If $mdest < 1 Or $mdest > 12 Then ExitScript("$mdest < 1 Or $mdest > 12")
		$ydest = StringTrimLeft($date, 6)
		If $ydest < 0 Or $ydest > 99 Then ExitScript("$ydest < 0 Or $ydest > 99")
		Do
			$date = StringTrimRight(GetTime(), 9)
			$dsorce = StringTrimRight($date, 6)
			If $dsorce < 1 Or $dsorce > 31 Then ExitScript("$dsorce < 1 Or $dsorce > 31")
			$msorce = StringTrimRight(StringTrimLeft($date, 3), 3)
			If $msorce < 1 Or $msorce > 12 Then ExitScript("$msorce < 1 Or $msorce > 12")
			$ysorce = StringTrimLeft($date, 6)
			If $ysorce < 0 Or $ysorce > 99 Then ExitScript("$ysorce < 0 Or $ysorce > 99")
			$daycout = 365 * ($ydest - $ysorce) + 31 * ($mdest - $msorce) + $ddest - $dsorce
			$rewindtime = $date & " 23:59:59"
			If $daycout > 0 Then
				SetTimeMajor($rewindtime)
				Sleep(1000)
			Else
				ExitLoop
			EndIf
		Until False
	EndIf
	_LogFuncF("PrepairDate()")
EndFunc   ;==>PrepairDate

Func SendArt($artshift = 0)
	;запись артикулов
	_LogFuncS("SendArt()")
	$HeadStr = "Запись артикулов"
	$s = "Оборот A = " & $A
	$s &= @CRLF & "Оборот Б = " & $B
	$s &= @CRLF & "Оборот В = " & $V
	$s &= @CRLF & "Оборот Г = " & $G
	$s &= @CRLF & "Оборот Д = " & $D
	$s &= @CRLF & "Возврат A = " & $A_r
	$s &= @CRLF & "Возврат Б = " & $B_r
	$s &= @CRLF & "Возврат В = " & $V_r
	$s &= @CRLF & "Возврат Г = " & $G_r
	$s &= @CRLF & "Возврат Д = " & $D_r
	If ShowInfo($HeadStr, $s, "выполнить?", 0x1001) <> 2 Then
		If $A <> "0.00" Then SetArt($artshift + 1, "А", $A, "А")
		If $B <> "0.00" Then SetArt($artshift + 2, "Б", $B, "Б")
		If $V <> "0.00" Then SetArt($artshift + 3, "В", $V, "В")
		If $G <> "0.00" Then SetArt($artshift + 4, "Г", $G, "Г")
		If $D <> "0.00" Then SetArt($artshift + 5, "Д", $D, "Д")
		If $A_r <> "0.00" Then SetArt($artshift + 6, "А возврат", $A_r, "А")
		If $B_r <> "0.00" Then SetArt($artshift + 7, "Б возврат", $B_r, "Б")
		If $V_r <> "0.00" Then SetArt($artshift + 8, "В возврат", $V_r, "В")
		If $G_r <> "0.00" Then SetArt($artshift + 9, "Г возврат", $G_r, "Г")
		If $D_r <> "0.00" Then SetArt($artshift + 10, "Д возврат", $D_r, "Д")
	EndIf
	_LogFuncF("SendArt()")
EndFunc   ;==>SendArt

Func ServInMajor($A)
	;внос
	_LogFuncS("ServInMajor(" & $A & ")")
	$HeadStr = "Внос"
	If ShowInfo($HeadStr, $A, "выполнить?", 0x1001) <> 2 Then ServIn($A)
	_LogFuncF("ServInMajor()")
EndFunc   ;==>ServInMajor

Func ServOutMajor($A)
	;вынос
	_LogFuncS("ServOutMajor(" & $A & ")")
	$HeadStr = "Вынос"
	If ShowInfo($HeadStr, $A, "выполнить?", 0x1001) <> 2 Then ServOut($A)
	_LogFuncF("ServOutMajor()")
EndFunc   ;==>ServOutMajor

Func SetRandTimeMajor($D, $t1, $t2, $dt = 0)
	_LogFuncS("SetRandTimeMajor(" & $D & "," & $t1 & "," & $t2 & "," & $dt & ")")
	; установка времени
	$HeadStr = "Установка времени"
	If $t1 <> "" And $t2 <> "" And $D <> "" And ShowInfo($HeadStr, $D & " " & $t1 & " " & $t2, "выполнить?", 0x1001) <> 2 Then
		SetRandTime($D, $t1, $t2, $dt)
	EndIf
	_LogFuncF("SetRandTimeMajor()")
EndFunc   ;==>SetRandTimeMajor

Func SetTimeMajor($t, $dt = 0)
	_LogFuncS("SetTimeMajor(" & $t & "," & $dt & ")")
	; установка времени
	$HeadStr = "Установка времени"
	If $t <> "" And ShowInfo($HeadStr, $t, "выполнить?", 0x1001) <> 2 Then SetTimeStrS($t, $dt)
	_LogFuncF("SetTimeMajor()")
EndFunc   ;==>SetTimeMajor

Func ShowHelpInfo()
	_LogFuncS("ShowHelpInfo()")
	ConsoleWrite(@CRLF)
	ConsoleWrite("Help info" & @CRLF)
	ConsoleWrite("---" & @CRLF)
	ConsoleWrite("overflow.exe [<KEY>=<PARAM> <KEY>=<PARAM> ... ]" & @CRLF)
	ConsoleWrite("KEY:" & @CRLF)
	ConsoleWrite("-h this Help" & @CRLF)
	ConsoleWrite("-l disable logging info to console" & @CRLF)
	ConsoleWrite("-d=<DELAY> info dialogs autoclose delay (0 - no close)" & @CRLF)
	ConsoleWrite("-f=<FILE NAME> load file(s)" & @CRLF)
	ConsoleWrite("-i enables showing info dialogs" & @CRLF)
	ConsoleWrite("-t[1|2]=<TIME> time shift in secs" & @CRLF)
	ConsoleWrite("-s safe mode work, pops TestFP dialog while working" & @CRLF)
	ConsoleWrite(@CRLF)
	_LogFuncF("ShowHelpInfo()")
EndFunc   ;==>ShowHelpInfo

Func ShowInfo($H, $msg = "", $msg2 = "", $mode = -1, $timeout = $ShowInfoDelay)
	_LogFuncS("ShowInfo(" & $H & "," & $msg & "," & $msg2 & "," & $mode & "," & $timeout & ")")
	$res = ""
	If $ShowInfoEnebled = 1 Then
		$res = DebugMsg($H & @CRLF & $msg & @CRLF & $msg2, $mode, $timeout)
		;WaitForW ($CommandExecWinName)
		_LogFuncF("ShowInfo()=" & $res)
		Return $res
	EndIf
	_LogFuncF("ShowInfo()")
EndFunc   ;==>ShowInfo

Func WriteHF()
	Dim $HFmas[8] = ["", "", "", "", "", "", "", ""]
	_LogFuncS("WriteHF()")
	;#cs
	$HeadStr = "Записать тек. шапку"
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then
		$counter = ""
		If $HFfilename == "" Then $HFfilename = StringTrimLeft($FPserial, 3) & ".FPH"
		$file = FileOpen($HFfilename, 0)

		If $file = -1 Then
			_Log("File does not exist")
			_LogFuncF("WriteHF()")
			Return
		EndIf
		Do
			$wr = FileReadLine($file)
			If @error == -1 Then ExitLoop
			$row = StringLeft($wr, 1)
			$txt = StringTrimLeft($wr, 2)
			If $row >= 0 And $row <= 7 Then $HFmas[$row] = $txt
			;HFwriteln($txt, $row)
		Until 0
		For $i = 0 To 7
			HFwriteln($HFmas[$i], $i)
		Next
		FileClose($file)
	EndIf
	;#ce
	_LogFuncF("WriteHF()")
EndFunc   ;==>WriteHF

Func XMajor()
	_LogFuncS("XMajor()")
	;X-отчет
	$HeadStr = "X-отчет"
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then DoX()
	_LogFuncF("XMajor()")
EndFunc   ;==>XMajor

Func ZMajor()
	;Z-отчет
	_LogFuncS("ZMajor()")
	$HeadStr = "Z-отчет"
	If ShowInfo($HeadStr, "", "выполнить?", 0x1001) <> 2 Then DoZ()
	_LogFuncF("ZMajor()")
EndFunc   ;==>ZMajor
