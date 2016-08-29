# convert Titanic to a nested d3 hierarchy

# devtools::install_github("timelyportfolio/d3r")
library(d3r)
library(dplyr)

titanic_df <- data.frame(Titanic)
tit_tb <- titanic_df %>%
  select(Class,Age,Survived,Sex,Freq) %>%
  d3_nest(value_cols="Freq", root="titanic")

tit_tb

# see as json
d3_json(tit_tb)

# see the structure with listviewer
d3_json(tit_tb) %>%
  listviewer::jsonedit()
