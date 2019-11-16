; Program Description: Parses 
; Author: Evan S. Hunt
; Date: 11/05/19

INCLUDE Irvine32.inc

.386

.model flat,stdcall

.stack 4096

ExitProcess PROTO, dwExitCode:DWORD

.data
	menu_Bar		BYTE    "===============================", 0
	menu_Msg1		BYTE	"1. x AND y", 0
	menu_Msg2		BYTE	"2. x OR y", 0
	menu_Msg3		BYTE	"3. NOT x", 0
	menu_Msg4		BYTE	"4. x XOR y", 0
	menu_Msg5		BYTE	"5. Exit Program", 0
	
	AND_Msg			BYTE    "AND OPERATION", 0
	OR_Msg			BYTE    "OR  OPERATION", 0
	NOT_Msg			BYTE    "NOT OPERATION", 0
	XOR_Msg			BYTE    "XOR OPERATION", 0
	hex_Prompt_Msg  BYTE	"Enter hexidecimal integer operand: ", 0
	
	error_Msg		BYTE	"Error: Invalid Input(s).", 0

.code
main PROC; Start of Main
	
	Clear_Screen:; Clears screen

		call	Clrscr

		jmp		Initialize

	Initialize:; Initializer
		
		mov		eax, 0;	Using eax as character register

		jmp		Parse

	Parse:; Parsing Controller
		
		call	Display_Main_Menu

		call	Selection

		call	Is_Quit_Key?
		je		Quit

		call	Is_AND?
		je		AND_Menu

		call	Is_OR?
		je		OR_Menu

		call	Is_NOT?
		je		NOT_Menu
		
		call	Is_XOR?
		je		XOR_Menu

		jmp		Error_Invalid_Input

	AND_Menu:; AND operator
		
		call	AND_op

		jmp		Parse

	OR_Menu:; OR operator
		
		call    OR_op

		jmp Parse

	NOT_Menu:; NOT operator
		
		call	NOT_op	

		jmp		Parse

	XOR_Menu:; XOR operator

		call	XOR_op	

		jmp		Parse

	Error_Invalid_Input:; Diplays Invalid Input(s) Error Message

		call	Write_Error_Msg

		jmp		Parse

	Quit:; Quits Program

		call	Crlf
		INVOKE	ExitProcess, 0

