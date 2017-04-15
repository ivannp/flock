flock
=====

An R package implementing synchronization between R processes (spawned by using the "parallel" package for instance) using file locks. Supports both exclusive and shared locking.

    require(flock)

    file.lock = lock("~/file.lock")
    # Critical section code goes here
    unlock(file.lock)

## Installation

    devtools::install_github("ivannp/flock")
