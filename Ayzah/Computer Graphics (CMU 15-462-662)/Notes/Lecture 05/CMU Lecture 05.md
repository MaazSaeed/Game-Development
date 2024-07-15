# Lecture 05: Spacial Transformations (CMU 15-462/662)

## Review: Linear Maps
Geometrically: maps lines to lines and preserves origin.

Algebraically: preserves vector space operations (addition and scaling).

## Linear Transformations
- Cheap to apply
- Easy to solve for (linear systems)
- Composition of linear transformations is linear:
    - product of many matrices is a single matrix.
    - uniform representation of transforms.
    - simplifies graphics algorithms, systems (GPUs, APIs).

## How to determine transformation?
By invariants it preserves.
transformation  invariants
linear          straight lines/origin
translation     difference between pair of points
scaling         lines through origin/vector directions
rotation        origin/distance between points/orientation

## 2D Rotations
![alt text](image.png)

## 3D Rotations
![alt text](image-1.png)

## Rotations - Transpose as Inverse
Q<sup>T</sup>Q = *I*

Does every matrix Q<sup>T</sup>Q = *I* represent a rotation?

No. E.g. ![alt text](image-3.png)

Q<sup>T</sup>Q = *I* holds true, but Q is a reflection matrix.

## Orthogonal Transformations
Transformations that preserve distances and origin.

Q<sup>T</sup>Q = *I*

For rotations, the determinant of Q is positive, det(Q) > 0.

For reflections, the determinant of Q is negative, det(Q) < 0.

## Scaling
Preserves direction while changing magnitude.

$$
\left(\begin{array}{cc} 
a & 0 & 0\\
0 & a & 0\\
0 & 0 & a\\
\end{array}\right)

\left(\begin{array}{cc} 
u1\\
u2\\
u<sub>3</sub>\\
\end{array}\right)
=
\left(\begin{array}{cc} 
10 & 0\\ 
0 & 5
\end{array}\right)
$$ 