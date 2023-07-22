library(purrr)

#' Get the results of the balance calculations for all the patients as text
#' 
#' This functions makes the calculations for all the patient in a certain date,
#' most commonly used for today's date.
#' 
#' It uses (depends on) the functions  `get_calculos()` and `get_calculos_text()`.
#'
#' @param db Data base containing the data to perform the calculations.
#' @param fecha  Date to select the patients with available information.
#'
#' @return
#' @export
#'
#' @examples
#' datos <- read_excel("data.xlsx")
#' get_all_calculos(datos, fecha = as_date("2023-07-03"))
get_all_calculos <- function(db, fecha = Sys.Date()) {
  db$fecha <- as.Date(db$fecha)
  pacientes_hoy <- db[db$fecha == fecha & !is.na(db$peso), "paciente"]
  pacientes_hoy <- unlist(unique(pacientes_hoy), use.names = FALSE)
  safe_get_calculos_text <- possibly(get_calculos_text, otherwise = "ERROR")
  res <- map_chr(pacientes_hoy, function(paciente) get_calculos_text(db, paciente, fecha))
  res <- paste0("PACIENTE: ", pacientes_hoy, "\n", res)
  res <- paste0(res, collapse = "\n\n\n\n")
  res
}
