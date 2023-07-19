library(glue)

#' Get the text to copy and paste in the daily notes of the patients
#' 
#' Note: this function depends on the main function `get_calculos()`.
#' 
#' This function creates a text that is ready to copy and paste in the daily
#' notes of the patients.
#' 
#' The arguments are the same as the function `get_calculos()`.
#'
#' @return
#' @export
#'
#' @examples
#' datos <- read_excel("data.xlsx")
#' get_calculos_text(datos, "corbacho", fecha = as_date("2023-07-03"))
#' 
get_calculos_text <- function(...) {
  result <- get_calculos(...)
  text <- readLines("plantilla_texto_acosta.txt")
  glue(text)
}
