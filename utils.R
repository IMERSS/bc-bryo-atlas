library(googledrive)
library(stringr)

# Helpful utility to template an arbitrary list of string arguments and then dump them to the console with a terminating newline
wg <- function (...) {
  args <- list(...)
  line <- paste(sapply(args, str_glue, .envir = parent.frame()), collapse = "")
  
  # Output the result using writeLines
  writeLines(line)
}

# Other incarnation at https://github.com/usda-nifa-b-team/b-team/blob/main/scripts/utils.R

downloadGdrive <- function (id, file_path, overwrite = FALSE) {
  if (overwrite || !file.exists(file_path)) {
    drive_download(as_id(id), path = file_path, overwrite = TRUE)
  }
}

idToDrib <- function (id) {
  path <- str_glue("https://drive.google.com/drive/folders/{id}")
  drib <- drive_get(as_id(path))
}

# Adapted from https://stackoverflow.com/a/64687628
downloadGdriveFolder <- function (id, file_path, skip_if_exists = TRUE) {
  exists <- file.exists(file_path)
  if (!exists || !skip_if_exists) {
    if (!exists) {
      dir.create(file_path)
    }
    # folder link to id
    folder_drib = idToDrib(id)
    
    # find files in folder
    files = drive_ls(folder_drib)
    
    cat("Fetching ", nrow(files), " files in folder ", folder_drib$name, "\n")
    
    # loop dirs and download files inside them
    for (i in seq_along(files$name)) {
      resource <- files$drive_resource[[i]]
      
      target <- str_c(file_path, "/", resource$name)
      if (resource$mimeType == "application/vnd.google-apps.folder") {
        cat (resource$name, " is a folder\n")
        downloadGdriveFolder(resource$id, target, skip_if_exists)
        # If there were subfolders, this would list them:
        # i_dir = drive_ls(files[i, ])
      }
      else {
        
        try({
          if (file.exists(target)) {
            wg("File {target} already exists, skipping download")
          } else {
            drive_download(as_id(files$id[i]), path = target)
          } 
        })
      }
    }
  } else {
    wg("Path {file_path} already exists, skipping download\n")
  }
}
