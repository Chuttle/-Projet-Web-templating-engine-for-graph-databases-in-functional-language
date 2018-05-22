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

-- writing function
-- | writer create a HTML page using the graphs and the subject of this page
writer :: [Relation] -> [Infos] -> [(String,Style)] -> String -> IO()
writer graph infos styles subject = writeFile (concat[subject,".html"]) (creerPage subject graph infos styles)

-- le main
-- | read all graphs, get the subjects and create the HTML Page linked to these subjects
main = do
    d <- readFile "graph.dat"
    info <- readFile "infos.dat"
    styles <- readFile "style.dat"
    let graph=read d::[Relation]
        infoGraph=read info::[Infos]
        styleGraph=read styles::[(String,Style)]
        sujets = getSujets graph
        nomFichier = map (++".html") sujets
        contenu = map (\subject -> creerPage subject graph infoGraph styleGraph) sujets
    sequence(zipWith writeFile nomFichier contenu)