library(shiny)
library(shinydashboard)

dashboardPage(skin = "black",
              dashboardHeader(title = "Quarterly Data XLSX Download"),
              dashboardSidebar(
                sidebarMenu(
                  menuItem("Q2 Data Download", tabName = "portfolioData", icon=icon("dashboard"))
                )
              ),
              dashboardBody(
                tabItems(
                  # first tab content
                  tabItem(tabName = "portfolioData",
                          h1("Q2 Portfolio Data (Same Store Data)"),
                          fluidRow(
                            column(12,
                                   h3("Communities Included in Excel Download:"),
                                   dataTableOutput('table2')
                            )
                          ),
                          fluidRow(
                            downloadButton("downloadData", "Download Portfolio Data")
                          )
                  
                  )
                )
              )
)

              