(function() {library(htmltools)
library(d3r)
library(treemap)

d3flex = htmlDependency(
  name="d3-flextree",
  version="0.1",
  src=c(href="https://cdn.rawgit.com/timelyportfolio/d3-flextree/573c60f8/build"),
  script="d3-flextree.js"
)

data(GNI2014)
tm <- treemap(
  GNI2014,
  index = c("continent", "country"),
  vSize = "population"
)$tm

tm_nest <- d3_nest(
  tm,
  value_cols = colnames(tm)[-(1:2)]
)
})()

scr_part <- function() {
  tags$script(HTML(
sprintf(
"
var tm = %s;

var tm_h = d3.hierarchy(tm)
  .sum(function(d){
    return d.colname==='country' ? d.vSize : 0
  })
  .sort(function(a,b){
    return b.value - a.value
  });

var width = 600;
var height = 400;
var nodeHeight = 200;
var nodeWidth = 10;

d3.treemap()
  .size([nodeWidth, nodeHeight])
  .tile(d3.treemapSlice)(tm_h);

tm_h.each(function(d) {
  d.h = d.y1 - d.y0;
  d.w = d.x1 - d.x0;
});

d3.partition()(tm_h);

var svg = d3.select('body').append('svg')
  .style('width',width + 20 + 20)
  .style('height',height + 20 + 20)
  .append('g')
  .attr('transform','translate(20,20)');

var nodes = svg.selectAll('g.node')
  .data(tm_h.descendants());

nodes = nodes.merge(
  nodes.enter().append('g')
    .classed('node', true)
);

nodes.attr('transform', function(d) {
  return d.height > 0 ?
    'translate(' + d.y0 * height  + ',' + ((d.x0 * height) + ((d.x1-d.x0)*height-d.h)/2 ) + ')' :
    'translate(' + d.y0 * height  + ',' + d.x0 * height + ')'
});

nodes.append('rect')
  .attr('width', function(d) { return nodeWidth; })
  .attr('height', function(d) { return d.h; })
  .style('fill', function(d) { return d.data.color || 'gray'; });

// from https://github.com/fbreitwieser/sankeyD3/blob/master/inst/htmlwidgets/lib/d3-sankey/src/sankey.js
function xy(x,y) { return x + ',' + y; }

// M(x,y) moveto function - moves pen to new location; doesn't draw
function M(x,y)  { return 'M' + xy(x,y); }

// C(x1,y1,x2,y2,x,y) curveto function
//   draws a cubic bezier curve from the current point to (x,y)
//   using (x1,y1) and (x2,y2) as control points
function C(x1,y1,x2,y2,x,y)  { return 'C' + xy(x1,y1) + ' ' + xy(x2,y2) + ' ' + xy(x,y); }

// S(x2,y2,x,y) smooth curveto function
//   draws a cubic bezier curve from the current point to (x,y)
//   with the first control point being a reflection of (x2,y2)
function C(x1,y1,x2,y2,x,y)  { return 'C' + xy(x1,y1) + ' ' + xy(x2,y2) + ' ' + xy(x,y); }

// L(x,y) lineto function - moves pen to new location; doesn't draw
function L(x,y)  { return 'L' + xy(x,y); }

// Z() closepath function - line is drawn from last point to first
function Z()  { return 'Z'; }

// V(y) vertical lineto function - draw a horizontal line from the current point to y
function V(y)  { return 'V' + y; }

// v(dy) vertical lineto function - draws a horizontal line from the current point for dy px
function v(dy)  { return 'v' + dy; }

// H(y) horizontal lineto function - draw a horizontal line from the current point to x
function H(x)  { return 'H' + x; }

function stack(x) {
  var xobj = {};
  var sum = d3.sum(x.children, function(d) {return d.h} )
  x.children.forEach(function(d) {
    xobj[d.data.name] = d.h/sum;
  })
  return d3.stack().keys(Object.keys(xobj))([xobj]);
}

nodes.each(function(node) {
  if(!node.children) {return}
  var st = stack(node);
  st.forEach(function(d,i) {
    var child = node.children[i]
    var link = svg.append('path')
      .classed('link', true);
    if(node.height === 1) {
      link.attr('d',d3.line()([
          [node.y0 * height + nodeWidth, ((node.x0 * height) + ((node.x1-node.x0)*height-node.h)/2 ) + d[0][0]*node.h],
          [child.y0 * height, child.x0 * height],
          [child.y0 * height, child.x0 * height + child.h],
          [node.y0 * height + nodeWidth, ((node.x0 * height) + ((node.x1-node.x0)*height-node.h)/2 ) + d[0][1]*node.h],
          //[node.y0 * height + nodeWidth, ((node.x0 * height) + ((node.x1-node.x0)*height-node.h)/2 )]
        ]))
    } else {
      link.attr('d',d3.line()([
        [node.y0 * height + nodeWidth, ((node.x0 * height) + ((node.x1-node.x0)*height-node.h)/2 ) + d[0][0]*node.h],
        [child.y0 * height, ((child.x0 * height) + ((child.x1-child.x0)*height-child.h)/2 )],
        [child.y0 * height, ((child.x0 * height) + ((child.x1-child.x0)*height-child.h)/2 ) + child.h],
        [node.y0 * height + nodeWidth, ((node.x0 * height) + ((node.x1-node.x0)*height-node.h)/2 ) + d[0][1]*node.h],
        //[node.y0 * height + nodeWidth, ((node.x0 * height) + ((node.x1-node.x0)*height-node.h)/2 )]
      ]))
    }

    link
      .style('stroke', child.data.color)
      .style('fill', child.data.color)
      .style('opacity', 0.7);

  })

})
nodes.append('text')
  .style('text-anchor','end')
  .text(function(d) { return d.data.name});

",
tm_nest
)
))
}

browsable(
  tagList(
    d3_dep_v4(offline=FALSE),
    scr_part()
  )
)
