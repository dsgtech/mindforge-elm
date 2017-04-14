import Html exposing (..)
import Html.Attributes exposing (style)
import Json.Decode exposing (..)


json = """
[
    {"id": 0, "text": "Root node", "parent": 0},
    {"id": 1, "text": "Child node 1", "parent": 0},
    {"id": 2, "text": "Child node 2", "parent": 0},
    {"id": 3, "text": "Child node 1.1", "parent": 1},
    {"id": 4, "text": "Child node 1.2", "parent": 1},
    {"id": 5, "text": "Child node 1.3", "parent": 1},
    {"id": 6, "text": "Child node 2.1", "parent": 2},
    {"id": 7, "text": "Child node 2.2", "parent": 2}
]
"""

type alias JsonNode = { id: Int, text: String, parent: Int }


type Tree
    = Empty
    | Node Int String (List Tree)

insert : JsonNode -> Tree -> Tree
insert ({id, text, parent} as node) tree =
    case tree of
        Empty ->
            Node id text []
        Node pid ptext children ->
            if parent == pid then
                Node pid ptext (List.append children [Node id text []])
            else
                Node pid ptext (List.map (insert node) children)


jsonNodeDecoder : Decoder JsonNode
jsonNodeDecoder =
    map3 JsonNode (field "id" int) (field "text" string) (field "parent" int)

getDecodedJsonNodes jsonStr =
    decodeString (list jsonNodeDecoder) jsonStr


getTreeFromDecodedJson : List JsonNode -> Tree
getTreeFromDecodedJson jsonNodes =
    List.foldl insert Empty jsonNodes


showTree : Tree -> Html msg
showTree tree =
    case tree of
        Empty
            -> text ""
        Node _ str childTree
            -> table [ style [("border-collapse", "true")] ]
            [
                tr []
                [ td [ style [("padding", "10px")] ] [ text str ]
                , List.map showTree childTree |> td [ style [("padding", "10px")] ]
                ]
            ]

main =
    let
        result =
            case getDecodedJsonNodes json of
                Ok(decodedJsonNodes) ->
                    decodedJsonNodes |> getTreeFromDecodedJson |> showTree
                Err(err) ->
                    div [] [text "Error: ", text err]
    in
        div []
        [ h1 [] [ text "MindForge" ]
        , result
        ]
