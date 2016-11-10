\name{unlock}
\alias{unlock}
\alias{unlock,FileLock-method}
\title{Locking/Unlocking}
\description{Unlocks a file previously locked via \code{lock}.}
\usage{unlock(file.lock)}
\arguments{
   \item{file.lock}{The \code{FileLock} object returned by \code{lock}.}
}
\author{Ivan Popivanov}
\seealso{\code{\link{lock}}}
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
