#' update the default decription file a new package
#' @param title title of package
#' @param description description of package
#' @param name name
#' @param email author email
#' @param .dp description path
#' @param write write out the new description
#' @return desc file
#' @importFrom utils as.person
#' @export
update_default_description <- function(
                        title,
                        description,
                        name = whoami::fullname(),
                        email = whoami::email_address(),
                        .dp = "DESCRIPTION",
                        write = TRUE
                         ) {
  if (!file.exists(.dp)) {
    stop("no description detected in directory ", .dp, call. = FALSE)
  }
  d <- desc::description$new(.dp)
  # will pass through if name is already a person object, else will convert
  p__ <- as.person(name)
  author <- utils::person(p__$given,
                          p__$family,
                          email = email,
                          role = c("aut", "cre"))
  d$del(keys = c("Maintainer", "Author", "URL", "BugReports", "License"))
  d$set_version(package_version("0.0.1"))
  d$set(Title = title)
  d$set(Description = description)
  d$set_authors(author)
  d$change_maintainer(given = p__$given, family = p__$family, email = email)
  if (write) {
    d$write(.dp)
  }
  d
}
