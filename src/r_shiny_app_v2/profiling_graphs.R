
data_for_liz %>%
  ggplot(aes(x = DEPARTMENT, fill = DEPARTMENT)) +
  geom_bar(show.legend = FALSE) +
  ggtitle("Abstract Count by Funding Department") +
  theme_bw()


data_for_liz %>%
  ggplot(aes(x = as.factor(FY), fill = as.factor(FY))) +
  geom_bar(show.legend = FALSE) +
  labs(x = "Year") +
  ggtitle("Abstract Count by Year") +
  theme_bw()

data_for_liz %>%
  filter(START_DATE > 1999) %>%
  ggplot(aes(x = as.factor(START_DATE), fill = as.factor(START_DATE))) +
  geom_bar(show.legend = FALSE) +
  xlab("Year") +
  ggtitle("Abstract Count by Project Start Year") +
  #labs(main = "Abstract Count by Project Start Year", x = "Year") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 30))

data_for_liz$ab_char <- nchar(data_for_liz$ABSTRACT)
mean(data_for_liz$ab_char)
min(data_for_liz$ab_char)
max(data_for_liz$ab_char)

data_for_liz %>%
  ggplot(aes(x = ab_char)) +
  geom_histogram(binwidth = 100) +
  ggtitle("Number of Characters per Abstracts") +
  theme_bw()
