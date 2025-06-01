fileName := A_Args[1]
fileName := StrReplace(fileName, "\", "\\")
{
	Send "!{Right}"
	Send "q(){Enter}"
	Sleep 500
	Send "R --no-save {Enter}"
	Sleep 1000
	Send "source(`"" fileName "`"){Enter}"
	Send "!{Left}"
}
