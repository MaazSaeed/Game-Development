#include <iostream>
using namespace std;

#include "Eigen/Dense"
using namespace Eigen;

int main() {
	// Solve the given linear system.
	// Ax = b
	// 1.2 x + 3.4 y + 5.6 z = 36.4
	// 7.8 x + 9.0 y + 1.2 z = 87.6
    // 3.4 x + 5.6 y + 7.8 z = 62.8

	Matrix3f A;
	Vector3f b;

	A << 1.2,3.4,5.6, 
		 7.8,9.0,1.2, 
		 3.4,5.6,7.8;

	b << 36.4,
		 87.6,
		 62.8;

	cout << "Matrix A: \n" << A << endl;
	cout << "Vector B: \n" << b << endl;

	Vector3f x = A.colPivHouseholderQr().solve(b);

	cout << "Solution: \n" << x << endl;

	return 0;
}