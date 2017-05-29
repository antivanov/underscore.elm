module Underscore exposing (
  map,
  reduce,
  reduceRight,
  find,
  filter,
  whereDict,
  whereProperty,
  findWhereDict,
  findWhereProperty,
  reject,
  every,
  some,
  contains,
  pluckDict,
  pluck)

{-| Port to Elm of Underscore 1.8.3 functions.

@docs map
@docs reduce
@docs reduceRight
@docs find
@docs filter
@docs whereDict
@docs whereProperty
@docs findWhereDict
@docs findWhereProperty
@docs reject
@docs every
@docs some
@docs contains
@docs pluck
@docs pluckDict
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

    (whereDict
      (Dict.fromList [(2, "2")])
      [Dict.fromList [(1, "1"), (2, "2")], Dict.fromList [(2, "2"), (3, "3")], Dict.fromList [(3, "3"), (4, "4")]]) ==
    [Dict.fromList [(1, "1"), (2, "2")], Dict.fromList [(2, "2"), (3, "3")]]
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

{-| Returns the list containing the records where the property has the given value.
This function should have been called "where", but it is a reserved keyword in Elm,
then it is "whereProperty".

....(whereProperty .country "Finland" [
      { city = "Helsinki", country = "Finland" }
      , { city = "Turku", country = "Finland" }
      , { city = "Tallinn", country = "Estonia" }
    ]) == [
      { city = "Helsinki", country = "Finland" }
      , { city = "Turku", country = "Finland" }
    ]
-}
whereProperty : (a -> comparable) -> comparable -> List a -> List a
whereProperty property propertyValue list = filter (\item -> (property item) == propertyValue ) list

{-| Returns the first matching value in the list that contain the given dictionary as a subdictionary.

    (findWhereDict
      (Dict.fromList [(2, "2")])
      [Dict.fromList [(1, "1"), (2, "2")], Dict.fromList [(2, "2"), (3, "3")], Dict.fromList [(3, "3"), (4, "4")]]) ==
    Just (Dict.fromList [(1, "1"), (2, "2")])
-}
findWhereDict : Dict comparable v -> List (Dict comparable v) -> Maybe (Dict comparable v)
findWhereDict pairs list =
  let
    matchingDictionaries = (whereDict pairs list)
  in
    case matchingDictionaries of
      head::tail -> Just head
      _ -> Nothing

{-| Returns the first matching value in the list where the property has the given value.

....(findWhereProperty .country "Finland" [
      { city = "Helsinki", country = "Finland" }
      , { city = "Turku", country = "Finland" }
      , { city = "Tallinn", country = "Estonia" }
    ]) == Just ({ city = "Helsinki", country = "Finland" })
-}
findWhereProperty : (a -> comparable) -> comparable -> List a -> Maybe a
findWhereProperty property propertyValue list =
  let
    matchingValues = (whereProperty property propertyValue list)
  in
    case matchingValues of
      head::tail -> Just head
      _ -> Nothing

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

-- Skipping "invoke", no object methods in Elm

{-| Extract a list of dictionary values with a specific key.

....pluckDict "name" [
      Dict.fromList [("name", "name1"), ("email", "email1")],
      Dict.fromList [("email", "email2")],
      Dict.fromList [("name", "name3"), ("email", "email3")]
    ] == [Just "name1", Nothing, Just "name3"]
-}
pluckDict : comparable -> List (Dict comparable v) -> List (Maybe v)
pluckDict keyName list = List.map (\d -> (Dict.get keyName d)) list

{-| Extract a list of values from a list of records by a derived property.

....pluck .name [
      { name="Alice", height=1.62 }
      , { name="Bob", height=1.85 }
      , { name="Chuck", height=1.76 }
    ] == ["Alice", "Bob", "Chuck"]
-}
pluck : (a -> comparable) -> List a -> List comparable
pluck property list = List.map property list