# get_wikipedia_daily.R

library(rvest)
library(dplyr)
library(readr)

url <- "https://en.wikipedia.org/wiki/Main_Page"

page <- read_html(url)

# Extract the "Today's featured article" section
featured <- page |>
  html_node("#mp-tfa p") |>
  html_text(trim = TRUE)

# Extract the article link
featured_link <- page |>
  html_node("#mp-tfa b a") |>     # first <a> in the section
  html_attr("href")

featured_url <- paste0("https://en.wikipedia.org", featured_link)

entry <- tibble(
  datetime = format(Sys.time(), tz = "America/New_York", usetz = TRUE),
  featured_article = featured,
  link = featured_url
)

dir.create("data", showWarnings = FALSE)
file <- "data/wikipedia_daily.csv"

# Append if exists, otherwise create
if (file.exists(file)) {
  write_csv(entry, file, append = TRUE, col_names = FALSE)
} else {
  write_csv(entry, file)
}

