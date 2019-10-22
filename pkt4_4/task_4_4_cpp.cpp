#include "stdio.h"
#include "math.h"

#define MAX_ARRAY_SIZE 256
#define ARRAY_SIZE = 3
#define ARRAY_VALUES = {10., 20., 30.}
#define C_VALUE = 1.
#define D_VALUE = 1.

void calc1Pract4ByLab4(double * x, double * a, float c, float d, int n){ // (c > d) 
	for (int index = 0; index < n; ++index){
		x[index] = (d / 2 - 53 / c) / (atan(d - a[index]) * c + 1);
	}
}

void calc2Pract4ByLab4(double * x, double * a, float c, float d, int n) { // (c <= d)
	for (int index = 0; index < n; ++index){	
		x[index] = (c * 4 + 28 * d / c) / (5 - atan(a[index] * d));
	}
}

// TODO: function calcSelectorByLab4 implement on assembler in dll-module, in C-code use explicit linking
void // return type of return type
(*calcSelectorByLab4(
void(*f1)(double *, double *, float, float, int), // arg0
void(*f2)(double *, double *, float, float, int), // arg1
float c, // arg2
float d // arg3
)
)(double *, double *, float, float, int) // args(arg0, arg1, arg2, arg3, arg4) of return type
{
	if (c > d) {
		return f1; // (c > d) 
	}
	else{
		return f2; // (c <= d) 
	}
}

int main()
{
	int n ARRAY_SIZE;
	double a[MAX_ARRAY_SIZE] ARRAY_VALUES, x[MAX_ARRAY_SIZE];// ARRAY_VALUES;
	float c C_VALUE;
	float d D_VALUE;

	calcSelectorByLab4(calc1Pract4ByLab4, calc2Pract4ByLab4, c, d)(x, a, c, d, n);
				
	printf("Result = [%lf][%lf][%lf]\r\n", x[0], x[1], x[2]);
	printf("Press any key to continue . . .");
	getchar();

	return 0;
}

