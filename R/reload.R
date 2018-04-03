#' reload a package namespace
#' @param pkg package to reload
#' @param ... arguments to pass to [library()]
#' @details
#' used to unload and reload a package namespace,
#' can be helpful when a package has been rebuilt in a
#' separate process
#' @importFrom utils packageVersion
#' @export
reload_namespace <- function(pkg, ...) {
  prev_version <- packageVersion(pkg)
  unloadNamespace(pkg)
  requireNamespace(pkg, ...)
  new_version <- packageVersion(pkg)
  message(glue::glue("{pkg} version: {prev_version} --> {new_version}"))
  invisible()
}


#' reload internal package
#' @param ... arguments to pass to [reload_namespace()]
#' @export
reload_internal <- function(...) {

  reload_namespace("internal", ...)
}
