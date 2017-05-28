module Underscore exposing (
  map,
  reduce,
  reduceRight,
  find,
  filter,
  whereDict,
  reject,
  every,
  some,
  contains)

{-| Port to Elm of Underscore 1.8.3 functions.

@docs map
@docs reduce
@docs reduceRight
@docs find
@docs filter
@docs whereDict
@docs reject
@docs every
@docs some
@docs contains
-}

import List exposing (map, foldl, filter, all)
import Dict exposing (Dict, keys, get)

{-| Transforms a given list by applying the provided element transformation function to every element.

    map [1, 2, 3] (\x -> x > 1) == [False, True, True]
-}
map : (a -> b) -> List a -> List b
map = List.map

{-| Reduces the list from the left given the initial value and the reduction step definition.

    reduce (\s x -> s + x) 0 [1, 2, 3] == 6
-}
reduce : (a -> b -> b) -> b -> List a -> b
reduce = List.foldl

{-| Reduces the list given from the right the initial value and the reduction step definition.

    reduceRight (\s x -> s ++ x) "" ["1", "2", "3"] == "123"
-}
reduceRight : (a -> b -> b) -> b -> List a -> b
reduceRight = List.foldr

{-| Finds first element in the list that satisfies the given predicate.

    find (\x -> x > 1) [1, 2, 3] == 2
-}
find : (a -> Bool) -> List a -> Maybe a
find predicate list =
  case list of
    head::rest ->
      if predicate head then
        Just head
      else
        find predicate rest
    [] -> Nothing

{-| Returns the list of the elements of the list that satisfy the given predicate.

    filter (\x -> x > 1) [1, 2, 3] == [2, 3]
-}
filter : (a -> Bool) -> List a -> List a
filter = List.filter

{-| Returns the list of the dictionaries contained in the list that contain the given dictionary as a subdictionary.

    whereDict (\x -> x > 1) [1, 2, 3] == [2, 3]
-}
whereDict : Dict comparable v -> List (Dict comparable v) -> List (Dict comparable v)
whereDict pairs list =
  let
    pairKeys = Dict.keys pairs
  in
    filter (\item ->
      let
        keyValueMatchesCheck = (\key -> (Dict.get key item) == (Dict.get key pairs))
      in
        List.all keyValueMatchesCheck pairKeys
    ) list

{-| Returns the list of the elements of the list that do not satisfy the given predicate.

....reject (\x -> x > 1) [1, 2, 3] == [1]
-}
reject : (a -> Bool) -> List a -> List a
reject predicate list = filter (\item -> not (predicate(item))) list

{-| Determine if all the elements in the list satisfy the predicate.

....every (\x -> x > 1) [1, 2, 3] == False
-}
every : (a -> Bool) -> List a -> Bool
every = List.all

{-| Determine if some of the elements in the list satisfy the predicate.

....every (\x -> x > 1) [1, 2, 3] == True
-}
some : (a -> Bool) -> List a -> Bool
some = List.any

{-| Determine if the list contains the element.

    contains 2 [1 2 3] == True
-}
contains : a -> List a -> Bool
contains = List.member