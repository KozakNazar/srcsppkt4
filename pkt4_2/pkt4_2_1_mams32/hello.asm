; Program "Hello world"
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;        ПРОЦ, МОДЕЛЬ, ОПЦІЇ, ІНКЛУДИ, БІБЛІОТЕКИ ІМПОРТУ
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

 .386
 .model flat, stdcall
option casemap:none

;includelib libcmt.lib; for new vs(from vs2015)
;includelib libvcruntime.lib; for new vs(from vs2015)
;includelib libucrt.lib; for new vs(from vs2015)
;includelib legacy_stdio_definitions.lib; for new vs(from vs2015)
;includelib msvcrt.lib; for old vs(to vs2013)
;includelib masm32\lib\msvcrt.lib; for masm32p
includelib \masm32\lib\msvcrt.lib; for masm32

;includelib kernel32.lib; for vs
;includelib masm32\lib\kernel32.lib; for masm32p
includelib \masm32\lib\kernel32.lib; for masm32

SetConsoleTitleA 	PROTO 	:DWORD
GetStdHandle 	PROTO     	:DWORD
WriteConsoleA 	PROTO   	:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExitProcess 	PROTO      	:DWORD
Sleep 		PROTO     	:DWORD
sprintf PROTO near C :DWORD,:VARARG
strlen PROTO near C :DWORD

.data
sWriteText  db 'HELLO, WORLD!!!!', 128 dup(0)
fmt db "result = %.3lf", 13, 10, 0;
temp qword ?

;// X = K + B2 - D2/C1 + E1*F2 // K=0x00025630
vB dq 10.;
vC dd 20.;
vD dq 30.;
vE dd 40.;
vF dq 50.;

a dq 10., 20., 30.;
x dq ?, ?, ?;
K equ 00025630h; (153136d)


;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;                         СЕКЦІЯ КОНСТАНТ
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

 .const

sConsoleTitle  db 'My First Console Application',0
;sWriteText  db 'HELLO, WORLD!!!!', 128 dup(0)

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;                          СЕКЦІЯ КОДУ
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

 .code

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;                    Головна Процедура
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

main PROC C
  LOCAL hStdout :DWORD         ;(1)
;-----compute------
    push dword ptr vF + 4
	push dword ptr vF
    push vE
	push dword ptr vD + 4
	push dword ptr vD
    push vC
	push dword ptr vB + 4
	push dword ptr vB
	call calcLab3
;------------------

  ;назва консолі
  push offset sConsoleTitle    ;(2)
  call SetConsoleTitleA

  ;отримуємо хендл виводу      ;(3)
  push -11
  call GetStdHandle
  mov hStdout,EAX

  push offset sWriteText
  call strlen; eax = strlen(sWriteText)
  add esp, 4
  ;виводимо HELLO, WORLD!      ;(4)
  push 0
  push 0
  push eax; 16d ;
  push offset sWriteText
  push hStdout
  call WriteConsoleA

  ;затримка щоб побачити результат;(5)
  push 2000d
  call Sleep

  ;выход                        ;(6)
  push 0
  call ExitProcess

main ENDP

calcLab3 PROC
    finit
    push ebp
	mov ebp, esp

	mov dword ptr temp, K
	fild temp
	fadd qword ptr [ebp + 8]  ; K + B2

	fld qword ptr [ebp + 20]
	fdiv dword ptr [ebp + 16]
	fchs
	fadd                      ; X = K + B2 - D2/C1
	
	fld dword ptr [ebp + 28]
	fmul qword ptr [ebp + 32]
	fadd                      ; X = K + B2 - D2/C1 + E1*F2
		
	fst temp
	push dword ptr temp[4]
	push dword ptr temp[0]
    push OFFSET fmt
    push OFFSET sWriteText

	call sprintf
    add esp, 16

	pop ebp
	ret 32

calcLab3 ENDP

;end; for new vs(from vs2015)
end main; for new vs(to vs2013) and masm32/masm32p
