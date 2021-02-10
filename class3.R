
rm(list=ls())

# install.packages("tidyverse")
library(tidyverse)

md_scs <- read_csv("data/2019_Accountability_Schools.csv")

## Base R

# Add/Manipulate Variable
#lss.numbers <- sprintf("%02d", md_scs$`LSS Number`)
#school.numbers <- sprintf("%04d", md_scs$`School Number`)
#md_scs$state.id <- paste0(lss.numbers, school.numbers)

# md_scs$state.id <- paste0(
#   sprintf("%02d", md_scs$`LSS Number`),
#   sprintf("%04d", md_scs$`School Number`)
# )

#md_scs$`LSS Name` <- tolower(md_scs$`LSS Name`)

# Change Variable Names

#colnames(md_scs) <- 1:11
#colnames(md_scs) <- c("year", "lss_number"........) # type them all out
#colnames(md_scs) <- gsub(" ", ".", tolower(colnames(md_scs)))

# Keep or Drop Variables
#md_scs[,c("school.name", "star.rating", "state.id")] # keep

#md_scs[,setdiff(colnames(md_scs), c("year"))] # drop

## Dplyr

### RENAME

analytic <- rename(md_scs, year = Year, lss.number = `LSS Number`)

colnames(md_scs) <- gsub(" ", ".", tolower(colnames(md_scs)))

### SELECT

# Keep Variables
analytic <- select(md_scs, school.name, star.rating)
#select(md_scs, "School Name", "Star Rating")

# Drop Variables
analytic <- select(md_scs, -year)

### MUTATE

# Add/Manipulate Variable
analytic <- mutate(md_scs, 
  state.id = paste0(
    sprintf("%02d", lss.number),
    sprintf("%04d", school.number)
    ),
  lss.name = tolower(lss.name),
  star.rating = star.rating * 3
)

#mutate(md_scs, star.rating = star.rating * 3)

### FILTER

# Add/Remove Observations
analytic <- filter(md_scs, lss.number == 30)

analytic <- filter(md_scs, lss.number == 30, star.rating > 2)                         

##### PART 2 #####


rm(list=ls())

# install.packages("tidyverse")
library(tidyverse)

analytic_raw <- read_csv("data/2019_Accountability_Schools.csv")

## Make a plan

# Variables:
# - schid : School Number (integer)
# - schname : School Name (string)
# - rating : Star Rating (integer)
# - totalpts : Total Points Earned Percentage (integer)
# Observations: Baltimore City Schools and Baltimore County Schools

## Select the variables you want

analytic <- select(analytic_raw, `School Number`, `School Name`, `LSS Number`, `Total Points Earned Percentage`, `Star Rating`)

## Rename the variables

colnames(analytic) <- c("schid", "schname", "lssid", "totalpts" , "rating")

## Select the observations you want

analytic <- filter(analytic, lssid == 30 | lssid == 3)
analytic <- select(analytic, -lssid)

## Recode variables
analytic <- mutate(analytic, totalpts = totalpts/100)

## Save
save(analytic, analytic_raw, file="data/analytic.Rdata")

#rm(list=ls())
#load("data/analytic.Rdata")

##### PART 3 #####

analytic_raw <- mutate_all(analytic_raw, function(x) { ifelse(x == "na", NA, x) })

analytic_raw %>% filter(., complete.cases(.))

analytic_raw %>% filter(., !complete.cases(.))
