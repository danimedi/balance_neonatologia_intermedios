# Balance neonatología intermedios

Este es el directorio del programa para calcular balances para neonatología.

## Preparativos

El primer paso es descargar los programas necesarios. En realidad, lo único estrictamente necesario es contar con el programa "R". Por aquí dejo un [link](https://www.r-project.org/). Sin embargo, considero que es conveniente tener instalado también [RStudio](https://posit.co/download/rstudio-desktop/) (para poder usar R de forma más interactiva) y [Git](https://git-scm.com/) (para poder descargar el código, actualizar el código si hay cambios, proponer cambios, reportar bugs, etc.).

Entonces, una vez tengamos descargado R (o los demás programas) debemos descargar algunos paquetes ejecutando el siguiente código:

``` r
install.packages(c("purrr", "glue", "readxl"))
```

Con esto, estaríamos listos.

## Si estamos en la computadora del la UCIN 4 (HNERM) ...

Ya está todo instalado. Estoy dejando un acceso directo en el escritorio a la carpeta de este programa:

![](images/screenshot_desktop.png)

La carpeta está en "Documentos".

## Tutorial

https://github.com/danimedi/balance_neonatologia_intermedios/assets/71237804/fbcdc046-eb2b-483f-8eb3-1b5af03f2490

### 1. Llenando datos

Los datos se llenan en el Excel que está incluido en la carpeta. Llenar los datos de la siguiente forma ...

### 2. Corriendo el código

Una vez tengamos los datos en el Excel, ejecutar el código ...

### 3. Modificando el código

El código puede modificarse a nuestro antojo. Incluso si no sabemos cómo programar con R, podemos realizar algunos cambios en el código. Por ejemplo, podemos cambiar la plantilla con la cual estamos obteniendo los datos ...

------------------------------------------------------------------------

## ¿Alguna consulta o problema?

Si tienen alguna consulta, pueden escribire a mi correo: [danielmedinaneira555\@gmail.com](mailto:danielmedinaneira555@gmail.com){.email}. Mi nombre es Daniel Medina, soy interno de medicina (y creador de este programa).
