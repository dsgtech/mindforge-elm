import Html exposing (..)

type Tree
    = Empty
    | Node String (List Tree)


getMindMap : Tree
getMindMap =
    Node "Root node" [ Node "Child node 1" []
                     , Node "Child node 2" []
                     ]

showTree : Tree -> Html msg
showTree tree =
    case tree of
        Empty
            -> text ""
        Node str childTree
            -> text str :: List.map showTree childTree |> div []

main =
    div []
    [ h1 [] [ text "MindForge" ]
    , showTree getMindMap
    ]
