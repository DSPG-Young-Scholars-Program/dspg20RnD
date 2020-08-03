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

tidy_abstracts <- readRDS("data/tidy_abstracts_dept.rds")
tidy_year <- readRDS("data/tidy_year.rds")
pandemic_topic <- readRDS("data/pandemic_topic.rds")
pandemic <- readRDS("data/thirtypandemictopics.rds")
corona_topic <- readRDS("data/corona_topic.rds")
corona <- readRDS("data/thirtycoronatopics.rds")
all_topics <- readRDS("data/all_topics.rds")
topics <- readRDS("data/seventyfivetopicsdf.rds")

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
          text = "Hot & Cold Topics",
          icon = icon("fire")
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
                    column(12, img(src = "uva-dspg-logo.jpg", width = "200px", height = "200px"), align = "center"),
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
                    p("This project utilizes topic models and visualization techniques to identify emerging research and development (R&D) topics within a corpus of publically available abstracts from",  a(href = "https://federalreporter.nih.gov/", "Federal RePORTER."), "The research builds upon an ongoing collaboration between the UVA Social and Decision Analytics Division (SDAD) and the National Center for Science and Engineering Statistics (NCSES) examining the use of administrative records to supplement or enhance data collected in NCSES surveys. Key components of our work include: (1) expanding the dataset to include the 2019 abstracts and (2) comparing two types of topic modeling techniques - Latent Dirichlet Allocation (LDA) and Nonnegative Matrix Factorization (NMF)."),
                    p("Our topic model analysis reveals 'hot' and 'cold' topics (i.e. those that increase or decrease in popularity) across time. We provide an interactive dashboard where users may explore our topic model results and investigate a pandemics case study. With the dashboard, users are able to view topics produced by the models, see key words associated with each topics, and track how the popularity of these topics fluctuate over time. Our project demonstrates the value of applying topic modeling and visualization to organize and interpret large government data sets and faciliate data-drive policy decisions."),
                    h2("Our Approach"),
                    img(src = "framework.png", width = "300px", align = "right"),
                    p("The foundation of our approach is the UVA SDAD Data Science Framework. Some highlights from applying the framework include:"),
                    #br(),
                    p(strong("Problem Identification:"), "Because we were extendind a previous study, we began by reviewing prior work on this project and conducting a literature review focused on identifying emerging topics and topic model visualization."),
                    #br(),
                    p(strong("Data Discovery:"), "We discovered that Federal RePORTER had been updated with data from 2019, which was not included in the prior word, so we acquired the most recent set of abstracts to include in our analysis."),
                    p(strong("Data Wrangling:"), "We performed exploratory data analysis on our revised dataset and cleaned & processed abstrats to prepare for their use in topic modeling."),
                    p(strong("Statistical Modeling & Analyses:"), "We compared LDA and NMF to find an optimal topic model algorithem for our dataset. Informed by our literature review, we indentified emerging topics and designated topics as 'hot' or 'cold' based on how their popularly changed across time. As a case study on emerging topics, we focused on identifying topics related to pandemic-related research."),
                    p(strong("Communication & Dissemination:"), "We constructed an RShiny dashboard, created a poster, and wrote a brief for", a(href = 'https://www.methodspace.com/category/sage-posts/', "SAGE Publications MethodSpace blog.")),
                    h2("Ethical Considerations"),
                    p("Ethics are a key component of the Data Science Framework and inform every step of this process. We did not collect or utilize any individual or demographic data for this project, which minimizes the potential harm to individuals. However, in considering the larger implications of the project, we recognize that our dataset only included federally funded grants within the United States. It does not necessarily capture the full scope of research and development within the United States nor around the world. We also recognize that", a(href = "https://iaphs.org/identifying-implicit-bias-grant-reviews/", "implicit bias in research funding"), "may impact the representation of topics within our dataset and, while not addressed within the scope of this project, could serve as a focus for future analysis." )
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
                    #column(12, p(strong("Word Frequency Over Time: Search Any Term!")), align = 'center'),
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
                    p("We downloaded the data from ", a(href = "https://federalreporter.nih.gov/", "Federal RePORTER."), " a website that allows users to access \"a repository of data and tools that will be useful to assess the impact of federal R&D investments...\" by enabling \"documentation and analysis of inputs, outputs, and outcomes resulting from federal investments in science.\ A previous DSPG project (2019) used data from 2008-2018, however we updated the data include 2019. The data consists of abstracts from each grant as well as grant metadata from 1+ million R&D grants from 2008-2019. Some columns (metadata) interest include Fiscal Year, Project Title, Agency, and Principal Investigator."),
                    h2("Methodology"),
                    h3("Data Preparation"),
                    p("We went through several steps in order to optimize the abstract text for topic modeling:"),
                    tags$ul(
                      tags$li("Because abstracts are the main source of information that is project analyzed, any rows with NA or \"No Abstract Provided\" in the \"ABSTRACT\" field were removed."),
                    tags$li("Date columns that had NA values were filled where possible with information from other date columns."),
                    tags$li("We removed duplicate rows based on whether rows had matching ABSTRACT, PROJECT_TITLE and PROJECT_START_DATE. For the rows that were identified as duplicate, the latest PROJECT_END_DATE was preserved, and the number of unique ORGANIZATIONs and Principal Investigators were recorded."),
                    tags$li("Lowercase all abstracts"),
                    tags$li("Removed -"),
                      tags$ul(
                     tags$li("white space & punctuation"),
                      tags$li("\"junk\" phrases throughout (ex. \"DESCRIPTION: Provided by applicant\", \"Background\", \"Intellectual merit\")"),
                      tags$li("Abstracts less than 150 characters"),
                      tags$li("Other data fields found within abstract")),
                      tags$li("Removed	stop words"),
                      tags$li("Went through the process of	lemmatization"),
                      tags$li("Used the 'bag-o-words' method to prepare text for models.")),
                    img(src = "combined_graphs.jpeg", align = "center"),
                    br(),
                    h3("Data Modeling"),
                    p("Topic modeling is the process of generating a series of underlying themes from a set (corpus) of documents. Initially, one can view a corpus as a series of documents, each composed of a string of words. These words do not each exist independently one another—they form coherent sentences and express broader ideas. However, if one wants to analyze these implicit ideas conveyed within a corpus, it is often not feasible to manually read and record what the focus of each document is. Topic modeling processes seek to resolve this common issue."),
                    p("Rather than view each document strictly as a collection of words, one can use topic modeling to insert an additional level of analysis: each document is composed of a distribution of topics, and each topic is a collection of thematically interrelated words. This distinction allows for more focused data analysis, since analyzing a corpus at the topic level can refine a sprawling jumble of thousands of documents into an interpretable, manageable dataset. We examined two topic modeling frameworks over the course of this project:"),
                    h4("Latent Dirichlet Allocation (LDA)"),
                    p("Probabilistic topic modeling process"),
                    tags$ul(
                            tags$li("Each document is a distribution of topics"),
                            tags$li("Each topic is a distribution of words")),
                    p("Generated latent topics"),
                    tags$ul(
                            tags$li("Draws out set of implicit themes across set of documents using Dirichlet probability distribution"),
                            tags$li("Provides additional layer of information for compartmentalization & analysis")),
                    p("LDA starts with a corpus of documents and attempts to output: (1) The topics that span within the corpus and (2) How these topics are distributed across each document. Each has an associated parameter, which helps determine the volume and specificity of topics that show up in the output."),
                    p(strong("Input:")),
                    p("Corpus"),
                    tags$ul(
                            tags$li("Conceptual: Set of documents "),
                            tags$li("Technical: Corpus starts as single object comprised of D (documents x words), but is processed into two matrices following Dirichlet distribution "),
                            tags$li("Takeaway: Because LDA is not built to discern context of words, data cleaning is essential step ")),
                    p(strong("Output:")),
                    p("Theta (θ)"),
                    tags$ul(
                            tags$li("Conceptual: \"Per-Document Topic Proportions\" "),
                            tags$li("Technical: Random matrix where θ(i,j) represents the probability of the i th document to containing the j th topic "),
                            tags$li("Takeaway: Approximates the potential association each document has with a set of topics; \"what topics does each document span?\" ")),
                    p("Beta (β)  "),
                    tags$ul(
                            tags$li("Conceptual: \"Set of Topics\"  "),
                            tags$li("Technical: A random matrix where β(i,j) represents the probability of i th topic containing the j th word "),
                            tags$li("Takeaway: Provides clusters of words that seem to connect thematically; \"what broader subject is spanned by these words?\" ")),
                      p(strong("Parameters: ")),
                      p("Alpha (α) "),
                      tags$ul(
                        tags$li("Conceptual: document-topic density: higher alpha -> documents are made up of more topics "),
                        tags$li("Technical: Distribution related parameter that governs what the distribution of topics is for all the documents in the corpus looks like. Impacts θ (the document x topic matrix) "),
                        tags$li("Takeaway: Determines \"sensitivity\" to presence of potential topics in a document ")),
                    p("Eta (η)  "),
                    tags$ul(
                      tags$li("Conceptual: topic-word density. higher beta -> topics are made up of more of the words in the corpus."),
                      tags$li("Technical: — Distribution related parameter that governs what the distribution of words in each topic looks like. Impacts β (the topic x word matrix) "),
                      tags$li("Takeaway: Determines \"specificity\" of words required to characterize each topic ")),
                    p(strong("Process: ")),
                    p("Uses Dirichlet distribution "),
                    tags$ul(
                      tags$li("Multivariate Beta distribution—multiple parameters used to model probabilities "),
                      tags$li("Topic modeling: uses probabilities to approximate clusters of potentially related words into topics and associate these topics with the array of documents ")),
                      br(),
                      h4("Nonnegative Matrix Factorization (NMF)"),
                      p("NMF decomposes (factorizes) high-dimensional vectors into a lower-dimensional representation "),
                    tags$ul(
                      tags$li("Typically uses linear algebra technique called term frequency–inverse document frequency (tf-idf) "),
                      tags$li("No Dirichlet overlaid onto data, meaning that word frequency is weighed more heavily in determining of topics, rather than emphasis on Dirichlet's probabilistic method ")),
                      p(strong("Unsupervised technique")),

                      tags$ul(tags$li("Iterative process, no labeling of topics that the model will be trained on. ")),

                      p(strong("Process: ")),
                      tags$ul(
                        tags$li("NMF modifies the dimensions of these two matrices such that the matrix product approaches matrix A until either the approximation error converges or maximum iterations are reached. "),
                        tags$li("Starting matrix is reduced using tf-idf; finds matrices W, H’, such that norm(A-WH’) is minimized. "),
                        tags$ul(
                          tags$li("A: document-term matrix "),
                          tags$li("W: Documents x Topics "),
                          tags$li("H: Topics x Terms ")),
                        tags$li("This process normalizes the matrix to ensure terms are properly weighted in terms of frequency "),
                        tags$li("Normalized matrix is then sent through iterative process "),
                        tags$ul(
                          tags$li("the values in factors W and H are given random initial values. The key required input parameter is the number of topics (components) k. "),
                          tags$li("Sorts contents of matrices into various clusters of terms (the most clearly delineated topics according to the model) "),
                          tags$li( "Output is list of weighted terms (representing topics) and which of these topics are most prevalent in each document ")))
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
        labs(title = "Word Frequency Over Time", subtitle = "Search Any Term", color ='Year') +
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

      plot_ly(topics, x = ~ START_YEAR, y = ~ Weight, type = "scatter", mode = "lines+markers", color = topics$Topic)
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
