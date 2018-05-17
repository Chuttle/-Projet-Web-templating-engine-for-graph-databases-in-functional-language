module HTMLBuilder
        (creerPage
        ,Relation
        ,Infos
        ,Style
        ,Type
        )where

-- all type and data
-- | Relation links a subject and a target with a relation
type Relation = (String, String, String)
-- | Infos links a subject to some informations concerning the subject
type Infos = (String, Type, String)
data Style = Style String String String String String String String String String String String String String String String String String deriving (Show, Eq,Read)
-- | The informations can be a Description or a Picture or an appereance for the HTML page
data Type = Description | Image | HTMLType deriving (Show,Enum, Eq,Read)

defaultstyle = (Style "<html> <head>  <title>" "</title> </head> <body>  <h1>"  "</h1>"  "<section id=descriptifs>"  "<p>" "</p>"  "<img src=\""  "\" alt=\""  " \" >"  "</section>"  "<section id=relation>"  "<p>"  ": <a href=\""  ".html\">"  "</a></p>"  "</section>"  " </body></html>")


creerPage :: String -> [Relation] -> [Infos] -> [(String, Style)] -> String
creerPage subject rel infos style = creationPage subject rel infos (getStyleFromSubject subject infos style)

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

sectionRelat :: String -> [Relation] -> Style -> String
sectionRelat subject rel style = section (creationLien subject rel style) style
        where section [] _ = []
              section links (Style _ _ _ _ _ _ _ _ _ _ dbtsection _ _ _ _ finsection _) = concat [dbtsection,links,finsection]


creationPage :: String -> [Relation] -> [Infos] -> Style -> String
creationPage subject rel infos (style@(Style dbtHeader finHeader finTitre _ _ _ _ _ _ _ _ _ _ _ _ _ finPage)) = concat [dbtHeader, subject, finHeader, subject, finTitre, sectionDesc subject infos style, sectionRelat subject rel style, finPage]



creationLien :: String -> [Relation] -> Style -> String
creationLien _ [] _= ""
creationLien subject ((a,b,c):xs) style@(Style _ _ _ _ _ _ _ _ _ _ _ _ template1 template2 template3 _ _)= if a==subject 
                                                                                                     then concat [b,template1,c,template2,c,template3, creationLien subject xs style]
                                                                                                     else creationLien subject xs style

sectionDesc :: String -> [Infos] -> Style -> String
sectionDesc _ [] _ = []
sectionDesc subject infos style = section (concat [creationDescription subject infos style,insertionImage subject infos style]) style
        where section [] _ = []
              section content (Style _ _ _ dbtsection _ _ _ _ _ finsection _ _ _ _ _ _ _) = concat [dbtsection,content,finsection]


creationDescription :: String -> [Infos] -> Style -> String
creationDescription _ [] _= ""
creationDescription subject ((a,b,c):xs) style@(Style _ _ _ _ dbtParagraphe finParagraphe _ _ _ _ _ _ _ _ _ _ _)= if a==subject && b==Description
                                                                                                            then concat [dbtParagraphe,c,finParagraphe, creationDescription subject xs style]
                                                                                                            else creationDescription subject xs style


insertionImage :: String -> [Infos] -> Style -> String
insertionImage _ [] _= ""
insertionImage subject ((a,b,c):xs) style@(Style _ _ _ _ _ _ dbtImage sepImage fin _ _ _ _ _ _ _ _)= if a==subject && b==Image
                                                                                               then concat [dbtImage,c,sepImage, subject, fin, insertionImage subject xs style]
                                                                                               else insertionImage subject xs style


