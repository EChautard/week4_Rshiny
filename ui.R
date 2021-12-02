#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Penguins near Palmer Station, Antarctica"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
            img(src = "OIP.jpeg", height = 108, width = 180),br(),
            'Adelie, Chinstrap and gentoo penguin species.',br(),'Photo credit: Buzzle',br(),br(),

            h3("Selection criteria"),br(),
            h4("1: Select penguin specie(s)"),
            checkboxGroupInput(inputId = "SpeciesFinder",
                               label = "Select Species:",
                               choices = c("Adelie" = "Adelie", "Gentoo" = "Gentoo", "Chinstrap"="Chinstrap"),
                               selected = c("Adelie","Gentoo","Chinstrap")), 
            br(),
            h4("2: Choose if you want to pool or split data by category"),
            radioButtons(inputId = "radio", 
                         label = "Select panel display:",
                         choices = list("Pool all data" = 1, "Split by year" = 2,
                                        "Split by sex" = 3),selected = 1),
            br(),
            h4("3: Select the number of bins you'd like to visualize on the histogram"),
            sliderInput("bins",
                        "Number of bins for the histogram:",
                        min = 1,
                        max = 50,
                        value = 30),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            br(),
            h2("Explore size measurements for adult foraging penguins"),
            textOutput("time"),br(),
            br(),
            br(),
            p("Let's explore a dataset from the R package palmerpenguins."),
            p("On the left panel, you can select penguin specie(s) for the data visualization, or how data should be visualized. Showing data split by category will for example switch to a facet grid mode. You can also select how many bins should be displayed on the hostograms to facilitate data visualization."),
            br(),
            h3("You selected species:"),
            uiOutput("species"),br(),
            h3("Distribution of body weight: "),
            p("Here is the distribution of animals by body weight, for the entire panel or by category (year, sex), depending on your selection."),
            plotlyOutput("distPlot"),
            h3("Scatterplot between bill length and depth: "),
            p("Here is a scatterplot to study if a potential correlation could be found between the bill lengths and depths, for the entire panel or by category (year, sex), depending on your selection."),
            plotlyOutput("corPlot"),
            h3("Data table: "),
            p("Here is the data table from the palmerpenguins R package, for the entire panel or filtered by species, depending on your selection."),
            dataTableOutput("view"),br()
            
        )
    )
))
