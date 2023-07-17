#' Get the values we need to include in the daily notes of the newborns at the
#' intensive care unit of neonatology
#' 
#' This function includes some calculations to obtain some variables that are
#' important.
#'
#' @param paciente Name of the patient, used to find the data in the data set.
#' @param fecha Date of the note we want to make (it uses the values of the
#'   previous day for most of the variables).
#' @param db Data base that contains the data needed to perform the calculations.
#'
#' @return A list containing values of different variables that are useful to
#'   make the daily notes of the patients
#' @export
#'
#' @examples
#' datos <- read_excel("data.xlsx")
#' get_calculos(datos, "corbacho", fecha = as_date("2023-07-03"))
#' 
get_calculos <- function(db, paciente, fecha = Sys.Date()) {
  
  i <- is.na(db$paciente)
  db <- db[!i, ]
  
  fila_hoy <- db[db$paciente == paciente & db$fecha == fecha, ]
  fila_ayer <- db[db$paciente == paciente & db$fecha == fecha - 1, ]
  
  i <- startsWith(names(db), "ingreso") | startsWith(names(db), "egreso")
  ingresos_y_egresos <- fila_ayer[,i]
  peso_nacer <- fila_hoy$peso_nacer
  peso_hoy <- fila_hoy$peso
  peso_ayer <- fila_ayer$peso
  delta_peso <- peso_hoy - peso_ayer
  delta_peso_nacer <- (peso_hoy - peso_nacer) / peso_nacer
  
  i <- startsWith(names(fila_ayer), "ingreso")
  total_ingresos <- rowSums(fila_ayer[,i])
  
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
  
  i <- c("egreso_deposiciones", "egreso_diuresis_24", "egreso_residuos")
  total_egresos <- rowSums(fila_ayer[, i])
  total_egresos <- total_egresos + perdidas_insensibles
  
  balance <- total_ingresos - total_egresos
  
  volumen_total_efectivo <- total_ingresos / peso_x * 1000
  
  via_oral_efectiva <- fila_ayer$ingreso_via_oral / peso_x * 1000
  
  get_flujo_urinario <- function(egreso_diuresis, peso, horas) {
    egreso_diuresis / peso * 1000 / horas
  }
  
  flujo_urinario_24h <- get_flujo_urinario(fila_ayer$egreso_diuresis_24, peso_x, 24)
  flujo_urinario_12h <- get_flujo_urinario(fila_ayer$egreso_diuresis_12, peso_x, 12)
  flujo_urinario_06h <- get_flujo_urinario(fila_ayer$egreso_diuresis_06, peso_x, 06)
  
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
    diuresis_flujo_24h = flujo_urinario_24h,
    diuresis_flujo_12h = flujo_urinario_12h,
    diuresis_flujo_06h = flujo_urinario_06h
  )
}