main ENDP; End of Main
	
	Display_Main_Menu PROC USES edx
	;	Displays the menu
	;	Recieves:	nothing
	;	Returns:	nothing
		call	Crlf
		mov		edx, OFFSET menu_Bar
		call	WriteString
		call	Crlf
		mov		edx, OFFSET menu_Msg1
		call	WriteString
		call	Crlf
		mov		edx, OFFSET menu_Msg2
		call	WriteString
		call	Crlf
		mov		edx, OFFSET menu_Msg3
		call	WriteString
		call	Crlf
		mov		edx, OFFSET menu_Msg4
		call	WriteString
		call	Crlf		
		mov		edx, OFFSET menu_Msg5
		call	WriteString
		call	Crlf
		mov		edx, OFFSET menu_Bar
		call	WriteString
		call	Crlf
		call	Crlf
		ret
	Display_Main_Menu ENDP
	
	Hex_Prompt PROC USES edx
	;	Prompts the user for a hexidecimal integer
	;	Recieves:	nothing
	;	Returns:	nothing
		mov		edx, OFFSET hex_Prompt_Msg
		call    Crlf
		call	WriteString
		call	Crlf
		ret
	Hex_Prompt ENDP

	Display_Selection PROC
	;	Displays the chosen operation
	;	Recieves:	edx
	;	Returns:	nothing
		call	Crlf
		call	WriteString
		call	Crlf 
		ret
	Display_Selection ENDP

	Display_Hex_Result PROC
	;	Displays the result in hexidecimal
	;	Recieves:	nothing
	;	Returns:	nothing
		call	Crlf
		call	WriteHex
		ret
	Display_Hex_Result ENDP
		
	Selection PROC
	;	Gets next int from console
	;	Recieves:	Nothing
	;	Returns:	AL, an int
		call	ReadChar
		ret
	Selection ENDP
	
	Next_Hex PROC
	;	Gets next hexidecimal number from console
	;	Recieves:	Nothing
	;	Returns:	AL, a character
		call	ReadHex
		ret
	Next_Hex ENDP
	
	Is_Enter_Key? PROC
	;	Compares AL to EnterKey ASCII value (13)
	;	Recieves:	AL = a character
	;	Returns:	ZF = 1
		cmp		al, 13	
		ret
	Is_Enter_Key? ENDP	
	
	Is_Quit_Key? PROC
	;	Compares AL to 5
	;	Recieves:	AL = a character
	;	Returns:	ZF = 1
		cmp		al, 53	
		ret
	Is_Quit_Key? ENDP	

	Is_AND? PROC
	;	Compares AL to 1
	;	Recieves:	AL = a character
	;	Returns:	ZF = 1
		cmp		al, 49	
		ret
	Is_AND? ENDP	

	AND_op PROC USES edx eax
	;	Prompts User for hexidecimalinput and's the inputs, then outputs the result
	;	Recieves:   edx
	;	Returns:	nothing
		mov     edx, OFFSET AND_Msg
		call 	Display_Selection	
		call	Hex_Prompt
		call	Next_Hex
		mov		edx, eax
		call	Hex_Prompt	
		call	Next_Hex
		and		eax, edx
		call	Display_Hex_Result
		ret
	AND_op ENDP
	
	Is_OR? PROC
	;	Compares AL to 2
	;	Recieves:	AL = a character
	;	Returns:	ZF = 1
		cmp		al, 50	
		ret
	Is_OR? ENDP	
	
	OR_op PROC
	;	Prompts User for hexidecimal input or's the inputs, then outputs the result
	;	Recieves:   edx
	;	Returns:	nothing
		mov     edx, OFFSET OR_Msg
		call 	Display_Selection	
		call	Hex_Prompt
		call	Next_Hex
		mov		edx, eax
		call	Hex_Prompt	
		call	Next_Hex
		or		eax, edx
		call	Display_Hex_Result
		ret
	OR_op ENDP

	Is_NOT? PROC
	;	Compares AL to 3
	;	Recieves:	AL = a character
	;	Returns:	ZF = 1
		cmp		al, 51	
		ret
	Is_NOT? ENDP

	NOT_op PROC
	;	Prompts User for hexidecimal input inverts the input, then outputs the result
	;	Recieves:   edx
	;	Returns:	nothing
		mov     edx, OFFSET NOT_Msg
		call 	Display_Selection	
		call	Hex_Prompt
		call	Next_Hex
		not		eax
		call	Display_Hex_Result
		ret
	NOT_op ENDP
	
	Is_XOR? PROC
	;	Compares AL to 4
	;	Recieves:	AL = a character
	;	Returns:	ZF = 1
		cmp		al, 52
		ret
	Is_XOR? ENDP

	XOR_op PROC
	;	Prompts User for hexidecimal input xor's the inputs, then outputs the result
	;	Recieves:   edx
	;	Returns:	nothing
		mov     edx, OFFSET XOR_Msg
		call 	Display_Selection	
		call	Hex_Prompt
		call	Next_Hex
		mov		edx, eax
		call	Hex_Prompt	
		call	Next_Hex
		xor		eax, edx
		call	Display_Hex_Result
		ret
	XOR_op ENDP

	Write_Error_Msg PROC USES edx
	;	Outputs error message
	;	Recieves:   nothing
	;	Returns:	nothing
		mov		edx, OFFSET error_Msg
		call	Crlf
		call	WriteString
		call	Crlf
		ret
	Write_Error_Msg ENDP

END main; End of Program