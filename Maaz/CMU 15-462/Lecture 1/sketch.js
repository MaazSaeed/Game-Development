// Cube's vertices
let vertices = {A: [1, 1, 1],
                B: [-1, 1, 1],
                C: [1, -1, 1],
                D: [-1, -1, 1],
                E: [1, 1, -1],
                F: [-1, 1, -1],
                G: [1, -1, -1],
                H: [-1, -1, -1]};

let edges = ["AB", "CD", "EF", "GH",
             "AC", "BD", "EG", "FH",
             "AE", "CG", "BF", "DH"];


// the camera location.
let [cx, cy, cz] = [2, 3, 5];


let newEdges = [];
for(let edge of edges) {
  [start, end] = edge.split``.map(v => vertices[v]);
  [sx, sy, sz] = [start[0] - cx, start[1] - cy, start[2] - cz];
  [ex, ey, ez] = [end[0] - cx, end[1] - cy, end[2] - cz];
  
  [suv1, suv2] = [sx / sz, sy / sz];
  [euv1, euv2] = [ex / ez, ey / ez];
  
  newEdges.push([suv1, suv2, euv1, euv2]);
}


function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(255);
  for(edge of newEdges) {
    [x1, y1, x2, y2] = edge;
    stroke(0);
    strokeWeight(3);
// the values of u and v are between -1 and 1, mapping them onto
    // the p5.js canvas
    line(map(x1, -1, 1, 0, width), map(y1, -1, 1, 0, height),
         map(x2, -1, 1, 0, width), map(y2, -1, 1, 0, height));
  }
}