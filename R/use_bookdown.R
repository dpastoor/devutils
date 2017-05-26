#' use bookdown in a folder
#' @param author author of bookdown
#' @param description description of project
#' @param ... optional values to pass to infuser
#' @param .path path to place bookdown template
#' @param .see_opts just print out the optional values to infuse
#' @importFrom purrr map map_lgl
use_bookdown <- function(author, description, ..., .path = ".", .see_opts = FALSE) {
  files <- list.files(system.file("bookdown_templates/simple", package = "devutils"), full.names = T)
  vars_requested <- map(files, ~ {
    vars <- infuser::variables_requested(.x)
    if (length(vars)) {
      return(unlist(vars))
    }
    return(NULL)
  }) %>% setNames(basename(files))
  vars_requested <- vars_requested[!map_lgl(vars_requested, is.null)]

  if (.see_opts) {
    print(vars_requested)
    return(invisible())
  }

  outputs <- map(files, function(.x) {
    infuser::infuse(.x, author = author, description = description)
  })

  map2(outputs, files, function(.x, .y) {
    readr::write_file(.x, file.path(normalizePath(.path), basename(.y)))
  })
}
