library(devtools)
library(shiny)
library(tidyverse)
library(shinydashboard)
library(colourpicker)
library(leaflet)
library(leaflet.extras)
library(RColorBrewer)
library(sf)
library(shiny)
library(dplyr)
library(leaflet.extras)
library(shinythemes)
library(ggplot2)
library(ggthemes)
library(viridis)
library(scales)
library(GGally)
library(ggrepel)
library(naniar)
library(tidytext)
library(shinyWidgets)
library(LDAvis)
library(LDAvisData)

#load data

raw_abstracts <- read.csv("~/git/dspg20rnd/dspg20RnD/data/original/working_federal_reporter_2020.csv")
tidy_abstracts <- read.csv("~/tidy_abstracts_dept.csv")
tidy_year <- read.csv("~/tidy_year.csv")
#tidy_words <- read.csv("~/tidy_words.csv")

#tidy_abstracts <- tibble(dept = raw_abstracts$DEPARTMENT, text = raw_abstracts$ABSTRACT)

#tidy_abstracts <- tidy_abstracts %>%
  #unnest_tokens(word, text) %>%
  #anti_join(stop_words) %>%
  #count(dept, word, sort = TRUE)

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
                  p('This project is for DSPG 2020 examining emerging topics in Research and Development using data from the Federal RePORTER database. Please be patient while graphs load.')),
           column(1)),
  hr(),

  tabsetPanel(

    tabPanel(h4("EDA & Profiling"),

             fluidRow(width = 12,
                      column(12, align = 'center',
                             h3(strong('Exploratory Data Analysis'))),
                      column(12, p("Some early exploratory data analysis we did to get a feel for the size and the scope of our dataset."))),

             fluidRow(style = "margin: 20px;",
                      column(12, align = 'center', p("Count of Abstract by Year")),
                      column(width = 10, align = 'center', plotOutput("freq_year", width = "100%"))),

             fluidRow(style = "margin: 20px;",
                      column(12, align = 'center', p("Count of Abstract by Department")),
                      column(width = 10, align = 'center', plotOutput("freq_dept", width = "100%"))),

             fluidRow(style = "margin: 20px;",
                      column(12, align = 'center', p("Count of Abstract by Agency")),
                      column(width = 10, align = 'center', plotOutput("freq_agen", width = "100%"))),

             fluidRow(width = 12,
                      column(12, align = 'center',
                             h3(strong('Data Profiling'))),
                      column(12, p("Looking at some of the missing values in our dataset and other examinations of the completeness of the Federal RePORTER dataset."))),

             fluidRow(style = "margin: 20px;",
                      column(12, align = 'center', p("Graph of NA values")),
                      column(width = 10, align = 'center', plotOutput("na", width = "100%"))),

    br()
    ),

    tabPanel(h4("Text Explorer"),
             fluidRow(width = 12,
                      column(12, align = 'center',
                             h3(strong('Text Explorer')))),

             fluidRow(style = "margin: 20px;",
                      column(12, align = 'center', p("Count of most frequent words")),
                      column(width = 12, align = 'center', plotOutput("wordcount", width = "100%"))),

             fluidRow(align = "center", width = 12,
                      column(10, h3(strong("Search dataset for frequency of different words over time."))),
                      searchInput("search_term", label = NULL, value = "research")),

             fluidRow(style = "margin: 20px;",
                      column(12, align = 'center', p("Word Frequency over time")),
                      column(width = 12, align = 'center', plotOutput("word_time", width = "100%"))),

             fluidRow(align = "center",
                      column(12, h3(strong("Words weighted by Funding Department"))),
                      selectInput("department", "Select Funding Department",
                                  choices = list("DOD", "ED", "EPA", "HHS", "NASA", "NSF", "USDA", "VA"),
                                  selected = "HHS")),
             fluidRow(style = "margin: 20px;",
                      column(width = 12, align = 'center', plotOutput("important_words", width = "100%"))),

             br()
             ),

    tabPanel(h4("Topic Models"),

             fluidRow(width = 12, style = "margin: 20px 0px 20px 20px",
                      column(2),
                      column(1),
                      column(12, p("Topic Modeling is a thing we have done.")),
                      column(1)),

             fluidRow(width = 12, style = "margin: 20px",
                      navlistPanel(widths = c(2, 10),
                                   tabPanel("LDAvis",
                                            fluidRow(width = 10,
                                                     column(1),
                                                     column(12, h3(strong( "LDAvis")),
                                                            hr(),
                                                            strong("What is LDAvis?")),
                                                     column(10, p( "LDAvis comes from", a(href = "https://nlp.stanford.edu/events/illvi2014/papers/sievert-illvi2014.pdf", "LDAvis: A method for visualizing and interpreting topics"), "by Sievert and Shirley." )),
                                                     column(10,
                                                            sliderInput("nTerms", "Number of terms to display", min = 20, max = 40, value = 30),
                                                            visOutput('myChart')
                                                     ))
                                            ),

                                   tabPanel("Termite",
                                            fluidRow(width = 12,
                                                     column(1),
                                                     column(12, h3(strong( "Termite")),
                                                            hr(),
                                                            strong("What is Termite?")),
                                                     column(12, " Termite comes from", a(href = "http://vis.stanford.edu/files/2012-Termite-AVI.pdf", "Termite: Visualization Techniques for Assessing Textual Topic Models"), "by Chuang, Manning, and Heer.")
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
             br()
             ),

    tabPanel(h4("Other Visualizations"),
             fluidRow(width = 12,
                      column(1),
                      column(10, align = 'center',
                             h3(strong('Other images we have generated about this data.'))),
                      column(1)),
             br()
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
                  em('Last updated: July 2020'))
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
      geom_bar(aes(x = DEPARTMENT, fill = DEPARTMENT), show.legend = FALSE)
  })

  output$freq_agen <- renderPlot({
    ggplot(raw_abstracts) +
      geom_bar(aes(x = AGENCY, fill = AGENCY), show.legend = FALSE)
  })

  output$na <- renderPlot({
    gg_miss_var(raw_abstracts, show_pct = TRUE) +
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
                            "DOD" =
                              tidy_abstracts[tidy_abstracts$dept == "DOD", ],
                            "ED" =
                              tidy_abstracts[tidy_abstracts$dept == "ED", ],
                            "EPA" =
                              tidy_abstracts[tidy_abstracts$dept == "EPA", ],
                            "HHS" =
                              tidy_abstracts[tidy_abstracts$dept == "HHS", ],
                            "NASA" =
                              tidy_abstracts[tidy_abstracts$dept == "NASA", ],
                            "NSF" =
                              tidy_abstracts[tidy_abstracts$dept == "NSF", ],
                            "USDA" =
                              tidy_abstracts[tidy_abstracts$dept == "USDA", ],
                            "VA" =
                              tidy_abstracts[tidy_abstracts$dept == "VA", ])

    selected_type %>%
      arrange(desc(tf_idf)) %>%
      mutate(word = factor(word, levels = rev(unique(word)))) %>%
      group_by(dept) %>%
      top_n(20) %>%
      ungroup() %>%
      ggplot(aes(word, tf_idf, fill = dept)) +
      geom_col(show.legend = FALSE) +
      labs(x = NULL, y = "tf_idf") +
      coord_flip()
  })
  filtered_data <- reactive({
    dplyr::filter(tidy_year, word == input$search_term)
  })

  output$word_time <- renderPlot({
      ggplot(filtered_data(), aes(x = year, y = n)) +
      geom_point() +
      geom_smooth()
  })

  output$myChart <- renderVis({
    with(Jeopardy,
         createJSON(phi, theta, doc.length, vocab, term.frequency,
                    R = input$nTerms))})


  output$word_time <- renderPlot({
    #selected_word <- input$search
    tidy_year %>%
      filter(word == "research") %>%
      ggplot(aes(x = year, y = n)) +
      geom_point() +
      geom_smooth()
  })

}

shinyApp(ui = ui, server = server)
