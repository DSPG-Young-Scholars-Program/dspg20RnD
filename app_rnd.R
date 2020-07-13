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

#load data

raw_abstracts <- read.csv("~/git/dspg20rnd/dspg20RnD/data/original/working_federal_reporter_2020.csv")

#make plot


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
                      column(8, p("Some early exploratory data analysis we did to get a feel for the size and the scope of our dataset."))),

             fluidRow(style = "margin: 20px;",
                      column(8, p("Count of Abstract by Year")),
                      column(width = 6, plotOutput("freq_year", width = "100%"))),

    br()
    ),

    tabPanel(h4("Text Explorer"),
             fluidRow(width = 12,
                      column(10, align = 'center',
                             h3(strong('Text Explorer')))),
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

}

shinyApp(ui = ui, server = server)
