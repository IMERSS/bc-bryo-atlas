library(whisker)
library(tidyverse)
library(googledrive)

downloadGdrive <- function (id, file_path, overwrite = FALSE) {
  if (overwrite || !file.exists(file_path)) {
    drive_download(as_id(id), path = file_path, overwrite = TRUE)
  }
}

# Found existence of these variables at https://quarto.org/docs/projects/scripts.html#pre-and-post-render
render_all <- nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))

if (render_all) {
  
  # Fetch from BC Bryophyte Guide/Catalogues/GBIF-0002297-240626123714530.csv
  downloadGdrive("1UlByeYlHRyKBl2xnmbF_tVG4jl_xcO3R", "tabular_data/GBIF-0002297-240626123714530.csv")
  
  template <- readr::read_file("templates/taxon.qmdt")
  gsub("\r\n", "\n", template)
  
  # Fetch from BC Bryophyte Guide/BC_Bryo_Guide
  downloadGdrive("1MG7C7GX1Tl2RO_vHuMwUo8quhzYZd_mElWRnPuNbpj8", "tabular_data/BC_Bryo_Guide.csv", TRUE)
  taxa <- read.csv("tabular_data/BC_Bryo_Guide.csv") %>%
    mutate_all(~replace_na(as.character(.), ""))
  
  # Note that whisker templating does not permit period characters in key names
  names(taxa)[names(taxa) == "quick.Dirty"] <- "quickNDirty"
  
  make_page <- function (row) {
    templated <- whisker.render(template, data=row)
    filename <- str_glue("taxa/{row$taxon}.qmd")
    file <- file(filename, "wb")
    write(templated, file)
    close(file)
    writeLines(str_glue("Written {nchar(templated)} bytes to file {filename}"))
  }
  
  for (i in seq_len(nrow(taxa))) {
    make_page(taxa[i,])
  }
} else {
  cat("Not rendering all files, skipping site generation\n")
}
