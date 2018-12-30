#' get information about installed packages
#' @export
#' @examples
#' \dontrun{
#' library(purrr)
#' # delete all remotely installed packages
#' ipm <- installed_packages_metadata()
#' ipm %>%
#'  walk(~ unlink(.x$path, recursive = TRUE))
#' }
installed_packages_metadata <- function() {
  ip <- as.data.frame(installed.packages(), stringsAsFactors = FALSE) %>%
    subset(is.na(Priority))
  pkg_remotes <- lapply(ip$Package, function(.p) {
    desc_path <- system.file("DESCRIPTION", package = .p)
    d_ <- desc::description$new(desc_path)
    rmt_meta <- as.list(d_$get(c("RemoteType", "remotes")))
    if (is.na(rmt_meta$RemoteType)) {
      return(NULL)
    }
    return(purrr::list_modify(rmt_meta, package = .p, path = dirname(desc_path)))
  }) %>% purrr::set_names(ip$Package) %>%
    purrr::compact()
  return(pkg_remotes)
}

