// Copyright [2014] [Ivan Popivanov]

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <Rcpp.h>

#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#ifdef WIN32
#undef Realloc
#undef Free
#include <io.h>
#include <windows.h>
#include <winbase.h>
#endif // WIN32

using namespace Rcpp;

void lock(const char * path, bool exclusive, int & descriptor, int & locked)
{
#ifdef WIN32
   descriptor = ::_open(path, O_RDWR|O_CREAT, S_IREAD|S_IWRITE);
#else
   descriptor = ::open(path, O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
#endif // WIN32
   if(descriptor < 0) {
      locked = 0;
      return;
   }

#ifdef WIN32
   HANDLE handle = (HANDLE)_get_osfhandle(descriptor);
   OVERLAPPED ov = {0};
   if(!LockFileEx(handle, exclusive ? LOCKFILE_EXCLUSIVE_LOCK : 0, 0, 1, 0, &ov)) {
      ::close(descriptor);
      descriptor = -1;
      locked = 0;
      return;
   }
#else
   struct flock fl;
   fl.l_type   = exclusive ? F_WRLCK : F_RDLCK; // F_RDLCK, F_WRLCK, F_UNLCK
   fl.l_whence = SEEK_SET;                      // SEEK_SET, SEEK_CUR, SEEK_END
   fl.l_start  = 0;                             // Offset from l_whence
   fl.l_len    = 0;                             // length, 0 = to EOF
   fl.l_pid    = ::getpid();                    // pid

   if(::fcntl(descriptor, F_SETLKW, &fl) == -1) {
      ::close(descriptor);
      descriptor = -1;
      locked = 0;
      return;
   }
#endif // WIN32

   locked = 1;
}

void unlock(int & descriptor) {
#ifdef WIN32
   HANDLE handle = (HANDLE)_get_osfhandle(descriptor);
   OVERLAPPED ov = {0};
   UnlockFileEx(handle, 0, 0, 1, &ov);
   ::_close(descriptor);
#else
   struct flock fl;
   
   fl.l_type   = F_UNLCK;
   fl.l_whence = SEEK_SET;
   fl.l_start  = 0;
   fl.l_len    = 0;
   fl.l_pid    = ::getpid();

   ::fcntl(descriptor, F_SETLK, &fl);
   ::close(descriptor);
#endif // WIN32
   
   descriptor = -1;
}

// [[Rcpp::export("lock.interface")]]
Rcpp::List lockInterface(const char * pathIn, bool exclusive)
{
   int descriptor;
   int locked = 0;
   lock(pathIn, exclusive, descriptor, locked);
   return Rcpp::List::create(Rcpp::Named("descriptor") = descriptor, Rcpp::Named("locked") = locked);
}

// [[Rcpp::export("unlock.interface")]]
void unlockInterface(int descriptorIn)
{
   int descriptor = descriptorIn;
   unlock(descriptor);
}
