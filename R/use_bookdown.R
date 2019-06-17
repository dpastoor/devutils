#' create a bookdown scaffold
#' @param author author of bookdown
#' @param title title of project
#' @param description description of project
#' @param ... optional values to pass to infuser
#' @param .path path to place bookdown template
#' @importFrom purrr map map_lgl walk2
#' @importFrom stats setNames
#' @examples \dontrun{
#' use_bookdown("Devin", "my cool project", "a very exciting project about things")
#' # put in subdirectory
#' use_bookdown("Devin", "my cool project", .path = "lab-notebook")
#' }
#' @export
use_bookdown <- function(author, title, description, ..., .path = ".") {
  files <- list_files(system.file("bookdown_templates/simple", package = "devutils"),
                      full.names = T)
  outputs <- infuse_files(files, author = author, description = description, title = title)
  done("applied bookdown template settings")

  mkdirp(.path)
  # this can be simple as bookdown does not currently have hierarchy and is
  # a single folder, however more complex logic would be needed for more
  # complex scenarios
  walk2(outputs, stringr::str_replace(basename(files), pattern = "__\\.", "."), function(file_string, filename) {
    readr::write_file(file_string, file.path(.path, filename))
  })
  done("bookdown files added in directory: ", .path)
}

#' infuse files or get the parameters needed
#' @param files vector of files to infuse
#' @param ... parameters to pass to glue
#' @details
#' parameters passed via ... will be given to glue and exposed
#' as variables to replace in any template variables, as denoted
#' by {{ }}
#' @return list
infuse_files <- function(files, ...) {
  outputs <- map(files, function(.x) {
    whisker::whisker.render(readr::read_file(.x), data = list(...))
  }) %>% setNames(basename(files))
  return(outputs)
}
