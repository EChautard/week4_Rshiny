#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(palmerpenguins)
library(plotly)
library(ggplot2)
library(DT)

penguins<-penguins[!is.na(penguins$body_mass_g),]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    #output$species <- renderText(paste0(input$SpeciesFinder))
    output$species <- renderUI(HTML(paste0("<ul><li>",sapply(input$SpeciesFinder, paste, collapse = "</li><li>"),"</li></ul>")))
    output$time<-renderText(as.character(format(Sys.Date(), format="%B %d %Y")))
    
    output$distPlot <- renderPlotly({
            # filter only selected specied of penguins
            penguins_sel <- penguins %>% filter(species %in% input$SpeciesFinder)
            # generate bins based on input$bins from ui.R
            x    <- penguins_sel$body_mass_g
            b <- input$bins
    
            # draw the histogram with the specified number of bins
            p <- ggplot(penguins_sel, aes(x=body_mass_g , color=species, fill = species), alpha=.5) +
                geom_histogram(bins=b) +
                xlab ("Body mass (g)") +
                ylab("Distribution")
            if ( input$radio == 2 ){
              p <- p + facet_grid(. ~ year)
            }
            else if ( input$radio == 3 ){
              p <- p + facet_grid(. ~ sex)
            }
            fig <- ggplotly(p)
            fig
    })

    output$corPlot <- renderPlotly({
      # filter only selected specied of penguins
      penguins_sel <- penguins %>% filter(species %in% input$SpeciesFinder)

      # Extend the regression lines beyond the domain of the data
      p <- ggplot(penguins_sel, aes(x=bill_length_mm, y=bill_depth_mm, color=species)) + geom_point(shape=1) +
        xlab ("Bill length (mm)") +
        ylab("Bill depth (mm)") +
        scale_colour_hue(l=50) + # Use a slightly darker palette than normal
        geom_smooth(method=lm,   # Add linear regression lines
                    se=FALSE,    # Don't add shaded confidence region
                    fullrange=TRUE)   # Extend regression lines
      if ( input$radio == 2 ){
        p <- p + facet_grid(. ~ year)
      }
      else if ( input$radio == 3 ){
        p <- p + facet_grid(. ~ sex)
      }
      
      fig <- ggplotly(p)
      fig
    })
    
    # Show the first "n" observations
    output$view <- renderDataTable({
      penguins_sel <- penguins %>% filter(species %in% input$SpeciesFinder)
      DT::datatable(penguins_sel)
    })
})
