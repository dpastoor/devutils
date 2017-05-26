#' use bookdown in a folder
#' @param author author of bookdown
#' @param description description of project
#' @param ... optional values to pass to infuser
#' @param .path path to place bookdown template
#' @param .see_opts just print out the optional values to infuse
#' @importFrom purrr map map_lgl map2
use_bookdown <- function(author, description, ..., .path = ".", .see_opts = FALSE) {
  files <- list.files(system.file("bookdown_templates/simple", package = "devutils"), full.names = T)
  outputs <- infuse_files(files, author = author, description = description, .return_opts = .see_opts)
  if(.see_opts) {
    print(outputs)
    return(outputs)
  }
  map2(outputs, files, function(.x, .y) {
    readr::write_file(.x, file.path(normalizePath(.path), basename(.y)))
  })
}

#' infuse files or get the parameters needed
#' @param files vector of files to infuse
#' @param ... parameters to pass to infuse
#' @param .return_opts return the requested variables instead of infusing
#' @return list
infuse_files <- function(files, ..., .return_opts = F) {
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