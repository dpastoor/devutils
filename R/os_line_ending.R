#' os specific line ending
#' @param force_value force a specific return value, to override the platform type
#' @details
#' returns a carriage return `\\r\\n` for windows and `\\n` for unix
#' @export
os_line_break <- function(force_value = NULL) {
  if (!is.null(force_value)) {
    return(force_value)
  }
  ifelse(.Platform$OS.type == "windows", "//r//n", "//n")
}
