; kernel32.іnc
; Файл з визначеннями функцій з kernel32.dll.
; Імена використовуваних функцій, 
;includelib    kernel32.lib; for vs
;includelib    masm32\lib\kernel32.lib; for masm32p
includelib    \masm32\lib\kernel32.lib; for masm32
; Дійсні імена використовуваних функцій
extrn  __imp__ExitProcess@4:dword
; Присвоювання для полегшення читаності коду.
ExitProcess   equ   __imp__ExitProcess@4

; shell32.іnc
; Файл з визначеннями функцій з shell32.dll.
;includelib    shell32.lib; for vs
;includelib    masm32\lib\shell32.lib; for masm32p
includelib    \masm32\lib\shell32.lib; for masm32
; Дійсні імена використовуваних функцій
extrn  __imp__ShellExecuteA@24:dword 
; Присвоювання для полегшення читаності коду.
ShellExecute   equ   __imp__ShellExecuteA@24 

; winurl.asm
; Приклад програми для Wіn32.
; Запускає встановлений за замовчуванням браузер на адресу, що зазначена в рядку
; URL. Аналогічно можна запускати будь-яку програму, документ і який завгодно
; файл, для якого визначена операція open.

;include   shell32.inc	; Файл з визначеннями функцій з shell32.dll.
;include   kernel32.inc	; Файл з визначеннями функцій з kernel32.dll.

.586
.model       flat
.const
URL    db    "http://www.lp.edu.ua/",0
.code
_start:                   ; Мітка точки входу повинна починатися з підкреслення.
xor           ebx,ebx
push          ebx             ; Для виконуваних файлів - спосіб показу.
push          ebx             ; Робоча директорія.
push          ebx             ; Командний рядок.
push          offset URL      ; Ім'я файлу зі шляхом
push          ebx             ; Операція open або prіnt (якщо NULL - open).
push          ebx             ; Ідентифікатор вікна, що одержить повідомлення.
call          ShellExecute    ; ShellExecute (NULL,NULL,url,NULL,NULL.NULL)
push          ebx             ; Код виходу.
call          ExitProcess     ; ExitProcess(0) 
end   _start
