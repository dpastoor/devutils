#' use internal packages setup in a projet
#' @param proj project name
#' @param name name
#' @param email email address
#' @param pkg_dir directory for internal project packages
#' @importFrom purrr discard map_chr
#' @examples \dontrun{
#' # autodetection of user information
#' use_internal("Test Project")
#'
#' # manual specification
#' use_internal("Test Project", "Devin Pastoor", "devin.pastoor@gmail.com")
#' }
#' @export
use_internal <- function(proj,
                         name = whoami::fullname(),
                         email = whoami::email_address(),
                         pkg_dir = "./packages") {
  required_packages <- c(
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

  stop_if_null(name, 'whoami could not auto-detect name, please provide name with structure: "first last>"')
  stop_if_null(email, "whoami could not auto-detect email, please provide email address")

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
  map_lgl(file.path(pkg_dir, folders), mkdirp)
  file.copy(from = full_paths,
            to = file.path(pkg_dir, stringr::str_replace(relative_paths, "--\\.", "."))
            )
  done("set up package structure")
  d <- create_internal_desc(proj, as.person(name), email)
  done("created description file")
  d$write(file.path(pkg_dir, "internal", "DESCRIPTION"))
  done("internal package created at: ", pkg_dir)
  return(invisible(TRUE))
}
