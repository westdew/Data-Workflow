

rm(list=ls())

library(tidyverse)

set.seed(1)

constrain <- function(val, min, max) {
  case_when(
    val < min ~ min,
    val > max ~ max,
    TRUE ~ val
  )
}

### Simple Reshape (wide to long)

N <- 1000
tests <- data.frame(
  id = 1:N,
  test_1 = rnorm(N, 100, 25)
) %>%
  mutate(
    test_2 = test_1 + rnorm(N, 5, 5),
    test_3 = test_2 + rnorm(N, 5, 5),
    test_4 = test_3 + rnorm(N, 5, 5)
  )

tests_long <- pivot_longer(
  tests,
  starts_with("test"),
  names_to = "testnum",
  names_prefix = "test_",
  values_to = "testscore"
)

## long to wide

tests_wide <- pivot_wider(
  tests_long,
  id,
  names_from = testnum,
  names_glue = "test_{testnum}",
  values_from = testscore
)

### Complex Reshape

### Multiple variables as columns (long to wide)

## ID | *testnum* | *testsbj* | testscore

rm(list=ls())

set.seed(1)

N <- 8000
tests <- data.frame(
  id = rep(1:(N/8), each=8),
  testnum = rep(1:4, times=N/4),
  testsbj = rep(c("ela", "math"), each=4, times=N/8),
  testscore = rnorm(N, 100, 25),
  stringsAsFactors = FALSE
)

tests_wide <- pivot_wider(
  tests, 
  id, 
  names_from = c(testsbj, testnum), 
  names_prefix = "test_",
  values_from = testscore
)

## wide to long

tests_long <- pivot_longer(
  tests_wide,
  starts_with("test"),
  names_to = c("testsbj", "testnum"),
  names_sep = "_",
  names_prefix = "test_",
  values_to = "testscore"
) %>% select(id, testnum, testsbj, testscore)

### Multiple observations per row (wide to long)

## ID | test_1 | test_2 | rushflag_1 | rushflag_2

rm(list=ls())

set.seed(1)

N <- 1000
tests <- data.frame(
  id = 1:N,
  test_1 = rnorm(N, 100, 25)
) %>%
  mutate(
    test_2 = test_1 + rnorm(N, 5, 5),
    test_3 = test_2 + rnorm(N, 5, 5),
    test_4 = test_3 + rnorm(N, 5, 5),
    rushflag_1 = as.integer(runif(N) > 0.99),
    rushflag_2 = as.integer(runif(N) > 0.98),
    rushflag_3 = as.integer(runif(N) > 0.95),
    rushflag_4 = as.integer(runif(N) > 0.90)
  )

tests_long <- pivot_longer(
  tests,
  -id,
  names_to = c(".value", "testnum"),
  names_sep = "_",
) %>% magrittr::set_colnames(c("id", "testnum", "testscore", "rushflag"))

## long to wide

tests_wide <- pivot_wider(
  rename(tests_long, test = testscore),
  id,
  names_from = "testnum", 
  names_sep = "_",
  values_from = c("test", "rushflag")
)
