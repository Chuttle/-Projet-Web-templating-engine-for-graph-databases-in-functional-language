import System.Environment
import HTMLBuilderUtils
import HTMLBuilder 
-- | generate HTML page using 3 graphs (graph.dat,infos.dat,style.dat)

-- les fonctions de tri/recherche
f :: [Relation] -> String -> [Relation]
f g e = filter (\(x,y,z) -> x==e) g


-- writing function
-- | writer create a HTML page using the graphs and the subject of this page
writer :: [Relation] -> [Infos] -> [(String,Style)] -> String -> IO()
writer graph infos styles subject = writeFile (concat[subject,".html"]) (creerPage subject graph  infos styles)

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
        contenu = map (\subject -> creerPage subject graph  infoGraph styleGraph) sujets
    sequence(zipWith writeFile nomFichier contenu)