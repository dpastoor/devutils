#' use internal packages setup in a projet
#' @param proj project name
#' @param first_name first name
#' @param last_name last name
#' @param email email address
#' @param pkg_dir directory for internal project packages
#' @importFrom purrr discard
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
    "pkgbuild"
  )
  has_required <- purrr::map_lgl(required_packages,
                                 requireNamespace,
                                 quietly = TRUE)
  if (!all(has_required)) {
    stop(glue::glue("need to install the following packages: {pkgs}",
                    pkgs = paste0(required_packages[!has_required],
                                  collapse = ", ")))
  }
  mkdirp(pkg_dir)
  internal_dir <- system.file("internal",
             package = "devutils")
  full_paths <- dir(internal_dir,
                    full.names = TRUE,
                    recursive = TRUE) %>%
    discard(is_dir)
  relative_paths <- dir(internal_dir,
                        recursive = TRUE) %>%
    discard(is_dir)

  folders <- unique(dirname(relative_paths))
  folders <- folders[folders != "."]
  map(file.path(pkg_dir, folders), mkdirp)
  file.copy(from = full_paths,
            to = file.path(pkg_dir, relative_paths)
            )

  d <- create_internal_desc(proj, first_name, last_name, email)
  d$write(file.path(pkg_dir, "internal", "DESCRIPTION"))

}
