#Create files for import into shiny app

raw_abstracts <- read.csv("~/git/dspg20rnd/dspg20RnD/data/original/working_federal_reporter_2020.csv")

library(tidyverse)
library(tidytext)

#Abstracts tidied by department
tidy_abstracts <- tibble(dept = raw_abstracts$DEPARTMENT, text = raw_abstracts$ABSTRACT)

tidy_abstracts <- tidy_abstracts %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(dept, word, sort = TRUE)

total_abstracts <- tidy_abstracts %>%
  group_by(dept) %>%
  summarize(total = sum(n))

tidy_abstracts <- left_join(tidy_abstracts, total_abstracts)

tidy_abstracts <- tidy_abstracts %>%
  bind_tf_idf(word, dept, n)

tidy_abstracts <- tidy_abstracts %>%
  select(dept, word, n, tf_idf)

write.csv(tidy_abstracts, "tidy_abstracts_dept.csv")

#Abstracts tidied by year
tidy_year <- tibble(year = raw_abstracts$FY.x, text = raw_abstracts$ABSTRACT)

tidy_year <- tidy_year %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(year, word, sort = TRUE)

write.csv(tidy_year, "tidy_year.csv")
