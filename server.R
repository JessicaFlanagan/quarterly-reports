library(shiny)
library(shinydashboard)
library(openxlsx)


source('functions.R')

function(input, output) {
  output$table <- renderDataTable(consoleData)
  output$table2 <- renderDataTable(samestoreDownload)
  
   output$downloadData <- downloadHandler(
     filename = function() {
       paste('data-', Sys.Date(), '.xlsx', sep='')
     },
     content = function(con) {
       #write.csv(trendMetrics, con)
       wb = createWorkbook()
       
       addWorksheet(wb, sheetName = "Trends", gridLines = TRUE)
       addWorksheet(wb, sheetName = "YoY (All)", gridLines = TRUE)
       addWorksheet(wb, sheetName = "YoY (Device)", gridLines = TRUE)
       addWorksheet(wb, sheetName = "YoY (Channel)", gridLines = TRUE)
       addWorksheet(wb, sheetName = "YoY (Age)", gridLines = TRUE)
       
       writeData(wb, 1, trendMetrics)
       writeData(wb, 2, metricsAll)
       writeData(wb, 3, metricsByDevice)
       writeData(wb, 4, metricsByChannel)
       writeData(wb, 5, metricsByAge)
       
       saveWorkbook(wb, con, overwrite = TRUE)
     }
   )
}
