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

opt_topics <- readRDS("data/opt_res.rds")
reg_topics <- readRDS("data/reg_topics.rds")
pan_topics <- readRDS("data/pan_topics.rds")
cor_topics <- readRDS("data/cor_topics.rds")

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
          tabName = "topicmodeling",
          text = "Topic Modeling",
          icon = icon("network-wired")
        ),

        menuItem(
          tabName = "both",
          text = "Hot & Cold Topics",
          icon = icon("fire")
        ),

        menuItem(
          tabName = "model",
          text = "Pandemics Case Studies",
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
                    column(12, img(src = "uva-dspg-logo.jpg", width = "300px", height = "300px"), align = "center"),
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
                    title = "Welcome to our Dataset!",
                    closable = FALSE,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    width = NULL,
                    enable_sidebar = FALSE,
                    p("Use this page to explore the words in the abstracts of our R&D projects dataset.
                      You can search for any word to see its representation within our corpus over time and see
                      word importance and frequencies based upon the different funding agencies included in
                      Federal RePORTER. Please be patient, graphs may take a few seconds to load.")
                  ),
                  boxPlus(
                    title = "Explore Words in the Corpus",
                    closable = FALSE,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    width = NULL,
                    enable_sidebar = TRUE,
                    sidebar_width = 20,
                    sidebar_start_open = TRUE,
                    sidebar_content = searchInput("search_term", label = "Type in your search term and then press the Enter key", value = "keyword"),
                    sidebar_title = "Search Term",
                    column(9, plotOutput("word_time")),
                    column(9, p("Note: Extremely frequently used words have been removed as possible search terms. In addition, the axis changes with the frequency of any given word."))
                  ),

                  boxPlus(
                    title = "Important Words by Funding Department",
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
                    column(9, plotOutput("important_words")),
                    footer = p("The weight of each word is given by the TFIDF for abstracts corresponding to the given department.
                               The weight can be thought of as a measure of importance of the word to the corpus.")
                  ),

                  boxPlus(
                    title = "Word Clouds by Funding Department",
                    closable = FALSE,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    width = 6,
                    enable_sidebar = TRUE,
                    sidebar_width = 22,
                    sidebar_start_open = TRUE,
                    sidebar_content = tagList(selectInput("selection", "Choose a department:",
                                                          choices = list("DOD", "ED", "EPA", "HHS",
                                                                         "NASA", "NSF", "USDA", "VA"),
                                                          selected = "DOD"),
                                              hr(),
                                              sliderInput("freq",
                                                          "Minimum Frequency:",
                                                          min = 1000,  max = 10000, value = 5000, step = 1000),
                                              sliderInput("max",
                                                          "Maximum Number of Words:",
                                                          min = 10,  max = 50,  value = 25, step = 5)),
                    column(10, plotOutput("wordcloud")),
                    footer = "The size of each word represents how frequently the word occurs in the abstracts for a given department.  Larger words appear more often."
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
                    column(12, p("Some text describing hot and cold emerging topics, where this idea came from, potentially citing that other paper"))),
                  boxPlus(
                    title = "Emerging Topics",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, h2("Emerging Topics"), align = 'center'),
                    column(12, p("Graphs produced with Plotly. Hover over the lines to see topic and proportion information. Click on a topic to deselect or double click on a topic to isolate. More settings are located on the top right of the graph.")),
                    column(12, plotlyOutput("emerging")),
                    column(12, DT::dataTableOutput("emerging_topics"))
                  ),

                  boxPlus(
                    title = "Hottest & Coldest Topics",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, h2("Hot & Cold Topics")),
                    column(12, p("Information about these figures."), align = 'center'),
                    p("outputs")
                    #column(12, plotlyOutput("emerging")),
                    #column(12, DT::dataTableOutput("emerging_topics"))
                  )
                )),

        tabItem(tabName = "data",
                fluidRow(
                  boxPlus(
                    title = "Data Source",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h3("Federal RePORTER"),
                    p("Our dataset consists of abstracts and project information for more than 1 million R&D grants entered into the ", a(href = "https://federalreporter.nih.gov/", "Federal RePORTER"), "system from 2008 - 2019. The Federal RePORTER database describes it as,  \"a collaborative effort led by STAR METRICS® to create a searchable database of scientific awards from [federal] agencies. This database promotes transparancy and engages the public, the research community, and agencies to describe federal science research investments and provide empirical data for science policy.\" Project information includes project title, department, agency, principle investigator, organization, and project start data. We downloaded our data using the Federal ExPORTER page.")),

                  boxPlus(
                    title = "Data Preparation",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h3("Data Preparation"),
                    p(strong("Defining 'Emerging' Topics:")),
                    p("Our project maps the increase and decrease in new federally funded research projects associated with topics across time. We define a topic as having 'emerged' the first time a project or projects associated with the topic and identified in the corpus. We prepared our data for analysis in keeping with this goal."),
                    p("We needed to:"),
                    tags$ol(
                      tags$li("fill in missing information for project start date"),
                      tags$li("decide on a deduplication strategy for dealing with duplicate abstracts in the corpus, and"),
                      tags$li("clean and prepare the abstracts for use in topic modeling.")),
                    p(strong("Fill in Missing Project Start Dates:")),
                    p("In order to track emerging topics, we need every project in our dataset to have a start date. Our initial dataset had 1,156,137 projects and 13.4% were missing start dates. For projects missing start dates, we utilized the budget start date if available (57.1% of the budget start dates in the full dataset were missing). For projects missing a start date and budget start date, we utilized the fiscal year in which it was added to the Federal RePORTER database as the start date."),
                    p(strong("Deduplication Strategy:")),
                    p("Because our focus was on identifying topics associated with new research projects, we needed to control for multi-institutional projects (e.g., a single project associated with investigators across two or more universities) and extensions of previously established projects (e.g., projects that have their funding extended are recorded in Federal RePORTER with a new start date every time their funding is extended). Counting the same project more than once in a given year or more than once across the timespan of analysis could artificially inflate the number of new projects associated with a topic in a given year. "),
                    p("To do this, we identified and removed duplicate projects. We defined duplicate protects as ones with the same title, abstract, and start date. All but one instance of each set of duplicate projects was removed. The remaining instance of each project was appended to include the latest project end date and the number of unique organizations and principle investigators associated with the project."),
                    p(strong("Abstract Cleaning and Processing:")),
                    p("We removed projects with empty/null abstracts (e.g., abstracts listed as “NA”, “No Abstract Provided”) and projects with abstracts that contained less than 150 characters. These projects lacked sufficient information for the model to associate them with a topic. We cleaned the abstract text by removing elements that were not part of the abstract or not relevant to the specifics of the project (e.g. phrases such as 'non-technical abstract', 'description (provided by applicant) and 'end of abstract). We also removed principal investigator names, project organizations and project titles (if included in abstracts) in order to prevent topics forming around people or universities."),
                    p("After cleaning the abstract text, we used standard natural language processing steps to prepare our abstracts for use with topic models."),
                    tags$ol(
                      tags$li(strong("Tokenization and Lemmatization:"), "Abstracts are transformed into a list of their words (each word is a 'token') and each word is lemmatized (i.e., variations of same word and part-of-speech are reduced to their shared dictionary form of lemma). For example, jumped (verb) and jumps (verb) would both be reduced to jump (verb) but jumpy (adjective) would not."),
                      tags$li(strong("Stop Word Removal"), "Tokens belonging to a standard stop word list are removed. Stop words are common words that provide little information on content and do not contribute to topic meaning, They include words such as: 'as, by, if, most, several, whereas.; We also added custom stop words not included in the standard list (e.g. furthermore, overall, specifically)."),
                      tags$li(strong("N-grams Creation:"), "We utilized bi-grams and tri-grams in pur abstract text. A bi-gram is two words that appear often enough one after the other that they get combined into one token. For example, 'anti_virus' is a bigram. A tri-gram is similar except it contains three words that appear sequentially.")),
                    p("We then removed non-alphanumeric characters in tokens, single character tokens, and numeric tokens that were not years. Listed in the table are the Python packages that we used for each step"),
                    tableOutput("packages"),
                    p("As a final step, inspired by the work in [1], we removed many of the most frequent (remaining) words in the corpus. For example, we removed words such as: research, study, project, use, result, understanding, and investigate. These words appear frequently in our corpus, but they do not contribute to topic meaning because they appear in such a high proportion of abstracts that they are not useful for differentiating across topics."),
                    p("Our final dataset includes 690,814 projects. See the graphs below for information about the number of abstracts in the corpus by project start year, the percent of abstracts by department, and the length of abstracts (in number of characters)."),
                    img(src = "combined_graphs.jpeg", align = "center"),
                    p("HHS represents such a high proportion of the corpus because of the many institutes located within", a(href = "https://www.nih.gov/institutes-nih/list-nih-institutes-centers-offices", "NIH."), "The spike in abstracts between 2009 - 2010 was due to the", a(href = "https://obamawhitehouse.archives.gov/administration/eop/cea/Estimate-of-Job-Creation/", "American Recovery and Reinvestment Act of 2009"), "that was designed to spur job creation after the 2008 Recession through increased science and science-related funding. The character length of abstracts are mainly concentrated around 2500, although there are quite a few longer abstracts as outliers. There are some abstracts over 10000 characters which are not represented in this graph."),
                    footer = p("[1] Alexandra Schofield, Mans Magnusson, Laure Thompson, and David Mimno. Understanding Text Pre-Processing for Latent Dirichlet Allocation. 2017.", a(href = "https://www.cs.cornell.edu/~xanda/winlp2017.pdf.", "https://www.cs.cornell.edu/~xanda/winlp2017.pdf."))
                  ),

                  boxPlus(
                    title = "Topic Modeling",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h3("Topic Modeling"),
                    p("When presented with a collection of text documents, or a corpus, one of the first steps one might take is to understand and classify each document into different topics or themes. For small corpora, it may be feasible to manually read and record the topics of each document; however, this is clearly impractical for large corpora of interest in recent years such as Twitter posts or articles from a scientific journal. Topic modeling helps resolve this issue by automatically processing a corpus and discovering topics that characterize the documents.  "),
                    p("An additional benefit is that document can be assigned to miltiple topics rather than just one, a reasonable assumption given that many documents consist of a combination of themes.  We examined two topic modeling algorithms over the course of this project: Latent Dirichlet allocation (LDA) and non-negative matrix factorization (NMF).  We used the Python package Scikit-Learn for the implementations of both LDA and NMF. "),
                    p(strong("Topic Model Input and Output")),
                    p("LDA and NMF both take a term-document matrix of our cleaned and processed abstract text as input.  A term-document matrix is a mathematical representation of text data as numerical data that can then be analyzed using a statistical model or machine learning algorithm.  More specifically, a term-document matrix tracks is comprised of the frequency count of each word in each document.   "),
                    p("LDA and NMF also output the same two matricies, consisting of the results of the topic model."),
                    tags$ol(
                      tags$li(strong("Document-Term Matrix:"), "this matrix contains information on which topics appear in which documents and how much they appear. LDA represents this information as probabilities of each topic in each document whereas NMF gives weights for each topic in each document."),
                      tags$li(strong("Topic-Term Matrix:"), "this matrix contains information on which words appear in which topics. Again, LDA represents this information using the probability of each word appearing in each topic and NMF gives weights for each word appearing in each topic.  When analyzing topics, we generally only look at the 5 or 10 words in each topic with the highest probability/weight.  ")),
                    p(strong("Latent Dirichlet Allocation - LDA")),
                    p("LDA is a statistical algorithm that generates topics probabilistically, sorting words based on their likelihood of appearing in the same document as one another and reporting these common word-association patterns as the corpus’s most probable topics.  In addition, LDA is a soft-clustering algorithm meaning that the same word can appear in multiple topics. "),
                    p("The main assumption underlying LDA is that the corpus is built using a generative structure that we are trying to recover.  More specifically, the assumption is that each document in the corpus is built word by word using the following steps: 1) pick a topic according to the probability distribution of topics in the corpus, 2) for the selected topic, pick a word according to the probability distribution of words for that topic, and 3) repeat steps 1-2 over and over to create a document.  LDA works to uncover this unobserved structure and thus outputs the document-topic distribution and topic-term distribution as results. "),
                    p("The seminal paper on LDA was written by David M. Blei, Andrew Y. Ng, and Michael I. Jordan [1]. "),
                    p(strong("Non-Negative Matrix Factorization")),
                    p("NMF is a linear algebra based method that is also a soft-clustering algorithm.  NMF is an approximate matrix decomposition that finds the document-topic matrix and topic-term matrix through iterative optimization.  The idea is that the document-term matrix can be approximated as the product of the document-topic matrix and the topic-term matrix, in effect clustering words together into topics, and weighting those topics amongst every document. This approximation yields the best attempt to recreate the original corpus with a topic structure.  The seminal paper on NMF was written by Daniel D. Lee and H. Sebastian Seung [2]. "),
                    column(12, img(src = "nmf_image.png", width = "80%"), align="center"), #, height = "100px"),
                    p("In our work, we use a weighted document-term matrix as input to NMF in order to achieve better topic modeling results.  Instead of only using the frequency of each word in each document, we use a term frequency-inverse document frequency (TFIDF) weighting scheme for each word in each document.  TFIDF has the effect of 'penalizing' words that appear in many documents in the corpus, which aids in topic modeling as these words are most likely not very specific to the topics themselves."),
                    p(strong("Evaluation of Topic Models")),
                    p("To evaluate the quality of our topic models, we need a measure or score of how well the model performed. We also want to ensure that the topics the model finds are coherent and human interpretable.  We generally only look at the top 5-10 words in each topic to interpret what topic is being represented."),
                    p("Given these goals, we use the measure of C", tags$sub("V"), "topic coherence as given in [3] to evaluate our topic models.  As shown in [3], C", tags$sub("V"), "topic coherence is the coherence measure most correlated to human interpretation of topics.  We find the C", tags$sub("V"), "coherence per topic, which is a score that encodes how often the topic words appear together in close proximity within the documents as well aas semantic information. To find the C", tags$sub("V"), "topic coherence for the entire model, take take the average of all of the topic C", tags$sub("V"), "coherence scores. The optimal topic model for our corpus is then selected by comparing the C", tags$sub("V"), "topic coherence scores from each model and selecting the one with the highest score."),
                    footer = p("[1] David M. Blei, Andrew Y. Ng, and Michael I. Jordan. 2003. Latent dirichlet allocation. Journal of Machine Learning Research 3, 993–1022.", a(href = "http://jmlr.org/papers/volume3/blei03a/blei03a.pdf", "http://jmlr.org/papers/volume3/blei03a/blei03a.pdf."),
                               br(),
                               "[2] Daniel D. Lee and H. Sebastian Seung. 1999. Learning the parts of objects by non-negative matrix factorization. Nature 401, 788-791. ",
                               br(),
                               "[3] Michael Röder, Andreas Both, and Alexander Hinneburg. 2015. Exploring the Space of Topic Coherence Measures. In Proceedings of the Eighth ACM International Conference on Web Search and Data Mining (WSDM ’15). Association for Computing Machinery, New York, NY, USA, 399–408. DOI:", a(href = "https://doi.org/10.1145/2684822.2685324", "https://doi.org/10.1145/2684822.2685324"))
                  ),

                  boxPlus(
                    title = "Emerging Topics",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    h3("Emerging Topics"),
                    p("Given our optimal topic mode, an NMF model with 75 topics, we analyze its results to discover and characterize 'hot' and 'cold' topics. To do so, we follow the approach of [1] with the exception that we use our optimal NMF topic model, not an LDA model. o categorize a topic as “hot” or “cold”, we first use the document-topic matrix to find the average weight of each topic in each year between 2010-2019. This creates a set of points for each topic, where each point has the form (year, weightyear).  We then model the relationship between the weights and years for each topic using linear regression. Topics that have regression lines with positive slopes are considered 'hot' and those that have regression lines with negative slopes are considered 'cold'."),
                    p("The slope of the regression line slope serves to capture the trend of the topic overtime.  For example, a “hot” topic means that over time research abstracts within Federal RePORTER’s database have a higher weight for that topic, ie. the topic is more present in the corpus.  The magnitude of the regression line slope allows us to compare which topics are “hotter” or “colder”.  "),
                    p("We used the work of [2] as a reference for this emerging topics technique as well, but instead of using a time period of a few years per data point of the regression line, we chose the strategy of [1] and use a year per data point.  "),
                    p(strong("Pandemics Case Study")),
                    p("We conduct a pandemics case study where we explore emerging topics around the research areas of pandemics and coronavirus.  To do this we first use information retrieval techniques to create two smaller corpora: one that focuses on pandemics, and one that focuses on coronavirus.  We then use an NMF topic model of 30 topics on each smaller corpus and conduct the emerging topics analysis as above.  The size of each corpus is given in the table below. "),
                    tableOutput("case_study"),
                    p("To construct the smaller corpora we use a combination of three different information retrieval techniques.  The steps below outline the process for the pandemics corpus.  For the coronavirus corpus we follow the same steps except replace the word “pandemic” with “coronavirus”. "),
                    tags$ol(
                      tags$li(strong("Literal Term Matching:"), "we use the term-document matrix of frequency counts per word per document for our full dataset of abstracts to extract the 500 projects that have the most occurrences of the word “pandemic” in their abstracts. "),
                      tags$li(strong("TFIDF:"), "we use the TFIDF term-document matrix of weighted counts per word per document for our full dataset of abstracts to extract the 500 projects that have the largest weights for the word “pandemic” in their abstracts. "),
                      tags$li(strong("Latent Semantic Indexing (LSI):"), "we use a truncated singular value decomposition on the TFIDF term-document matrix for our full dataset of abstracts to extract the 500 projects that have abstracts most relevant to the search query for the word “pandemic”.  LSI differs from the previous two information retrieval approaches in the fact that project abstracts returned as relevant to the search query do not necessarily have to contain the word “pandemic”.  But they may contain words that are latently related to the word “pandemic”.  For more information about LSI, the interested reader can see the seminal paper [3].  We use the implementation of the truncated singular value decomposition in the Python package Scikit-Learn. ")),
                    p("To create the smaller corpus we then take the set of unique projects from the union of the results returned from the three information retrieval methods above.  "),
                    footer = p("[1] Thomas L. Griffiths and Mark Steyvers. 2004. Finding Scientific Topics. Proceedings of the National Academy of Sciences 101 (suppl 1), 5228-5235. ", br(), " [2] Hakyeon Lee and Pilsung Kang. 2018. Identifying core topics in technology and innovation management studies: a topic model approach. The Journal of Technology Transfer 43, 1291–1317.", a(href = "https://doi.org/10.1007/s10961-017-9561-4", "https://doi.org/10.1007/s10961-017-9561-4."), br(), "[3] Scott Deerwester, Susan T. Dumais, George W. Furnas, Thomas K. Landauer, and Richard Harshman. 1990. Indexing by latent semantic analysis. Journal of the American Society for Information Science 41 (6), 391-407. ")
                    )

                  )),

        tabItem(tabName = "topicmodeling",
                fluidRow(
                  boxPlus(
                    title = "Topic Modeling Approach Details",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, p("After cleaning and processing the R&D abstracts in our corpus, we are ready to use them for topic modeling.  We create the term-document matrix from the cleaned abstracts and in the process filter the terms to include in the matrix.  We only include a term in the matrix if it meets the following criterion:"),
                      tags$ol(
                        tags$li("A term must appear in at least 20 documents in the corpus, and"),
                        tags$li("A term cannot appear in more than 60% of the documents of the corpus.")
                      ),
	                    p("This filtering of extremes allows us to remove terms that are not frequent enough to become a top 10 word in a topic, and to remove common words to the corpus that would not contribute to topic meaning.  We use the term-document matrix with LDA and the TFIDF term-document matrix with NMF.  Both matrices are created using the Python package Scikit-Learn."),
                      p("In addition to a matrix, LDA and NMF also both require the number of topics as input.  Unfortunately, we do not know the number of topics present in the corpus in advance.  We find our optimal topic model by varying the number of topics for NMF and LDA while tracking the CV topic coherence for each choice.  The model with the largest coherence is the optimal model."),
                      p("For the interested reader, LDA also takes two other parameters: α and β.  α controls the document-topic density and β controls the topic-word density.  A higher value of alpha means that documents are assumed to be made up of more topics whereas a higher value of beta means that topics are assumed to be made up of more of the words in the corpus.  In all of our LDA model runs, we use α = 1/N, where N is the number of topics, and β = 0.1.  These parameter choices allow our documents to be made up of multiple topics [last phrase needs more detail] and the topics to be specific.")
                      )
                    ),
                  boxPlus(
                    title = "Choosing the Optimal Topic Model",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, p("We used the metric of topic coherence to evaluate the best model. Topic coherence is a measure used in topic modeling to measuring the degree of semantic similarity between high scoring words in the topic. Below are the plots of CV topic coherence versus number of topics for our LDA and NMF models.  Each point on these plots represents one run of LDA or NMF with the corresponding number of topics.  Both LDA and NMF are stochastic algorithms, which means that we could get different results for two runs of the same model using the same parameters.  Future work includes creating these plots but where each point would represent the average coherence of ten runs of LDA or NMF with the corresponding number of topics."),
                           column(12, img(src = "LDA_NMF_tc.png", width = "100%"), align = "center"),
                           p("We see that NMF is outperforming LDA and that the optimal topic model for our corpus is NMF using 75 topics.  The jagged nature of these line graphs is due to the stochastic nature of NMF and LDA.  In the future, the plots representing average coherence of 10 model runs for each number of topics will be smoother.")
                    )
                  ),
                  boxPlus(
                    title = "Optimal Topic Model Results",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, p("We give results for the optimal topic model below and proceed to use it for our emerging topics work as well."),
                           column(12, img(src = "coherence.png", width = "90%"), align = "center"),
                           p("Through the measure of topic coherence, we see that topics on liver, vaccine, and students have a high degree of semantic similarity between high scoring words within the topic."),
                           column(12, img(src = "topic_rep.png", width = "90%"), align = "center"),
                           p("We analyzed topics by how represented they are in our data. We found popular topics of cell, patients, proteins and technology."),
                           column(12, img(src = "topic_rank.png", width = "90%"), align = "center"),
                           p("We also analyzed topics by their rank. We found dominant topics similarly to the team in “Identifying Core Topics in Technology and Innovation Management: A Topic Model Approach” by analyzing the number of articles which each topic has the highest proportion. Here, we see that a topic on proteins is the highest-ranking topic at almost 5% while the cell topic (most represented topic in graph above) was less than .5% a dominant topic."),
                           column(12, DT::dataTableOutput("optimal_topics"))

                    )
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
                    column(12, p("We utilized query words to develop two text corpuses for pandemics and coronavirus. This allowed our team to focus on documents specifically related to these words."))),
                    #column(12, p("Graphs produced with Plotly. Hover over the lines to see topic and proportion information. To change graph settings, hover over the top right of the graph."))),
                  boxPlus(
                    title = "Case Study 1: Pandemics",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, h2("Pandemics"), align = 'center'),
                    column(12, p("Explore topics by hovering over lines to see the topic and proportion information. On the legend, click on a topic to deselect or double click on a topic to isolate it and see only one line on the plot.  There are many more functionality options above the legend. To highlight a few, you can click on the Camera button to download the current view as a png. Furthermore, you can use the magnifying glass, plus, and minus sign to zoom in and out. Finally, on the double tag, you can compare proportions for all topics year over year. All interactive graphs are produced with Plotly. Some of the top topics in pandemics are infant respiratory and zika.")),
                    column(12, plotlyOutput("pandemics")),
                    column(12, p("Search for a specific word to find which topics contain the search term.")),
                    column(12, DT::dataTableOutput("pandemics_topics"))
                  ),
                  boxPlus(
                    title = "Case Study 2: Coronavirus",
                    closable = FALSE,
                    width = NULL,
                    status = "warning",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    enable_sidebar = FALSE,
                    column(12, h2("Coronavirus"), align = 'center'),
                    column(12, p("Explore topics by hovering over lines to see the topic and proportion information. On the legend, click on a topic to deselect or double click on a topic to isolate it and see only one line on the plot.  There are many more functionality options above the legend. To highlight a few, you can click on the Camera button to download the current view as a png. Furthermore, you can use the magnifying glass, plus, and minus sign to zoom in and out. Finally, on the double tag, you can compare proportions for all topics year over year. All interactive graphs are produced with Plotly. Some of the top topics in coronavirus are mers and cmv.")),
                    #column(12, p("Graphs produced with Plotly. Hover over the lines to see topic and proportion information. Click on a topic to deselect or double click on a topic to isolate. More settings are located on the top right of the graph.")),
                    column(12, plotlyOutput("coronavirus")),
                    column(12, p("Search for a specific word to find which topics contain the search term.")),
                    column(12, DT::dataTableOutput("coronavirus_topics"))
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
                                       "Research Scientist"
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
                                       "Deputy Division Director & Research Professor"
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
                                       "Senior Scientist"
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
                                       "Research Assistant Professor"
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
                                     "Director of R&D Statistics Program at NCSES"
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
        geom_point(size=3) +
        labs(title = "Word Frequency Over Time", subtitle = "Search Any Term", color = 'Year', x = "Year", y = "Word Frequency") +
        geom_smooth(aes(group = 1), se = FALSE, color = 'light blue', size = 2) +
        scale_x_continuous(breaks = seq(2009, 2019, by = 1)) +
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
        with(wordcloud(word, n, scale = c(5,1.5),
                       min.freq = input$freq, max.words = input$max,
                       ordered.colors = TRUE))
    })

    output$packages <- renderTable({
      table <- matrix(c("Tokenization and Lemmatization", "stanza", "Stop Word List Creation", "spaCy", "N-Grams Creation", "gensim"), ncol = 2, byrow = TRUE)
      colnames(table) <- c("Step", "Python Package")
      table

    })

    output$case_study <- renderTable({
      case_table <- matrix(c("Pandemics", 1137, "Coronavirus", 1012), ncol = 2, byrow = TRUE)
      colnames(case_table) <- c("Corpus", "Number of Projects")
      case_table
    })

    output$emerging <- renderPlotly({

      plot_ly(topics, x = ~ START_YEAR, y = ~ Weight, type = "scatter", mode = "lines+markers", color = topics$Topic, name = topics$Topic_Legend)
    })

    output$emerging_topics <- DT::renderDataTable({
      datatable(reg_topics, rownames = FALSE, options = list(
        order = list(list(0, 'desc'))))
    })

    output$pandemics <- renderPlotly({
      plot_ly(pandemic, x = ~ START_YEAR, y = ~ Weight, type = "scatter", mode = "lines+markers", color = pandemic$Topic, name = pandemic$Topic_Legend)
    })

    output$pandemics_topics <- DT::renderDataTable({
      datatable(pan_topics, rownames = FALSE, options = list(
        order = list(list(0, 'desc'))))
    })

    output$coronavirus <- renderPlotly({
      plot_ly(corona, x = ~ START_YEAR, y = ~ Weight, type = "scatter", mode = "lines+markers", color = corona$Topic, name = corona$Topic_Legend
              )
    })

    output$coronavirus_topics <- DT::renderDataTable({
      datatable(cor_topics, rownames = FALSE, options = list(
        order = list(list(0, 'desc'))))
    })

    output$optimal_topics <- DT::renderDataTable({
      datatable(opt_topics, rownames = FALSE, options = list(
        order = list(list(0, 'desc'))))
    })
  }
)
