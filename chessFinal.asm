%include "/usr/local/share/csc314/asm_io.inc"


; the file that stores the initial state
%define BOARD_FILE 'board.txt'

; how to represent everything
%define BLACK_PAWN 'p'

; the size of the game screen in characters
%define HEIGHT 10
%define WIDTH 18

; these keys do things
%define EXITCHAR 'x'

segment .data

	; used to fopen() the board file defined above
	board_file			db BOARD_FILE,0

	; used to change the terminal mode
	mode_r				db "r",0
	raw_mode_on_cmd		db "stty raw -echo",0
	raw_mode_off_cmd	db "stty -raw echo",0

	; called by system() to clear/refresh the screen
	clear_screen_cmd	db "clear",0

	; things the program will print
	help_str			db 13,10,"Controls: ", \
							"Type quit to end game", \
							13,10,10,0
	last_move_str		db	"Move input: ",0

	; variables to hold the move characters
	move1	db	0
	move2	db	0
	move3	db	0
	move4	db	0

segment .bss

	; this array stores the current rendered gameboard (HxW)
	board	resb	(HEIGHT * WIDTH)

segment .text

	global	asm_main
	global  raw_mode_on
	global  raw_mode_off
	global  init_board
	global  render

	extern	system
	extern	putchar
	extern	getchar
	extern	printf
	extern	fopen
	extern	fread
	extern	fgetc
	extern	fclose

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************

	; put the terminal in raw mode so the game works nicely
	call	raw_mode_on

	; read the game board file into the global variable
	call	init_board

	game_loop:
		; draw the last move display, then the game board
		mov		BYTE[move1], 0
		mov		BYTE[move2], 0
		mov		BYTE[move3], 0
		mov		BYTE[move4], 0
		call	render
		
		; get move from the user
		call	getchar
		mov		BYTE[move1], al
		call	render
		call	getchar
		mov		BYTE[move2], al
		call	render
		call	getchar
		mov		BYTE[move3], al
		call	render
		call	getchar
		mov		BYTE[move4], al
		call	render

		; see if you need to quit
		cmp		BYTE[move1], 'q'
		jne		noQuit
		cmp		BYTE[move2], 'u'
		jne		noQuit
		cmp		BYTE[move3], 'i'
		jne		noQuit
		cmp		BYTE[move4], 't'
		je		game_loop_end
		noQuit:

		; logic for finding first piece
		mov		eax, board
        mov     ebx, eax

		cmp		BYTE[move1], 'A'
		je		move1A
		cmp		BYTE[move1], 'a'
		je		move1A
		cmp		BYTE[move1], 'B'
		je		move1B
		cmp		BYTE[move1], 'b'
		je		move1B
		cmp		BYTE[move1], 'C'
		je		move1C
		cmp		BYTE[move1], 'c'
		je		move1C
		cmp		BYTE[move1], 'D'
		je		move1D
		cmp		BYTE[move1], 'd'
		je		move1D
		cmp		BYTE[move1], 'E'
		je		move1E
		cmp		BYTE[move1], 'e'
		je		move1E
		cmp		BYTE[move1], 'F'
		je		move1F
		cmp		BYTE[move1], 'f'
		je		move1F
		cmp		BYTE[move1], 'G'
		je		move1G
		cmp		BYTE[move1], 'g'
		je		move1G
		cmp		BYTE[move1], 'H'
		je		move1H
		cmp		BYTE[move1], 'h'
		je		move1H
		jmp		invalidMove

		move1A:
			add		eax, 2
			jmp		move2Start
		move1B:
			add		eax, 4
			jmp		move2Start
		move1C:
			add		eax, 6
			jmp		move2Start
		move1D:
			add		eax, 8
			jmp		move2Start
		move1E:
			add		eax, 10
			jmp		move2Start
		move1F:
			add		eax, 12
			jmp		move2Start
		move1G:
			add		eax, 14
			jmp		move2Start
		move1H:
			add		eax, 16
			jmp		move2Start

		move2Start:
		cmp		BYTE[move2], '1'
		je		move2_1
		cmp		BYTE[move2], '2'
		je		move2_2
		cmp		BYTE[move2], '3'
		je		move2_3
		cmp		BYTE[move2], '4'
		je		move2_4
		cmp		BYTE[move2], '5'
		je		move2_5
		cmp		BYTE[move2], '6'
		je		move2_6
		cmp		BYTE[move2], '7'
		je		move2_7
		cmp		BYTE[move2], '8'
		je		move2_8
		jmp		invalidMove

		move2_1:
			add		eax, 0
			jmp		move3Start
		move2_2:
			add		eax, 18
			jmp		move3Start
		move2_3:
			add		eax, 36
			jmp		move3Start
		move2_4:
			add		eax, 54
			jmp		move3Start
		move2_5:
			add		eax, 72
			jmp		move3Start
		move2_6:
			add		eax, 90
			jmp		move3Start
		move2_7:
			add		eax, 108
			jmp		move3Start
		move2_8:
			add		eax, 126
			jmp		move3Start

		; logic for finding second piece
        ;mov     ebx, board
		move3Start:
		cmp		BYTE[move3], 'A'
		je		move3A
		cmp		BYTE[move3], 'a'
		je		move3A
		cmp		BYTE[move3], 'B'
		je		move3B
		cmp		BYTE[move3], 'b'
		je		move3B
		cmp		BYTE[move3], 'C'
		je		move3C
		cmp		BYTE[move3], 'c'
		je		move3C
		cmp		BYTE[move3], 'D'
		je		move3D
		cmp		BYTE[move3], 'd'
		je		move3D
		cmp		BYTE[move3], 'E'
		je		move3E
		cmp		BYTE[move3], 'e'
		je		move3E
		cmp		BYTE[move3], 'F'
		je		move3F
		cmp		BYTE[move3], 'f'
		je		move3F
		cmp		BYTE[move3], 'G'
		je		move3G
		cmp		BYTE[move3], 'g'
		je		move3G
		cmp		BYTE[move3], 'H'
		je		move3H
		cmp		BYTE[move3], 'h'
		je		move3H
		jmp		invalidMove

		move3A:
			add		ebx, 2
			jmp		move4Start
		move3B:
			add		ebx, 4
			jmp		move4Start
		move3C:
			add		ebx, 6
			jmp		move4Start
		move3D:
			add		ebx, 8
			jmp		move4Start
		move3E:
			add		ebx, 10
			jmp		move4Start
		move3F:
			add		ebx, 12
			jmp		move4Start
		move3G:
			add		ebx, 14
			jmp		move4Start
		move3H:
			add		ebx, 16
			jmp		move4Start

        move4Start:
        cmp		BYTE[move4], '1'
		je		move4_1
		cmp		BYTE[move4], '2'
		je		move4_2
		cmp		BYTE[move4], '3'
		je		move4_3
		cmp		BYTE[move4], '4'
		je		move4_4
		cmp		BYTE[move4], '5'
		je		move4_5
		cmp		BYTE[move4], '6'
		je		move4_6
		cmp		BYTE[move4], '7'
		je		move4_7
		cmp		BYTE[move4], '8'
		je		move4_8
		jmp		invalidMove

		move4_1:
			add		ebx, 0
			jmp		endChecking
		move4_2:
			add		ebx, 18
			jmp		endChecking
		move4_3:
			add		ebx, 36
			jmp		endChecking
		move4_4:
			add		ebx, 54
			jmp		endChecking
		move4_5:
			add		ebx, 72
			jmp		endChecking
		move4_6:
			add		ebx, 90
			jmp		endChecking
		move4_7:
			add		ebx, 108
			jmp		endChecking
		move4_8:
			add		ebx, 126
			jmp		endChecking

        endChecking:

        ; Validate if a piece exists in spot eax
		cmp		BYTE[eax], ' '
		je		invalidMove ; piece is a space character, cannot move

        ; see if you are overwriting one of your own pieces
		; this is a very ugly check but it works
		cmp		BYTE[eax], 0x5A
		jg		firstLowercase
		jmp		firstCapital
		firstLowercase:
			cmp		BYTE[ebx], 0x5A
			jg		bothLowercase
			jmp		firstLowerSecondCapital
		firstCapital:
			cmp		BYTE[ebx], 0x5A
			jg		firstCapitalSecondLowercase
			jmp		bothCapital
		bothLowercase:
			jmp		invalidMove
		bothCapital:
			; check if second piece is a space (override 0x20 being capital)
			cmp		BYTE[ebx], 0x20
			je		continueMove
				jmp		invalidMove
			continueMove:
		firstLowerSecondCapital:
		firstCapitalSecondLowercase:

		; check if piece is lowercase pawn
		cmp		BYTE[eax], 'p'
		jne		notLowercaseP
				; check if on home row
				mov		ecx, eax
				sub		ecx, board
				cmp		ecx, 0x6E
				jl		aboveHomeRow

					; make sure not moving more than 2 up
					mov		edx, ebx
					sub		edx, board
					sub		edx, ecx
					cmp		edx, -36
					jl		invalidMove ; invalid, stop move now

						; check if moving diagonal up left
						cmp		edx, -20
						jne		notDiagonalUpLeft
							; make sure there's a piece in that slot
							cmp		BYTE[ebx], ' '
							je		invalidMove		; invalid, stop move now
								; execute move
								mov     cl, BYTE[eax]
								mov     BYTE[ebx], cl
								mov     BYTE[eax], ' '
								jmp		endLowercaseP
						notDiagonalUpLeft:

						; check if moving diagonal up right
						cmp		edx, -16
						jne		notDiagonalUpRight
							; make sure there's a piece in that slot
							cmp		BYTE[ebx], ' '
							je		invalidMove		; invalid, stop move now
								; execute move
								mov     cl, BYTE[eax]
								mov     BYTE[ebx], cl
								mov     BYTE[eax], ' '
								jmp		endLowercaseP
						notDiagonalUpRight:

						; check if moving exactly two up and make sure pieces aren't in either spot
						cmp		edx, -36
						jne		notTwoUp
							; check first piece
							mov		ecx, eax
							sub		ecx, 18 ; offset of first piece now in ecx
							cmp		BYTE[ecx], ' '
							je		spotOneOpen
								jmp		invalidMove
							spotOneOpen:
								sub		ecx, 18 ; offset of second piece now in ecx
								cmp		BYTE[ecx], ' '
								je		spotTwoOpen
									jmp		invalidMove
							spotTwoOpen:
								; execute move
								mov     cl, BYTE[eax]
								mov     BYTE[ebx], cl
								mov     BYTE[eax], ' '
								jmp		endLowercaseP

						notTwoUp:
						
						; check if moving exactly one up and make sure piece is not in front
						cmp		edx, -18
						jne		notOneUp
							; check first piece
							mov		ecx, eax
							sub		ecx, 18 ; offset of first piece now in ecx
							cmp		BYTE[ecx], ' '
							je		spotOneOpen_b
								jmp		invalidMove
							spotOneOpen_b:
								; execute move
								mov     cl, BYTE[eax]
								mov     BYTE[ebx], cl
								mov     BYTE[eax], ' '
								jmp		endLowercaseP
						notOneUp:

					jmp		endLowercaseP

				aboveHomeRow:
					; prevent moving up 2
					; get offset of move
					mov		edx, ebx
					sub		edx, board
					sub		edx, ecx
					cmp		edx, -36
					je		invalidMove ; invalid, stop move now

					; check if moving exactly one up and make sure piece is not in front
					cmp		edx, -18
					jne		notOneUp_b
						; check first piece
						mov		ecx, eax
						sub		ecx, 18 ; offset of first piece now in ecx
						cmp		BYTE[ecx], ' '
						je		spotOneOpen_c
							jmp		invalidMove
						spotOneOpen_c:
							; check if pawn is at end of board
							mov		edx, ebx
							sub		edx, board
							cmp		edx, 18
							jge		pawnNotAtEnd
								; promote pawn to queen
								mov		BYTE[eax], 'q'
								
							pawnNotAtEnd:
							; execute move
							mov     cl, BYTE[eax]
							mov     BYTE[ebx], cl
							mov     BYTE[eax], ' '
							jmp		endLowercaseP
					notOneUp_b:

					; check if moving diagonal up left
					cmp		edx, -20
					jne		notDiagonalUpLeft_b
						; make sure there's a piece in that slot
						cmp		BYTE[ebx], ' '
						je		invalidMove		; invalid, stop move now
							; check if pawn is at end of board
							mov		edx, ebx
							sub		edx, board
							cmp		edx, 18
							jge		pawnNotAtEnd_b
								; promote pawn to queen
								mov		BYTE[eax], 'q'
								
							pawnNotAtEnd_b:
							; execute move
							mov     cl, BYTE[eax]
							mov     BYTE[ebx], cl
							mov     BYTE[eax], ' '
							jmp		endLowercaseP
					notDiagonalUpLeft_b:

					; check if moving diagonal up right
					cmp		edx, -16
					jne		notDiagonalUpRight_b
						; make sure there's a piece in that slot
						cmp		BYTE[ebx], ' '
						je		invalidMove		; invalid, stop move now
							; check if pawn is at end of board
							mov		edx, ebx
							sub		edx, board
							cmp		edx, 18
							jge		pawnNotAtEnd_c
								; promote pawn to queen
								mov		BYTE[eax], 'q'
								
							pawnNotAtEnd_c:
							; execute move
							mov     cl, BYTE[eax]
							mov     BYTE[ebx], cl
							mov     BYTE[eax], ' '
							jmp		endLowercaseP
					notDiagonalUpRight_b:

		endLowercaseP:
			jmp		game_loop
		notLowercaseP:

		; check if piece is capital pawn
		cmp		BYTE[eax], 'P'
		jne		notCapitalP
				; check if on home row
				mov		ecx, eax
				sub		ecx, board
				cmp		ecx, 0x23
				jg		belowHomeRow_cap

					; make sure not moving more than 2 down
					mov		edx, ebx
					sub		edx, board
					sub		edx, ecx
					cmp		edx, 36
					jg		invalidMove ; invalid, stop move now

						; check if moving diagonal down left
						cmp		edx, 16
						jne		notDiagonalDownLeft
							; make sure there's a piece in that slot
							cmp		BYTE[ebx], ' '
							je		invalidMove		; invalid, stop move now
								; execute move
								mov     cl, BYTE[eax]
								mov     BYTE[ebx], cl
								mov     BYTE[eax], ' '
								jmp		endCapitalP
						notDiagonalDownLeft:

						; check if moving diagonal down right
						cmp		edx, 20
						jne		notDiagonalDownRight
							; make sure there's a piece in that slot
							cmp		BYTE[ebx], ' '
							je		invalidMove		; invalid, stop move now
								; execute move
								mov     cl, BYTE[eax]
								mov     BYTE[ebx], cl
								mov     BYTE[eax], ' '
								jmp		endCapitalP
						notDiagonalDownRight:

						; check if moving exactly two down and make sure pieces aren't in either spot
						cmp		edx, 36
						jne		notTwoDown_cap
							; check first piece
							mov		ecx, eax
							add		ecx, 18 ; offset of first piece now in ecx
							cmp		BYTE[ecx], ' '
							je		spotOneOpen_cap
								jmp		invalidMove
							spotOneOpen_cap:
								add		ecx, 18 ; offset of second piece now in ecx
								cmp		BYTE[ecx], ' '
								je		spotTwoOpen_cap
									jmp		invalidMove
							spotTwoOpen_cap:
								; execute move
								mov     cl, BYTE[eax]
								mov     BYTE[ebx], cl
								mov     BYTE[eax], ' '
								jmp		endCapitalP

						notTwoDown_cap:
						
						; check if moving exactly one down and make sure piece is not in front
						cmp		edx, 18
						jne		notOneDown_cap
							; check first piece
							mov		ecx, eax
							add		ecx, 18 ; offset of first piece now in ecx
							cmp		BYTE[ecx], ' '
							je		spotOneOpen_b_cap
								jmp		invalidMove
							spotOneOpen_b_cap:
								; execute move
								mov     cl, BYTE[eax]
								mov     BYTE[ebx], cl
								mov     BYTE[eax], ' '
								jmp		endCapitalP
						notOneDown_cap:

					jmp		endCapitalP

				belowHomeRow_cap:
					; prevent moving down 2
					; get offset of move
					mov		edx, ebx
					sub		edx, board
					sub		edx, ecx
					cmp		edx, 36
					je		invalidMove ; invalid, stop move now

					; check if moving exactly one down and make sure piece is not in front
					cmp		edx, 18
					jne		notOneUp_b_cap
						; check first piece
						mov		ecx, eax
						add		ecx, 18 ; offset of first piece now in ecx
						cmp		BYTE[ecx], ' '
						je		spotOneOpen_c_cap
							jmp		invalidMove
						spotOneOpen_c_cap:
							; check if pawn is at end of board
							mov		edx, ebx
							sub		edx, board
							cmp		edx, 126
							jl		pawnNotAtEnd_cap
								; promote pawn to queen
								mov		BYTE[eax], 'Q'
								
							pawnNotAtEnd_cap:
							; execute move
							mov     cl, BYTE[eax]
							mov     BYTE[ebx], cl
							mov     BYTE[eax], ' '
							jmp		endCapitalP
					notOneUp_b_cap:

					; check if moving diagonal down left
					cmp		edx, 16
					jne		notDiagonalDownLeft_b
						; make sure there's a piece in that slot
						cmp		BYTE[ebx], ' '
						je		invalidMove		; invalid, stop move now
							; check if pawn is at end of board
							mov		edx, ebx
							sub		edx, board
							cmp		edx, 126
							jl		pawnNotAtEnd_b_cap
								; promote pawn to queen
								mov		BYTE[eax], 'Q'
								
							pawnNotAtEnd_b_cap:
							; execute move
							mov     cl, BYTE[eax]
							mov     BYTE[ebx], cl
							mov     BYTE[eax], ' '
							jmp		endCapitalP
					notDiagonalDownLeft_b:


					; check if moving diagonal down right
					cmp		edx, 20
					jne		notDiagonalDownRight_b
						; make sure there's a piece in that slot
						cmp		BYTE[ebx], ' '
						je		invalidMove		; invalid, stop move now
							; check if pawn is at end of board
							mov		edx, ebx
							sub		edx, board
							cmp		edx, 126
							jl		pawnNotAtEnd_c_cap
								; promote pawn to queen
								mov		BYTE[eax], 'Q'
								
							pawnNotAtEnd_c_cap:
							; execute move
							mov     cl, BYTE[eax]
							mov     BYTE[ebx], cl
							mov     BYTE[eax], ' '
							jmp		endCapitalP
					notDiagonalDownRight_b:

		endCapitalP:
			jmp		game_loop
		notCapitalP:

		; check if piece is king
		; case doesn't matter as the moves are synonymous (one any direction)
		cmp		BYTE[eax], 'k'
		jne		notLowercaseKing
		cmp		BYTE[eax], 'k'
		je		isKing
		notLowercaseKing:
		cmp		BYTE[eax], 'K'
		jne		notKing
		isKing:
			; make sure king is moving only one spot in any direction
			mov		ecx, eax
			sub		ecx, board ; offset of original location
			mov		edx, ebx
			sub		edx, board
			sub		edx, ecx	; movement differential
			; define valid moves
			cmp		edx, -20
			je		validKing
			cmp		edx, -18
			je		validKing
			cmp		edx, -16
			je		validKing
			cmp		edx, -2
			je		validKing
			cmp		edx, 2
			je		validKing
			cmp		edx, 16
			je		validKing
			cmp		edx, 18
			je		validKing
			cmp		edx, 20
			je		validKing
			jmp		invalidMove		; move not defined, must be invalid
			validKing:
				; actually move the king
				mov     cl, BYTE[eax]
				mov     BYTE[ebx], cl
				mov     BYTE[eax], ' '
				jmp		endKing

		endKing:
			jmp		game_loop
		notKing:

		; check if piece is rook
		; case doesn't matter as the moves are synonymous
		cmp		BYTE[eax], 'r'
		jne		notLowercaseRook
		cmp		BYTE[eax], 'r'
		je		isRook
		notLowercaseRook:
		cmp		BYTE[eax], 'R'
		jne		notRook
		isRook:
			; check if moving horizontally or vertically
			mov		ecx, eax
			sub		ecx, board ; offset of original location
			mov		edx, ebx
			sub		edx, board
			sub		edx, ecx	; movement differential

			mov		edi, edx	; backup of differential

			mov		esi, 7
			topLoop:
			cmp		esi, 0
			je		endLoop
				add		edx, 18
				cmp		edx, 0
				je		vertical	
			dec 	esi
			jmp		topLoop
			endLoop:

			mov		esi, 7
			mov		edx, edi
			topLoop2:
			cmp		esi, 0
			je		endLoop2
				sub		edx, 18
				cmp		edx, 0
				je		vertical
			dec		esi
			jmp		topLoop2
			endLoop2:

			horizontal:
				; reget the movement differential
				mov		ecx, eax
				sub		ecx, board ; offset of original location
				mov		edx, ebx
				sub		edx, board
				sub		edx, ecx	; movement differential
				cmp		edx, -18
				jl		invalidMove
				cmp		edx, 18
				jg		invalidMove
				
				; check each piece in horizontal path
				mov		edi, edx	; edi now stores the targeted path
				cmp		edi, 0
				jg		movingRight
					; movingLeft
					mov		esi, -2
					mov		edx, eax
					topLoop_b:
					cmp		esi, edi
					je		validPath
						sub		edx, 2
						sub		esi, 2
						cmp		BYTE[edx], ' '
						jne		invalidMove
						jmp		topLoop_b
				movingRight:
					mov		esi, 2
					mov		edx, eax
					topLoop_c:
					cmp		esi, edi
					je		validPath
						add		edx, 2
						add		esi, 2
						cmp		BYTE[edx], ' '
						jne		invalidMove
						jmp		topLoop_c
				validPath:
				; actually move the rook
				mov     cl, BYTE[eax]
				mov     BYTE[ebx], cl
				mov     BYTE[eax], ' '
				jmp		endRook
			vertical:
				; reget the movement differential
				mov		ecx, eax
				sub		ecx, board ; offset of original location
				mov		edx, ebx
				sub		edx, board
				sub		edx, ecx	; movement differential

				; check each piece in vertical path
				mov		edi, edx	; edi now stores the targeted path
				cmp		edi, 0
				jg		movingDown
					; movingUp
					mov		esi, -18
					mov		edx, eax
					topLoop_d:
					cmp		esi, edi
					je		validPath_b
						sub		edx, 18
						sub		esi, 18
						cmp		BYTE[edx], ' '
						jne		invalidMove
						jmp		topLoop_d
				movingDown:
					mov		esi, 18
					mov		edx, eax
					topLoop_e:
					cmp		esi, edi
					je		validPath_b
						add		edx, 18
						add		esi, 18
						cmp		BYTE[edx], ' '
						jne		invalidMove
						jmp		topLoop_e

				validPath_b:
				; actually move the rook
				mov     cl, BYTE[eax]
				mov     BYTE[ebx], cl
				mov     BYTE[eax], ' '
				jmp		endRook
		endRook:
			jmp		game_loop
		notRook:

		; check if piece is knight
		; case doesn't matter as the moves are synonymous
		cmp		BYTE[eax], 'n'
		jne		notLowercaseKnight
		cmp		BYTE[eax], 'n'
		je		isKnight
		notLowercaseKnight:
		cmp		BYTE[eax], 'N'
		jne		notKnight
		isKnight:
			; make sure knight is moving as defined
			mov		ecx, eax
			sub		ecx, board ; offset of original location
			mov		edx, ebx
			sub		edx, board
			sub		edx, ecx	; movement differential
			; define valid moves
			cmp		edx, -38
			je		validKnight
			cmp		edx, -34
			je		validKnight
			cmp		edx, -22
			je		validKnight
			cmp		edx, -14
			je		validKnight
			cmp		edx, 14
			je		validKnight
			cmp		edx, 22
			je		validKnight
			cmp		edx, 34
			je		validKnight
			cmp		edx, 38
			je		validKnight
			jmp		invalidMove		; move not defined, must be invalid
			validKnight:
				; actually move the knight
				mov     cl, BYTE[eax]
				mov     BYTE[ebx], cl
				mov     BYTE[eax], ' '
				jmp		endKnight
		endKnight:
			jmp		game_loop
		notKnight:

		invalidMove:
            ; just loop back up to grab input again, maybe add some output later (TODO:?)
			jmp		game_loop

	game_loop_end:

	; restore old terminal functionality
	call raw_mode_off

	;***************CODE ENDS HERE*****************************
	popa
	mov		eax, 0
	leave
	ret

