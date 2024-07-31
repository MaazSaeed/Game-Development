# Lecture 09: Introduction to Geometry (CMU 15-462/662)

Geometric processing and geometric modelling

Try to model complex shapes

How to add geometric complexity

What is geometry?
1. The study of shapes, sizes, patterns and positions.
2. The study of spaces where some quantity can be measured.

How to describe a given piece of geometry?
How can we use digital data to encode shape?
How to describe a shape?
Linguistic: circle
Mathematically: $x^2 + y^2 = 1$
Allows you to describe which points are inside the circle
Explicit: $(cos\theta, sin\theta)$ (i.e. x and y)
Any other encodings of the circle?
In terms of calculus, you could say the path traced out by the earth around the sun -> solution to the equation gives a curve
Discrete: approximate the circle by a polygon
Symmetry: stays the same regardless of how you rotate it
Curvature: $k = 1$

Many different ways to characterise a shape.

Given all these options, which is the best way to encode geometry on a computer?
