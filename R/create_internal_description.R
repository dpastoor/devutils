#' create decription file for internal package
#' @param proj project name
#' @param name name
#' @param email author email
#' @return desc file
#' @details
#' creates the desc object representation with the fields
#' needed to bootstrap an internal package description
#' @export
create_internal_desc <- function(
  proj,
  first_name,
  last_name,
  email
) {
  d <- desc::description$new("!new")
  # will pass through if name is already a person object, else will convert
  p__ <- as.person(name)
  author <- utils::person(p__$given,
                   p__$family,
                   email = email,
                   role = c("aut", "cre"))
  d$del(keys = c("Maintainer", "URL", "BugReports", "License"))
  d$set(Package = "internal")
  d$set_version(package_version("0.0.1"))
  d$set(Title = "internal functions")
  d$set(Description = glue::glue("Internal package for project: {proj}."))
  d$set_authors(author)
  d$set_dep(package = "magrittr", type = "Imports")
  d
}
