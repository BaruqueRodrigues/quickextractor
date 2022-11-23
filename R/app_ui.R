#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(theme = bslib::bs_theme(version = 4),
              navbarPage(title = h1("quickextractor"),
                         tabPanel(title = "Home",
                                  mod_home_ui("home_1")
                                  ),
                         tabPanel(title = "Extract Data",
                                  mod_extract_data_ui("extract_data_1")
                                  ),
                         tabPanel(title = "Build SQLite",
                                  mod_build_sqlite_ui("build_sqlite_1")

                         ),

                         footer = tags$footer(
                           column(
                             offset = 1,
                             width = 4,
                             p(
                               "Desenvolvido em",
                               a(href = "https://shiny.rstudio.com", "Shiny"),
                               "por",
                               a(href = "https://twitter.com/baruqrodrigues",
                                 "Baruque Rodrigues")
                             )
                           )
                         )

              )

    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "quickextractor"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
