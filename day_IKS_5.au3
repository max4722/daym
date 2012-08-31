#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=bin\daym.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#Tidy_Parameters=/sfc
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "consts.au3"
#include "interf.au3"
#include "time.au3"
#include "operations.au3"
#include "cmds.au3"

Init()
$TIME2_shift = 13
GetDiagInfo()
BackupHF()
WriteHF()

While OpenFileArt($arr)
	LoadDataFromFile()
	CheckData()
	SetTimeMajor($TIME1, $TIME1_shift)
	MakeZero()
	If $VNOS <> "0.00" Then ServInMajor($VNOS)
	SendArt()
	MakeSales()
	MakeReturns()
	If $VUNOS = "0.00" Then $TIME2_shift -= 2
	If $VUNOS2 = "0.00" Then $TIME2_shift -= 2
	SetTimeMajor($TIME2, $TIME2_shift)
	If $VUNOS <> "0.00" Then
		XMajor()
		ServOutMajor($VUNOS)
	EndIf
	If $VUNOS2 <> "0.00" Then
		XMajor()
		ServOutMajor($VUNOS2)
	EndIf
	XMajor()
	ZMajor()
WEnd

SetTimeMajor(StringFormat("%02d-%02d-%02d %02d:%02d:%02d", @MDAY, @MON, StringRight(@YEAR, 2), @HOUR, @MIN, 3), 0)
CLearAllArt()
ExitScript()

