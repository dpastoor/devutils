#' initialize an overseer modeling folder
#' @param check_file file present in overseer directory to confirm proper working directory
#' @param dir directory name
#' @param abs whether the directory is
#' @param overwrite whether to overwrite models.R file if it already exists, defaults to FALSE
#' @examples \dontrun{
#' init_overseer() # default to models directory with models.R file inside
#' init_overseer("vancomcyin_poppk.cpp") # check for cpp file vancomycin_poppk.cpp
#' init_overseer(dir = "mrgsolve_models") # create directory mrgsolve_models instead of models
#' }
#' @export
init_overseer <- function(
                          check_file = NULL,
                          dir = "modeling",
                          abs = FALSE,
                          overwrite = FALSE
                          ) {
  if (abs) {
    path <- normalizePath(dir, mustWork = FALSE)
  } else {
    path <- normalizePath(file.path(getwd(), dir), mustWork = FALSE)
  }
  if (!dir.exists(path)) {
    message("creating dir: ", path)
    dir.create(path)
  }

  imc <- paste0("if (!interactive_model_check(\"",
                ifelse(is.null(check_file),
                      "<REPLACEWITHYOURFIRSTMODEL.cpp>",
                       check_file),
                "\")) {")

  models_path <- normalizePath(file.path(path, "models.R"), mustWork = FALSE)
  if (file.exists(models_path) && !overwrite) {
    warning("detected models.R file present already, no action taken")
    return(invisible())
  }
  message("creating models.R")
  writeLines(c("library(overseer)",
               "",
               "# check to make sure sourcing from proper directory if running interactively",
               imc,
               "    stop(\"make sure the directory is set to the models directory before running interactively,",
               "    to make sure the relative paths will be the same as when sourcing\")",
               "}",
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
