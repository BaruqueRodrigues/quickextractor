
<!-- README.md is generated from README.Rmd. Please edit that file -->

# quickextractor

quickextractor é um programa feito em R e Shiny para remover
subconjuntos de dados de a partir de large data.

# Uso

Como o projeto está em versão beta e ainda não foi distribuído, é
necessário fazer download do
[R](https://cran.r-project.org/bin/windows/base/) e do [R
Studio](https://posit.co/download/rstudio-desktop/). Após o download e a
instalação de ambos abra o rstudio e rode as linhas de código abaixo.

``` r
install.packages("devtools") 
```

Caso apareça alguma mensagem no console solicitando a instalação de
algum pacote adicional, insira o console o valor que corresponda ao All.

Após a instalação do pacote devtools ser concluída execute a linha
abaixo.

A linha abaixo faz o download do repositório do github do projeto

``` r
devtools::install_github("BaruqueRodrigues/quickextractor")
```

Após o download e a instalação do quickextractor execute a linha abaixo
para abrir o programa

``` r
quickextractor::run_app()
```
