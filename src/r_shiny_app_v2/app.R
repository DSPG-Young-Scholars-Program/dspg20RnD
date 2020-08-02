library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(dashboardthemes)
library(plotly)
library(wordcloud)
library(tidyverse)
library(ggplot2)
library(DT)

source("theme.R")

  # DATA IMPORT -----------------------------------------------

tidy_abstracts <- read.csv("data/tidy_abstracts_dept.csv")
tidy_year <- read.csv("data/tidy_year.csv")
pandemic_topic <- read.csv("data/pandemic_topic.csv")
pandemic <- read.csv("data/thirtypandemictopics.csv")
corona_topic <- read.csv("data/corona_topic.csv")
corona <- read.csv("data/thirtycoronatopics.csv")
all_topics <- read.csv("data/all_topics.csv")
topics <- read.csv("data/seventyfivetopicsdf.csv")

  # UI ---------------------------------------------------------

shinyApp(
  ui = dashboardPagePlus(
    title = "DashboardPage",
    header = dashboardHeaderPlus(
      title = "DSPG 2020"
      ),

    # SIDEBAR (LEFT) ----------------------------------------------------------

    sidebar = dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem(
          tabName = "homepage",
          text = "Home Page",
          icon = icon("home")
        ),

        menuItem(
          tabName = "overview",
          text = "Project Overview",
          icon = icon("info circle")
        ),
        menuItem(
          tabName = "data",
          text = "Data & Methodology",
          icon = icon("database")
        ),

        menuItem(
          tabName = "graph",
          text = "Explore the Corpus",
          icon = icon("microscope")
        ),

        menuItem(
          tabName = "both",
          text = "  Hot & Cold Topics",
          icon = icon("hotjar")
        ),

        menuItem(
          tabName = "model",
          text = "Pandemics Topic Modeling",
          icon = icon("filter")
        ),

        menuItem(
          tabName = "team",
          text = "Team",
          icon = icon("user-friends")
        )
      )
    ),

  # BODY --------------------------------------------------------------------
    body = dashboardBody(
      customTheme,
      fluidPage(
      tabItems(
        tabItem(tabName = "homepage",
                fluidRow(
                  boxPlus(
                    title = "Home Page",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    column(12, img(src = "uva-dspg-logo.jpg"), align = "center"),
                    column(12, h1("UVA Biocomplexity Institute"), align = "center"),
                    column(12, h2("R&D Abstracts: Emerging Topic Identification"), align = "center")

                  ))),

        tabItem(tabName = "overview",
                fluidRow(
                  boxPlus(
                    title = "Project Overview",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    column(12, align = 'center', h3(strong("R&D Abstracts: Emerging Topic Identification and Development of Visualization Tools"))),
                    h2("Project Description"),
                    p("This goal of this project is to identify emerging research topics across time utilizing topic models and visualization techniques.  The data utilized for this project is a corpus of Research and Development abstracts that is publicly available from", a(href = "https://federalreporter.nih.gov/", "Federal RePORTER."), "We built on prior work for this project by adding the 2019 abstracts to our dataset and using the topic modeling techniques of Latent Dirichlet Allocation and Nonnegative Matrix Factorization.  Using these topic model results we employed an emerging topic strategy to determine which topics are gaining (or waning) in popularity over time.  We also created this dashboard for users to interact with topic model results and investigate a pandemics case study."),
                    h2("Project Goals"),
                    p("This project will demonstrate how to find emerging topics in a corpus and will present the emerging topics found in the R&D abstract corpus from Federal RePORTER.  The cohesive visualization work will illuminate more topic model results that have not seen in our past work. With additional development, a general method for visualization of topic models on government data would ease interpretation in general, and could be expanded beyond NCSES and facilitate data-driven policy for policy-makers in general. "),
                    h2("Our Approach"),
                    p("We began with an existing dataset of abstracts from Federal RePORTER which had been previously profiled and cleaned, but with the addition of the 2019 abstracts pulled from Federal RePORTER, we decided to reprofile and clean. This required decisions to be made about duplicates, 'junk phrases', and the minimum number of characters in the abstracts. These steps allowed us to create a clean corpus on which to use two different topic modeling techniques: Latent Dirichlet Allocation, a probabilistic process, and  Nonnegative Matrix Factorization, an iterative process, in order to find the optimal model for our dataset. From these topic models, we analyzed the proportion and rank of the different topics over time to find our 'hot' and 'cold' topics."),
                    h2("Ethical Considerations"),
                    p("Throughout our work on this project, we thought through the ethical implications of our work. We recognize that our so-called 'emerging' topics only encompass government funded grants within the United States and thus does not necessarily represent the full scope of research and development in the United States or around the world. We also recognize that there exists an", a(href = "https://iaphs.org/identifying-implicit-bias-grant-reviews/", "implicit bias in research funding"), "that we do not address within the scope of this project. That being said, we decided the project would be beneficial for understanding where funding is allocated, potentially allowing for adjustments to be made. We also did not directly examine any specific individuals or demograph group, and our dataset is publically available." )
                  )
                )),

        tabItem(tabName = "graph",
                fluidRow(
                  boxPlus(
                    title = "Explore Words in the Corpus",
                    closable = FALSE,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    width = NULL,
                    enable_sidebar = TRUE,
                    sidebar_width = 15,
                    sidebar_start_open = TRUE,
                    sidebar_content = searchInput("search_term", label = "Enter search term", value = "keyword"),
                    sidebar_title = "Search Term",
                    column(12, p(strong("Word Frequency Over Time: Search Any Term!")), align = 'center'),
                    column(10, plotOutput("word_time")),
                    column(10, p("Note: Extremely frequently used words have been removed as possible search terms. In addition, the axis changes with the frequency of any given word."))
                  ),

                  boxPlus(
                    title = "Word Frequencies",
                    closable = FALSE,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    width = 6,
                    enable_sidebar = TRUE,
                    sidebar_width = 20,
                    sidebar_start_open = TRUE,
                    sidebar_content = tagList(selectInput("department", "Select Funding Department",
                                                          choices = list("DOD", "ED", "EPA", "HHS",
                                                                         "NASA", "NSF", "USDA", "VA"),
                                                          selected = "HHS")),
                    column(10, plotOutput("important_words")),
                    footer = p("Word frequencies weighted by the funding department of the abstract. The weight is calculated by multiplying the term frequency by the inverse document frequency. More info can be found", a(href = "https://www.tidytextmining.com/tfidf.html", "here."))
                  ),

                  boxPlus(
                    title = "Word Clouds",
                    closable = FALSE,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    width = 6,
                    enable_sidebar = TRUE,
                    sidebar_width = 20,
                    sidebar_start_open = TRUE,
                    sidebar_content = tagList(selectInput("selection", "Choose a department:",
                                                          choices = list("DOD", "ED", "EPA", "HHS",
                                                                         "NASA", "NSF", "USDA", "VA"),
                                                          selected = "DOD"),
                                              hr(),
                                              sliderInput("freq",
                                                          "Minimum Frequency:",
                                                          min = 1000,  max = 500000, value = 50000),
                                              sliderInput("max",
                                                          "Maximum Number of Words:",
                                                          min = 1,  max = 100,  value = 50)),
                    column(10, plotOutput("wordcloud")),
                    footer = "Word clouds by funding agency."
                  )
                )),

        tabItem(tabName = "both",
                fluidRow(
                  boxPlus(
                    title = "Hot and Cold Topics Overview",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, p("Some text describing hot and cold emerging topics, where this idea came from, potentially citing that other paper")),
                    column(12, p("Graphs produced with Plotly. Hover over the lines to see topic and proportion information. To change graph settings, hover over the top right of the graph."))),
                  boxPlus(
                    title = "Emerging Topics",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, h2("Emerging Topics: These topics have seen an increase over time within our dataset."), align = 'center'),
                    column(12, plotlyOutput("emerging")),
                    column(12, dataTableOutput("emerging_topics"))
                  ),

                  boxPlus(
                    title = "Receding Topics",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, h2("Receding Topics: These topics are seecn a decrease over time within our dataset."), align = 'center'),
                    p("plot output like above"),
                    p("data table output like above")
                    #plotlyOutput("emerging"),
                    #dataTableOutput("emerging_topics")
                  )
                )),

        tabItem(tabName = "data",
                fluidRow(
                  boxPlus(
                    title = "Data & Methodology",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h2("Data Source"),
                    h3("Federal RePORTER"),
                    p("We downloaded the data from ", a(href = "https://federalreporter.nih.gov/", "Federal RePORTER."), " a website that allows users to access \"a repository of data and tools that will be useful to assess the impact of federal R&D investments...\" by enabling \"documentation and analysis of inputs, outputs, and outcomes resulting from federal investments in science.\"" ,
                      br(),
                       "A previous DSPG project (2019) used data from 2008-2018, however we updated the data include 2019. The data consists of abstracts from each grant as well as grant metadata from 1+ million R&D grants from 2008-2019. Some columns (metadata) interest include Fiscal Year, Project Title, Agency, and Principal Investigator.
                      "),
                    h2("Methodology"),
                    h3("Data Preparation"),
                    p("•	Because abstracts are the main source of information that is project analyzed, any rows with NA or \"No Abstract Provided\" in the \"ABSTRACT\" field were removed.",
                      br(),
                      "•	Date columns that had NA values were filled where possible with information from other date columns.",
                      br() ,
                      "•	We removed duplicate rows based on whether rows had matching ABSTRACT, PROJECT_TITLE and PROJECT_START_DATE. For the rows that were identified as duplicate, the latest PROJECT_END_DATE was preserved, and the number of unique ORGANIZATIONs and Principal Investigators were recorded.",
                      br(),
                      "•	lowercase all abstracts", br(),
                      "•	remove: ", br(),
                      "o	white space & punctuation", br(),
                      "o	\"junk\" phrases throughout (ex. \"DESCRIPTION: Provided by applicant\", \"Background\", \"Intellectual merit\")",
                      br() ,
                      "o	Abstracts less than 150 characters", br(),
                      "o	Other data fields found within abstract", br(),
                      "•	stop word removal", br(),
                      "•	lemmatization", br(),
                      "•	bag o words
                      "),
                    column(4,
                    img(src = "char_histogram.jpeg", width = "450px", height = "300px"), align = "right"),
                    column(2, align = "center"),
                    column(4, img(src = "dept_bar.jpeg", width = "450px", height = "300px"), align = "left"),
                    column(4, img(src = "proj_start_year_bar.jpeg", width = "450px", height = "300px"), align = "right"),
                    column(4, align = "left"),
                    br(),
                    column(12, h3("Data Modeling")),
                    column(12, p("Topic modeling is the process of generating a series of underlying themes from a set (corpus) of documents. Initially, one can view a corpus as a series of documents, each composed of a string of words. These words do not each exist independently one another—they form coherent sentences and express broader ideas. However, if one wants to analyze these implicit ideas conveyed within a corpus, it is often not feasible to manually read and record what the focus of each document is. Topic modeling processes seek to resolve this common issue.",
                      br(),
                      "Rather than view each document strictly as a collection of words, one can use topic modeling to insert an additional level of analysis: each document is composed of a distribution of topics, and each topic is a collection of thematically interrelated words. This distinction allows for more focused data analysis, since analyzing a corpus at the topic level can refine a sprawling jumble of thousands of documents into an interpretable, manageable dataset.",
                      br(),
                      "We examined two topic modeling frameworks over the course of this project:",
                      br(),
                      "-Latent Dirichlet Allocation  (LDA) - Probabilistic process: \"What is most likely distribution of topics across each documents?\" ",
                      br(),
                      "-Non-negative Matrix Factorization (NMF) - Iterative process: \"Based on word frequency and association, where do we find clusters of words and what does each cluster signify?\"
                      "))
                  )
                )),

        tabItem(tabName = "model",
                fluidRow(
                  boxPlus(
                    title = "Subsetting a Corpus",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, p("About the subset process, etc.")),
                    column(12, p("Graphs produced with Plotly. Hover over the lines to see topic and proportion information. To change graph settings, hover over the top right of the graph."))),
                  boxPlus(
                    title = "Case Study 1: Pandemics",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, h2("Pandemics."), align = 'center'),
                    column(12, plotlyOutput("pandemics")),
                    column(12, dataTableOutput("pandemics_topics"))
                  ),

                  boxPlus(
                    title = "Case Study 2: Coronavirus",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, h2("Coronavirus."), align = 'center'),
                    plotlyOutput("coronavirus"),
                    dataTableOutput("coronavirus_topics")
                  )
                )),

        tabItem(tabName = "team",
                fluidRow(
                  boxPlus(
                    title = "Our Team",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h2("DSPG Team Members"),
                    p("The", a(href = "https://biocomplexity.virginia.edu/social-decision-analytics/dspg-program", "Data Science for the Public Good Young Scholars program"), "is a summer immersive program held at the Biocomplexity Institute’s Social and Decision Analytics division (SDAD). The program engages students from across the country to work together on projects that address state, federal, and local government challenges around critical social issues relevant in the world today. DSPG young scholars conduct research at the intersection of statistics, computation, and the social sciences to determine how information generated within every community can be leveraged to improve quality of life and inform public policy."),

                    fluidRow(

                      style = "height:10px;"),
                    fluidRow(

                      # Lara
                      column(3,
                             div(class="panel panel-default",
                                 div(class="panel-body",  width = "600px",
                                     align = "center",
                                     div(
                                       tags$img(src = "teamphotos/lara.jpg",
                                                width = "100px", height = "100px")
                                     ),
                                     div(
                                       tags$h5("Lara Haase"),
                                       tags$h6( tags$i("Graduate Fellow"))
                                     ),
                                     div(
                                       "Lara is pursing a Masters of Science in Public Policy & Management - Data Analytics at Carnegie Mellon."
                                     )
                                 )
                             )
                      ),
                      # Martha
                      column(3,
                             div(class="panel panel-default",
                                 div(class="panel-body",  width = "600px",
                                     align = "center",
                                     div(
                                       tags$img(src = "teamphotos/MARTHA.jpg",
                                                width = "100px", height = "100px")
                                     ),
                                     div(
                                       tags$h5("Martha Czernuszenko"),
                                       tags$h6( tags$i("Intern"))
                                     ),
                                     div(
                                       "Martha recently graduated from The University of Texas where she studied Information Systems & Business Honors."
                                     )
                                 )
                             )
                      ),
                      # Liz
                      column(3,
                             div(class="panel panel-default",
                                 div(class="panel-body",  width = "600px",
                                     align = "center",
                                     div(
                                       tags$img(src = "teamphotos/LIZ.jpg",
                                                width = "100px", height = "100px")),
                                     div(
                                       tags$h5("Liz Miller"),
                                       tags$h6( tags$i("Intern"))
                                     ),
                                     div(
                                       "Liz is an incoming senior at William and Mary where she studies International Relations  & History."
                                     )
                                 )
                             )
                      ),
                      # Sean
                      column(3,
                             div(class="panel panel-default",
                                 div(class="panel-body",  width = "600px",
                                     align = "center",
                                     div(
                                       tags$img(src = "teamphotos/SEAN.jpg",
                                                width = "100px", height = "100px")),
                                     div(
                                       tags$h5("Sean Pietrowicz"),
                                       tags$h6( tags$i("Intern"))
                                     ),
                                     div(
                                       "Sean recently graduated from Notre Dame where he studied Applied Computational Math & Statistics"
                                     )
                                 )
                             )
                      ),
                      column(1)),


                    #SDAD
                    h2("UVA SDAD Team Members"),
                    p("The Social and Decision Analytics Division (SDAD) is one of three research divisions within the Biocomplexity Institute and Initiative at the University of Virginia. SDAD combines expertise in statistics and social and behavioral sciences to develop evidence-based research and quantitative methods to inform policy decision-making and evaluation. The researchers at SDAD span many disciplines including statistics, economics, sociology, psychology, political science, policy, health IT, public health, program evaluation, and data science.
                      The SDAD office is located near our nation's capital in Arlington, VA. You can
                      learn more about us at", a(href = "https://biocomplexity.virginia.edu/social-decision-analytics", "https://biocomplexity.virginia.edu/social-decision-analytics"), "."),
                    fluidRow(

                      style = "height:50px;"),

                    fluidRow(

                      # Kathryn
                      column(3,
                             div(class="panel panel-default",
                                 div(class="panel-body",  width = "600px",
                                     align = "center",
                                     div(
                                       tags$img(src = "teamphotos/KATHRYN.jpg",
                                                width = "100px", height = "100px")
                                     ),
                                     div(
                                       tags$h5("Kathryn Linehan"),
                                       tags$h6( tags$i())
                                     ),
                                     div(
                                       "Kathryn is a research scientist."
                                     )
                                 )
                             )
                      ),
                      # Stephanie
                      column(3,
                             div(class="panel panel-default",
                                 div(class="panel-body",  width = "600px",
                                     align = "center",
                                     div(
                                       tags$img(src = "teamphotos/STEPHANIE.jpg",
                                                width = "100px", height = "100px")
                                     ),
                                     div(
                                       tags$h5("Stephanie Shipp"),
                                       tags$h6( tags$i())
                                     ),
                                     div(
                                       "Stephanie is the Deputy Division Director & Research Professor."
                                     )
                                 )
                             )
                      ),
                      # Joel
                      column(3,
                             div(class="panel panel-default",
                                 div(class="panel-body",  width = "600px",
                                     align = "center",
                                     div(
                                       tags$img(src = "teamphotos/JOEL.jpg",
                                                width = "100px", height = "100px")),
                                     div(
                                       tags$h5("Joel Thurston"),
                                       tags$h6( tags$i())
                                     ),
                                     div(
                                       "Joel is a senior scientist."
                                     )
                                 )
                             )
                      ),
                      # Eric
                      column(3,
                             div(class="panel panel-default",
                                 div(class="panel-body",  width = "600px",
                                     align = "center",
                                     div(
                                       tags$img(src = "teamphotos/ERIC.png",
                                                width = "100px", height = "100px")),
                                     div(
                                       tags$h5("Eric Oh"),
                                       tags$h6( tags$i())
                                     ),
                                     div(
                                       "Eric is a research assistant professor."
                                     )
                                 )
                             )
                      ),
                      column(1)),
                    h2("Project Sponsors"),
                    p("Our sponsor is The National Center for Science and Engineering Statistics (NCSES). NCSES's mandate is the collection, interpretation, analysis, and dissemination of objective data on the science and engineering enterprise."),
                    column(3,
                           div(class="panel panel-default",
                               div(class="panel-body",  width = "600px",
                                   align = "center",
                                   div(
                                     tags$img(src = "teamphotos/JOHN.png",
                                              width = "100px", height = "100px")),
                                   div(
                                     tags$h5("John Jankowski "),
                                     tags$h6( tags$i())
                                   ),
                                   div(
                                     "John is the Director of R&D Statistics Program at The National Center for Science and Engineering Statistics."
                                   )
                               )
                           )
                    )
                    #h2("Acknowledgements"),
                    #p("[Optional: You can also include external collaborators in this section or a separate section.]")
                    )
                ))
      )
      ))
    ),

  server = function(input, output) {

    filtered_data <- reactive({
      dplyr::filter(tidy_year, word == input$search_term)
    })

    output$word_time <- renderPlot({
      ggplot(filtered_data(), aes(x = year, y = n)) +
        geom_point(aes(colour = factor(year))) +
        geom_smooth(aes(x = year, y = n), se = FALSE, color = 'light blue', size = 2) +
        theme_bw()
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
        labs(x = "word", y = "weight by department") +
        coord_flip() +
        theme_bw()
    })

    output$wordcloud <- renderPlot({
      selected_cloud <- switch(input$selection,
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

      selected_cloud %>%
        with(wordcloud(word, n, scale = c(2,0.75),
                       min.freq = input$freq, max.words = input$max,
                       ordered.colors = TRUE))
    })

    output$emerging <- renderPlotly({

      plot_ly(topics, x = ~ START_YEAR, y = ~ Proportion, type = "scatter", mode = "lines+markers", color = topics$Topic)
    })

    output$emerging_topics <- renderDataTable({
      datatable(all_topics)
    })

    output$pandemics <- renderPlotly({
      plot_ly(pandemic, x = ~ START_YEAR, y = ~ Weight, type = "scatter", mode = "lines+markers", color = pandemic$Topic)
    })

    output$pandemics_topics <- renderDataTable({
      datatable(pandemic_topic)
    })

    output$coronavirus <- renderPlotly({
      plot_ly(corona, x = ~ START_YEAR, y = ~ Weight, type = "scatter", mode = "lines+markers", color = corona$Topic)
    })

    output$coronavirus_topics <- renderDataTable({
      datatable(corona_topic)
    })

  }
)
