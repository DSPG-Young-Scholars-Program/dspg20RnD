library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(dashboardthemes)
library(LDAvis)
library(LDAvisData)
library(plotly)
library(wordcloud)

source("theme.R")

  # DATA IMPORT -----------------------------------------------

raw_abstracts <- read.csv("~/git/dspg20rnd/dspg20RnD/data/original/working_federal_reporter_2020.csv")
tidy_abstracts <- read.csv("~/tidy_abstracts_dept.csv")
tidy_year <- read.csv("~/tidy_year.csv")
tentopics_tenwords <- read_csv("~/tentopics_tenwords.csv")

tentopics_tenwords <- tentopics_tenwords %>%
  filter(START_YEAR > 1999)

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
        menuItem(
          tabName = "findings",
          text = "Findings",
          icon = icon("chart-pie")
        ),

        menuItem(
          tabName = "graph",
          text = "Explore the Corpus",
          icon = icon("map-marked-alt")
        ),

        menuItem(
          tabName = "both",
          text = "Emerging Topics",
          icon = icon("map-marked-alt")
        ),

        menuItem(
          tabName = "model",
          text = "Try Topic Modeling",
          icon = icon("map-marked-alt")
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
                    h1("RnD Abstracts: Emerging Topic Identification and Development of Visualization Tools"),
                    h2("Project Description"),
                    p("Partnered with the National Center for Science and Engineering Statistics, our team analyzed abstracts of federally funded research and development grants from 2008-2019. We used topic modeling, an unsupervised machine learning method, to identify topics across the abstracts and find which topics are emerging in popularity, and which are declining."),
                    h2("Project Goals"),
                    p("This project had two main goals. First, to identify emerging research topics across time utilizing topic models and visualization techniques. Second, to present topic model outputs visually in a cohesive way."),
                    h2("Our Approach"),
                    p("Using an abstract corpus from the Federal RePORTER database, we used Latent Dirichlet Allocation topic models to identify emerging topics within the dataset."),
                    h2("Ethical Considerations"),
                    p("We considered ethics.")
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
                    sidebar_content = searchInput("search_term", label = NULL, value = "research"),
                    sidebar_title = "Search Term",
                    plotOutput("word_time")
                  ),
                  p("Word Frequency Over Time: Search Any Term!"),
                  p("Note: Extremely frequently used words such as 'the', 'and', etc. have been removed as possible search terms."),

                  boxPlus(
                    title = "Word Frequencies",
                    closable = FALSE,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    width = 6,
                    enable_sidebar = TRUE,
                    sidebar_width = 15,
                    sidebar_start_open = TRUE,
                    sidebar_content = tagList(selectInput("department", "Select Funding Department",
                                                          choices = list("DOD", "ED", "EPA", "HHS",
                                                                         "NASA", "NSF", "USDA", "VA"),
                                                          selected = "HHS")),
                    plotOutput("important_words"),
                    footer = "Word frequencies weighted by the funding department of the abstract."
                  ),

                  boxPlus(
                    title = "Word Clouds",
                    closable = FALSE,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    width = 6,
                    enable_sidebar = TRUE,
                    sidebar_width = 15,
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
                    plotOutput("wordcloud"),
                    footer = "Word clouds by funding agency."
                  )
                )),

        tabItem(tabName = "both",
                fluidRow(
                  boxPlus(
                    title = "Emerginig Topics",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = TRUE,
                    #sidebar_content = tagList(selectInput("Topic", "Select Topics",
                           #                               choices = topics,
                           #                               multiple = TRUE)),
                    h2("Emerging Topics Graphs"),
                    plotlyOutput("emerging")
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
                    img(src = "data_sets.png", width = "450px", align = "right"),
                    h3("Data Source"),
                    p("Federal RePORTER."),
                    h3("Data Source 3"),
                    h2("Methodology"),
                    p("Text"),
                    h3("Data Preparation"),
                    p("Text."),
                    h3("Data Modeling"),
                    p("Text.")
                  )
                )),

        tabItem(tabName = "findings",
                fluidRow(
                  boxPlus(
                    title = "Findings",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h2("Summary of Findings"),
                    p("Example text: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante."),
                    h3("Results Section One"),
                    img(src = "irrational_venn_diagram.png", width = "360px", align = "right"),
                    p("Example text: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante."),
                    h3("Results Section Two"),
                    p("Example text: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante."),
                    h3("Results Section Three"),
                    img(src = "food_reality_chart.png", width = "400px", align = "right"),
                    p("Example text: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam in varius purus. Nullam ut sodales ante.")
                  )),

                  boxPlus(title = "Visualizing Topics with LDAvis",
                          closable = FALSE,
                          status = "warning",
                          solidHeader = TRUE,
                          collapsible = TRUE,
                          width = NULL,
                          enable_sidebar = FALSE,
                          p( "LDAvis comes from", a(href = "https://nlp.stanford.edu/events/illvi2014/papers/sievert-illvi2014.pdf", "LDAvis: A method for visualizing and interpreting topics"), "by Sievert and Shirley." ),
                          sliderInput("nTerms", "Number of terms to display", min = 5, max = 20, value = 10),
                          column(width = 8, visOutput('myChart'))
                )),

        tabItem(tabName = "model",
                fluidRow(
                  boxPlus(
                    title = "Try Topic Modeling for Yourself",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h2("This is where out interactive topic modeling with a smaller corpus will go.")
                  )
                )),

        tabItem(tabName = "team",
                fluidRow(
                  boxPlus(
                    title = "Findings",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h2("DSPG Team Members"),
                    p("[Photos go about here.]"),
                    h2("UVA SDAD Team Members"),
                    p("The Social and Decision Analytics Division (SDAD) is one of three research divisions within the Biocomplexity Institute and Initiative at the University of Virginia. SDAD combines expertise in statistics and social and behavioral sciences to develop evidence-based research and quantitative methods to inform policy decision-making and evaluation. The researchers at SDAD span many disciplines including statistics, economics, sociology, psychology, political science, policy, health IT, public health, program evaluation, and data science.
                      The SDAD office is located near our nation's capital in Arlington, VA. You can
                      learn more about us at", a(href = "https://biocomplexity.virginia.edu/social-decision-analytics", "https://biocomplexity.virginia.edu/social-decision-analytics"), "."),
                    p("[Photos go about here.]"),
                    h2("Project Sponsors"),
                    p("[Photos, information, and/or links about your sponsor go about here. You may want to use materials that your sponsors have already shared with you about their institution or coordinate with your stakeholders to include pertinent information here.]"),
                    h2("Acknowledgements"),
                    p("[Optional: You can also include external collaborators in this section or a separate section.]")
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
        labs(x = NULL, y = "tf_idf") +
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

    output$myChart <- renderVis({
      with(Jeopardy,
           createJSON(phi, theta, doc.length, vocab, term.frequency,
                      R = input$nTerms))})

    #filtered_topic <- reactive({
      #dplyr::filter(tentopics_tenwords, Topic == input$Topic)
    #})

    output$emerging <- renderPlotly({
      #selected_topic <- switch(input$Topic)
      #tentopics_tenwords %>%
        #filter(selected_topic %in% Topic) %>%
      plot_ly(tentopics_tenwords, x = ~ START_YEAR, y = ~ Proportion, type = "scatter", mode = "lines", color = tentopics_tenwords$Topic)
    })

  }
)
