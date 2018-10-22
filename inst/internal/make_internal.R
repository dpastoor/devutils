library(magrittr)

doc_package <- function(.pkg_path = "internal") {
  roxygen2::roxygenize(glue::glue("{.pkg_path}"), load_code = pkgload::pkg_ns)
}

parse_build_message <- function(.x) {
  .x <- .x[grepl(pattern = "* building", .x)]
  if (!length(.x)) {
    stop("error parsing build message - perhaps didn't properly")
  }
  .x <- stringr::str_replace(.x, "\\* building ", "")
  .x <- stringr::str_replace_all(.x, "'", "")
  return(.x)
}

build_package <- function(.pkg = "internal") {
  list(pkg_name = pkgbuild::build(.pkg), time = Sys.time())
}

check_desc <- function(.desc_path) {
  desc::desc_get_version(.desc_path)
}

#' @param .pkg package details from build_package
#' @details
#' expects `pkg_name` and `time` for the build
install_bin <- function(.pkg_details) {
  callr::rcmd("INSTALL", c("--library=bin", .pkg_details$pkg_name))
  message(sprintf("latest package version installed: %s", basename(stringr::str_replace(.pkg_details$pkg_name, ".tar.gz", ""))))
  Sys.time()
}

withr::with_dir(file.path(here::here(), "packages"), {
  doc_package() 
  build_package() %>%
  install_bin()
})
