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

#All topics
all_topics <- read_csv("~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/seventyfivetopicsdf (2).csv")
all_topics <- all_topics %>%
  filter(START_YEAR > 2009)

write.csv(all_topics, "~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/seventyfivetopicsdf.csv")

topics <- all_topics %>%
  group_by(Topic, `Top 10 Words`) %>%
  summarise(`Top 10 Words` = paste0(unique(`Top 10 Words`), collapse = " "))

write.csv(topics, "~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/all_topics.csv")

#Coronavirus topics
corona <- read_csv("~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/FINALthirtycoronatopics (2).csv")
corona <- corona %>%
  filter(START_YEAR > 2009)

write.csv(corona, "~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/thirtycoronatopics.csv")

corona_topic <- corona %>%
  group_by(Topic, `Top 10 Words`) %>%
  summarise(`Top 10 Words` = paste0(unique(`Top 10 Words`), collapse = ""))

write.csv(corona_topic, "~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/corona_topic.csv")

#Pandemics topics

pandemic <- read_csv("~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/FINALthirtypandemictopics (1).csv")
pandemic <- pandemic %>%
  filter(START_YEAR > 2009)

write.csv(pandemic, "~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/thirtypandemictopics.csv")

pandemic_topic <- pandemic %>%
  group_by(Topic, `Top 10 Words`) %>%
  summarise(`Top 10 Words` = paste0(unique(`Top 10 Words`), collapse = " "))

write.csv(pandemic_topic, "~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/pandemic_topic.csv")
