rm(list=ls())

library(tidyverse)

strings <- c("ab", "abc", "abdab", "abe", "ab 12")

grep("abc", strings, value=F) # vector of match indices
grep("abc", strings, value=T) # vector of matches
grepl("abc", strings) # logical vector
sub("ab", "123", strings) # replace first instance
gsub("ab", "123", strings) # replace all instances

library("gapminder")

View(gapminder)

countries <- unique(as.character(gapminder$country))

grep("(i|t)", countries, value=T)

sub("land", "LAND", grep(".*[itIT].*land$", countries, value=T))
