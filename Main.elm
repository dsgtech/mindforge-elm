import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD

main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

-- MODEL

type alias JsonNode = { id: Int, text: String, parent: Int }

type Tree
    = Empty
    | Node Int String (List Tree)

type alias Model = Tree

init : (Model, Cmd Msg)
init =
    (Empty, getJson)

-- UPDATE

type Msg
    = Refresh
    | JsonReceived (Result Http.Error (List JsonNode))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Refresh ->
            (model, getJson)
        JsonReceived (Ok jsonNodes) ->
            (jsonNodes |> getTree, Cmd.none)
        JsonReceived (Err _) -> -- TODO: Handle error properly.
            (model, Cmd.none)


-- VIEW
view : Model -> Html Msg
view model =
    div []
    [ h1 [] [ text "MindForge" ]
    , button [onClick Refresh] [text "Refresh"]
    , showTree model
    ]

-- HELPERS

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


jsonNodeDecoder : JD.Decoder JsonNode
jsonNodeDecoder =
    JD.map3
        JsonNode
        (JD.field "id" JD.int)
        (JD.field "text" JD.string)
        (JD.field "parent" JD.int)

jsonNodesDecoder : JD.Decoder (List JsonNode)
jsonNodesDecoder =
    JD.list jsonNodeDecoder


getTree : List JsonNode -> Tree
getTree jsonNodes =
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
                , List.map showTree childTree |>
                    td [ style [("padding", "10px")] ]
                ]
            ]

getJson : Cmd Msg
getJson =
    Http.send JsonReceived (Http.get "test0.json" jsonNodesDecoder)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
