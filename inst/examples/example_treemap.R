\dontrun{
  library(treemap)
  library(d3r)
  library(dplyr)
  library(tidyr)

  treemap::random.hierarchical.data() %>%
    d3_nest(value_cols = "x")

  # use example from ?treemap
  data(GNI2014)
  treemap(
    GNI2014,
    index=c("continent", "iso3"),
    vSize="population",
    vColor="GNI",
    type="value",
    draw=FALSE
  ) %>%
    {.$tm} %>%
    select(continent,iso3,color,vSize) %>%
    d3_nest(value_cols = c("color", "vSize"))
}
