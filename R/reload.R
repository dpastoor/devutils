#' reload a package namespace
#' @param pkg package to reload
#' @param ... arguments to pass to [library()]
#' @details
#' used to unload and reload a package namespace,
#' can be helpful when a package has been rebuilt in a
#' separate process
#' @export
reload_namespace <- function(pkg, ...) {
  unloadNamespace(pkg)
  library(pkg, character.only = TRUE, ...)
}


#' reload internal package
#' @param ... arguments to pass to [reload_namespace()]
#' @export
reload_internal <- function(...) {
  reload_namespace("internal", ...)
}
