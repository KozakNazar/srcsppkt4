#define _CRT_SECURE_NO_WARNINGS
#define WIN32_LEAN_AND_MEAN             // компоненти з заголовків Windows, що рідко застосовуються

#define MAX_SIZE_WRITE_TEXT 1024

#include <windows.h>

#include "stdio.h"
#include <math.h>

TCHAR sConsoleTitle[] = L"My First Console Application";
char sWriteText[MAX_SIZE_WRITE_TEXT] = { 0 }; // "HELLO, WORLD!!!!"
char fmt[] = "result = %.3lf\r\n";

// X = K + B2 - D2/C1 + E1*F2
#define K 0x00025630 //(153136)
extern "C" void calcLab3(double b2, float c1, double d2, float e1, double f2){
	sprintf(sWriteText, fmt, (double)K + b2 - d2 / (double)c1 + (double)e1 * f2);
}

int main(){
	HANDLE std_out; // (1)
    // -----compute------
	double b2 = 10.;
	float c1 = 20.;
	double d2 = 30.;
	float e1 = 40.;
	double f2 = 50.;
	calcLab3(b2, c1, d2, e1, f2);
	// ------------------

	SetConsoleTitle(sConsoleTitle); // (2)

	std_out = GetStdHandle(STD_OUTPUT_HANDLE); // (3)

	WriteConsoleA(std_out, sWriteText, strlen(sWriteText), NULL, NULL);// (4)

	Sleep(2000);// (5)

	ExitProcess(0);// (6)

	return 0;
}