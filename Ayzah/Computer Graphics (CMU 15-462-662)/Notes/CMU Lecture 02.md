# Lecture 02: Linear Algebra (cmu15-462/662)

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-1.jpg?height=636&width=727&top_left_y=954&top_left_x=799)

- vector: direction and magnitude

- $r$ and $\theta$-polar coordinates

$r$ and $\theta$ cannot be implemented in the cartesian coordinate system, you need $(x, y)$ for that system.

#### Rules of a Vector Space:

$\underline{u}+\underline{v}=\underline{v}+\underline{u}$

$\underline{u}+(\underline{v}+\underline{\omega})=(\underline{u}+\underline{v})+\underline{\omega}$

$\underline{v}+\underline{0}=\underline{0}+\underline{v}=\underline{v}$ ( Zero vector )

$\underline{v}$ has $-v  \quad \underline{v}+(-v)=0$

$1\underline{v} = \underline{v}$

$ a(b \underline{v})=b(a \underline{v})=(a b) \underline{v} $
$(a+b) \underline{v}=a \underline{v}+b \underline{v}$

If an object obeys these rules, even if it is not an arrow, it is still a vector space.

### Functions as vectors

A function could be the intensity of am image, could describe a piece of geometry, amplitude of sound vibration.

Can you add two functions?

# ************** PICTURE **************

$\uparrow f(x) \_$nm

$\xrightarrow\left[(f+g)\left(\AA^{(*)}\right]{=}\right.$

Simibrly for cons do the same for therese

### Norm of a Vector

length, norm, magnitude - used interchangeably.

Intuitively - now should capture how big the vector is.

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-2.jpg?height=1452&width=5604&top_left_y=1503&top_left_x=341)

### Natural Properties of Length

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-2.jpg?height=979&width=5926&top_left_y=3250&top_left_x=192)

$$
|c \underline{u}|=c|\underline{u}| \quad \underline{u}+\underline{v}|\underline{u}|+|\underline{v}| \geq|\underline{u}+\underline{v}|
$$

Norm: Formal Definition

Norm is any function that assigns a member to each vector and satisfies the following propertico.

$$
\begin{aligned}
& |\underline{v}| \geq 0 \\
& |\underline{v}| \geq 1=0 \\
& |a \underline{v}|=|a||\underline{v}| \\
& |\underline{u}|+|\underline{v}| \geq|\underline{u}+\underline{v}|
\end{aligned}
$$

### Euclidean Norm in Cartesian Coordinates

$$
|u|=\left|\left(u_{1}, \ldots, u_{n}\right)\right|=\sqrt{\sum_{i=1}^{n} u_{i}^{2}}
$$

$$
\begin{aligned}
& \underline{n}=(4,2) \\
& |u|=\sqrt{4^{2}+2^{2}}=\sqrt{20} \\
& =2 \sqrt{5}
\end{aligned}
$$

Does this formula salish all the natural, geometric properties of a noun?

1.1 nom of vector 1111 norm of function

$\mathcal{L}^{2}$ Norm of Functions

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-3.jpg?height=1301&width=2554&top_left_y=791&top_left_x=584)

Note that this formula is almost the same as the pairions one except thatthis is cantimons.

Note that the formula does not exactly salify, all the popeutics, because in accordance \#to the pepenties, it is not just the zee vector that cow have the zero nom, as the discontiomities are rumored by the integration.

Function $f(x) .1$ for $x=0.5$, else $f(x)=0$ pones that.

Example:

Find the $\mathcal{L}^{2}$ form of $f(x)=x \sqrt{3}$

$$
\sqrt{\int_{0}^{\prime}(x \sqrt{3})^{2} d x}=\sqrt{\int_{0}^{1} 3 x^{2} d x}=\sqrt{\left.x^{2}\right|_{0} ^{1}}=\sqrt{1^{3}-0^{3}}=\sqrt{1}=1 .
$$

Inner Product - Projecting and Scaling.
The angle between two vectors is vul.

The angle between tor vectors is very important to def determine the similacitige between the two, how well aligned are the thor rectors.

$$
\langle v, u\rangle=\underbrace{\langle u, v\rangle}
$$

length of the projection $v$ onto you

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-3.jpg?height=790&width=1411&top_left_y=6404&top_left_x=4074)

If you scale me of the vectors, the miner product will also be scaled

$\langle u, v\rangle$ being the sige of the shadow oast by. the nit nclor $v$ on $u$ them doubling is length should cast a shadow of thrice the length

$$
\langle 2 u, v\rangle=2\langle u, v\rangle
$$

$\langle\underline{u}, \underline{u}\rangle=1$ (with $n$ bing a nit vector) if $n$ is not a mit vector, then what is $<u, u$ = equal to?

