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

Geometry in the real world can be extremely complex:
- how to show a cloth blowing in the wind?
- how to show water splasing, droplets breaking and merging?
- how to show minute, many details?
- how to show volumetric aspect of a shape?
- how to show the shape of cells, proteins, etc?

Two big categories of encoding geometry:
1. Explicit representations
- point cloud
- polygon mesh (points and connections)
- subdivision, NURBS
2. Implicit
Does not give a defined shape, rather is a question of: am I in the shape or not?
Points are not known directly, more about satisfying a relationship
- level set
- algebraic surface
- L-systems

Each choice is best suited for a different task.
You will need to go back and forth with explicit and implicit

An implicit representation can be described by checking if the point exists in a certain place.
this can thus be very difficult as you do not know where the point is present, e.g. sampling.


**[ insert diagram for implicit representations]**

But the implicit approach is useful when you have the function and you have a point, and you just have to check if the point is present inside the function.


**[ insert diagram for implicit representations with sphere]**


### Explicit Representation
All  the points are given directly, e.g. points on a sphere: $(cos(u)sin(v)), (sin(u)sin(v), cos(v))$ for $0 <= u < 2\pi$ and $0 <= v <= \pi$

### [ diagram of the game and torus ]
(for torus)
We have three numbers but two parameters so how can we use the explicit approach here? It's not possible
Explicit surfaces make tasks like sampling easy, but tests like inside/outside difficult.

### Algebraic Surfaces (Implicit)

A surface is a zero set of a polynomial in $x, y, z$. Examples:
**[insert diagram ]**

What about more complicated shapes? You cannot possibly come up with a unique function/polynomial to represent every shape.

The solution to this is Constructive Solid Geometry (Implicit)
Through this approach, you can build more complicated shapes via Boolean operations.


#### Constructive Solid Geometry (Implicit)
- You are able to build more complicated shapes by applying Boolean operations, e.g. that two shapes are completely separate, two shapes are in union , the intersection of two shapes, the difference of two shapes
You can then chain the expressions one after the other, getting a tree-like structure of Boolean operations that describe the shape.
Doesn't help model organic looking shapes, but does allow to model mechanical shapes like machine parts.

#### Blobby Surfaces 
Instead of using boolean operations, you can gradually blend surfaces together.
We start with two points, then use the Gaussian described in the figure, and when we take the sum at two different points, we see the two bumps intersecting. A similar technique may be adopted to show water droplets merging

**INSERT DIAGRAM**

#### Bending Distance Functions
How to implement Boolean union using distance
**use slides**

#### Level Sets
Implicit surfaces are great at showing nice features like blending and merging, but not so good about to describe complex forms
Instead of using formulas, as that increase complexity and nearly impossible to model complicated shapes, we use grids that allow you to store values, and based on the values in which some are negative and some are positive, you interpolate them, and the places where the result is zero is the surface of the function
This approach provides much more explicit control over the shape, like texture mapping.
Although this seems like a great approach, but you must realise that you have sampled your geometry onto a grid, so  if the resolution is not high enough then features are lost, and in formal terms, this may be terms as aliasing.
You will then need to do sophisticated sampling and filtering to reconstruct the shape.

A big drawback of Level Sets is the storage they require. A 2D surface now requires $O(n^3)$.
A way to go about this is to have a sparce data structure that only stores a narrow band containing the values around the surface. 

## **FRACTALS**


#### Pros and Cons of Implicit Representations
Pros:
- the description can be very compact (e.g., a polynomial)
- easy to determine if a point is in our shape (by just plugging it in)
- other queries may also be easy (e.g., distance to surface)
- for simple shapes you can provide exact descriptions and have no sampling errors
- they allow you to easily handle changes in topology (best for fluid simulation)
Cons:
- expensive to find all points in the shape (e.g., for drawing)
- very difficult to model complex shapes


## Explicit Representations
### Point Clouds
- If you are given a dense set of points, i.e. list of points (x, y, z), you can easily render the surface.
- The points may also include other attributes like colour.
- They allow you to easily represent any kind of geometry as you do not have to approximate any function, but just use the set of points provided.
- Easy to draw a dense cloud, especially if you have a lot more than one point per pixel.
- But it is hard to interpolate under sampled regions
- It is hard to do processing/simulation if you do not have enough points and how one point is connected with another.

### Polygon Mesh
- The most important concept used to represent meshes in computer graphics.
- Instead of storing points, you store vertices and polygons (most often triangles or quads) to represent the surfaces.
- It is easier to do processing/simulation in this way, and results in more adaptive sampling.
- The figure below shows a shape with the front and back in a spherical shape while the rest of it is straight. So we can use triangles to represent the spherical parts, making them in a way that they curve around. While the rest of the shape can be made using long thin triangles.
- This results in a more complicated data structure.
- There are "irregular neighbourhoods". In points, you had points adjacent to one another, representing the object. In a mesh you don't always have a clear view of what might be the adjacent vertices.

### Triangle Mesh
- Store the vertices as tripes of coordinates (x, y, z)
- Store triangles as triples of indices (i, j, k)
- Use Barycentric Interpolation to define the points inside triangles.
- You can think of the triangle mesh as a linear interpolation of a point cloud.

**REVISIT THE BARYCENTRIC INTERPOLATION PROCESSING THEY ARE EXPLAINING**

### Recall: Linear Interpolation
You have Barycentric basis functions and you are using locations in space as the coordinates of these basis functions.
Why should we limit ourselves to *linear* basis functions?
Can we get more interesting geometry using other bases?

Bernstein Basis
- Linear interpolation essentially uses 1st order polynomials
- Provide more flexibility by using higher order polynomials.
- Instead of using the usual basis, i.e. $(1, x, x^2, x^3, ...)$, we use the Bernstein basis:
**INSERT EQUATION AND DIAGRAM**


### Bezier Curves
- A Bezier curve is a curve expressed in the Bernstein basis:
**Insert Equation**
- For n = 1, you just get a line segment.
- For n = 3, you get the "cubic Bezier".
- The Bezier curve has the following important features:
1. Interpolates endpoints
2. Tangent to end segments
3. Contained in convex hull (nice for rasterization)
**Check what the above points mean**
If you want to curve with more control points, what should be done?
Increase the degree of the Bernstein basis?
Although the Bezier curve will interpolate the two points, they only approximate the immediate points. Makes high degree Bezier curves hard to control.
**Insert diagram**

### Piecewise Bezier Curves
A better approach is to piece together many Bezier curves. This is a widely used technique in Illustrator, fonts, SVG, etc.)
**INSERT DIAGRAM**
Formally, the piecewise Bezier curve looks like this:
**INSERT EQUATION AND UNDERSTAND WHAT'S GOING ON**

### Bezier Curves - tangent continuity
To have a nice, seamless transition from one piece to the next, there are two requirements:
1. the endpoints must meet so that there are no gaps.
2. the tangents are the same at the meeting points so that the transition is smooth.
**INSERT DIAGRAM**

A good way to approach this is to count how many constraints and degrees of freedom are there, how many conditions are you trying to satisfy, how many degrees of freedom are you allowed to manipulate?

How many degrees of freedom are there in the 4 points mentioned above ($p1, p2, p3, p4$)? 
Do we think of it as 4 degrees of freedom, or since each of the points has two coordinates, do we think of it as 8 degrees of freedom?

Good to differentiate between scalar degrees of freedom and vector degrees of freedom.

How many constraints are there in this case?
2 - endpoints must meet and tangents must meet.


**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**
**INSERT DIAGRAM**









