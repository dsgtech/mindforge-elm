import Html exposing (Html, div, text)
import Xml exposing (Value)
import Xml.Encode exposing (null)
import Xml.Decode exposing (decode)
import Xml.Query exposing (tags, tag, string, int, collect)

decodedXml : Value
decodedXml =
    """
    <people>
        <person>
            <name>noah</name>
            <age max="100">50</age>
        </person>
        <person>
            <name>josh</name>
            <age max="100">57</age>
        </person>
    </people>
    """
        |> decode
        |> Result.toMaybe
        |> Maybe.withDefault null


type alias Person =
    { name: String
    , age: Int
    }

person : Value -> Result String Person
person value =
    Result.map2
        (\name age ->
            { name = name
            , age = age
            }
        )
        (tag "name" string value)
        (tag "age" int value)

showPerson : Person -> Html msg
showPerson {name, age} =
    div[] [text name, text ", ", text (toString age)]

people : List Person
people =
    tags "person" decodedXml
        |> collect person

main =
    List.map showPerson people |> div []
