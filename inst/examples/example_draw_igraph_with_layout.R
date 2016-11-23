library(htmltools)
library(d3r)
library(igraph)
library(scales)

d3_draw_igraph <- function(
  igrf, layout=layout.auto, width=400, height=400, ...
){
  coords <- norm_coords(layout(igrf),0,width-30,0,height-30)
  V(igrf)$x <- coords[,1]
  V(igrf)$y <- coords[,2]
  json <- d3r::d3_igraph(igrf)

  browsable(
    attachDependencies(
      tags$script(
        HTML(
          sprintf(
  '
  var data = %s;

  //http://stackoverflow.com/questions/28102089/simple-graph-of-nodes-and-links-without-using-force-layout
  var width = %.0f;
  var height = %.0f;
  var svg = d3.select("body")
    .append("svg")
    .attr("width", width)
    .attr("height", height)
    .append("g")
      .attr("transform","translate(15,15)");

  data.nodes.forEach(function(d){
    d.x = +d.x;
    d.y = +d.y;
  })

  var drag = d3.drag()
    .on("drag", function(d, i) {
      d.x += d3.event.dx
      d.y += d3.event.dy
      d3.select(this).attr("cx", d.x).attr("cy", d.y);
      links.each(function(l, li) {
        if (l.source == d.id) {
          d3.select(this).attr("x1", d.x).attr("y1", d.y);
        } else if (l.target == d.id) {
          d3.select(this).attr("x2", d.x).attr("y2", d.y);
        }
      });
    });

  var links = svg.selectAll("link")
    .data(data.links)
    .enter()
    .append("line")
    .attr("class", "link")
    .attr("x1", function(l) {
      var sourceNode = data.nodes.filter(function(d, i) {
        return d.id == l.source
      })[0];
      d3.select(this).attr("y1", sourceNode.y);
      return sourceNode.x
    })
    .attr("x2", function(l) {
      var targetNode = data.nodes.filter(function(d, i) {
        return d.id == l.target
      })[0];
      d3.select(this).attr("y2", targetNode.y);
      return targetNode.x
    })
    .attr("fill", "none")
    .attr("stroke", "black");

  var nodes = svg.selectAll("node")
    .data(data.nodes)
    .enter()
    .append("circle")
    .attr("class", "node")
    .attr("cx", function(d) {
      return d.x
    })
    .attr("cy", function(d) {
      return d.y
    })
    .attr("r", 10)
    .style("fill", function(d){return d.fill;})
    .style("stroke", "none")
    .call(drag);
'
            ,
            json,
            width,
            height
          )
        )
      ),
      d3_dep_v4()
    )
  )
}



data("karate", package="igraphdata")
# simple community example
wc <- cluster_walktrap(karate)
# apply some color to the nodes
V(karate)$fill <- col_factor(palette="Set1",domain=NULL)(membership(wc))
d3_draw_igraph(karate)
