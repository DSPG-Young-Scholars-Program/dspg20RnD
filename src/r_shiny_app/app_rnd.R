library(devtools)
library(shiny)
library(tidyverse)
library(shinydashboard)
library(plotly)
library(colourpicker)
library(leaflet)
library(leaflet.extras)
library(RColorBrewer)
library(sf)
library(shiny)
library(dplyr)
library(leaflet.extras)
library(shinythemes)
library(tableHTML)
library(ggplot2)
library(ggthemes)
library(viridis)
library(scales)
library(readxl)
library(GGally)
library(ggrepel)
library(naniar)
library(tidyverse)
library(tidytext)

#load data

raw_abstracts <- read.csv("~/git/dspg20rnd/dspg20RnD/data/original/working_federal_reporter_2020.csv")

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

# ui -----------------------------------------------------------------------------------------

ui <- fluidPage(
  theme = shinytheme("cosmo"),

  tags$style(type = "text/css", ".recalculating {opacity: 1.0;}"),
  tags$style(
    ".leaflet .legend {width:200px; text-align: left;}",
    ".leaflet .legend i{float: left;}",
    ".leaflet .legend label{float:left; text-align: left;}"
  ),
  tags$head(tags$style(HTML(" .sidebar { font-size: 40%; } "))),

  #headerPanel(
    #tags$a(href = "https://biocomplexity.virginia.edu/social-decision-analytics",
    #img(src = "Marks_wave_bolder-15.jpg",
        #class = "topimage", width = "50%", style = "display: block; margin-left: auto; margin-right: auto;" #)
    #)),
  hr(),

  fluidRow(width = 12,style = "margin = 20px",  column(12, align = "center", h2(strong("Emerging Topics in Research and Development")))),

  hr(),


  fluidRow(width = 12,
           column(1),
           column(10,
                  p(),
                  p('This project is for DSPG 2020 examining emerging topics in Research and Development using data from the Federal RePORTER database.')),
           column(1)),
  hr(),

  tabsetPanel(

    tabPanel(h4("EDA & Profiling"),

             fluidRow(width = 12,
                      column(10, align = 'center',
                             h3(strong('Exploratory Data Analysis'))),
                      column(10, p("Some early exploratory data analysis we did to get a feel for the size and the scope of our dataset."))),

             fluidRow(style = "margin: 20px;",
                      column(8, p("Count of Abstract by Year")),
                      column(width = 6, plotOutput("freq_year", width = "100%"))),

             fluidRow(style = "margin: 20px;",
                      column(8, p("Count of Abstract by Department")),
                      column(width = 6, plotOutput("freq_dept", width = "100%"))),

             fluidRow(style = "margin: 20px;",
                      column(8, p("Count of Abstract by Agency")),
                      column(width = 6, plotOutput("freq_agen", width = "100%"))),

             fluidRow(width = 12,
                      column(10, align = 'center',
                             h3(strong('Data Profiling'))),
                      column(10, p("Looking at some of the missing values in our dataset."))),

             fluidRow(style = "margin: 20px;",
                      column(8, p("Graph of NA values")),
                      column(width = 6, plotOutput("na", width = "100%"))),

    br()
    ),

    tabPanel(h4("Text Explorer"),
             fluidRow(width = 12,
                      column(10, align = 'center',
                             h3(strong('Text Explorer')))),

             fluidRow(style = "margin: 20px;",
                      column(8, p("Count of most frequent words")),
                      column(width = 6, plotOutput("wordcount", width = "100%"))),

             fluidRow(align = "center",
                      selectInput("department", "Funding Department",
                                  choices = list("DOD", "ED", "EPA", "HHS", "NASA", "NSF", "USDA", "VA"),
                                  selected = "HHS")),
             fluidRow(style = "margin: 20px;",
                      column(width = 6, plotOutput("important_words", width = "100%"))),

             br()
             ),

    tabPanel(h4("Topic Models"),

             fluidRow(width = 12, style = "margin: 20px 0px 20px 20px",
                      column(2),
                      column(1),
                      column(8, p("Topic Modeling is a thing we have done.")),
                      column(1)),

             fluidRow(width = 12, style = "margin: 20px",
                      navlistPanel(widths = c(2, 10),
                                   tabPanel("LDAvis",
                                            fluidRow(width = 12,
                                                     column(1),
                                                     column(10, h3(strong( "LDAvis")),
                                                            hr(),
                                                            strong("What is LDAvis?"))
                                   )),
                                   tabPanel("Termite",
                                            fluidRow(width = 12,
                                                     column(1),
                                                     column(10, h3(strong( "Termite")),
                                                            hr(),
                                                            strong("What is Termite?"))
                                    )),

                                   tabPanel("Clusters",
                                            fluidRow(width = 12,
                                                     column(1),
                                                     column(10, h3(strong( "Clusters")),
                                                            hr(),
                                                            strong("Clusters: pictures of dots"))
                                   )),

                                   tabPanel("Word Clouds",
                                            fluidRow(width = 12,
                                                     column(1),
                                                     column(10,
                                                            h3(strong( "Word Clouds")),
                                                            hr(),
                                                            strong("Some people love word clouds, some people hate them"))
                                            )),

                                   tabPanel("Etc.",
                                            fluidRow(width = 12,
                                                     column(1),
                                                     column(10,
                                                            h3(strong( "Et Cetera")),
                                                            hr(),
                                                            strong("Other things????????"))
                                            ))
                                            )),
             br(),
             ),

    tabPanel(h4("Other Visualizations"),
             fluidRow(width = 12,
                      column(1),
                      column(10, align = 'center',
                             h3(strong('Other images we have generated about this data.'))),
                      column(1)),
             br(),
    ),

    tabPanel(h4("Who We Are"),
             fluidRow(width = 12, style = "margin: 20px",
                      column(12,
                             p("The Social and Decision Analytics Division (SDAD) is one of three research divisions within the
                               Biocomplexity Institute and Initiative at the University of Virginia. SDAD combines expertise in statistics
                               and social and behavioral sciences to develop evidence-based research and quantitative methods to inform policy
                               decision-making and evaluation. The researchers at SDAD span many disciplines including
                               statistics, economics, sociology, psychology, political science, policy, health IT, public health, program evaluation, and data science.
                               The SDAD office is located near our nation's capital in Arlington, VA. You can
                               learn more about us at", a(href = "https://biocomplexity.virginia.edu/social-decision-analytics", "https://biocomplexity.virginia.edu/social-decision-analytics"), "."),

                             p("Questions about the dashboard can be directed to :"),

                             p(a(href = "mailto:kjl5t@virginia.edu"," Kathryn Linehan"), ", Visiting Research Scientist")))
             )
    ),
  hr(),

  fluidRow(style = "margin: 20px",
           width = 12,
           column(12, align = 'center',
                  em('Last updated: May 2020'))
  )
                                                   )

# Run the application
server <- function(input, output, session) {

  output$freq_year <- renderPlot({
    ggplot(raw_abstracts) +
      geom_bar(aes(x = FY.x))
  })

  output$freq_dept <- renderPlot({
    ggplot(raw_abstracts) +
      geom_bar(aes(x = DEPARTMENT))
  })

  output$freq_agen <- renderPlot({
    ggplot(raw_abstracts) +
      geom_bar(aes(x = AGENCY))
  })

  output$na <- renderPlot({
    gg_miss_var(raw_abstracts_2020, show_pct = TRUE) +
      labs(y = "% Missing")
  })

  output$wordcount <- renderPlot({
    tidy_abstracts %>%
      count(word, sort = TRUE) %>%
      filter(n > 450000) %>%
      mutate(word = reorder(word, n)) %>%
      ggplot(aes(word, n)) +
      geom_col(show.legend = FALSE) +
      xlab(NULL) +
      coord_flip() +
      ggtitle(label = "Abstracts:", subtitle = "Highest Frequency Words")
  })

  output$important_words <- renderPlot({

    selected_type <- switch(input$department,
                            "Defense Department" =
                              raw_abstracts[raw_abstracts$DEPARTMENT == "DOD", ],
                            "Department of Education" =
                              raw_abstracts[raw_abstracts$DEPARTMENT == "ED", ],
                            "Environmental Protections Agency" =
                              raw_abstracts[raw_abstracts$DEPARTMENT == "EPA", ],
                            "Health and Human Services" =
                              raw_abstracts[raw_abstracts$DEPARTMENT == "HHS", ],
                            "NASA" =
                              raw_abstracts[raw_abstracts$DEPARTMENT == "NASA", ],
                            "National Science Foundation" =
                              raw_abstracts[raw_abstracts$DEPARTMENT == "NSF", ],
                            "US Department of Agriculture" =
                              raw_abstracts[raw_abstracts$DEPARTMENT == "USDA", ],
                            "Veterans Affairs" =
                              raw_abstracts[raw_abstracts$DEPARTMENT == "VA", ]
                            )

    selected_type %>%
      arrange(desc(tf_idf)) %>%
      mutate(word = factor(word, levels = rev(unique(word)))) %>%
      group_by(dept) %>%
      top_n(10) %>%
      ungroup() %>%
      ggplot(aes(word, tf_idf, fill = dept)) +
      geom_col(show.legend = FALSE) +
      labs(x = NULL, y = "tf_idf") +
      facet_wrap(~dept, ncol = 1, scales = "free") +
      coord_flip()
  })

}

shinyApp(ui = ui, server = server)
