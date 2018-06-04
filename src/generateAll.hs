import System.Environment
import HTMLBuilderUtils
import HTMLBuilder 

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