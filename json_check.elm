import Html exposing (..)
import Json.Decode exposing (..)

type alias JsonNode = { id: Int, text: String, parent: Int }

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


jsonNodeDecoder : Decoder JsonNode
jsonNodeDecoder =
    map3 JsonNode (field "id" int) (field "text" string) (field "parent" int)

getDecodedJsonNodes jsonStr =
    decodeString (list jsonNodeDecoder) jsonStr


showJsonNode : JsonNode -> Html msg
showJsonNode {id, text, parent} =
    div[]   [ Html.text "id:"
            , Html.text (toString id)
            , Html.text ", "
            , Html.text "text:"
            , Html.text text
            , Html.text ", "
            , Html.text "parent:"
            , Html.text (toString parent)
            ]


main =
     case getDecodedJsonNodes json of
         Ok(jsonNodes) ->
             List.map showJsonNode jsonNodes |> div []
         Err(err) ->
             div [] [text "Error: ", text err]
