#' use internal packages setup in a projet
#' @param proj project name
#' @param first_name first name
#' @param last_name last name
#' @param email email address
#' @param pkg_dir directory for internal project packages
#' @importFrom purrr discard map_chr
#' @examples \dontrun{
#' use_internal("Test Project", "Devin", "pastoor", "devin.pastoor@gmail.com")
#' }
#' @export
use_internal <- function(proj,
                         first_name,
                         last_name,
                         email,
                         pkg_dir = "./packages") {
  required_packages <- c(
    "remake",
    "glue",
    "stringr",
    "pkgbuild",
    "callr"
  )
  has_required <- purrr::map_lgl(required_packages,
                                 requireNamespace,
                                 quietly = TRUE)
  if (!all(has_required)) {
    stop(glue::glue("need to install the following packages: {pkgs}",
                    pkgs = paste0(required_packages[!has_required],
                                  collapse = ", ")))
  }
  done("checking for required packages")
  mkdirp(pkg_dir)
  internal_dir <- system.file("internal",
             package = "devutils")
  full_paths <- list_files(internal_dir,
                    full.names = TRUE
                    ) %>%
    discard(is_dir)
  relative_paths <- list_files(internal_dir) %>%
    discard(is_dir)
  ## replace __.dotfile with .dotfile

  folders <- unique(dirname(relative_paths))
  folders <- folders[folders != "."]
  map_chr(file.path(pkg_dir, folders), mkdirp)
  file.copy(from = full_paths,
            to = file.path(pkg_dir, relative_paths)
            )
  done("setting up package structure")
  d <- create_internal_desc(proj, first_name, last_name, email)
  done("creating description file")
  d$write(file.path(pkg_dir, "internal", "DESCRIPTION"))
  done("internal package created at ", pkg_dir)
  return(invisible(TRUE))
}
