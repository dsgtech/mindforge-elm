import Html exposing (..)
import Html.Attributes exposing (style, type_, placeholder)
import Html.Events exposing (onClick, onInput)
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

type alias Model =
    { tree : Tree
    , fileName : String
    }

init : (Model, Cmd Msg)
init =
    (Model Empty "test0.json", getJson "test0.json")

-- UPDATE

type Msg
    = Refresh
    | JsonReceived (Result Http.Error (List JsonNode))
    | RebuildSource
    | RebuildSourceAck (Result Http.Error Int)
    | MindMapFileName String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Refresh ->
            (model, getJson model.fileName)
        JsonReceived (Ok jsonNodes) ->
            ({ model | tree = jsonNodes |> getTree }, Cmd.none)
        JsonReceived (Err _) -> -- TODO: Handle error properly.
            (model, Cmd.none)
        RebuildSource ->
            (model, rebuildSource)
        RebuildSourceAck (_) -> -- TODO: Handle error properly.
            (model, Cmd.none)
        MindMapFileName name ->
            ({ model | fileName = name }, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
    div []
    [ h1 [] [ text "MindForge" ]
    , button [onClick RebuildSource] [text "Rebuild Elm source"]
    , input [ type_ "text"
            , placeholder "mind map file"
            , onInput MindMapFileName] []
    , button [onClick Refresh] [text "Load"]
    , showTree model.tree
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

getJson : String -> Cmd Msg
getJson fileName =
    Http.send JsonReceived (Http.get fileName jsonNodesDecoder)

rebuildSource : Cmd Msg
rebuildSource =
    Http.send RebuildSourceAck (Http.get "rebuild_source" (JD.succeed 0))

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
