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
  
  glue(
    "PN: {result$peso_nacer} G / P AYER: {result$peso_ayer} G / P HOY: {result$peso_hoy} G / DP: {result$delta_peso} G / DPN: {result$delta_peso_nacer * 100}%

BH24H: {result$balance} ML (VTE: {result$volumen_total_efectivo} ML/KG/DIA)
I: VO {result$ingreso_via_oral} + EV {result$ingreso_endovenoso} + TTO {result$ingreso_tratamiento} = {result$total_ingresos} ML
E: O {result$egreso_diuresis_24} + DEPO {result$egreso_deposiciones} + RG {result$egreso_residuos} + PI {result$perdidas_insensibles} = {result$total_egresos} ML
FU 24/12/6H: {result$diuresis_flujo_24h}/{result$diuresis_flujo_12h}/{result$diuresis_flujo_06h} ML/KG/H"
  )
}
