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
jsonlite::toJSON(tit_tb, dataframe="row", auto_unbox=TRUE)
