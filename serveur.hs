import Network
import System.IO
import System.Environment
import Data.List (find)
import HTMLBuilder

-- sorting and searching functions
-- | getFirst returns the first element of a Relation
getFirst :: Relation -> String
getFirst (s,r,p) = s

-- | getLast returns the last element of a Relation
getLast :: Relation -> String
getLast (s,r,p) = p

-- | getSujets returns all the first and last element of a list of Relation with just one copy of each
getSujets :: [Relation] -> [String]
getSujets g = shrinkToUniq (concat[fmap getFirst g, fmap getLast g])

-- | shrinkToUniq returns a list with just one copy of the elements of the list in parameter
shrinkToUniq :: [String] -> [String]
shrinkToUniq [] = []
shrinkToUniq (x:xs) = let shrinkedList = shrinkToUniq xs
                      in case find (\y -> x==y) shrinkedList of Nothing -> x:shrinkedList
                                                                _ -> shrinkedList

main = do
    a <- getArgs
    case a of
      ["slave",file1,file2,file3,port] -> slave file1 file2 file3 (read port :: PortNumber)

-- protocole
slave :: String -> String -> String -> PortNumber -> IO()
slave file1 file2 file3 port = withSocketsDo $ do
  g <- readFile file1
  i <- readFile file2
  s <- readFile file3
  sock <- listenOn $ PortNumber port
  slavebody sock g i s

-- action serveur
slavebody :: Socket -> String -> String -> String -> IO()
slavebody sock g i s = do
 -- forever $ do
  -- (handle,host,port) <- accept sock
  -- rc <- hGetLine handle
  let graph = read g :: [Relation]
  let infoGraph = read i :: [Infos]
  let styleGraph = read s :: [(String,Style)]
  let sujets = getSujets graph
  let nomFichier = map (++".html") sujets
  let contenu = map (\subject -> creerPage subject graph infoGraph styleGraph) sujets
  send sock sequence(zipWith writeFile nomFichier contenu)