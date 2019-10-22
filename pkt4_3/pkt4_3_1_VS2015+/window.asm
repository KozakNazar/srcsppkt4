; window.asm
; Графічна win32-програма, виводить вікно і міняє заголовок при натисканні лівої клавіші 
; мишки.

.386
.model flat
EXTRN   _sprintf:near

include def32.inc
include kernel32.inc 
include user32.inc

includelib libcmt.lib; for new vs(from vs2015)
includelib libvcruntime.lib; for new vs(from vs2015)
includelib libucrt.lib; for new vs(from vs2015)
includelib legacy_stdio_definitions.lib; for new vs(from vs2015)
;includelib msvcrt.lib; for old vs(to vs2013)
;includelib masm32\lib\msvcrt.lib; for masm32p
;includelib \masm32\lib\msvcrt.lib; for masm32

;includelib masm32\lib\user32.lib; for masm32p
;includelib masm32\lib\kernel32.lib; for masm32p
;includelib masm32\lib\shell32.lib; for masm32p
;includelib \masm32\lib\user32.lib; for masm32
;includelib \masm32\lib\kernel32.lib; for masm32
;includelib \masm32\lib\shell32.lib; for masm32

.data
class_name     db    "Window class 1",0
window_name    db    "Win32 assembly example",0
wnd_text       db    "Hello                                                                               ",0

fmt db "result: x[%d] = %lf, x[%d] = %lf, x[%d] = %lf", 13, 10, 0;

temp qword ?
CONST_53 equ 53d;
CONST_28 equ 28d;
CONST_5 equ 5d;

cV dd 1.; c
dV dd 1.;

a dq 10., 20., 30.;
x dq ?, ?, ?;


; Структура, що описує клас вікна.
wc WNDCLASSEX <4*12,CS_HREDRAW or CS_VREDRAW,Offset win_proc,0,0,?,?,?,\
COLOR_WINDOW+1,0,offset class_name,0> 
; Тут знаходяться наступні поля: 
; wc.cbSize = 4*12 - розмір цієї структури 
; wc.style - стиль вікна (як перемальовувати його то) 
; wc.lpfnWndProc – обробник подій вікна (віконна процедура win_proc) 
; wc.cbClsExtra - число додаткових байт після структури (0) 
; wc.cbWndExtra - число додаткових байт після вікна (0) 
; we.hInstance - ідентифікатор нашого процеса (?) 
; wc.hIcon - ідентифікатор іконки (?) 
; wc.hCursor - ідентифікатор курсора (?)
; wc.hbrBackground - ідентифікатор пензлика або колір фона + 1(COLOR_WINDOW+1) 
; wc.lpszMenuName - ресурс з основним меню (в цьому прикладі - 0) 
; wc.lpszClassName - імя класса (рядок class.name) 
; wc.hIconSm - ідентифікатор маленької іконки (тільки в Windows 95, 
; для NT має бути 0).

.data?
msg_  MSG   <?,?,?,?,?,?>   	; А це - структура, в яку повертається
; повідомлення після GetMessage

.code 
WinMain@16 proc c
;-----compute------
    push 3
    push dV
	push cV
    push OFFSET a
	push OFFSET x
call calcLab4 ;
    push 3
	push OFFSET x 
call printResult
;------------------

xor   ebx,ebx      			; В ЕВХ буде 0 для команд push 0. 
; Визначити ідентифікатор нашої програми
push  ebx
call  GetModuleHandle
mov   esi,eax      			; і зберегти його в ESI. 
; Заповнити й зареєструвати клас.
mov   dword ptr wc.hInstance,eax ; Ідентифікатор предка. ; Вибрати іконку.
push  IDI_APPLICATION 		; Стандартна іконка додатка.
push  ebx         			; Ідентифікатор модуля з іконкою,
call  LoadIcon
mov   wc.hIcon,eax   		; Ідентифікатор іконки для нашого класу.
; Вибрати форму курсора
push  IDC_ARROW     		; Стандартна стрілка.
push  ebx         			; Ідентифікатор модуля з курсором
call  LoadCursor
mov   wc.hCursor,eax  		; Ідентифікатор курсору для нашого класу
push  offset wc
call  RegisterClassEx 		; Зареєструвати клас.



