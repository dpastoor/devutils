#' create a bookdown scaffold
#' @param author author of bookdown
#' @param title title of project
#' @param description description of project
#' @param ... optional values to pass to infuser
#' @param .path path to place bookdown template
#' @param .see_opts just print out the optional values to infuse
#' @importFrom purrr map map_lgl map2
#' @importFrom stats setNames
#' @examples \dontrun{
#' use_bookdown("Devin", "my cool project", "a very exciting project about things")
#' # put in subdirectory
#' use_bookdown("Devin", "my cool project", .path = "lab-notebook")
#' }
#' @export
use_bookdown <- function(author, title, description, ..., .path = ".", .see_opts = FALSE) {
  files <- list_files(system.file("bookdown_templates/simple", package = "devutils"),
                      full.names = T)
  outputs <- infuse_files(files, author = author, description = description, .return_opts = .see_opts)
  done("applying bookdown settings")
  if(.see_opts) {
    print(outputs)
    return(outputs)
  }

  mkdirp(.path)

  map2(outputs, basename(files), function(file_string, filename) {
    readr::write_file(file_string, file.path(.path, filename))
  })
  done("bookdown files added in directory ", .path)
}

#' infuse files or get the parameters needed
#' @param files vector of files to infuse
#' @param ... parameters to pass to infuse
#' @param .return_opts return the requested variables instead of infusing
#' @return list
infuse_files <- function(files, ..., .return_opts = FALSE) {
  vars_requested <- map(files, ~ {
    vars <- infuser::variables_requested(.x)
    if (length(vars)) {
      return(unlist(vars))
    }
    return(NULL)
  }) %>% setNames(basename(files))
  vars_requested <- vars_requested[!map_lgl(vars_requested, is.null)]

  if (.return_opts) {
    return(vars_requested)
  }

  outputs <- map(files, function(.x) {
    infuser::infuse(.x, ...)
  }) %>% setNames(basename(files))
  return(outputs)
}
