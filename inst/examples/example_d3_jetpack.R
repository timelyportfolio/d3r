\dontrun{

library(d3r)
library(htmltools)

tl <- tagList(tags$script(HTML(sprintf(
"
var x = 5;

var svg = d3.select('body')
    .append('svg');

svg.append('rect')
    .at({
        x: 100,
        y: 100,
        width: 100,
        height: 100
    })
    .st({
        fill: 'blue',
        stroke: 'purple'
    });
"
))), d3_dep_v4(), d3_dep_jetpack())
browsable(tl)



tl <- tagList(tags$script(HTML(sprintf(
 "
 var svg = d3.select('body')
     .append('svg');

 test_data = [{x: 250, y: 250}, {x: 300, y: 300}, {x: 300, y: 100}];

 svg.appendMany(test_data, 'circle')
     .at({
         cx: function(d){return d.x},
         cy: function(d){return d.y},
         r: 50
     })
     .st({
         fill: 'purple',
         stroke: 'blue'
     });
 "
))), d3_dep_v4(), d3_dep_jetpack())

browsable(tl)

}