; Створити вікно
mov   ecx,CW_USEDEFAULT		; push ecx коротше push N у п'ять разів.
push  ebx                  	; Адреса структури CREATESTRUCT (тут NULL)
push  esi         			; Ідентифікатор процесу, що буде одержувати
; повідомлення від вікна (тобто  наш).
push  ebx         			; Ідентифікатор меню або вікна-нащадка.

push  ebx         			; Ідентифікатор вікна-предка,
push  ecx         			; Висота (CW_USEOEFAULT - за замовчуванням)
push  ecx         			; Ширина (за замовчуванням),
push  ecx         			; Y-координата (за замовчуванням)
push  ecx         			; Х-координата (за замовчуванням),
push  WS_OVERLAPPEDWINDOW  	; Стиль вікна,
push  offset window_name   	; Заголовок вікна,
push  offset class_name    	; Любою зареєстрований клас,
push  ebx                  	; Додатковий стиль
call  CreateWindowEx       	; Створити вікно (еах - ідентифікатор вікна)
push  eax                  	; Ідентифікатор для UpdateWіndow.
push  SW_SHOWNORMAL        	; Тип показу для для ShowWіndow
push  eax                  	; Ідентифікатор для ShowWіndow.

; Більше ідентифікатор вікна нам не буде потрібний
call    ShowWindow         	; Показати вікно
call    UpdateWindow   		; і послати йому повідомлення WM_PAІNT.

; Основний цикл - перевірка повідомлень від вікна й вихід no WM_QUІT.
mov   edi, offset msg_ 	;    push edі коротше push N в 5 разів. 
message_loop:
push   ebx         		;    Останнє повідомлення.
push   ebx         		;    Перше повідомлення
push   ebx         		;    Ідентифікатор вікна (0 - будь-яке наше вікно)
push   edi         		;    Адреса структури MSG
call   GetMessage  		;    Одержати повідомлення від вікна з очікуванням -
;    не забувайте використати PeekMessage.
;    якщо потрібно в цьому циклі щось виконувати.
test   eax,eax     		;    Якщо отримано WM_QUІT.
jz     exit_msg_loop	;    вийти.
push   edi         		;    Інакше - перетворити повідомлення типу
call   TranslateMessage 	;    WM_KEYUP у повідомлення типу WM_CHAR
push   edi
call   DispatchMessage 	;    і послати їх процедурі вікна (інакше його просто
;    не можна буде закрити)
jmp   short message_loop  	;    Продовжити цикл 

exit_msg_loop: 			
;Вихід із програми.
push   ebx
call   ExitProcess

WinMain@16 endp

; Процедура wіn_proc
; Викликається вікном щораз, коли воно одержує яке-небудь повідомлення.
; Саме тут буде відбуватися вся робота програми.

; Процедура не повинна змінювати регістри EBP, EDІ, ESІ й ЕВХ!
win_proc      proc
; Тому що ми одержуємо параметри в стеці, побудувати стековый кадр.
push   ebp
mov   ebp,esp 
; Процедура типу WіndowProc викликається з наступними параметрами:
wp_hWnd   equ dword  ptr  [ebp+08h]	; ідентифікатор вікна,
wp_uMsg   equ dword  ptr  [ebp+0Ch] 	; номер повідомлення,
wp_wParam equ dword  ptr  [ebp+10h]	; перший параметр,
wp_lParam equ dword  ptr  [ebp+l4h]	; другий параметр.
; Якщо ми одержали повідомлення WM_DESTROY (воно означає, що вікно вже видалили 
; з екрана, нажавши ALT+F4 або кнопку у верхньому правому куті),
; то відправимо основній програмі   повідомлення WM_QUІT.
cmp   	wp_uMsg,WM_DESTROY
jne  	not_wm_destroy
push   0                     ; Код виходу.
call   PostQuitMessage       ; Послати WM_QUІT
jmp    short end_wm_check     ; і вийти із процедури. 

not_wm_destroy: 
cmp   wp_uMsg,WM_LBUTTONDOWN
je    wm_lbutdwn
; Якщо ми одержали інше повідомлення - викликати його оброблювач за замовчуванням.
leave                 ; Відновити ebp
jmp   DefWindowProc   ; і викликати DefWіndowProc з нашими параметрами
; і адресою повернення в стеці. 
wm_lbutdwn:
; Вивести текст у заголовку вікна
push offset wnd_text
push wp_hWnd
call SetWindowText
leave
jmp DefWindowProc	  ; Після внесення своїх зміни в стандартний хід опрацювання
			  ; повідомлення треба дати програмі завершити опрацювання
			  ; стандартним чином 
