source("get_calculos.R")
source("get_calculos_text.R")
source("get_all_calculos.R")

library(readxl)
datos <- read_excel("data.xlsx")

txt <- get_all_calculos(datos)
writeLines(txt, con = "output.txt")
