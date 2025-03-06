fileName := A_Args[1]

{
	Send "!{Right}"
	Send "quit(){Enter}"
	Send "python -i '" fileName "'{Enter}"
	Send "!{Left}"
}
