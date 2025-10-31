# User Onboarding Dashboard
# Shiny Dashboard Application for analyzing user onboarding data

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(scales)

# Source the graphs/plotting functions
source("R/graphs.R")

# Load data
user_data <- read.csv("data/data_visualization.csv", stringsAsFactors = FALSE)

# Data preprocessing
user_data <- user_data %>%
  mutate(
    user_registered = mdy(user_registered),
    completed_date = mdy(completed_date),
    user_paid = as.factor(user_paid),
    onboarded = as.factor(onboarded)
  )

# UI Definition
ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(title = "Student Onboarding"),
  
  dashboardSidebar(
    width = 250,
    h4("Filters", style = "padding-left: 15px; color: white;"),
    hr(style = "border-color: white;"),
    
    selectInput("filterCountry", "Country:",
                choices = c("All", sort(unique(user_data$onboarding_country[!is.na(user_data$onboarding_country) & 
                                                                              user_data$onboarding_country != "NULL" & 
                                                                              user_data$onboarding_country != ""]))),
                selected = "All"),
    
    selectInput("filterSubscription", "Subscription Type:",
                choices = c("All", sort(unique(user_data$subscription_type[!is.na(user_data$subscription_type) & 
                                                                             user_data$subscription_type != "NULL" & 
                                                                             user_data$subscription_type != ""]))),
                selected = "All"),
    
    selectInput("filterOnboarded", "Onboarding Status:",
                choices = c("All", "onboarded", "not-onboarded"),
                selected = "All"),
    
    selectInput("filterChannel", "Acquisition Channel:",
                choices = c("All", sort(unique(user_data$onboarding_heard_from_label[!is.na(user_data$onboarding_heard_from_label) & 
                                                                                       user_data$onboarding_heard_from_label != "NULL" & 
                                                                                       user_data$onboarding_heard_from_label != ""]))),
                selected = "All"),
    
    dateRangeInput("dateRange", "Registration Date Range:",
                   start = min(user_data$user_registered, na.rm = TRUE),
                   end = max(user_data$user_registered, na.rm = TRUE)),
    
    actionButton("resetFilters", "Reset Filters", 
                 style = "width: 90%; margin: 10px;",
                 class = "btn-warning")
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper { background-color: #ecf0f5; }
        .box { border-top: 3px solid #3c8dbc; }
        .small-box { border-radius: 5px; }
        .small-box h3 { font-size: 32px; font-weight: bold; }
      "))
    ),
    
    # Key Metrics Row
    fluidRow(
      valueBoxOutput("totalStudents", width = 4),
      valueBoxOutput("totalSurveys", width = 4),
      valueBoxOutput("onboardingRate", width = 4)
    ),
    
    # World Map Row
    fluidRow(
      box(
        title = "Global Distribution - Onboarding Rate by Country",
        width = 12,
        status = "primary",
        solidHeader = TRUE,
        plotOutput("worldMapRate", height = 400)
      )
    ),
    
    # Bar Plots Row
    fluidRow(
      box(
        title = "Where Did You Hear About Us?",
        width = 4,
        status = "info",
        solidHeader = TRUE,
        plotOutput("channelPlot", height = 350)
      ),
      box(
        title = "What Are Your Objectives?",
        width = 4,
        status = "success",
        solidHeader = TRUE,
        plotOutput("objectivesPlot", height = 350)
      ),
      box(
        title = "What Would You Like to Learn?",
        width = 4,
        status = "warning",
        solidHeader = TRUE,
        plotOutput("learningPlot", height = 350)
      )
    )
  )
)

# Server Logic
server <- function(input, output, session) {
  
  # Reactive filtered data
  filtered_data <- reactive({
    data <- user_data
    
    # Apply filters
    if (input$filterCountry != "All") {
      data <- data %>% filter(onboarding_country == input$filterCountry)
    }
    
    if (input$filterSubscription != "All") {
      data <- data %>% filter(subscription_type == input$filterSubscription)
    }
    
    if (input$filterOnboarded != "All") {
      data <- data %>% filter(onboarded == input$filterOnboarded)
    }
    
    if (input$filterChannel != "All") {
      data <- data %>% filter(onboarding_heard_from_label == input$filterChannel)
    }
    
    # Date range filter
    data <- data %>%
      filter(user_registered >= input$dateRange[1],
             user_registered <= input$dateRange[2])
    
    return(data)
  })
  
  # Reset filters
  observeEvent(input$resetFilters, {
    updateSelectInput(session, "filterCountry", selected = "All")
    updateSelectInput(session, "filterSubscription", selected = "All")
    updateSelectInput(session, "filterOnboarded", selected = "All")
    updateSelectInput(session, "filterChannel", selected = "All")
    updateDateRangeInput(session, "dateRange",
                         start = min(user_data$user_registered, na.rm = TRUE),
                         end = max(user_data$user_registered, na.rm = TRUE))
  })
  
  # Value Boxes
  output$totalStudents <- renderValueBox({
    valueBox(
      format(nrow(filtered_data()), big.mark = ","),
      "Total Students",
      icon = icon("users"),
      color = "blue"
    )
  })
  
  output$totalSurveys <- renderValueBox({
    surveys_count <- filtered_data() %>%
      filter(onboarded == "onboarded") %>%
      nrow()
    
    valueBox(
      format(surveys_count, big.mark = ","),
      "Total Surveys Completed",
      icon = icon("clipboard-check"),
      color = "green"
    )
  })
  
  output$onboardingRate <- renderValueBox({
    total <- nrow(filtered_data())
    onboarded <- sum(filtered_data()$onboarded == "onboarded", na.rm = TRUE)
    rate <- if(total > 0) round((onboarded / total) * 100, 1) else 0
    
    valueBox(
      paste0(rate, "%"),
      "Onboarding Rate",
      icon = icon("chart-line"),
      color = "purple"
    )
  })
  
  # World Map with Rate
  output$worldMapRate <- renderPlot({
    plot_world_map_rate(filtered_data())
  })
  
  # Channel Plot
  output$channelPlot <- renderPlot({
    plot_acquisition_channels(filtered_data())
  })
  
  # Objectives Plot
  output$objectivesPlot <- renderPlot({
    plot_user_goals(filtered_data())
  })
  
  # Learning Plot
  output$learningPlot <- renderPlot({
    plot_learning_interests(filtered_data())
  })
}

# Run the application
shinyApp(ui = ui, server = server)
