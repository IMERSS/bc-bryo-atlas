library(whisker)
library(googlesheets4)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)

template <- readr::read_file("templates/taxon.qmdt")
gsub("\r\n", "\n", template)

taxa <- read_sheet("1MG7C7GX1Tl2RO_vHuMwUo8quhzYZd_mElWRnPuNbpj8", sheet = "friendly") %>%
    mutate_all(~replace_na(as.character(.), ""))
names(taxa)[names(taxa) == "quick&Dirty"] <- "quickNDirty"

make_page <- function (row) {
  templated <- whisker.render(template, data=row)
  filename <- str_glue("taxa/{row$taxon}.qmd")
  file <- file(filename, "wb")
  write(templated, file)
  close(file)
  writeLines(str_glue("Written {nchar(templated)} bytes to file {filename}"))
}

for (i in 1:nrow(taxa)) {
   make_page(taxa[i,])
}
