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
#' @export
mkdirp <- function(.dir, verbose = FALSE) {
  if (!dir.exists(.dir)) {
    "!DEBUG creating dir at `.dir`"
    dir.create(.dir, recursive = TRUE)
  }
}

#' list files, including hidden ones, in a directory
#' @param path a character vector of full path names; the default corresponds to the working directory, Default: '.'
#' @param all.files a logical value. If FALSE, only the names of visible files are returned.
#'     If TRUE, all file names will be returned., Default: TRUE
#' @param recursive logical. Should the listing recurse into directories?, Default: TRUE
#' @param no.. logical. Should both "." and ".." be excluded also from non-recursive listings?, Default: TRUE
#' @param ... args to pass to [dir()]
#' @param normalize whether to convert file paths to canonical form for the platform, Default: FALSE
#' @param must_work logical: if TRUE then an error is given if the result cannot be determined; if NA then a warning., Default: TRUE
#' @return vector of file paths
#' @export
list_files <- function(path = ".", all.files = TRUE, recursive = TRUE, no.. = TRUE, ..., normalize = FALSE, must_work = TRUE) {
  dirs__ <- dir(path, all.files = all.files, no.. = no.., recursive = recursive, ...)
  if (normalize) {
    dirs__ <- normalizePath(dirs__, mustWork = must_work)
  }
  return(dirs__)
}
