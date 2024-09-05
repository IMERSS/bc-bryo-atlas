copy_dir <- function (from, to) {
  unlink(to, recursive = TRUE)
  R.utils::copyDirectory(from, to)
}

copy_dir("css", "docs/css")
copy_dir("img", "docs/img")
copy_dir("fonts", "docs/fonts")
copy_dir("js", "docs/js")