; === FUNCTION ===
raw_mode_on:

	push	ebp
	mov		ebp, esp

	push	raw_mode_on_cmd
	call	system
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
raw_mode_off:

	push	ebp
	mov		ebp, esp

	push	raw_mode_off_cmd
	call	system
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
init_board:

	push	ebp
	mov		ebp, esp

	; FILE* and loop counter
	; ebp-4, ebp-8
	sub		esp, 8

	; open the file
	push	mode_r
	push	board_file
	call	fopen
	add		esp, 8
	mov		DWORD [ebp-4], eax

	; read the file data into the global buffer
	; line-by-line so we can ignore the newline characters
	mov		DWORD [ebp-8], 0
	read_loop:
	cmp		DWORD [ebp-8], HEIGHT
	je		read_loop_end

		; find the offset (WIDTH * counter)
		mov		eax, WIDTH
		mul		DWORD [ebp-8]
		lea		ebx, [board + eax]

		; read the bytes into the buffer
		push	DWORD [ebp-4]
		push	WIDTH
		push	1
		push	ebx
		call	fread
		add		esp, 16

		; slurp up the newline
		push	DWORD [ebp-4]
		call	fgetc
		add		esp, 4

	inc		DWORD [ebp-8]
	jmp		read_loop
	read_loop_end:

	; close the open file handle
	push	DWORD [ebp-4]
	call	fclose
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
render:

	push	ebp
	mov		ebp, esp

	; two ints, for two loop counters
	; ebp-4, ebp-8
	sub		esp, 8

	; clear the screen
	push	clear_screen_cmd
	call	system
	add		esp, 4


	push	last_move_str
	call	printf
	add		esp, 4
	push	DWORD[move1]
	call	putchar
	add		esp, 4
	push	DWORD[move2]
	call	putchar
	add		esp, 4
	push	DWORD[move3]
	call	putchar
	add		esp, 4
	push	DWORD[move4]
	call	putchar
	add		esp, 4

	; print the help information
	push	help_str
	call	printf
	add		esp, 4

	; outside loop by height
	; i.e. for(c=0; c<height; c++)
	mov		DWORD [ebp-4], 0
	y_loop_start:
	cmp		DWORD [ebp-4], HEIGHT
	je		y_loop_end

		; inside loop by width
		; i.e. for(c=0; c<width; c++)
		mov		DWORD [ebp-8], 0
		x_loop_start:
		cmp		DWORD [ebp-8], WIDTH
		je 		x_loop_end

			; print whatever's in the buffer
			mov		eax, [ebp-4]
			mov		ebx, WIDTH
			mul		ebx
			add		eax, [ebp-8]
			mov		ebx, 0
			mov		bl, BYTE [board + eax]
			push	ebx
			call	putchar
			add		esp, 4

		inc		DWORD [ebp-8]
		jmp		x_loop_start
		x_loop_end:

		; write a carriage return (necessary when in raw mode)
		push	0x0d
		call 	putchar
		add		esp, 4

		; write a newline
		push	0x0a
		call	putchar
		add		esp, 4

	inc		DWORD [ebp-4]
	jmp		y_loop_start
	y_loop_end:

	mov		esp, ebp
	pop		ebp
	ret
