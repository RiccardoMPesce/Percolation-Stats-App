library(shiny)
library(httr)
library(glue)
library(ggplot2)
library(dplyr)

simulation_page <- tabPanel(
  title = "Analysis",
  titlePanel("Analysis"),
  sidebarLayout(
    sidebarPanel(
      title = "Simulation Parameters",
      textInput(
        "server_address", 
        "Server Address",
        placeholder = "0.0.0.0"
      ),
      textInput(
        "server_port", 
        "Server Port",
        placeholder = "5000"
      ),
      numericInput("n", "Percolation Grid Dimension", 5, min = 1),
      numericInput("sample_size", "Sample Size", 20, min = 1),
      actionButton("run_button", "Run Analysis")
    ),
    mainPanel(
      title = "Simulation Results",
      titlePanel("Simulation Results"),
      verbatimTextOutput("summary"),
      plotOutput("plot"),
      plotOutput("box_plot")
    )
  )
)

custom_simulation_page <- tabPanel(
  title = "Custom Threshold Analysis",
  titlePanel("Analysis for a custom threshold"),
  sidebarLayout(
    sidebarPanel(
      title = "Simulation Parameters",
      textInput(
        "server_address_custom", 
        "Server Address",
        placeholder = "0.0.0.0"
      ),
      textInput(
        "server_port_custom", 
        "Server Port",
        placeholder = "5000"
      ),
      numericInput("p_custom", "Custom Threshold", 0.4, min = 0, max = 1),
      numericInput("n_custom", "Percolation Grid Dimension", 5, min = 1),
      numericInput("sample_size_custom", "Sample Size", 20, min = 1),
      actionButton("run_button_custom", "Run Analysis")
    ),
    mainPanel(
      title = "Simulation Results",
      titlePanel("Simulation Results"),
      verbatimTextOutput("summary_custom"),
      plotOutput("plot_custom")
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
    geom_histogram(color="black", fill="white") +
    xlab("Computed Threshold") + 
    ylab("")
}

draw_plot_custom <- function(data) {
  ggplot(data = data, aes(x = value)) +
    geom_bar(color="black", fill="white") +
    xlab("") + 
    ylab("")
}

draw_box_plot <- function(data) {
  ggplot(data = data, aes(x = value)) +
    geom_boxplot(color="black", fill="white") +
    xlab("Computed Threshold") + 
    ylab("")
}

write_stats <- function(data) {
  summary(data$value)
}

ui <- navbarPage(
  title = "Percolation Data Analyser",
  simulation_page,
  custom_simulation_page,
  about_page
)

server <- function(input, output, session) {
  results <- NULL
  
  simulation <- eventReactive(
    input$run_button,
    {
      req(input$n)
      req(input$sample_size)
      json_data <- GET(glue("{input$server_address}:{input$server_port}/simulation/simulate/{input$n}/{input$sample_size}/"))
      results <- as_tibble(unlist(content(json_data)$results))
    }
  )
  
  simulation_custom <- eventReactive(
    input$run_button_custom,
    {
      req(input$p_custom)
      req(input$n_custom)
      req(input$sample_size_custom)
      json_data_custom <- GET(glue("{input$server_address_custom}:{input$server_port_custom}/simulation/simulate_custom_p/{input$p_custom}/{input$n_custom}/{input$sample_size_custom}/"))
      results_custom <- as_tibble(unlist(content(json_data_custom)$results))
    }
  )
  
  output$plot <- renderPlot({
    results <- simulation()
    draw_plot(results)
  })
  
  output$plot_custom <- renderPlot({
    results <- simulation_custom()
    draw_plot_custom(results)
  })
  
  output$box_plot <- renderPlot({
    results <- simulation()
    draw_box_plot(results)
  })
  
  output$summary <- renderPrint({
    results <- simulation()
    write_stats(results)
  })
}

shinyApp(ui, server)