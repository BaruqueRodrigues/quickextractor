#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_build_sqlite_server("build_sqlite_1")
  mod_extract_data_server("extract_data_1")
  mod_home_server("home_1")
}
