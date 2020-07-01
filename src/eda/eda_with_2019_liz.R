library(tidyverse)
library(tidytext)

#Import Data
raw_abstracts <- read.csv('/project/biocomplexity/sdad/projects_data/ncses/prd/RND_Topic_Modelling/Raw_Data/raw_abstracts.csv')

abstracts_2019 <- raw_abstracts %>%
  filter(FY = 2019)

#Convert to tidy format and remove stopwords

tidy_all <- tibble(text = raw_abstracts$ABSTRACT)
tidy_2019 <- tibble(text = abstracts_2019$ABSTRACT)
tidy_titles <- tibble(text = raw_abstracts$PROJECT_TITLE)

tidy_all <- tidy_all %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_2019 <- tidy_2019 %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_titles <- tidy_titles %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

#Graphically display most prevalent words

tidy_2019 %>%
  count(word, sort = TRUE) %>%
  filter(n > 250000) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip("Words: 2019 Abstracts")

tidy_all %>%
  count(word, sort = TRUE) %>%
  filter(n > 200000) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  ggtitle("Words: All Abstracts")

tidy_titles %>%
  count(word, sort = TRUE) %>%
  filter(n > 10000) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  ggtitle("Titles: All Abstracts")

#Count abstracts by ___
count(raw_abstracts, FY)
ggplot(raw_abstracts) +
  geom_bar(aes(x = FY))

count(raw_abstracts, DEPARTMENT)
ggplot(raw_abstracts) +
  geom_bar(aes(x = DEPARTMENT))

count(raw_abstracts, AGENCY)
ggplot(raw_abstracts) +
  geom_bar(aes(x = AGENCY))

ggplot(raw_abstracts) +
  geom_histogram(aes(x = FY_TOTAL_COST), binwidth = 500000)

