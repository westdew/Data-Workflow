
rm(list=ls())

library(tidyverse)
library(readxl)

### Part 1: Merge Data

## Make a plan
# - schid
# - schname
# - gradeband
# - pew_swd
# - per_el
# - star_rating
# Observations: Traditional Schools in Baltimore City Schools

## Import data & munging & cleaning

# a <- c(1, 2, 3, 4, 5, 6)
# 
# tmp <- mean(a)
# tmp <- round(tmp)
# paste0(tmp, "%")
# 
# paste0(round(mean(a, na.rm=T), 4), "%")
# 
# a %>% mean(na.rm=T) %>% round(4) %>% paste0("%")

# State Accountability

# import and select
md_sch_report_cards <- read_csv("data/2019_Accountability_Schools.csv") %>%
  select("School Number", "School Name", "Star Rating", "LSS Number")

# rename (no spaces!)
colnames(md_sch_report_cards) <- c("schid", "schname", "star_rating", "lssid")

# munge & clean
md_sch_report_cards <- md_sch_report_cards %>%
  filter(lssid == 30) %>% # Baltimore City
  select(-lssid) %>%
  mutate(schid = as.character(schid))

# Local Demographic

# import and select
bmore_sch_enrollment <- read_excel("data/2018-19-CitySchoolsSchoolandDistrictLevelEnrollment.xlsx") %>%
  select("School Number", "School Name", "Gradeband", "School Type", "% SWD", "% EL")

# rename (no spaces!)
colnames(bmore_sch_enrollment) <- c("schid", "schname", "gradeband", "schtype", "per_swd", "per_el")

# munge & clean
bmore_sch_enrollment <- bmore_sch_enrollment %>%
  filter(
    schid != "A",
    schtype == "Traditional"
  ) %>% 
  select(-schtype) %>%
  mutate(
    per_swd = per_swd*100,
    per_el = per_el*100
  )

## merging

analytic <- left_join(bmore_sch_enrollment, md_sch_report_cards, by = "schid")

#select(analytic, starts_with("schname")) %>% filter(schname.x != schname.y & schname.x != paste0(schname.y, " School")) %>% View()

#filter(analytic, !complete.cases(analytic)) %>% View


# finish up

analytic <- analytic %>%
  filter(complete.cases(.)) %>%
  rename(schname = schname.x) %>%
  select(-schname.y)

# save

save(analytic, file="data/analytic.Rdata")
