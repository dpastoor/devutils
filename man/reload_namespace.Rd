% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reload.R
\name{reload_namespace}
\alias{reload_namespace}
\title{reload a package namespace}
\usage{
reload_namespace(pkg, ...)
}
\arguments{
\item{pkg}{package to reload}

\item{...}{arguments to pass to \code{\link[=library]{library()}}}
}
\description{
reload a package namespace
}
\details{
used to unload and reload a package namespace,
can be helpful when a package has been rebuilt in a
separate process
}
