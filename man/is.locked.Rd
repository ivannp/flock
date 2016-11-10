\name{is.locked}
\alias{is.locked}
\alias{is.locked,FileLock-method}
\title{Locking/Unlocking}
\description{Checks whether a lock has been obtained.}
\usage{is.locked(file.lock)}
\arguments{\item{file.lock}{The lock as an object of type \code{FileLock}.}}
\author{Ivan Popivanov}
\examples{
\dontrun{
require(flock)

file.lock = lock("~/file.lock")
# Critical section code goes between here and the unlock call
if(is.locked(file.lock)) {
   print("Got the lock!")
}
unlock(file.lock)
}
}
\keyword{lock}
\keyword{unlock}
