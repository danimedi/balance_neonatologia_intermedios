library(lubridate)
library(readxl)
library(dplyr)

# This is the data where all the information comes from
datos <- read_excel("data.xlsx")

#' Get the values we need to include in the daily notes of the newborns at the
#' intensive care unit of neonatology
#' 
#' This function includes some calculations to obtain some variables that are
#' important.
#'
#' @param paciente Name of the patient, used to find the data in the data set.
#' @param fecha Date of the note we want to make (it uses the values of the
#'   previous day for most of the variables).
#'
#' @return A list containing values of different variables that are useful to
#'   make the daily notes of the patients
#' @export
#'
#' @examples
#' get_calculos("corbacho", fecha = as_date("2023-07-03"))
#' 
get_calculos <- function(paciente, fecha = today()) {
  
  fila_hoy <- datos[datos$paciente == paciente & datos$fecha == fecha, ]
  fila_ayer <- datos[datos$paciente == paciente & datos$fecha == fecha - 1, ]
  
  simplify <- function (x) {
    unname(unlist(x))
  }
  
  ingresos_y_egresos <- fila_ayer %>%
    select(starts_with("ingreso"), starts_with("egreso"))
  peso_nacer <- select(fila_hoy, peso_nacer) %>% simplify()
  peso_hoy <- select(fila_hoy, peso) %>% simplify()
  peso_ayer <- select(fila_ayer, peso) %>% simplify()
  delta_peso <- peso_hoy - peso_ayer
  delta_peso_nacer <- (peso_hoy - peso_nacer) / peso_nacer
  
  total_ingresos <- fila_ayer %>%
    select(starts_with("ingreso")) %>%
    summarize(sum_all = rowSums(.)) %>%
    simplify()
  
  if (peso_hoy < peso_nacer) {
    peso_x <- peso_nacer
  } else {
    peso_x <- peso_hoy
  }
  
  get_perdidas_insensibles <- function(peso) {
    # Constante
    if (peso < 750) {
      k <- 2.5
    } else if (peso >= 750 & peso < 1000) {
      k <- 2
    } else if (peso >= 1000 & peso < 1500) {
      k <- 1.5
    } else if (peso >= 1500 & peso < 2000) {
      k <- 1
    } else if (peso >= 2000 & peso < 2500) {
      k <- 0.75
    } else if (peso >= 2500) {
      k <- 0.5
    }
    return(peso * 24 * k)
  }
  
  perdidas_insensibles <- get_perdidas_insensibles(peso_x) / 1000
  
  total_egresos <- fila_ayer %>%
    select(egreso_deposiciones, egreso_diuresis_24, egreso_residuos) %>%
    summarize(sum_all = rowSums(.)) %>%
    simplify()
  total_egresos <- total_egresos + perdidas_insensibles
  
  balance <- total_ingresos - total_egresos
  
  volumen_total_efectivo <- total_ingresos / peso_x * 1000
  
  via_oral_efectiva <- fila_ayer %>%
    summarize(result = ingreso_via_oral / peso_x * 1000) %>%
    simplify()
  
  flujo_urinario <- fila_ayer %>%
    mutate(
      flujo_24h = egreso_diuresis_24 / peso_x * 1000 / 24,
      flujo_12h = egreso_diuresis_12 / peso_x * 1000 / 12,
      flujo_06h = egreso_diuresis_06 / peso_x * 1000 / 6,
      .keep = "none"
    )
  
  list(
    ingreso_endovenoso = ingresos_y_egresos$ingreso_endovenoso,
    ingreso_tratamiento = ingresos_y_egresos$ingreso_tratamiento,
    ingreso_via_oral = ingresos_y_egresos$ingreso_via_oral,
    egreso_deposiciones = ingresos_y_egresos$egreso_deposiciones,
    egreso_diuresis_24 = ingresos_y_egresos$egreso_diuresis_24,
    egreso_residuos = ingresos_y_egresos$egreso_residuos,
    peso_nacer = peso_nacer,
    peso_ayer = peso_ayer,
    peso_hoy = peso_hoy,
    delta_peso = delta_peso,
    delta_peso_nacer = delta_peso_nacer,
    total_ingresos = total_ingresos,
    perdidas_insensibles = perdidas_insensibles,
    total_egresos = total_egresos,
    balance = balance,
    volumen_total_efectivo = volumen_total_efectivo,
    via_oral_efectiva = via_oral_efectiva,
    diuresis_flujo_24h = flujo_urinario$flujo_24h,
    diuresis_flujo_12h = flujo_urinario$flujo_12h,
    diuresis_flujo_06h = flujo_urinario$flujo_06h
  )
}
