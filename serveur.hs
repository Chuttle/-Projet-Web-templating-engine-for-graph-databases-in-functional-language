import Network
import System.IO

main = do
	a <- getArgs
	case a of
	  ["slave",file1,file2,file3,port] -> slave file1 file2 file3 (read port :: PortNumber)
	  ["query",host,port,q] -> query host (read port :: PortNumber) q
	slave file1 file2 file3 port = withSocketsDo $ do
	  g <- readFile file1
	  i <- readFile file2
	  s <- readFile file3
	  sock <- listenOn $ PortNumber port
	  slavebody sock g i s
	  
slavebody sock g i s =
forever $ do
  (handle,host,port) <- accept sock
  rc <- hGetLine handle
  let graph read g :: [Relation]
  let info read i :: [Infos]
  let st read s :: 
  hPutStrLn handle