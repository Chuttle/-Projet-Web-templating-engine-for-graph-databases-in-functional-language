{-# LANGUAGE OverloadedStrings #-}
-- | create a Module Main
module Main where

import           HTMLBuilderUtils
import           HTMLBuilder 

import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server
import           Data.List.Split (splitOn)
import           Data.ByteString.Internal (unpackChars)
import           Data.ByteString.Char8 (pack)
import           Data.Maybe (fromJust)
import           Data.List (find)

-- | the main function that read the graphs and create the site
main :: IO ()
main = do 
    d <- readFile "graph.dat"
    info <- readFile "infos.dat"
    styles <- readFile "style.dat"
    let graph=read d::[Relation]
        infoGraph=read info::[Infos]
        styleGraph=read styles::[(String,Style)]
        sujets = getSujets graph
    quickHttpServe (site graph infoGraph styleGraph sujets)

-- | take three graphs and a list of String as parameters return a Snap
site :: [Relation] -> [Infos] -> [(String,Style)] -> [String] -> Snap ()
site rel info styles subjects =
    ifTop (writeBS "hello world") <|>
    route [ ("foo", writeBS "bar")
          , (":param.html", echoHandler rel info styles subjects)
          ] 

-- | take the graphs as parameters and return a Snap
echoHandler :: [Relation] -> [Infos] -> [(String,Style)] -> [String] -> Snap ()
echoHandler rel infos styles subjects = do
    param <- getParam "param.html"
    maybe (writeBS "must specify echo/param in URL")
          (\x -> writeBS (pack (checkparam (unpackChars x) rel infos styles subjects))) param

-- | take a parameter and the graphs as parameters and create the page with the name of the parameter if the parameter is a subject and if the URL is well spelt (name.html)
checkparam :: String -> [Relation] -> [Infos] -> [(String,Style)] -> [String] -> String
checkparam param rel infos styles subjects = if (last splitedParam) == "html"  && (length splitedParam) == 2 && (find (\y -> (head splitedParam)==y) subjects) /= Nothing
                                             then creerPage (head splitedParam) rel  infos styles
                                             else "wrong URL"
                                             where splitedParam = splitOn "." param