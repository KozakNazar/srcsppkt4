; kernel32.�nc
; ���� � ������������ ������� � kernel32.dll.
; ����� ���������������� �������, 
;includelib    kernel32.lib; for vs
;includelib    masm32\lib\kernel32.lib; for masm32p
includelib    \masm32\lib\kernel32.lib; for masm32
; ĳ��� ����� ���������������� �������
extrn  __imp__ExitProcess@4:dword
; ������������ ��� ���������� �������� ����.
ExitProcess   equ   __imp__ExitProcess@4

; shell32.�nc
; ���� � ������������ ������� � shell32.dll.
;includelib    shell32.lib; for vs
;includelib    masm32\lib\shell32.lib; for masm32p
includelib    \masm32\lib\shell32.lib; for masm32
; ĳ��� ����� ���������������� �������
extrn  __imp__ShellExecuteA@24:dword 
; ������������ ��� ���������� �������� ����.
ShellExecute   equ   __imp__ShellExecuteA@24 

; winurl.asm
; ������� �������� ��� W�n32.
; ������� ������������ �� ������������� ������� �� ������, �� ��������� � �����
; URL. ��������� ����� ��������� ����-��� ��������, �������� � ���� ��������
; ����, ��� ����� ��������� �������� open.

;include   shell32.inc	; ���� � ������������ ������� � shell32.dll.
;include   kernel32.inc	; ���� � ������������ ������� � kernel32.dll.

.586
.model       flat
.const
URL    db    "http://www.lp.edu.ua/",0
.code
_start:                   ; ̳��� ����� ����� ������� ���������� � �����������.
xor           ebx,ebx
push          ebx             ; ��� ����������� ����� - ����� ������.
push          ebx             ; ������ ���������.
push          ebx             ; ��������� �����.
push          offset URL      ; ��'� ����� � ������
push          ebx             ; �������� open ��� pr�nt (���� NULL - open).
push          ebx             ; ������������� ����, �� �������� �����������.
call          ShellExecute    ; ShellExecute (NULL,NULL,url,NULL,NULL.NULL)
push          ebx             ; ��� ������.
call          ExitProcess     ; ExitProcess(0) 
end   _start
