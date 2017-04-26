library(d3r)
library(htmltools)
library(pipeR)

d3_ann <- htmlDependency(
  name = "d3-annotation",
  version = "1.12.1",
  src = c(href = "https://unpkg.com/d3-svg-annotation@1.12.1/"),
  script = "d3-annotation.js",
  stylesheet = "d3-annotation.css"
)

example1 = '
const type = d3.annotationLabel

const annotations = [{
  note: {
    label: "Longer text to show text wrapping",
    title: "Annotations :)"
  },
  //can use x, y directly instead of data
  data: { date: "18-Sep-09", close: 185.02 },
  dy: 137,
  dx: 162
}]

const parseTime = d3.timeParse("%d-%b-%y")
const timeFormat = d3.timeFormat("%d-%b-%y")

//set domains even though skipped in original example
const x = d3.scaleTime()
  .range([0, 800])
  .domain([new Date("2009-09-01"),new Date("2009-09-30")])
const y = d3.scaleLinear()
  .range([300, 0])
  .domain([0,200])

const makeAnnotations = d3.annotation()
  .editMode(true)
  .type(type)
  //accessors & accessorsInverse not needed
  //if using x, y in annotations JSON
  .accessors({
    x: d => x(parseTime(d.date)),
    y: d => y(d.close)
  })
  .accessorsInverse({
    date: d => timeFormat(x.invert(d.x)),
    close: d => y.invert(d.y)
  })
.annotations(annotations)

d3.select("svg")
  .append("g")
  .attr("class", "annotation-group")
  .call(makeAnnotations)
'

tagList(
  tag("svg", list(style = 'height:300px; width:800px; background-color:gray50;')),
  tags$script(HTML(example1)),
  d3_dep_v4(),
  d3_ann
) %>>%
  browsable()


# now let's try it with svglite
library(svglite)

plot(1:10, type="b")
rp <- recordPlot()
size = dev.size()
plt = par("plt")
usr = par("usr")

s <- svgstring(standalone=FALSE,width = size[1], height=size[2])
replayPlot(rp)
dev.off()

# this is just to make it render in RStudio
library(xml2)
svg_xml <- read_xml(as.character(s()))
cp_rect <- xml_find_first(svg_xml,"*//clipPath/rect")
cp_attr <- lapply(
  list(
    x = xml_attr(cp_rect,"x"),
    y = xml_attr(cp_rect,"y"),
    height = xml_attr(cp_rect,"height"),
    width = xml_attr(cp_rect,"width")
  ),
  as.numeric
)

# drawing with no knowledge of plot from R
#   using example1
tagList(
  tags$style(".annotation-note-bg {stroke: none;}"),
  HTML(s()),
  tags$script(HTML(
sprintf(
'
vb = d3.select("svg").attr("viewBox").split(" ");
var width = +vb[2];
var height = +vb[3];

var svg = d3.select("svg");

var margins = %s;
var usr = %s;

var type = d3.annotationLabel;

var annotations = [
{
  note: {
    label: "Point with x=3, y=3. Drag my points somewhere else.",
    title: "Annotations :)"
  },
  //can use x, y directly instead of data
  data: { x: 3, y: 3 },
  dy: -40,
  dx: 20
},
{
  note: {
    label: "x(8), y(8)",
    title: "another point"
  },
  //can use x, y directly instead of data
  data: { x: 8, y: 8 },
  dy: -40,
  dx: 20
}
]

// use clipPath rect for range of plot; multiplying usr * height
//  did not work on the y limits
//  but only because I did not research enough
//  and lazily assume that there will be a clipPath around our plot
//  and that it will be the first clipPath in our svg

// RStudio iframe security does not like following
//  so I elected to do after commented for this to work
/*
var cp = d3.select("clipPath rect");

//set domains even though skipped in original example
var x = d3.scaleLinear()
  //.range([width * margins[0], width*margins[1]])
  .range([parseFloat(cp.attr("x")), parseFloat(cp.attr("width")) + parseFloat(cp.attr("x"))])
  .domain([usr[0], usr[1]])
var y = d3.scaleLinear()
  //.range([height * margins[3], height * margins[2]])
  .range([parseFloat(cp.attr("height")) + parseFloat(cp.attr("y")), +cp.attr("y")])
  .domain([usr[0], usr[1]])
*/

var cp_attr = %s;
var x = d3.scaleLinear()
  .range([cp_attr.x, cp_attr.width + cp_attr.x])
  .domain([usr[0], usr[1]])
var y = d3.scaleLinear()
  .range([cp_attr.height + cp_attr.y, cp_attr.y])
  .domain([usr[0], usr[1]])

var makeAnnotations = d3.annotation()
  .editMode(true)
  .type(type)
  //accessors & accessorsInverse not needed
  //if using x, y in annotations JSON
  .accessors({
    x: function(d) { return x(d.x) },
    y: function(d) { return y(d.y) }
  })
  .accessorsInverse({
    x: function(d) { return x.invert(d.x) },
    y: function(d) { return y.invert(d.y) }
  })
  .annotations(annotations)

svg
  .append("g")
  .attr("class", "annotation-group")
  .call(makeAnnotations)
',
jsonlite::toJSON(plt),
jsonlite::toJSON(usr),
jsonlite::toJSON(cp_attr, auto_unbox=TRUE)
)
  )),
  d3_dep_v4(),
  d3_ann
) %>>%
  browsable()

