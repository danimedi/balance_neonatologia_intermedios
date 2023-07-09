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
#' get_calculos_text("corbacho", fecha = as_date("2023-07-03"))
#' 
get_calculos_text <- function(paciente, fecha = today()) {
  result <- get_calculos(paciente, fecha)
  glue(
    "PESO AL NACER: {result$peso_nacer} g // PESO AYER: {result$peso_ayer} g // PESO HOY: {result$peso_hoy} g
DELTA PESO: {result$delta_peso} g // DELTA PESO AL NACER: {result$delta_peso_nacer * 100}%

BALANCE 24 HORAS: {result$balance} cc
INGRESOS (24 HORAS): {result$total_ingresos} cc
= EV {result$ingreso_endovenoso} + TTO {result$ingreso_tratamiento} + VO {result$ingreso_via_oral}
EGRESOS (24 HORAS): {result$total_egresos} cc
= DEPOSICIONES {result$egreso_deposiciones} + DIURESIS {result$egreso_diuresis_24} + RESIDUOS {result$egreso_residuos} + PÉRDIDAS INSENSIBLES {result$perdidas_insensibles}

VOLUMEN TOTAL EFECTIVO: {result$volumen_total_efectivo} cc/kg
VÍA ORAL EFECTIVA: {result$via_oral_efectiva} cc/kg
FLUJO URINARIO (cc/kg) EN 24 HORAS {result$diuresis_flujo_24h} // EN 12 HORAS {result$diuresis_flujo_12h} // EN 6 HORAS {result$diuresis_flujo_06h}"
  )
}
