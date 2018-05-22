import Network
import System.IO
import HTMLBuilder
import generateAll

main = do
    a <- getArgs
    case a of
      ["slave",file1,file2,file3,port] -> slave file1 file2 file3 (read port :: PortNumber)

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
  let graph = read g :: [Relation]
       info = read i :: [Infos]
       st = read s :: [Style]
       sujets = getSujets graph
       nomFichier = map (++".html") sujets
       contenu = map (\subject -> creerPage subject graph infoGraph styleGraph) sujets
  hPutStrLn handle sequence(zipWith writeFile nomFichier contenu)