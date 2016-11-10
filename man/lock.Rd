\name{lock}
\alias{lock}
\title{Locking/Unlocking}
\description{Locks a file in exclusive or shared mode.}
\usage{lock(path, exclusive = TRUE)}
\arguments{
  \item{path}{Character. The path.}
  \item{exclusive}{Logical. The lock type, exclusive or shared.}
}
\details{The file is created if it doesn't exist.}
\value{
Returns an object of type \code{FileLock}, which is to be
used for the \code{unlock} call.
}
\author{
Ivan Popivanov
}
\examples{
\dontrun{
require(flock)

file.lock = lock("~/file.lock")
# Critical section code goes here
unlock(file.lock)
}
}
\keyword{lock}
\keyword{unlock}
