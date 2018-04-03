#' reload the internal package
#' @export
reload_internal <- function() {
  prev_version <- packageVersion("internal")
  unloadNamespace("internal")
  library(internal)
  new_version <- packageVersion("internal")
  message(glue::glue("internal version: {prev_version} --> {new_version}"))
  invisible()
}
