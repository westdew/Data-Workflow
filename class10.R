rm(list=ls())

library(tidyverse)
library(lubridate)
library(patchwork)
library(rmarkdown)

# import data
raw <- read_csv("data/2018-2021_Daily_Attendance_by_School.csv")

# wrangle data
analytic <- raw %>%
  mutate(
    dbn = `School DBN`,
    school_year = SchoolYear,
    per_present = Present/Enrolled*100,
    date = mdy(Date)
  ) %>%
  arrange(dbn, school_year, date) %>%
  group_by(dbn, school_year) %>%
  mutate(day = 1:n()) %>%
  select(dbn, school_year, date, day, per_present)

# save data
save(analytic, file="data/nyc1821.RData")

# plot schools using for loop
dbns <- sample(unique(analytic$dbn), 10)
for(d in dbns) {
  df <- analytic %>% filter(dbn == d)
  
  p1 <- ggplot(df) +
    geom_line(aes(x = day, y = per_present)) +
    facet_wrap(vars(school_year))
  
  p2 <- ggplot(df) +
    geom_line(aes(x = day, y = per_present, group = school_year, color = as.factor(school_year)))
  
  p <- p1 / p2
  
  ggsave(paste0("assets/", d, ".png"), p)
}

# plot schools using apply
# dbns <- sample(unique(analytic$dbn), 10)
# plot_per_present <- function(d) {
#   df <- analytic %>% filter(dbn == d)
#   
#   p1 <- ggplot(df) +
#     geom_line(aes(x = day, y = per_present)) +
#     facet_wrap(vars(school_year))
#   
#   p2 <- ggplot(df) +
#     geom_line(aes(x = day, y = per_present, group = school_year, color = as.factor(school_year)))
#   
#   p <- p1 / p2
#   
#   ggsave(paste0("assets/", d, ".png"), p)
# }
# output <- sapply(dbns, plot_per_present)

# generate school pdfs using for loops

dbns <- sample(unique(analytic$dbn), 10)
for(d in dbns) {
  params <- list(
    dbn = d
  )
  render(
    "class10.Rmd", 
    output_file = paste0("assets/", d, ".pdf"),
    params = params,
    knit_root_dir = getwd(),
    envir = new.env(parent = globalenv())
    )
}
