#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL


#' detect if a filepath is for a directory
#' @param x vector of file paths
#' @export
is_dir <- function(x) {
  isTRUE(file.info(x)$isdir)
}

#' get the basename of a filepath, minus any extensions
#' @param .x filepath
#' @export
#' @rdname basename_sans_ext
#' @importFrom tools file_path_sans_ext
basename_sans_ext <- function(.x) {
  basename(file_path_sans_ext(.x))
}

#' recursively create a dir
#' @param .dir path
#' @param verbose give a message about dir creation
mkdirp <- function(.dir, verbose = FALSE) {
  if (!dir.exists(.dir)) {
    "!DEBUG creating dir at `.dir`"
    dir.create(.dir, recursive = TRUE)
  }
}
