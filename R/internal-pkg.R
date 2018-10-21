## ---- ported from devtools to remove dependency
is_loaded <- function (pkg = "internal") {
  pkg %in% loadedNamespaces()
}
r_env_vars <- function () {
  vars <- c(R_LIBS = paste(.libPaths(), collapse = .Platform$path.sep),
            CYGWIN = "nodosfilewarning", R_TESTS = "", R_BROWSER = "false",
            R_PDFVIEWER = "false", TAR = auto_tar())
  if (is.na(Sys.getenv("NOT_CRAN", unset = NA))) {
    vars[["NOT_CRAN"]] <- "true"
  }
  vars
}

auto_tar <- function() {
    tar <- Sys.getenv("TAR", unset = NA)
    if (!is.na(tar))
      return(tar)
    windows <- .Platform$OS.type == "windows"
    no_rtools <- is.null(pkgbuild::rtools_path())
    if (windows && no_rtools)
      "internal"
    else ""
}
## ----

doc_package <- function(.pkg_path = "internal") {
  roclets <- roxygen2::load_options(.pkg_path)$roclets
  roclets <- setdiff(roclets, "collate")
  withr::with_envvar(r_env_vars(), roxygen2::roxygenise(.pkg_path,
                                                        roclets = roclets))
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

# install a package to the bin folder
# @param .pkg_details package details from build_package
# @param .dir dir to install to
# @details
# expects `pkg_name` and `time` for the build
install_bin <- function(.pkg_details, .dir = "bin") {
  current_version <- tryCatch(packageVersion("internal"), error = function(e) NULL)
  pkg_meta <- basename(stringr::str_replace(.pkg_details$pkg_name, ".tar.gz", ""))
  pkg_name <- stringr::str_replace(pkg_meta, "_.*", "")
  version_to_install <- package_version(stringr::str_replace(pkg_meta, ".*_", ""))
  if (version_to_install < current_version) {
    stop("version attempting to install lower than currently installed version", call. = FALSE)
  }
  upgrade_type <- if (version_to_install == current_version) {
    "cross-graded"
  } else {
    "upgraded"
  }
  callr::rcmd("INSTALL", c(glue::glue("--library={.dir}"), .pkg_details$pkg_name))
  if (!is.null(current_version)) {
    message(glue::glue("package {pkg_name} {upgrade_type} from {current_version} to {version_to_install}"))
  } else {
    message(glue::glue("package {pkg_name} installed with version: {version_to_install}"))
  }
  Sys.time()
}

#' build the internal package
#' @param .pkgsdir path to packages dir where internal/ and bin/ live
#' @export
.build_internal <- function(.pkgsdir = file.path(here::here(), "packages")) {
  withr::with_dir(.pkgsdir, {
    initially_loaded <- isNamespaceLoaded("internal")
    if (initially_loaded) {
      unloadNamespace("internal")
    }
    doc_package()
    build_package() %>%
      install_bin()

    if (initially_loaded) {
      requireNamespace("internal")
    }
  })
}
