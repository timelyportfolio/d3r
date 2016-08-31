\dontrun{
library(igraph)
library(igraphdata)
library(d3r)

# with random graph
d3r::d3_igraph(igraph::sample_pa(100))

# check case where vertices 0 cols
d3_igraph(igraph::watts.strogatz.game(1, 50, 4, 0.05))

# with karate from igraphdata
#  notice graph attributes are added
data("karate",package="igraphdata")
(karate_d3 <- d3r::d3_igraph(karate))

listviewer::jsonedit(karate_d3)

data("kite",package="igraphdata")
listviewer::jsonedit(d3_igraph(kite))
}