end_wm_check:
leave	               ; Відновити ebp
ret   16              ; і повернутися самим, очистивши стек від параметрів.
win_proc endp


calcLab4 PROC
    finit
    push ebp
	mov ebp, esp

	mov ecx, dword ptr [ebp + 24]    
	xor esi, esi; (mov esi, 0)


	fld dword ptr [ebp + 20] ;  d
	fld dword ptr [ebp + 16] ;  c
	fcompp
	;xor eax, eax
	fstsw ax
	sahf
	jna compute_loop_2; // if (c <= d) goto compute_loop_2;


    compute_loop_1: ; // if (c > d);
	fld1
	fchs
	fld dword ptr [ebp + 20] ; d
	fscale; d/2
	mov dword ptr temp, CONST_53
	fild dword ptr temp
	fdiv dword ptr [ebp + 16] ; 53 / c
	fsub; d / 2 - 53 / c
	

	fld dword ptr [ebp + 20] ;  d
	mov ebx, dword ptr [ebp + 12]  ; a
	fsub qword ptr [ebx + 8 * esi]; d - a[esi]
	fld1
	fpatan; arctg(d - a[esi])
	fmul dword ptr [ebp + 16]  ;  arctg(d - a[esi]) * c 	
	fld1
	fadd;  arctg(d - a[esi])*c + 1

	fdiv;  (d / 2 - 53 / c) / (arctg(d - a[esi]) * c + 1)

	mov ebx, dword ptr [ebp + 8]  ; x
	fst qword ptr [ebx + 8 * esi] ; x[esi]

	inc esi
	loop compute_loop_1
	jmp return_proc

	
	compute_loop_2: ; // if (c <= d);
	fld1
	fld1
	fadd; faddp
	fld dword ptr [ebp + 16]; c
	fscale; c*4
	mov dword ptr temp, CONST_28
	fild dword ptr temp
	fmul dword ptr [ebp + 20] ; 28 * d
	fdiv dword ptr [ebp + 16] ; 28 * d / c
	fadd; c*4 + 28 * d / c

	mov ebx, dword ptr [ebp + 12] ; a
	fld qword ptr [ebx + 8 * esi]; a[esi]
	fmul dword ptr [ebp + 20] ;  a[esi] * d
	fld1
	fpatan; arctg(a[esi] * d)
	fchs ;  - arctg(d - a[esi]) 
	mov dword ptr temp, CONST_5
	fiadd dword ptr temp  ;  5 - arctg(d - a[esi])

	fdiv;  (c*4 + 28 * d / c) / (5 - arctg(d - a[esi]))

	mov ebx, dword ptr [ebp + 8]  ; x 
	fst qword ptr [ebx + 8 * esi] ; x[esi]

	inc esi
	loop compute_loop_2
	jmp return_proc

	return_proc:			
	pop ebp;
	ret 20 ; ret 0; (for motod 2)
calcLab4 ENDP

printResult PROC
    push ebp
	mov ebp, esp

	mov ecx, dword ptr [ebp + 12] ; mov ecx, dword ptr [ebp + 24]; (for motod 2)
	mov esi, ecx
	dec esi
	mov ebx, dword ptr [ebp + 8]  ; x

	output_loop:

	;mov edx, dword ptr [ebx + 8 * esi + 4];
	;mov eax, dword ptr [ebx + 8 * esi];
    ;push edx; 
    ;push eax;

    push dword ptr [ebx + 8 * esi + 4];
    push dword ptr [ebx + 8 * esi];
    push esi

	dec esi
	loop output_loop


    push OFFSET fmt
	push OFFSET wnd_text
    call _sprintf
	add esp, 8
	mov eax, dword ptr [ebp + 12] ; mov ecx, dword ptr [ebp + 24]; (for motod 2)
	mov ecx, 12
	mul ecx
	add esp, eax ; 8(4+4) + n*8(4+4)
				
	pop ebp; 
	ret 8 ; ret 20; (for motod 2)
	
printResult ENDP

end; for new vs(from vs2015)
;end WinMain@16; for old vs(to vs2013) and masm32/masm32p