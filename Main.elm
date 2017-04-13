import Html exposing (..)

type Tree
    = Empty
    | Node String (List Tree)


getMindMap : Tree
getMindMap =
    Node "Root node" [ Node "Child node 1"  [ Node "Child node 1.1" [ Node "Child node 1.1.1" []
                                                                    , Node "Child node 1.1.2" []
                                                                    ]
                                            , Node "Child node 1.2" []
                                            , Node "Child node 1.3" []
                                            ]
                     , Node "Child node 2"  [ Node "Child node 2.1" []
                                            , Node "Child node 2.2" []
                                            ]
                     ]

showTree : Tree -> Html msg
showTree tree =
    case tree of
        Empty
            -> text ""
        Node str childTree
            -> table []
            [
                tr []
                [ td [] [ text str ]
                , List.map showTree childTree |> td []
                ]
            ]

main =
    div []
    [ h1 [] [ text "MindForge" ]
    , showTree getMindMap
    ]
