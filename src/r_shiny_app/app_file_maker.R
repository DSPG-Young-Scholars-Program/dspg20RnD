#Create files for import into shiny app

final_abstracts <- read.csv("~/git/dspg20rnd/dspg20RnD/data/final/app_data.csv")

library(tidyverse)
library(tidytext)

#tidied abstracts

tidy_words <- tibble(text = final_abstracts$final_frqwds_removed)

tidy_words <- tidy_words %>%
  unnest_tokens(word, text) %>%
  count(word, sort = TRUE)

write.csv(tidy_words, "tidy_words.csv")

#Abstracts tidied by department
tidy_abstracts <- tibble(dept = final_abstracts$DEPARTMENT, text = final_abstracts$final_frqwds_removed)

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
tidy_year <- tibble(year = raw_abstracts$FY, text = final_abstracts$final_frqwds_removed)

tidy_year <- tidy_year %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(year, word, sort = TRUE)

write.csv(tidy_year, "tidy_year.csv")
