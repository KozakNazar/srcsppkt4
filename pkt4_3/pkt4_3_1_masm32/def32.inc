; Sç winuser.h.
IDI_APPLICATION   	    equ             32512
WM_DESTROY        	    equ             2
CS_HREDRAW        	    equ             2
CS_VREDRAW         	    equ             1
CW_USEDEFAULT      	    equ             80000000h
WS_OVERLAPPEDWINDOW	    equ             0CF0000h
IDC_ARROW          	    equ             32512
SW_SHOWNORMAL   	    equ           	1
COLOR_WINDOW       	    equ             5
WM_LBUTTONDOWN     	    equ             201h

WNDCLASSEX          	 struc
cbSize                 dd             ?
style                  dd             ?
lpfnWndProc            dd             ?
cbClsExtra             dd             ?
cbWndExtra             dd             ?
hInstance              dd             ?
hIcon                  dd             ?                                                         
hCursor                dd             ?
hbrBackground          dd             ?
lpszMenuName           dd             ?
lpszClassName          dd             ?
hIconSm                dd             ?
WNDCLASSEX                 ends
MSG                        struc
Hwnd			   dd             ?
message      		   dd             ?
wParam       		   dd             ?
lParam       		   dd             ?
time       		   dd             ?
pt         		   dd             ? 
MSG               		ends
