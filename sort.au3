#include-once
Func __qs_stk_pop(ByRef $stk, ByRef $ls)
	If $ls = 0 Then
		SetError(1)
		Return 0
	EndIf
	$ls = $ls - 1
	Return $stk[$ls]
EndFunc   ;==>__qs_stk_pop

Func __qs_stk_push($value, ByRef $stk, ByRef $ls)
	$stk[$ls] = $value
	$ls = $ls + 1
EndFunc   ;==>__qs_stk_push

Func __qs_swap(ByRef $st, ByRef $nd)
	Local $t = $nd
	$nd = $st
	$st = $t
EndFunc   ;==>__qs_swap

Func _Quicksort(ByRef $A, $p, $r, $dir = 0)
	;http://www.google.com.ua/url?sa=t&rct=j&q=autoit+quicksort+%D0%B2+%D0%BC%D0%B0%D1%81%D1%81%D0%B8%D0%B2%D0%B5&source=web&cd=2&ved=0CC4QFjAB&url=http%3A%2F%2Fwww.autoitscript.com%2Fforum%2Ftopic%2F11480-recursionless-quicksort%2F&ei=cCoyT6PjO-So4gSDy-mgBQ&usg=AFQjCNHrN8XEUpuFgONyhLYeqTnx8QvK0Q&sig2=2X0TknFgDSa0EuNZcN9gTg
	Local $j, $q
	$j = Int(Log($r - $p) / Log(2)) * 2 + 2
	Local $stk[$j], $ls = 0

	While 1
		While $p < $r
			;__qs_swap($a[Random($p, $r, 1) ], $a[$r]);<- Uncomment this if your array is already almost sorted
			$q = $p - 1
			For $j = $p To $r - 1
				If ($dir = 0 And $A[$j] <= $A[$r]) Or ($dir = 1 And $A[$j] >= $A[$r]) Then;<-------------- Edit here if you want change sorting condition
					$q = $q + 1
					__qs_swap($A[$q], $A[$j])
				EndIf
			Next
			$q = $q + 1
			__qs_swap($A[$q], $A[$r])

			If $r - $q > $q - $p Then
				__qs_stk_push($q + 1, $stk, $ls)
				__qs_stk_push($r, $stk, $ls)
				$r = $q - 1
			Else
				__qs_stk_push($p, $stk, $ls)
				__qs_stk_push($q - 1, $stk, $ls)
				$p = $q + 1
			EndIf
		WEnd

		$r = __qs_stk_pop($stk, $ls)
		If @error Then ExitLoop
		$p = __qs_stk_pop($stk, $ls)
	WEnd
EndFunc   ;==>_Quicksort
