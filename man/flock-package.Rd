\name{flock-package}
\alias{flock-package}
\alias{flock}
\docType{package}
\title{
Process synchronization using file locks.
}
\description{
Enables synchronization between R processes using a file
lock. Supports both exclusive (writer) and shared (readers)
locks.

On UNIX, the implementation relies on the \code{fcntl} system
call. While on Windows, the \code{LockFileEx}/\code{UnlockFileEx}
APIs are used.
}
\details{
\tabular{ll}{
Package: \tab flock\cr
Type: \tab Package\cr
Version: \tab 0.6\cr
Date: \tab 2014-11-24\cr
License: \tab Apache License 2.0\cr
}

}
\author{
Ivan Popivanov

Maintainer: Ivan Popivanov <ivan.popivanov@gmail.com>
}
\keyword{package}
\examples{
\dontrun{
require(DBI)
require(flock)
require(RSQLite)
require(parallel)

dbpath <- tempfile()
con <- dbConnect(RSQLite::SQLite(), dbname=dbpath)
df <- data.frame(value = 0)
dbWriteTable(con, "test", df)
dbDisconnect(con)

write.one.value <- function(val, lock.name=NULL) {
   if(!is.null(lock.name)) {
      file.lock = lock(lock.name)
   }
   
   # The three lines below are the "critical section"
   con <- dbConnect(RSQLite::SQLite(), dbname = dbpath)
   dbWriteTable(con, "test", data.frame(value = val), append = TRUE)
   dbDisconnect(con)
   
   if(!is.null(lock.name)) {
      unlock(file.lock)
   }
}

lock.name = tempfile()

# Run the parallel database updates with two cores
mclapply(1:100, write.one.value, mc.cores=2, lock.name=lock.name)

# To see the failing scenario, run (on a multi-core system):
# mclapply(1:100, write.one.value, mc.cores=2)
}
}
