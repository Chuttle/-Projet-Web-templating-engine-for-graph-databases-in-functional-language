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

-- | select the part of the URL to load
site :: [Relation] -> [Infos] -> [(String,Style)] -> [String] -> Snap ()
site rel info styles subjects =
    route [ (":param.html", echoHandler rel info styles subjects)
          ] 

-- | filter a potential parse error in site
echoHandler :: [Relation] -> [Infos] -> [(String,Style)] -> [String] -> Snap ()
echoHandler rel infos styles subjects = do
    param <- getParam "param.html"
    maybe (writeBS "error")
          (\x -> writeBS (pack (checkparam (unpackChars x) rel infos styles subjects))) param

-- | generate the page if it exit or a 404 error
checkparam :: String -> [Relation] -> [Infos] -> [(String,Style)] -> [String] -> String
checkparam param rel infos styles subjects = if (last splitedParam) == "html"  && (length splitedParam) == 2 && (find (\y -> (head splitedParam)==y) subjects) /= Nothing
                                             then creerPage (head splitedParam) rel  infos styles
                                             else "Error 404"
                                             where splitedParam = splitOn "." param