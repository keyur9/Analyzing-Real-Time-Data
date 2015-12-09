###
# Real Time Data Streaming Demo (POC)
# Author: Keyur Doshi
# Date: 12/08/2015
###


# Installing required packages
ifelse(("shiny" %in% rownames(installed.packages()) == FALSE),install.packages("shiny"),suppressPackageStartupMessages(library(shiny)))
ifelse(("DT" %in% rownames(installed.packages()) == FALSE),install.packages("DT"),suppressPackageStartupMessages(library(DT)))
ifelse(("caret" %in% rownames(installed.packages()) == FALSE),install.packages("caret"),suppressPackageStartupMessages(library(caret)))
ifelse(("mailR" %in% rownames(installed.packages()) == FALSE),install.packages("mailR"),suppressPackageStartupMessages(library(mailR)))
ifelse(("rCharts" %in% rownames(installed.packages()) == FALSE),install.packages("rCharts"),suppressPackageStartupMessages(library(rCharts)))
ifelse(("htmlwidgets" %in% rownames(installed.packages()) == FALSE),install.packages("htmlwidgets"),suppressPackageStartupMessages(library(htmlwidgets)))

# Removing Items from environment
remove(list=ls())

# Server functionality
shinyServer(function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    iris[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
    
  })
  
  X_col <- reactive ({
    iris[, c(input$xcol)]
  })
  
  Y_col <- reactive ({
    iris[, c(input$ycol)]
  })
  
  # Obeserving send button event
  
  observeEvent(input$send, {
    file.remove("Dynamic_Clustering.png") # reomve file
    dev.set()
    working_dir <- getwd()
    filename <-"/Dynamic_Clustering.png"
    Output_file<-paste(working_dir,filename,sep = "")
    png(filename=Output_file)
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    dev.off()
    
    dev.set()
    working_dir <- getwd()
    filename <-"/Dynamic_Clustering.png"
    attachment <- paste(working_dir,filename,sep = "")
    dev.off()
    
    sender <- "keyur.kv@gmail.com"
    recipients <- input$email #c("keyur.kv@gmail.com")
    send.mail(from = sender,
              to = recipients,
              subject="Hello from R",
              body = "Testing Shiny with R",
              smtp = list(host.name = "smtp.gmail.com", port = 465, 
                          user.name="keyur.kv@gmail.com", passwd="keyur@888", ssl=TRUE),
              authenticate = TRUE,
              attach.files=attachment,
              send = TRUE)
  })
  
  # Function to capture User's input
  upetalLength <- reactive({
    input$petalLength
  })
  
  # Function to capture User's input
  upetalWidth <- reactive({
    input$petalWidth
  })
  
  # Function to capture User's input
  uspecies <- reactive({
    input$species
  })
  
  # Model for prediction
  model_fit <- glm(Sepal.Length ~ Species + Petal.Width + Petal.Length, data = iris, family = "gaussian") #  method = "lm" 
  
  # Function to capture User's input
  observeEvent(input$predictSepalLength, {
    
    output$predict_new_value <- renderText({
      
      input$predictSepalLength
      
      kSpecies <- as.character(uspecies()) 
      kPetal_Width <- as.double(upetalWidth())
      kPetal_Length <- as.double(upetalLength())
      
      predicted_value <- predict(model_fit,data.frame(Species = uspecies(), Petal.Width = kPetal_Width,
                                                      Petal.Length = kPetal_Length) ) 
      
    })
  })
  
  # Function to capture User's input
  observeEvent(input$download, {
    file.remove("Dynamic_Clustering.png")
    dev.set()
    working_dir <- getwd()
    filename <-"/Dynamic_Clustering.png"
    Output_file<-paste(working_dir,filename,sep = "")
    png(filename=Output_file)
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    dev.off()
    session$sendCustomMessage(type = 'testmessage',message = list(a = 1, b = 'text'))
  })
  
  # Plot output based on User's input
  output$plot1 <- renderPlot({
    
    withProgress(message = 'Creating Plot', value = 0.1, {
      Sys.sleep(0.25)
      
      # Create 0-row data frame which will be used to store data
      dat <- data.frame(x = numeric(0), y = numeric(0))
      
      # withProgress calls can be nested, in which case the nested text appears
      # below, and a second bar is shown.
      withProgress(message = 'Generating data', detail = "part 0", value = 0, {
        for (i in 1:5) {
          # Each time through the loop, add another row of data. This a stand-in
          # for a long-running computation.
          dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))
          
          # Increment the progress bar, and update the detail text.
          incProgress(0.1, detail = paste("part", i))
          
          # Pause for 0.1 seconds to simulate a long computation.
          Sys.sleep(0.1)
        }
      })
      
      # Increment the top-level progress indicator
      incProgress(0.5)
      
      # Another nested progress indicator.
      # When value=NULL, progress text is displayed, but not a progress bar.
      withProgress(message = 'Almost there', detail = "Done",
                   value = NULL, {
                     
                     Sys.sleep(0.75)
                   })
      
      # We could also increment the progress indicator like so:
      # incProgress(0.5)
      # but it's also possible to set the progress bar value directly to a
      # specific value:
      setProgress(1)
    })
    
    #       
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  # HighChart output based on User's input
  output$myChart <- renderChart2({
    withProgress(message = 'Creating Highcharts', value = 0.1, {
      Sys.sleep(0.25)
      
      # Create 0-row data frame which will be used to store data
      dat <- data.frame(x = numeric(0), y = numeric(0))
      
      # withProgress calls can be nested, in which case the nested text appears
      # below, and a second bar is shown.
      withProgress(message = 'Generating data', detail = "part 0", value = 0, {
        for (i in 1:5) {
          # Each time through the loop, add another row of data. This a stand-in
          # for a long-running computation.
          dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))
          
          # Increment the progress bar, and update the detail text.
          incProgress(0.1, detail = paste("part", i))
          
          # Pause for 0.1 seconds to simulate a long computation.
          Sys.sleep(0.1)
        }
      })
      
      # Increment the top-level progress indicator
      incProgress(0.5)
      
      # Another nested progress indicator.
      # When value=NULL, progress text is displayed, but not a progress bar.
      withProgress(message = 'Almost there', detail = "Done",
                   value = NULL, {
                     
                     Sys.sleep(0.75)
                   })
      
      # We could also increment the progress indicator like so:
      # incProgress(0.5)
      # but it's also possible to set the progress bar value directly to a
      # specific value:
      setProgress(1)
    })
    datadf <- data.frame(iris)
    p1 <- hPlot(x=input$xcol, y=input$ycol, type="bubble", group ="Species",size = input$clusters, data=datadf) # "Petal.Width"
    p1$chart(zoomType="xy")
    p1
  })
 
  # Polychart output based on User's input
  output$polyChart <- renderChart2({
    
    withProgress(message = 'Creating Polychart', value = 0.1, {
      Sys.sleep(0.25)
      
      # Create 0-row data frame which will be used to store data
      dat <- data.frame(x = numeric(0), y = numeric(0))
      
      # withProgress calls can be nested, in which case the nested text appears
      # below, and a second bar is shown.
      withProgress(message = 'Generating data', detail = "part 0", value = 0, {
        for (i in 1:5) {
          # Each time through the loop, add another row of data. This a stand-in
          # for a long-running computation.
          dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))
          
          # Increment the progress bar, and update the detail text.
          incProgress(0.1, detail = paste("part", i))
          
          # Pause for 0.1 seconds to simulate a long computation.
          Sys.sleep(0.1)
        }
      })
      
      # Increment the top-level progress indicator
      incProgress(0.5)
      
      # Another nested progress indicator.
      # When value=NULL, progress text is displayed, but not a progress bar.
      withProgress(message = 'Almost there', detail = "Done",
                   value = NULL, {
                     
                     Sys.sleep(0.75)
                   })
      
      # We could also increment the progress indicator like so:
      # incProgress(0.5)
      # but it's also possible to set the progress bar value directly to a
      # specific value:
      setProgress(1)
    })
    datadf <- data.frame(iris) 
    #         x  = input$xcol
    #         y  = input$ycol
    plot1 <- nPlot(Sepal.Length ~ Sepal.Width,data=datadf, 
                   type='scatterChart') #group='Species',
    plot1$xAxis(axisLabel = 'Sepal.Length')
    plot1$yAxis(axisLabel = 'Sepal.Width')
    plot1
  })
  
  # Summary
  output$summary <- renderPrint({
    summary(iris)
    
  })
  
  # Data Table
  output$table <- renderDataTable({
    dataTabledf <- data.frame(iris, "Clusters" = clusters()$cluster)
    
  }, options=list(pageLength=10,tableTools = list(sSwfPath = copySWF()),dom = 'T<"clear">lfrtip'))
  
}
)