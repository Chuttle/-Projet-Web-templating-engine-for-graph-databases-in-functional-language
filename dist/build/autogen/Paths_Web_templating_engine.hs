module Paths_Web_templating_engine (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\louis\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\louis\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-7.10.3\\Web-templating-engine-0.1-B5YPPjBVKjlFfjfWVEXKOr"
datadir    = "C:\\Users\\louis\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-7.10.3\\Web-templating-engine-0.1"
libexecdir = "C:\\Users\\louis\\AppData\\Roaming\\cabal\\Web-templating-engine-0.1-B5YPPjBVKjlFfjfWVEXKOr"
sysconfdir = "C:\\Users\\louis\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Web_templating_engine_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Web_templating_engine_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Web_templating_engine_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Web_templating_engine_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Web_templating_engine_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