$$
\begin{aligned}
& \hat{u}=\underline{u}|u| \rightarrow\langle\underline{u}, \underline{u}\rangle=\langle\hat{\dot{u}}|u|, \hat{u}|u|\rangle \\
& \langle\underline{u}, \underline{x}\rangle=\langle\underline{v}, \underline{u}\rangle \\
& =|u|^{2}\langle\hat{u}, \hat{u}\rangle \\
& \langle\underline{u}, u\rangle \geqslant 0 \\
& =|u|^{2} \cdot 1=|u|^{2} \\
& \langle\underline{u}, \underline{u}\rangle=0 \Leftrightarrow \underline{u}=0 \\
& \langle a \underline{u}, \underline{\underline{ }}\rangle=a\langle u, v\rangle \\
& \langle\underline{u}+\underline{v}, \underline{u}\rangle=\langle\underline{u}, \underline{w}\rangle+\langle\underline{v}, \underline{w}\rangle
\end{aligned}
$$

$2^{2}$ /mer Product of Zunctions

Tust like how we had nouns for furctians, we cam use the inor product to how well they live uo.

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-4.jpg?height=700&width=6122&top_left_y=4060&top_left_x=337)

Measuring images.

-10) if we use rom to find the interesting ingege, it cat with dond in one. \%ocater to this mether is the inturatig a ball the sily. in the phatas by taling the dus. of the edges in the photas by taking the devivateve. The more the edges, the more intiresting it is.

Linear us effine Maps.

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-4.jpg?height=1447&width=2266&top_left_y=7206&top_left_x=289)

alvays passes through the origin.

Affive-does not pass throng ougie.

Span

set of all vectors that cam be arittim as a linear combination

$$
\begin{aligned}
& a \underline{u}+b \underline{v} \\
& \operatorname{pan}\left(\underline{u}, \underline{-}, \ldots, \underline{u}_{k}\right)=\left\{\underline{x} \in V \mid \underline{x}=\sum_{i=1}^{k} a_{i} \underline{u}_{i}, a_{1}, \ldots, a_{k} \in \mathbb{R}\right\}
\end{aligned}
$$

Span and Linear Maps.

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-5.jpg?height=948&width=4460&top_left_y=2319&top_left_x=393)

Linear mop

image of a function all the points that cam be reachool by

applying a function ito its domain.

Basis

$$
\operatorname{span}\left(e_{1}, \ldots, e_{n}\right)=\mathbb{R}^{n}
$$

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-5.jpg?height=838&width=3414&top_left_y=4038&top_left_x=2660)

orlónormal

Gram Schmidt

Used to find othonounal basis from a given wet of basis vectors.

Gram Schmidt Nhoratmm

- nomadize the first recto- (ic divide by its leech)
- subtract any component of the frost ave fam the second one.
- nomalize $2^{n}$
- seat, sowing components of fist $k$ vectors from $k+1$.

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-5.jpg?height=1228&width=5593&top_left_y=7255&top_left_x=628)

Fourier Transform

Imuctians aloollave an orthonormal basis.

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-6.jpg?height=607&width=6169&top_left_y=1093&top_left_x=291)

System of Linear Equations

$x+2 y=3$ Unknown values are sometimes called "degrees of $4 x+5 y=6 \quad$ freedom; equations are sonstines called "constraints" $y=2 \quad x=-1$
![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-6.jpg?height=1672&width=5492&top_left_y=2858&top_left_x=352)

affine since the yetemu does not

Uniqueness, Existence of Solution e.
![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-6.jpg?height=2258&width=2672&top_left_y=5252&top_left_x=388)

![](https://cdn.mathpix.com/cropped/2024_07_01_e41a4f9ec9b3e80fbddeg-6.jpg?height=1255&width=2280&top_left_y=5226&top_left_x=3098)
any paint alar the hire.

no solution.

not every paint com be "reached" by $f$

matrices can be used for

1. symbolic manipulation 2 .munerical computation

$$
\begin{aligned}
& f(u)=u_{1} a_{1}+u_{2} a_{2} \\
& \text { how to encode as a matrix? } \quad A=\left[\begin{array}{ll}
a_{1}, x & a_{2}, x \\
a_{1}, y & a_{2}, y \\
a_{1}, 2 & a_{2}, z
\end{array}\right] \\
& {\left[\begin{array}{ll}
a_{1}, x & a_{2}, x \\
a_{2}, y & a_{2}, y \\
a_{1}, 2 & a_{2}, 2
\end{array}\right]\left[\begin{array}{l}
u_{1} \\
u_{2}
\end{array}\right]=\left[\begin{array}{ll}
a_{1}, x u_{1}+a_{2}, x u_{2} \\
a_{1}, y u_{1}+a_{2}, y u_{2} \\
a_{1}, z u_{1}+a_{2}, 3 u_{2}
\end{array}\right]}
\end{aligned}
$$

