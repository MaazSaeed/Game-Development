# Lecture 11: Digital Geometry Processing (CMU 15-462/662)

Digital geometry processing builds upon the concepts of digital signal processing. We will study geometric signals, which also deal with the concepts of signal processing, e.g.
- upsampling
- downsampling
- resampling
- filtering
- aliasing

Beyond pure geometry, these are basic building blocks for many areas and algorithms in graphics, such as rendering and animation.

The geometry processing pipline is not as specific as the rasterization pipeline, but it is broken into three stages:
1. Scan an object in the real world.
2. Process it in an algorithmic way, analyse it, edit it, transform it.
3. Print back out the changes we have made to it.