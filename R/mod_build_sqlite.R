#' build_sqlite UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_build_sqlite_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      fileInput(ns("file_sql"), "Indique o diretório do SQL",
                buttonLabel = "Explorar", placeholder = "Nenhum diretório apontado")
    ),
    fluidRow(actionButton(ns("selecionar_dados"), "", icon = icon("crosshairs")),
             actionButton(ns("filtrar_dados"), "", icon = icon("filter")),
             downloadButton(ns("baixar_dados"), label = "Baixar Dados")

    )


  )
}

#' build_sqlite Server Functions
#'
#' @noRd
mod_build_sqlite_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    #Limite de dados no Shiny
    options(shiny.maxRequestSize=32*1024^3)

    #Remover notação cientitifica
    options(scipen = 999)

    observeEvent(input$filtrar_dados, {
      showModal(
        modalDialog(

            title = "Filtrar Dados",
            footer = modalButton("Fechar"),
            size = "xl",
            fluidRow(

            column(3,
                            selectInput(ns("variavel"),label = "Selecione a Variável",
                                        choices = "Nenhuma Selecionada")
            ),
            column(3,
                   selectInput(ns("logica"),label = "Selecione a Lógica",
                               choices = c(">", ">=", "==", "%in%", "<", "<=",
                                           "entre"

                               ))
            ),
            column(3,
                   textInput(ns("filtro"),label = "Insira a Lógica"))

            )



      )

      )
    })

    dataset <- reactive({
      #pegando o input do sqlite
      file_sql<- input$file_sql
      if (is.null(file_sql)) return(NULL)

      #salvando ele no filename
      filename <- file_sql$datapath

      #Passando para a conexão
      con_sqlite <-DBI::dbConnect(RSQLite::SQLite(), filename)

      dplyr::tbl(con_sqlite)
    })

  })
}

## To be copied in the UI
# mod_build_sqlite_ui("build_sqlite_1")

## To be copied in the server
# mod_build_sqlite_server("build_sqlite_1")
