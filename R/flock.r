## Copyright [2014] [Ivan Popivanov]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

require(methods)

# The file locking interface
lock = function(path, exclusive=TRUE)
{
   expanded.path = path.expand(path)
   res = lock.interface(expanded.path, exclusive)
   return(new("FileLock", path=expanded.path, descriptor=res$descriptor, locked=res$locked))
}

setClass(
   "FileLock",
   slots=list(
      path="character",
      descriptor="integer",
      locked="integer"))

setGeneric("unlock", function(file.lock) { standardGeneric("unlock")})
setMethod("unlock", "FileLock", function(file.lock) {
   unlock.interface(file.lock@descriptor)
})

setGeneric("is.locked", function(file.lock) { standardGeneric("is.locked")})
setMethod("is.locked", "FileLock", function(file.lock) {
   return(file.lock@locked == 1)
})