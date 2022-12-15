#' extract_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import shinyjs
mod_extract_data_ui <- function(id){
  ns <- NS(id)
  options(shiny.maxRequestSize=120*1024^3)
  options(scipen = 999)
  tagList(
    #Modal de carregamento dos dados

    fluidRow("Clique no botão abaixo para personalizar o carregamento dos dados"),
    fluidRow(
      actionButton(ns("modal_carregamento"), "Opções de carregamento"#,
                  #style="color: #fff; background-color: #337ab7; border-color: #d12c0f"
                   )
      ),

    #File input
    shiny::fluidRow(shinyjs::useShinyjs(),

                    fileInput(ns("file"),
                              "Indique o Repositorio do Dataset",
                              buttonLabel = "Carregar diretorio",
                              placeholder = "Nenhum Arquivo Selecionado")
                    #DataEditR::dataInputUI(ns("input1")),
    ), #fim fluidrow

    #
    #Fluidrow botões
    fluidRow(

      DataEditR::dataSelectUI(ns("select1")),
      DataEditR::dataFilterUI(ns("filter1")),
      #DataEditR::dataOutputUI(ns("output1")),
      downloadButton(ns("download"),
                     label = "Baixar Dataset")
    ),

    fluidRow(verbatimTextOutput(outputId = ns("render_glimpse"))),#fim fluidrow

    #Downlooad button
    #fluidRow(downloadButton(ns("downloadData"), "Baixar Dados"))
  )#Fim taglist

}

#' extract_data Server Functions
#'
#' @noRd
mod_extract_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    #Limite de dados no Shiny
    options(shiny.maxRequestSize=32*1024^3)

    #Remover notação cientitifica
    options(scipen = 999)

    observeEvent(input$modal_carregamento,
                 {showModal(modalDialog(
                   textInput(ns("delim"),
                             label = "Selecione o Separador. Deixe em branco para ser detectado automaticamente",
                             ""),
                   numericInput(ns("skip"), "Linhas para serem puladas quando o arquivo for carregado", 0, min = 0),
                   numericInput(ns("n_max"), "Linhas para serem lidas quando o arquivo for carregado", 0, min = 0),
                   radioButtons(ns("colnames"), "Você deseja ler os arquivos com nomes de colunas?",
                                choices =  c("TRUE", "FALSE"),
                                selected = "TRUE"),

                   footer = tagList(
                     modalButton("Fechar")
                   )
                 ))


                 }
    )
    # observeEvent(input$ok, {
    #   removeModal()
    # })
    # Criando reactive values que vão disparar a reatividade no dataset
    values <- reactiveValues(data = NULL, data_active = NULL,
                             rows = NULL, columns = NULL)


    # Carregar os dados

    #dados <-DataEditR::dataInputServer("input1")

    dados <- reactive({
      req(input$file)
      delim <- if (input$delim == "") NULL else input$delim
      n_max <- if (input$n_max == 0)  Inf else input$n_max
      vroom::vroom(input$file$datapath, delim = delim, skip = input$skip,
                   n_max = n_max, .name_repair = "unique",
                   col_names = input$colnames,
                   num_threads = parallel::detectCores()#,
                   #locale =  vroom::locale(encoding = "WINDOWS-1252"),delim = ";"

      )
    })

    # Disparar a reatividade para inserir os dados no dataset reativo
    observeEvent(dados(), {
      values$rows <- NULL
      values$columns <- NULL
      values$data <- dados()
    })

    # Filtrar e Selecionar
    data_select <- DataEditR::dataSelectServer("select1",
                                               # Passando os dados do elemento reativo
                                               data = reactive(values$data))
    data_filter <- DataEditR::dataFilterServer("filter1",
                                               # Passando os dados do elemento reativo
                                               data = reactive(values$data))

    #Inserindo elementos filtrados e selecionados

    observe({
      values$rows <- data_filter$rows()
      values$columns <- data_select$columns()
    })

    observe({
      if (length(values$rows) == 0 & length(values$columns) ==
          0) {
        values$data_active <- values$data
      }
      else {
        if (length(values$rows) != 0 & length(values$columns) ==
            0) {
          values$data_active <- values$data[values$rows,
                                            , drop = FALSE]
        }
        else if (length(values$rows) == 0 & length(values$columns) !=
                 0) {
          values$data_active <- values$data[, values$columns,
                                            drop = FALSE]
        }
        else if (length(values$rows) != 0 & length(values$columns) !=
                 0) {
          values$data_active <- values$data[values$rows,
                                            values$columns, drop = FALSE]
        }
      }
    })
    # Printar o glimpse

    output$render_glimpse <- renderPrint({
      dplyr::glimpse(values$data_active
                     #dados
      )
    })
    # Exportar

    # DataEditR::dataOutputServer("output1",
    #                  data = reactive(values$data_active)
    # )
    output$download <- downloadHandler(
      filename = function() {
        paste0(tools::file_path_sans_ext(input$file$name), ".csv")
      },
      content = function(file) {
        vroom::vroom_write(values$data_active, file,delim = ",",
                           num_threads = parallel::detectCores()

        )
      }
    )
  })
}

## To be copied in the UI
# mod_extract_data_ui("extract_data_1")

## To be copied in the server
# mod_extract_data_server("extract_data_1")
