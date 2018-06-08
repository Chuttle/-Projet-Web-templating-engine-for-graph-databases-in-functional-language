-- | All the data and type needed to the function
module HTMLBuilder
        (creerPage
        ,Relation
        ,Infos 
        ,Style (..)
        ,Type (..)
        ,Parameter (..)
        )where

-- all type and data
-- | Relation links a subject and a target with a relation
type Relation = (String, String, String)

-- | Infos links a subject to some informations concerning the subject
type Infos = (String, Type, String)

-- | The informations can be a Description or a Picture or an appereance for the HTML page
data Type = Description | Image | HTMLType deriving (Show,Enum, Eq,Read)

-- | Style defines the appereance for the HTML page
-- Syntax: 
--
-- Node nom [Parameter] [Style] -> représente une balise HTML. nom est le nom de la balise entre guillemets, [Parameter] est une liste d'attributs de la balise comme décrit plus bas, et Style est une liste des Noeuds qui seront dans la balise.
-- Text texte -> insère un texte de votre choix
-- Title  -> insère le titre de la page
-- IterateRelation [Style]  -> permet de reproduire une fois par relation la série de balise contenue
-- LinkName -> permet d'insérer le nom de la première relation active. Utilisable dans un noeud IterateRelation
-- LinkTarget -> permet d'insérer la cible de la première relation active. Utilisable dans un noeud IterateRelation 
-- IterateInfos Type [Style] -> permet de reproduire une fois par élément du fichier info du type précisé la série de balise contenue
-- Info -> permet d'insérer la cible de la première Info active. Utilisable dans un noeud IterateInfos
-- 
data Style = Node String [Parameter] [Style] 
                | Text String  
                | Title  
                | IterateRelation [Style] 
                | LinkName 
                | LinkTarget 
                | IterateInfos Type [Style] 
                | Info deriving (Show,Read)
           
-- | represent a parameter in a HTML document
-- use P for a string and L for a link
data Parameter = Param String String
               | Link String
               | TitleP String
               | InfoP String deriving (Show,Read)

-- a default style
defaultstyle = (Node "html" [] [
                      Node "head" [] [
                          Node "title" [] [
                              Text "le titre de la page est: "
                              ,Title
                              ]
                          ]
                      ,Node "body" [] [
                            Node "h1" [] [Title]
                            ,IterateInfos Description [
                                Node "p" [] [
                                    Text "Une description est :"
                                    ,Info
                                    ]
                                ]
                            ,IterateInfos Image [
                                Node "img" [InfoP "src", TitleP "alt" ] []
                                ]
                            ,IterateRelation[
                                Node "p" [] [
                                    Text "a pour " 
                                    ,LinkName
                                    ,Text ": "
                                    ,Node "a" [Link "href"] [
                                        LinkTarget
                                        ]
                                    ]
                                ]
                            ]
                             
                      ]
                )

-- | creerPage takes a subject and the graphs as parameters and return the html code for the page associated to the subject
creerPage :: String -> [Relation] -> [Infos] -> [(String, Style)] -> String
creerPage subject rel infos style = creationPage subject (myfilter subject rel) (myfilter subject infos) (getStyleFromSubject subject infos style)

-- | search the style associated to the subject in the graphs and returns it
getStyleFromSubject :: String -> [Infos] -> [(String, Style)] -> Style
getStyleFromSubject _ [] styles = getStyleFromName "default" styles
getStyleFromSubject subject ((a, b, c):infos) styles = if a==subject && b==HTMLType
                                                       then getStyleFromName c styles
                                                       else getStyleFromSubject subject infos styles

-- | search the style associated to the name in the style graph and returns it
getStyleFromName :: String -> [(String, Style)] -> Style
getStyleFromName _ [] = defaultstyle
getStyleFromName name ((currentName, currentStyle):styles) 
   |name == currentName = currentStyle
   |otherwise           = getStyleFromName name styles

-- | takes a parameter and a list, search in the list if the second element of a triplet is equal to the parameter and return a list
myfilter :: String -> [(String, a, b)] -> [(String, a, b)]
myfilter _ [] = []
myfilter subject ((a, b, c):infos) = if a==subject
                                     then (a,b,c):(myfilter subject infos)
                                     else myfilter subject infos

-- | takes a subject, the graphs and the style of this subject and return the html code of this page
creationPage :: String -> [Relation] -> [Infos] -> Style -> String
creationPage subject rel infos style = printNode subject rel infos style

-- | read the Style graph and concat all parts to create the html code
printNode :: String -> [Relation] -> [Infos] -> Style -> String
printNode subject rel                  infos (Node name params [])             = concat ["<", name, printParams subject rel infos params, "/>"]
printNode subject rel                  infos (Node name params nodes)          = concat (concat [["<", name, printParams subject rel infos params,">"], map (printNode subject rel infos) nodes, ["</", name, ">"]])
printNode subject rel                  infos (Text content)                    = content
printNode subject rel                  infos (Title)                           = subject
printNode subject []                   infos (IterateRelation nodes)           = []
printNode subject (rels@(_:otherrels)) infos thisnodes@(IterateRelation nodes) = concat (concat [map (printNode subject rels infos) nodes, [printNode subject otherrels infos thisnodes]])
printNode subject ((_,name,_):_)       infos (LinkName)                        = name
printNode subject ((_,_,target):_)     infos (LinkTarget)                      = target
printNode subject rel                  []    (IterateInfos _ nodes)            = []
printNode subject rel (infos@((_,Description,_):otherinfos)) thisnodes@(IterateInfos Description nodes) = concat (concat [map (printNode subject rel infos) nodes, [printNode subject rel otherinfos thisnodes]])
printNode subject rel (infos@((_,Image,_):otherinfos))       thisnodes@(IterateInfos Image nodes)       = concat ( concat [map (printNode subject rel infos) nodes, [printNode subject rel otherinfos thisnodes]])
printNode subject rel (_:infos)                              thisnodes@(IterateInfos _ nodes)           = printNode subject rel infos thisnodes
printNode subject rel ((_,_,value):_)                        (Info)                                     = value

-- | puts parameters in the html code where it needs to be
printParams :: String -> [Relation] -> [Infos] -> [Parameter] -> String
printParams _ _ _ [] = []
printParams subject rel infos ((Param name value):params) = concat [" ", name, " = ", value, printParams subject rel infos params]
printParams subject rel infos ((TitleP name ):params) = concat [" ", name, " = \"", subject, "\"", printParams subject rel infos params]
printParams subject (rel@((_,_,value):_)) infos ((Link name):params) = concat [" ", name, " = \"",value, ".html\"", printParams subject rel infos params]
printParams subject rel (infos@((_,_,value):_)) ((InfoP name):params) = concat [" ", name, " = \"", value, "\"", printParams subject rel infos params]