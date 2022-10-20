library(tidyverse)
library(rvest)
library(lubridate)
library(robotstxt)

paths_allowed("https://www.slickcharts.com/")

page <- read_html("https://www.slickcharts.com/sp500")
page_2 <- read_html("https://www.slickcharts.com/sp500/performance")

companies <- page |>
  html_elements(".mmt-sticky-close , .mb-5 td:nth-child(2)") |>
  html_text()

symbols <- page |>
  html_elements(".mmt-sticky-close , td~ td+ td a") |>
  html_text()

weights <- page |>
  html_elements(".mmt-sticky-close , .mb-5 td:nth-child(4)") |>
  html_text()

prices <- page |>
  html_elements(".text-nowrap:nth-child(5)") |>
  html_text()

ytd_returns <- page_2 |>
  html_elements("td:nth-child(4)") |>
  html_text2()

symbols_2 <- page_2 |>
  html_elements(".grippy-host , td~ td+ td a") |>
  html_text2()

sp500_by_company_1 <- tibble(
  company = companies,
  symbol = symbols,
  weight = weights,
  current_price = prices
)

sp500_by_company_2 <- tibble(
  ytd_return = ytd_returns,
  symbol = symbols_2
)


sp500_by_company <- sp500_by_company_1 |>
  left_join(sp500_by_company_2, by = "symbol") |>
  mutate(
    weight = as.numeric(weight)
  )

write_csv(sp500_by_company, file = "data/sp500_by_company.csv")
