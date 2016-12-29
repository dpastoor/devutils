#' initialize an overseer modeling folder
#' @param dir directory name
#' @param abs whether the directory is
#' @export
init_overseer <- function(dir = "modeling", abs = FALSE) {
  if (abs) {
    path <- normalizePath(dir, mustWork = FALSE)
  } else {
    path <- normalizePath(file.path(getwd(), dir), mustWork = FALSE)
  }
  if (!dir.exists(path)) {
    message("creating dir: ", path)
    dir.create(path)
  }
  models_path <- normalizePath(file.path(path, "models.R"), mustWork = FALSE)
  message("creating models.R")
  writeLines(c("library(overseer)",
               "",
               "models <- overseer$new()",
               "",
               "",
               "# add model files below",
               "",
               "",
               "# return overseer instance to be pulled in via source()$value",
               "# do not add any code below this line or delete the models object",
               "# or sourcing the file may not work properly",
               "models",
               ""), models_path)
  message("sucessfully initialized!")
  invisible()
}
