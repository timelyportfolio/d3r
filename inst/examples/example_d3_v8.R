\dontrun{

# to do this all in R, please see ggraph
# https://github.com/thomasp85/ggraph
# by Thomas Lin Pedersen
library(d3r)

# make a simple data.frame of US state data
states <- data.frame(
  region = as.character(state.region),
  state = as.character(state.abb),
  population = state.x77[,"Population"],
  stringsAsFactors = FALSE
)

# use d3_nest to get the data.frame in a d3 hierarchy
state_hier <- d3_nest(
  states,
  value_cols = "population"
)

# use d3_v8 to do something useful with d3 and, our state data
ctx <- d3_v8()
ctx$eval(sprintf(
  " var states = %s",
  state_hier
))
ctx$eval(
"
// we assigned the variable states above
//  so now make it a real d3 hierarchy
var root = d3.hierarchy(states);

// sum on population
root.sum(function(d) {return d.population ? d.population : 0});


// use d3 to circle pack or state hierarchy
d3.pack()(root);

// get something we can convert into a data.frame in R
var states_packed = [];
root.each(function(d) {
  states_packed.push({
    name: d.data.name,
    radius: d.r,
    x: d.x,
    y: d.y
  });
});
"
)

# now get states_packed from our context
#  to plot in R
states_packed <- ctx$get("states_packed")
opar <- par(no.readonly=TRUE)
# make it square
par(pty="s")
symbols(
  states_packed$x,
  states_packed$y,
  states_packed$radius,
  inches=FALSE,
  asp=1
)
text(y~x, data=states_packed, labels=states_packed$name)
# return to original par before we made it square
par(opar)

# d3.quadtree example

library(d3r)

x = runif(100)
y = runif(100)

ctx <- d3_v8()
# assign pts as array of pts in V8
ctx$assign("pts", matrix(c(x,y),ncol=2,byrow=TRUE))
# use d3.quadtree() to plot rects
ctx$eval(
  "
  var d3q = d3.quadtree()
  .addAll(pts);
  // nodes function from https://bl.ocks.org/mbostock/4343214
  function nodes(quadtree) {
  var nodes = [];
  quadtree.visit(function(node, x0, y0, x1, y1) {
  nodes.push({x0:x0, y0:y0, x1: x1, y1: y1})
  });
  return nodes;
  }
  "
)

nodes <- ctx$get("nodes(d3q)", simplifyVector = FALSE)
# draw points
opar <- par(no.readonly=TRUE)
# make it square
par(pty="s")
plot(y~x)
# draw quadtree rects
rect(
  lapply(nodes,function(x){x$x0}),
  lapply(nodes,function(x){x$y0}),
  lapply(nodes,function(x){x$x1}),
  lapply(nodes,function(x){x$y1})
)
par(opar)
}
