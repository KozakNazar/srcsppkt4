#define _CRT_SECURE_NO_WARNINGS
#define _CRT_NON_CONFORMING_SWPRINTFS
#define WIN32_LEAN_AND_MEAN             // компоненти з заголовків Windows, що рідко застосовуються

#define MAX_SIZE_WND_TEXT 1024

#include <windows.h>

#include "stdio.h"
#include <math.h>

wchar_t class_name[] = L"Window class 1";
wchar_t window_name[] = L"Win32 assembly example";
wchar_t wnd_text[MAX_SIZE_WND_TEXT] = { 0 }; // L"Hello";

#define MAX_ARRAY_SIZE 256
#define ARRAY_SIZE = 3
#define ARRAY_VALUES = {10., 20., 30.}
#define C_VALUE = 1.
#define D_VALUE = 1.

LRESULT CALLBACK win_proc(HWND wp_hWnd, UINT wp_uMsg, WPARAM wp_wParam, LPARAM wp_lParam);

void calcPract4ByLab4(double * x, double * a, float c, float d, int n){
	for (int index = 0; index < n; ++index){
		if (c > d) {
			x[index] = (d / 2 - 53 / c) / (atan(d - a[index]) * c + 1); // (c > d) 
		}
		else{       
			x[index] = (c * 4 + 28 * d / c) / (5 - atan(a[index] * d)); // (c <= d) 
		}
	}
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR lpCmdLine, int nCmdShow)
{
	int n ARRAY_SIZE;
	double a[MAX_ARRAY_SIZE] ARRAY_VALUES, x[MAX_ARRAY_SIZE];// ARRAY_VALUES;
	float c C_VALUE;
	float d D_VALUE;
	calcPract4ByLab4(x, a, c, d, n);
	swprintf(wnd_text, L"Result = [%lf][%lf][%lf]", x[0], x[1], x[2]);

	MSG msg_;
	HWND hWnd;
	WNDCLASSEX wc;

	wc.cbSize = sizeof(wc);
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc = win_proc;
	wc.cbClsExtra = NULL;
	wc.cbWndExtra = NULL;
	wc.hbrBackground = HBRUSH(COLOR_WINDOW + 1);
	wc.lpszMenuName = NULL;
	wc.lpszClassName = class_name;
	wc.hIconSm = NULL;

	wc.hInstance = GetModuleHandle(NULL); /*handle to the file used to create the calling process */
	wc.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);

	RegisterClassEx(&wc);

	hWnd = CreateWindowEx(
		NULL,
		class_name,
		window_name,
		WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		NULL,
		(HMENU)NULL,
		wc.hInstance,
		NULL);

	ShowWindow(hWnd, SW_SHOWNORMAL);

	UpdateWindow(hWnd);

	while (GetMessage(&msg_, NULL, NULL, NULL))  {
		TranslateMessage(&msg_);
		DispatchMessage(&msg_);
	}
	return msg_.wParam;
}

//Віконна процедура
LRESULT CALLBACK win_proc(HWND wp_hWnd, UINT wp_uMsg, WPARAM wp_wParam, LPARAM wp_lParam)
{
	switch (wp_uMsg)
	{
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	case WM_LBUTTONDOWN:
		SetWindowText(wp_hWnd, wnd_text);
		break;
	default:
		return DefWindowProc(wp_hWnd, wp_uMsg, wp_wParam, wp_lParam);
	}
	return 0;
}
