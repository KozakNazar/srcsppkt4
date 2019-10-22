; window.asm
; �������� win32-��������, �������� ���� � ���� ��������� ��� ��������� ��� ������ 
; �����.

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


; ���������, �� ����� ���� ����.
wc WNDCLASSEX <4*12,CS_HREDRAW or CS_VREDRAW,Offset win_proc,0,0,?,?,?,\
COLOR_WINDOW+1,0,offset class_name,0> 
; ��� ����������� ������� ����: 
; wc.cbSize = 4*12 - ����� ���� ��������� 
; wc.style - ����� ���� (�� ��������������� ���� ��) 
; wc.lpfnWndProc � �������� ���� ���� (������ ��������� win_proc) 
; wc.cbClsExtra - ����� ���������� ���� ���� ��������� (0) 
; wc.cbWndExtra - ����� ���������� ���� ���� ���� (0) 
; we.hInstance - ������������� ������ ������� (?) 
; wc.hIcon - ������������� ������ (?) 
; wc.hCursor - ������������� ������� (?)
; wc.hbrBackground - ������������� �������� ��� ���� ���� + 1(COLOR_WINDOW+1) 
; wc.lpszMenuName - ������ � �������� ���� (� ����� ������� - 0) 
; wc.lpszClassName - ��� ������ (����� class.name) 
; wc.hIconSm - ������������� �������� ������ (����� � Windows 95, 
; ��� NT �� ���� 0).

.data?
msg_  MSG   <?,?,?,?,?,?>   	; � �� - ���������, � ��� �����������
; ����������� ���� GetMessage

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

xor   ebx,ebx      			; � ��� ���� 0 ��� ������ push 0. 
; ��������� ������������� ���� ��������
push  ebx
call  GetModuleHandle
mov   esi,eax      			; � �������� ���� � ESI. 
; ��������� � ������������ ����.
mov   dword ptr wc.hInstance,eax ; ������������� ������. ; ������� ������.
push  IDI_APPLICATION 		; ���������� ������ �������.
push  ebx         			; ������������� ������ � �������,
call  LoadIcon
mov   wc.hIcon,eax   		; ������������� ������ ��� ������ �����.
; ������� ����� �������
push  IDC_ARROW     		; ���������� ������.
push  ebx         			; ������������� ������ � ��������
call  LoadCursor
mov   wc.hCursor,eax  		; ������������� ������� ��� ������ �����
push  offset wc
call  RegisterClassEx 		; ������������ ����.



; �������� ����
mov   ecx,CW_USEDEFAULT		; push ecx ������� push N � �'��� ����.
push  ebx                  	; ������ ��������� CREATESTRUCT (��� NULL)
push  esi         			; ������������� �������, �� ���� ����������
; ����������� �� ���� (�����  ���).
push  ebx         			; ������������� ���� ��� ����-�������.

push  ebx         			; ������������� ����-������,
push  ecx         			; ������ (CW_USEOEFAULT - �� �������������)
push  ecx         			; ������ (�� �������������),
push  ecx         			; Y-���������� (�� �������������)
push  ecx         			; �-���������� (�� �������������),
push  WS_OVERLAPPEDWINDOW  	; ����� ����,
push  offset window_name   	; ��������� ����,
push  offset class_name    	; ����� ������������� ����,
push  ebx                  	; ���������� �����
call  CreateWindowEx       	; �������� ���� (��� - ������������� ����)
push  eax                  	; ������������� ��� UpdateW�ndow.
push  SW_SHOWNORMAL        	; ��� ������ ��� ��� ShowW�ndow
push  eax                  	; ������������� ��� ShowW�ndow.

; ������ ������������� ���� ��� �� ���� ��������
call    ShowWindow         	; �������� ����
call    UpdateWindow   		; � ������� ���� ����������� WM_PA�NT.

; �������� ���� - �������� ���������� �� ���� � ����� no WM_QU�T.
mov   edi, offset msg_ 	;    push ed� ������� push N � 5 ����. 
message_loop:
push   ebx         		;    ������ �����������.
push   ebx         		;    ����� �����������
push   ebx         		;    ������������� ���� (0 - ����-��� ���� ����)
push   edi         		;    ������ ��������� MSG
call   GetMessage  		;    �������� ����������� �� ���� � ����������� -
;    �� ��������� ����������� PeekMessage.
;    ���� ������� � ����� ���� ���� ����������.
test   eax,eax     		;    ���� �������� WM_QU�T.
jz     exit_msg_loop	;    �����.
push   edi         		;    ������ - ����������� ����������� ����
call   TranslateMessage 	;    WM_KEYUP � ����������� ���� WM_CHAR
push   edi
call   DispatchMessage 	;    � ������� �� �������� ���� (������ ���� ������
;    �� ����� ���� �������)
jmp   short message_loop  	;    ���������� ���� 

exit_msg_loop: 			
;����� �� ��������.
push   ebx
call   ExitProcess

WinMain@16 endp

; ��������� w�n_proc
; ����������� ����� �����, ���� ���� ������ ���-������ �����������.
; ���� ��� ���� ���������� ��� ������ ��������.

; ��������� �� ������� �������� ������� EBP, ED�, ES� � ���!
win_proc      proc
; ���� �� �� �������� ��������� � �����, ���������� �������� ����.
push   ebp
mov   ebp,esp 
; ��������� ���� W�ndowProc ����������� � ���������� �����������:
wp_hWnd   equ dword  ptr  [ebp+08h]	; ������������� ����,
wp_uMsg   equ dword  ptr  [ebp+0Ch] 	; ����� �����������,
wp_wParam equ dword  ptr  [ebp+10h]	; ������ ��������,
wp_lParam equ dword  ptr  [ebp+l4h]	; ������ ��������.
; ���� �� �������� ����������� WM_DESTROY (���� ������, �� ���� ��� �������� 
; � ������, ������� ALT+F4 ��� ������ � ��������� ������� ���),
; �� ��������� ������� �������   ����������� WM_QU�T.
cmp   	wp_uMsg,WM_DESTROY
jne  	not_wm_destroy
push   0                     ; ��� ������.
call   PostQuitMessage       ; ������� WM_QU�T
jmp    short end_wm_check     ; � ����� �� ���������. 

not_wm_destroy: 
cmp   wp_uMsg,WM_LBUTTONDOWN
je    wm_lbutdwn
; ���� �� �������� ���� ����������� - ��������� ���� ���������� �� �������������.
leave                 ; ³������� ebp
jmp   DefWindowProc   ; � ��������� DefW�ndowProc � ������ �����������
; � ������� ���������� � �����. 
wm_lbutdwn:
; ������� ����� � ��������� ����
push offset wnd_text
push wp_hWnd
call SetWindowText
leave
jmp DefWindowProc	  ; ϳ��� �������� ���� ���� � ����������� ��� �����������
			  ; ����������� ����� ���� ������� ��������� �����������
			  ; ����������� ����� 
end_wm_check:
leave	               ; ³������� ebp
ret   16              ; � ����������� �����, ��������� ���� �� ���������.
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