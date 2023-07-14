source("get_calculos.R")
source("get_calculos_text.R")
source("get_all_calculos.R")

library(readxl)
datos <- read_excel("data.xlsx")

get_calculos(datos, "alvarez canaza")
get_calculos_text(datos, "alvarez canaza")

txt <- get_all_calculos(datos)
writeLines(txt, con = "output.txt")
