source('global.R')

dbHeader <- dashboardHeader(title = "Scorecard Application"
                            # ,
                            # tags$li(a(href = 'https://softserveinc.com/en-US/',
                            #           img(src = '.\\SoftServe_primary-RGB.png',
                            #               title = "SoftServeInc Home", height = "45px"),
                            #           style = "padding-top:10px; padding-bottom:10px;"),
                            #         class = "dropdown")
                            )


body <- dashboardBody(
  tabsetPanel(
    tabPanel(h4("Application"),

                 box(
                   tabPanel("Application", wellPanel(
                     numericInput("creditDuration", "Credit Duration (in month):", min = 0, value = 36),
                     selectInput("property", "Property type:", c("OWN","RENT"), selected = "OWN"),
                     numericInput("loanAmount", "Loan amount:", min = 0, value = 8000),
                     selectInput("age", "Applicant's age:", c("<21","21-25","26-35","36-41","42-50","51+"), selected = "26-35"),
                     selectInput("dependants", "Number of dependants:", c("0","1","2","3","4+"), selected = "0"),
                     sliderInput("monthObligations", "Monthly obligations:", min = 0, max = 10000, value = 1000),
                     sliderInput("obligationsToIncome", "Obligations to Income ratio, %:",  min = 0, max = 100, value = 33),
                     sliderInput("loanToValue", "Loan to Value ratio, %:", min = 0, max = 100, value = 70),
                     selectInput("dealerID", "Dealer ID:", c("1","2","3","4","5","6","7","8"), selected = "1")
                   ))),
             		  box(
             			tags$style(type='text/css', '#odds {background-color: rgba(255,255,0,0.40); color: green;}'),
             			tags$style(type='text/css', '#pd {background-color: rgba(255,255,0,0.40); color: green;}'),
             			tags$style(type='text/css', '#score {background-color: rgba(255,255,0,0.40); color: green;}'),
                  tags$style(type='text/css', '#decision {background-color: rgba(0,0,255,0.10); color: blue;}'),
             			tags$head(tags$style(HTML(" #decision {font-size: 20px;} "))),
             			tags$head(tags$style(HTML(" #score {font-size: 20px;} "))),
             			h3("Score:",
             			(verbatimTextOutput("score", placeholder = T))),
             			h3("Probability of default:",
             			(verbatimTextOutput("pd", placeholder = T))),
             			h3("Odds:",
             			(verbatimTextOutput("odds", placeholder = T))),
             			h1("Suggested credit decision:",
             			(verbatimTextOutput("decision", placeholder = T))) #style='width: 100px; height: 1000px' )
             		  )),
    tabPanel(h4("Scorecard"),
             tabPanel("ScoreCard", dataTableOutput("scorecard"), icon = icon("table"))
             )
  )
)
dashboardPage(
  dbHeader,
  # sidebar,
  dashboardSidebar(disable = TRUE),
  body,
  skin = "black"
)


# shinyUI(fluidPage(
# titlePanel("Credit Decisioning"),
# 	sidebarLayout(position = "right",
#
# 		  sidebarPanel(
# 			tags$style(type='text/css', '#odds {background-color: rgba(255,255,0,0.40); color: green;}'),
# 			tags$style(type='text/css', '#pd {background-color: rgba(255,255,0,0.40); color: green;}'),
# 			tags$style(type='text/css', '#score {background-color: rgba(255,255,0,0.40); color: green;}'),
#     		tags$style(type='text/css', '#decision {background-color: rgba(0,0,255,0.10); color: blue;}'),
# 			tags$head(tags$style(HTML(" #decision {font-size: 20px;} "))),
# 			tags$head(tags$style(HTML(" #score {font-size: 20px;} "))),
# 			h3("Score:",
# 			(verbatimTextOutput("score", placeholder = T))),
# 			h3("Probability of default:",
# 			(verbatimTextOutput("pd", placeholder = T))),
# 			h3("Odds:",
# 			(verbatimTextOutput("odds", placeholder = T))),
# 			h1("Suggested credit decision:",
# 			(verbatimTextOutput("decision", placeholder = T))) #style='width: 100px; height: 1000px' )
# 		  ),
# 		  mainPanel(
# 			tabsetPanel(
# 				tabPanel("Application", wellPanel(
# 					numericInput("creditDuration", "Credit Duration (in month):", min = 0, value = 36),
# 					selectInput("property", "Property type:", c("OWN","RENT"), selected = "OWN"),
# 					numericInput("loanAmount", "Loan amount:", min = 0, value = 8000),
# 					selectInput("age", "Applicant's age:", c("<21","21-25","26-35","36-41","42-50","51+"), selected = "26-35"),
# 					selectInput("dependants", "Number of dependants:", c("0","1","2","3","4+"), selected = "0"),
# 					sliderInput("monthObligations", "Monthly obligations:", min = 0, max = 10000, value = 1000),
# 					sliderInput("obligationsToIncome", "Obligations to Income ratio, %:",  min = 0, max = 100, value = 33),
# 					sliderInput("loanToValue", "Loan to Value ratio, %:", min = 0, max = 100, value = 70),
# 					selectInput("dealerID", "Dealer ID:", c("1","2","3","4","5","6","7","8"), selected = "1")
# 				)),
# 				tabPanel("ScoreCard", dataTableOutput("scorecard"), icon = icon("table"))
#
# 			)
# 		  )
# 	)
#
# ))