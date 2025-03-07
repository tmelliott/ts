% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/types.R
\name{ts_logical}
\alias{ts_logical}
\title{Logical or boolean type}
\usage{
ts_logical(n = -1L)
}
\arguments{
\item{n}{The length of the boolean vector. If \code{n = 1} then a single boolean is expected. If \code{n = 0} then any length is expected. If \code{n > 1} then a boolean vector of length \code{n} is expected.}
}
\value{
A ts object that accepts logical scalars or vectors of length \code{n}.
}
\description{
Booleans are represented in Zod schema as either a boolean (\code{z.boolean()}),
or a typed Uint8Array (\code{z.instanceof(Uint8Array)}).
}
\examples{
x <- ts_logical(1)
x$check(TRUE)

\dontrun{
# this will fail
x$check(5)
}
}
