{-# LANGUAGE OverloadedStrings #-}
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

site :: [Relation] -> [Infos] -> [(String,Style)] -> [String] -> Snap ()
site rel info styles subjects =
    ifTop (writeBS "hello world") <|>
    route [ ("foo", writeBS "bar")
          , (":param.html", echoHandler rel info styles subjects)
          ] 

echoHandler :: [Relation] -> [Infos] -> [(String,Style)] -> [String] -> Snap ()
echoHandler rel infos styles subjects = do
    param <- getParam "param.html"
    maybe (writeBS "must specify echo/param in URL")
          (\x -> writeBS (pack (checkparam (unpackChars x) rel infos styles subjects))) param

checkparam :: String -> [Relation] -> [Infos] -> [(String,Style)] -> [String] -> String
checkparam param rel infos styles subjects = if (last splitedParam) == "html"  && (length splitedParam) == 2 && (find (\y -> (head splitedParam)==y) subjects) /= Nothing
                                             then creerPage (head splitedParam) rel  infos styles
                                             else "wrong URL"
                                             where splitedParam = splitOn "." param