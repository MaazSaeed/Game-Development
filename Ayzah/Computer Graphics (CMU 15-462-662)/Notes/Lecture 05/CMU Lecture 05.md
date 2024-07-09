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

