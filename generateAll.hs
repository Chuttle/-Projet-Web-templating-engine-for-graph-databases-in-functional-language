import System.Environment
import Data.List (find)
import HTMLBuilder 
-- les fonctions de tri/recherche
f :: [Relation] -> String -> [Relation]
f g e = filter (\(x,y,z) -> x==e) g

getFirst :: Relation -> String
getFirst (s,r,p) = s

getLast :: Relation -> String
getLast (s,r,p) = p

getSujets :: [Relation] -> [String]
getSujets g = shrinkToUniq (concat[fmap getFirst g, fmap getLast g])

shrinkToUniq :: [String] -> [String]
shrinkToUniq [] = []
shrinkToUniq (x:xs) = let shrinkedList = shrinkToUniq xs
                      in case find (\y -> x==y) shrinkedList of Nothing -> x:shrinkedList
                                                                _ -> shrinkedList

-- fonction d'écriture
writer :: [Relation] -> [Infos] -> [(String,Style)] -> String -> IO()
writer graph infos styles subject = writeFile (concat[subject,".html"]) (creerPage subject graph  infos styles)

-- le main

main = do
    d <- readFile "graph.dat"
    info <- readFile "infos.dat"
    styles <- readFile "style.dat"
    let graph=read d::[Relation]
        infoGraph=read info::[Infos]
        styleGraph=read styles::[(String,Style)]
        sujets = getSujets graph
        nomFichier = map (++".html") sujets
        contenu = map (\subject -> creerPage subject graph  infoGraph styleGraph) sujets
    sequence(zipWith writeFile nomFichier contenu)