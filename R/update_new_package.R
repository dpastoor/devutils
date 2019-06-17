#' update the default configuration of new package scaffold
#' @param title title of package
#' @param description description of package
#' @param name name
#' @param email author email
#' @param .dp description path
#' @return desc file
#' @importFrom utils as.person
#' @export
update_new_package <- function(
  title,
  description = title,
  name = whoami::fullname(),
  email = whoami::email_address(),
  .dp = "DESCRIPTION"
) {
  if (.dp != "DESCRIPTION") {
    # not in package dir, lets go there temporarily
    cwd <- getwd()
    on.exit({
      setwd(cwd)
    }, add = TRUE)
    pkgdir <- dirname(.dp)
    setwd(pkgdir)
  }
  update_default_description(title,
                              description,
                              name = name,
                              email = email,
                              .dp = "DESCRIPTION",
                              write = TRUE)
  file.remove("NAMESPACE")
  if (fs::dir_exists('man')) {
    fs::dir_delete("man")
  }
  if (file.exists("R/hello.R")) {
    file.remove("R/hello.R")
  }
  # use_pipe needs to see a roxygen setup so run document
  # once to bootstrap
  devtools::document()
  usethis::use_pipe()
  devtools::document()
  return(invisible(TRUE))
}
