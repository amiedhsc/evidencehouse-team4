# Load required packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(DT)
library(dplyr)

source("global.R")

# Define the UI part of the application
ui <- dashboardPage(
  
  # HEADER ----------------------
  
  dashboardHeader(title = "Latest Amendments"),
  
  
  # SIDEBAR -----------------------
  
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",
      
      # TAB: Recent Amendments ----
      menuItem("Recent Amendments", tabName = "amend_table", icon = icon("clipboard-list")),
      
      # TAB: MP Details ----
      menuItem("MP Details", tabName = "mp_detail", icon = icon("user")),
      div(id = 'sidebar_mps',
          conditionalPanel("input.sidebar === 'mp_detail'",
                           pickerInput("select_mp",
                                       "Select an MP", 
                                       choices = list_mps, 
                                       options = list(`actions-box` = TRUE),
                                       multiple = T)
                           # selectizeInput("select_mp",
                           #                "Select an MP",
                           #                choices =  list_mps,
                           #                selected = NULL)
          ),
          conditionalPanel("input.sidebar === 'mp_detail'",
                           pickerInput("select_theme",
                                       "Select a theme", 
                                       choices = list_themes, 
                                       options = list(`actions-box` = TRUE),
                                       multiple = T)
                           # selectizeInput("select_theme",
                           # "Select a theme",
                           # choices =  list_themes,
                           # selected = NULL)               
          )),
      
      # TAB: Theme Details ----
      menuItem("Theme Details", tabName = "theme_detail", icon = icon("icons")),
      
      # TAB: FAQs ----
      menuItem("FAQs", tabName = "help", icon = icon("circle-question"))
      
    )
  ),
  
  
  # BODY ---------------------------
  
  dashboardBody(
    
    # Set colour scheme for navbar and sidebar
    tags$head(
      tags$style(HTML('
                      /* logo */
                      .skin-blue .main-header .logo {
                      background-color: #148796;
                      }
                      
                      /* logo when hovered */
                      .skin-blue .main-header .logo:hover {
                      background-color: #148796;
                      }
                      
                      /* navbar (rest of the header) */
                      .skin-blue .main-header .navbar {
                      background-color: #148796;
                      }
                      
                      /* menu when hovered */
                      .skin-blue .main-header .navbar .sidebar-toggle:hover {
                      background-color: #106d79;
                      }
                      
                      /* active selected tab in the sidebarmenu */
                      .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                      background-color: #148796;
                      }
                      
                      ')
      ),
      ),
    
    # Add dashboard body for each tab
    tabItems(
      
      # Add details to Recent Amendments tab
      tabItem(tabName = "amend_table",
              fluidPage(
                DT::dataTableOutput('table_amend')
              )
      ),
      tabItem(tabName = "mp_detail",
              fluidPage(
                DT::dataTableOutput('table_mp')
              ))
    )
      )
      )

server <- function(input, output) {
  
  output$table_amend <- DT::renderDataTable(
    DT::datatable(amend_data, options = list(pageLength = 25))
  )
  
  output$table_mp <- DT::renderDataTable(
    DT::datatable(mp_data %>% filter(Name %in% input$select_mp,
                                     Theme %in% input$select_theme), 
                  options = list(pageLength = 25))
  )
  
}

shinyApp(ui, server)
