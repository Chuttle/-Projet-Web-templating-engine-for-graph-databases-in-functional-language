module HTMLBuilderUtils 
      (getSujets
      ,shrinkToUniq
      ,getFirst
      ,getLast
      ) where
import HTMLBuilder 
import Data.List (find)

-- | shrinkToUniq returns a list with just one copy of the elements of the list in parameter
shrinkToUniq :: [String] -> [String]
shrinkToUniq [] = []
shrinkToUniq (x:xs) = let shrinkedList = shrinkToUniq xs
                      in case find (\y -> x==y) shrinkedList of Nothing -> x:shrinkedList
                                                                _ -> shrinkedList


-- | getSujets returns all the first and last element of a list of Relation with just one copy of each
getSujets :: [Relation] -> [String]
getSujets g = shrinkToUniq (concat[fmap getFirst g, fmap getLast g])

-- sorting and searching functions
-- | getFirst returns the first element of a Relation

getFirst :: Relation -> String
getFirst (s,r,p) = s

-- | getLast returns the last element of a Relation
getLast :: Relation -> String
getLast (s,r,p) = p


