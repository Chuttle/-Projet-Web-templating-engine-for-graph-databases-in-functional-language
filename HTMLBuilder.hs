module HTMLBuilder
        (creerPage
        ,Relation
        ,Infos (..)
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

data Parameter = P String String
               | L String
               | T String
               | I String deriving (Show,Read)


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
                                Node "img" [I "src", T "alt" ] []
                                ]
                            ,IterateRelation[
                                Node "p" [] [
                                    Text "a pour " 
                                    ,LinkName
                                    ,Text ": "
                                    ,Node "a" [L "href"] [
                                        LinkTarget
                                        ]
                                    ]
                                ]
                            ]
                             
                      ]
                )

creerPage :: String -> [Relation] -> [Infos] -> [(String, Style)] -> String
creerPage subject rel infos style = creationPage subject (myfilter subject rel) (myfilter subject infos) (getStyleFromSubject subject infos style)

getStyleFromSubject :: String -> [Infos] -> [(String, Style)] -> Style
getStyleFromSubject _ [] styles = getStyleFromName "default" styles
getStyleFromSubject subject ((a, b, c):infos) styles = if a==subject && b==HTMLType
                                                       then getStyleFromName c styles
                                                       else getStyleFromSubject subject infos styles

getStyleFromName :: String -> [(String, Style)] -> Style
getStyleFromName _ [] = defaultstyle
getStyleFromName name ((currentName, currentStyle):styles) 
   |name == currentName = currentStyle
   |otherwise           = getStyleFromName name styles

myfilter :: String -> [(String, a, b)] -> [(String, a, b)]
myfilter _ [] = []
myfilter subject ((a, b, c):infos) = if a==subject
                                     then (a,b,c):(myfilter subject infos)
                                     else myfilter subject infos

creationPage :: String -> [Relation] -> [Infos] -> Style -> String
creationPage subject rel infos style = printNode subject rel infos style


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




printParams :: String -> [Relation] -> [Infos] -> [Parameter] -> String
printParams _ _ _ [] = []
printParams subject rel infos ((P name value):params) = concat [" ", name, " = ", value, printParams subject rel infos params]
printParams subject rel infos ((T name ):params) = concat [" ", name, " = \"", subject, "\"", printParams subject rel infos params]
printParams subject (rel@((_,_,value):_)) infos ((L name):params) = concat [" ", name, " = \"",value, ".html\"", printParams subject rel infos params]
printParams subject rel (infos@((_,_,value):_)) ((I name):params) = concat [" ", name, " = \"", value, "\"", printParams subject rel infos params]

