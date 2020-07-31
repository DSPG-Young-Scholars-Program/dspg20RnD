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

#raw_abstracts <- read.csv("~/git/dspg20rnd/dspg20RnD/src/r_shiny_app_v2/data/working_federal_reporter_2020.csv")
tidy_abstracts <- read.csv("data/tidy_abstracts_dept.csv")
tidy_year <- read.csv("data/tidy_year.csv")
tentopics_tenwords <- read.csv("data/tentopics_tenwords.csv")

tentopics_tenwords <- tentopics_tenwords %>%
  filter(START_YEAR > 2009)

#topics <- count(tentopics_tenwords, Topic)$Topic

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
          tabName = "overview",
          text = "Project Overview",
          icon = icon("info circle")
        ),
        menuItem(
          tabName = "data",
          text = "Data & Methodology",
          icon = icon("database")
        ),

        #menuItem(
         # tabName = "findings",
          #text = "Findings",
          #icon = icon("chart-pie")
        #),

        menuItem(
          tabName = "graph",
          text = "Explore the Corpus",
          icon = icon("microscope")
        ),

        menuItem(
          tabName = "both",
          text = " Hot & Cold Topics",
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
                    h2("Data Sources"),
                    #img(src = "data_sets.png", width = "450px", align = "right"),
                    h3("Data Source"),
                    p("Federal RePORTER."),
                    h2("Methodology"),
                    h3("Data Preparation"),
                    p("Text."),
                    h3("Data Modeling"),
                    p("Text.")
                  )
                )),

        #tabItem(tabName = "findings",
                #fluidRow(
                  #boxPlus(
                    #title = "Findings",
                    #closable = FALSE,
                  #  width = NULL,
                   # status = "warning",
              #      solidHeader = TRUE,
               #     collapsible = TRUE,
                 #   h2("Summary of Findings"),
              #      p("Example text: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante."),
                 #   h3("Choosing Optimal Models"),
                #    p("LDA vs NMF. Choosing number of topic. Semantic coherence."),
               #     h3("Top Emerging/Receeding Topics in depth"),
                #    p("Wow! This topic has grown so much! How interesting!"),
                #    h3("Pandemics Results"),
                 #   p("Interesting findings about pandemics because we are in one.")
               #   ))),

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
                    column(12, h2("Pandemics."), align = 'center')
                    #column(12, plotlyOutput("emerging")),
                    #column(12, dataTableOutput("emerging_topics"))
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
                    p("plot output like above"),
                    p("data table output like above")
                    #plotlyOutput("emerging"),
                    #dataTableOutput("emerging_topics")
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
        geom_smooth(aes(x = year, y = n), se = FALSE, color = 'light blue', size = 2)
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
        coord_flip()
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

    #filtered_topic <- reactive({
      #dplyr::filter(tentopics_tenwords, Topic == input$Topic)
    #})

    output$emerging <- renderPlotly({
      #selected_topic <- switch(input$Topic)
      #tentopics_tenwords %>%
        #filter(selected_topic %in% Topic) %>%
      plot_ly(tentopics_tenwords, x = ~ START_YEAR, y = ~ Proportion, type = "scatter", mode = "lines+markers", color = tentopics_tenwords$Topic)
    })

    output$emerging_topics <- renderDataTable({
      datatable(tentopics_tenwords)
    })

  }
)
