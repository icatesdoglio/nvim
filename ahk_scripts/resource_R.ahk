fileName := A_Args[1]
fileName := StrReplace(fileName, "\", "\\")
{
	Send "!{Right}"
	Send "quit(){Enter}n{Enter}"
	Send "R {Enter}"
	Sleep 1000
	Send "source(`"" fileName "`"){Enter}"
	Send "!{Left}"
}
