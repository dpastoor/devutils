% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update_new_package.R
\name{update_new_package}
\alias{update_new_package}
\title{update the default configuration of new package scaffold}
\usage{
update_new_package(title, description = title,
  name = whoami::fullname(), email = whoami::email_address(),
  .dp = "DESCRIPTION")
}
\arguments{
\item{title}{title of package}

\item{description}{description of package}

\item{name}{name}

\item{email}{author email}

\item{.dp}{description path}
}
\value{
desc file
}
\description{
update the default configuration of new package scaffold
}
