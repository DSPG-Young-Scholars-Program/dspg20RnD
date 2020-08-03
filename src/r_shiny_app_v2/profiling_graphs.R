
data_for_liz %>%
  count(DEPARTMENT) %>%
  mutate(perc = (n / nrow(data_for_liz)) *100) %>%
  ggplot(aes(x = DEPARTMENT, y = perc, fill = DEPARTMENT)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  ylim(0, 100) +
  labs(x = "Department", y = "Percent of Dataset") +
  ggtitle("Abstract Count by Funding Department") +
  theme_bw() -> dept_gr


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
  theme(axis.text.x = element_text(angle = 30)) -> date_gr

data_for_liz$ab_char <- nchar(data_for_liz$ABSTRACT)
mean(data_for_liz$ab_char)
min(data_for_liz$ab_char)
max(data_for_liz$ab_char)

data_for_liz %>%
  filter(ab_char < 10001) %>%
  ggplot(aes(x = ab_char)) +
  geom_histogram(binwidth = 100, fill = "#0072B2") +
  ggtitle("Number of Characters per Abstracts") +
  theme_bw() -> char_hist

grid.arrange(dept_gr, date_gr, char_hist, nrow = 2)


