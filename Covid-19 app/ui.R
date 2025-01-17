
# Load Libraries ----------------------------------------------------------

library("shiny")
library("shinythemes")


# UI Code -----------------------------------------------------------------

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # App title ----
    titlePanel("Covid-19 Pandemic Overview"),
    h4("World map colored by status per 100k citizens"),
    # Output: global map ----
    plotOutput(outputId = "Heatmap",
               click = "map_click"),
    sidebarLayout(
        
        sidebarPanel(
            selectInput(inputId = "status",
                        label = "Choose status",
                        choices = c("Cases" = "Confirmed", 
                                    "Deaths" = "Deaths")),
            checkboxInput(inputId = "yLog", 
                          label = "Display Y-Axis on a Log Scale?")),
        mainPanel(
            plotOutput(outputId = "timeseries_plot")),
        position = c("left", "right"))
))

