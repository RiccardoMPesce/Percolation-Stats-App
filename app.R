library(shiny)
library(httr)
library(glue)
library(ggplot2)
library(dplyr)

main_page <- tabPanel(
  title = "Analysis",
  titlePanel("Analysis"),
  sidebarLayout(
    sidebarPanel(
      title = "Simulation Parameters",
      numericInput("n", "Percolation Grid Dimension", 5, min = 1),
      numericInput("sample_size", "Sample Size", 20, min = 1),
      actionButton("run_button", "Run Analysis")
    ),
    mainPanel(
      title = "Simulation Results",
      titlePanel("Simulation Results"),
      plotOutput("plot"),
      verbatimTextOutput("summary")
    )
  )
)

about_page <- tabPanel(
  title = "About",
  titlePanel("About"),
  "Created with R by Riccardo M. Pesce"
)

draw_plot <- function(data) {
  ggplot(data = data, aes(x = value)) +
    geom_histogram(color="black", fill="white")
}

write_stats <- function(data) {
  summary(data$value)
}

ui <- navbarPage(
  title = "Percolation Data Analyser",
  main_page,
  about_page
)

server <- function(input, output, session) {
  results <- NULL
  
  simulation <- eventReactive(
    input$run_button,
    {
      req(input$n)
      req(input$sample_size)
      json_data <- GET(glue("http://0.0.0.0:5000/simulation/simulate/{input$n}/{input$sample_size}/"))
      results <- as_tibble(unlist(content(json_data)$results))
    }
  )
  
  output$plot <- renderPlot({
    results <- simulation()
    draw_plot(results)
  })
  
  output$summary <- renderPrint({
    results <- simulation()
    write_stats(results)
  })
}

shinyApp(ui, server)