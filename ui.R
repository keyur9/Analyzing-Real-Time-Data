###
# Real Time Data Streaming Demo (POC)
# Author: Keyur Doshi
# Date: 12/08/2015
###

# Installing required packages
ifelse(("shiny" %in% rownames(installed.packages()) == FALSE),install.packages("shiny"),suppressPackageStartupMessages(library(shiny)))
ifelse(("rCharts" %in% rownames(installed.packages()) == FALSE),install.packages("rCharts"),suppressPackageStartupMessages(library(rCharts)))
ifelse(("htmlwidgets" %in% rownames(installed.packages()) == FALSE),install.packages("htmlwidgets"),suppressPackageStartupMessages(library(htmlwidgets)))

# Removing Items from environment
remove(list=ls())

# UI
shinyUI(navbarPage("Real Time Clustering", windowTitle = "Real Time Clustering",position = "static-top",
                   tabPanel("Dashboard",
                            sidebarLayout(
                              sidebarPanel(
                                selectInput('xcol', 'X Variable', names(iris[-5]),selected=names(iris)[[1]]),
                                selectInput('ycol', 'Y Variable', names(iris[-5]),
                                            selected=names(iris)[[2]]),
                                numericInput('clusters', 'Cluster count', 3,
                                             min = 1, max = 9),
                                hr(),
                                radioButtons("plot_type", "Plot type",c("rCharts","base","polyChart"),selected = "rCharts",inline = TRUE),
                                hr(),
                                singleton(
                                  tags$head(tags$script(src = "message-handler.js"))
                                ),
                                h3("Download Image"),
                                helpText("Click the button to download the image."),
                                actionButton("download", "Download"),
                                
                                h3("Send Email"),
                                helpText("Share your findings with your colleague."),
                                textInput("email", label = NULL,value = "Enter email address..."),
                                
                                actionButton("send", "Send Email")
                                #fluidRow(column(3, verbatimTextOutput("value")))
                              ),
                              mainPanel(  
                                
                                conditionalPanel(
                                  condition = "input.plot_type == 'rCharts'",showOutput("myChart","Highcharts")),
                                conditionalPanel(
                                  condition = "input.plot_type == 'polyChart'",showOutput("polyChart","Nvd3")),# polycharts
                                conditionalPanel(
                                  condition = "input.plot_type == 'base'",plotOutput('plot1'))
                              )
                            ),
                            HTML('<footer>
                                 <hr>
                                 <center>
                                 Built by <a href="https://www.linkedin.com/in/keyur9">Keyur Doshi</a>.  Styled with <a href="http://rcharts.io/"> rCharts</a>.  Hosted on <a href="https://github.com/"> GitHub</a>.  Inspired by <a href="http://shiny.rstudio.com/"> ShinyApps</a>
                                 </center>
                                 </footer>')
                            ),
                   
                   tabPanel("Data Summary",
                            verbatimTextOutput("summary"),
                            HTML('<footer>
                                 <hr>
                                 <center>
                                 Built by <a href="https://www.linkedin.com/in/keyur9">Keyur Doshi</a>.  Styled with <a href="http://rcharts.io/"> rCharts</a>.  Hosted on <a href="https://github.com/"> GitHub</a>.  Inspired by <a href="http://shiny.rstudio.com/"> ShinyApps</a>
                                 </center>
                                 </footer>')
                            ),
                   tabPanel("Data Table",
                            dataTableOutput("table"),
                            HTML('<footer>
                                 <hr>
                                 <center>
                                 Built by <a href="https://www.linkedin.com/in/keyur9">Keyur Doshi</a>.  Styled with <a href="http://rcharts.io/"> rCharts</a>.  Hosted on <a href="https://github.com/"> GitHub</a>.  Inspired by <a href="http://shiny.rstudio.com/"> ShinyApps</a>
                                 </center>
                                 </footer>')
                            ),
                   
                   tabPanel("Prediction",
                            
                            sidebarLayout(
                              sidebarPanel(
                                
                                # add some help text
                                h3("Prediction"),
                                
                                p("This will demonstrate the prediction of Sepal Length provided the 
                                  Petal Width, Petal Length and Species")
                                
                                ),
                              
                              mainPanel(
                                
                                
                                # add a selection box for selecting a county
                                h3("Prediction of Sepal Length of Flowers"),
                                p("Select a set of input variables below to predict the sepal lenght of flowers"),
                                
                                fluidRow(
                                  column(3,
                                         
                                         selectInput("species", 
                                                     label = "Select the Species",
                                                     choices = list("versicolor", "virginica","setosa") # , # (iris[5]) iris[5]
                                         ) # selected = "versicolor"
                                  ),
                                  
                                  column(3,
                                         
                                         numericInput("petalWidth", 
                                                      label = "Petal Width (mm):",
                                                      min = 0.01, max = 3, value = 0.1)
                                  ),
                                  
                                  column(3,
                                         
                                         sliderInput("petalLength", 
                                                     label = "Petal Length (mm):",
                                                     min = 0.1, max = 7.0, value = 0.1)
                                  )
                                ),
                                
                                actionButton("predictSepalLength", 
                                             label="Predict Sepal Length"),
                                br(),
                                br(),
                                
                                verbatimTextOutput("predict_new_value")
                                
                              )
                            ),  
                            HTML('<footer>
                                 <hr>
                                 <center>
                                 Built by <a href="https://www.linkedin.com/in/keyur9">Keyur Doshi</a>.  Styled with <a href="http://rcharts.io/"> rCharts</a>.  Hosted on <a href="https://github.com/"> GitHub</a>.  Inspired by <a href="http://shiny.rstudio.com/"> ShinyApps</a>
                                 </center>
                                 </footer>')
                                   ),
                        
                        tabPanel("About", 
                                 
                                 HTML ('<div class="col-sm-10 col-sm-offset-1"><h1>Welcome to Real Time Clustering Application</h1>
                                       
                                       <p>The <em>Real Time Clustering Application</em> web application helps you real time clustering of your data. It streamlined the process of viewing plot, data summary, data table, and prediction of Sepal Length - all done inside your web browser.</p>
                                       
                                       <p>A common and logical usage of the web app would be: click <strong>Download</strong> on Plot panel to download the graphical representation of the clustering; specify the email address for sending mail in the <strong>Send Email</strong> section ; then view the  summary of your data under <strong>Data Summary</strong> and <strong>Data Table</strong> panels. Finally, you will be able to predict the Specal Length in the <strong>Prediction</strong> panel.</p>
                                       
                                       <h3>Feedback</h3>
                                       
                                       <p>If you have any questions, suggestions, or ideas about the web app, please feel free to let me know:</p>
                                       
                                       <p>Keyur Doshi &lt;<a href="mailto:kdoshi2@stevens.edu">kdoshi2@stevens.edu</a>&gt;</p>
                                       <footer>
                                       <hr>
                                       <center>
                                       Built by <a href="https://www.linkedin.com/in/keyur9">Keyur Doshi</a>.  Styled with <a href="http://rcharts.io/"> rCharts</a>.  Hosted on <a href="https://github.com/"> GitHub</a>.  Inspired by <a href="http://shiny.rstudio.com/"> ShinyApps</a>
                                       </center>
                                       </footer>
                                       </div>')
                                 
                                 )
                        )
                        )