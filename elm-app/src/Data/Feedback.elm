module Data.Feedback exposing (Feedback, decoder, encode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode exposing (Value)


type alias Feedback =
    { email : String
    , institution : String
    , created_at : String
    , finished : Bool
    , description : String
    }



-- SERIALIZATION --


decoder : Decoder Feedback
decoder =
    decode Feedback
        |> required "email" Decode.string
        |> required "institution" Decode.string
        |> required "createdAt" Decode.string
        |> required "finished" Decode.bool
        |> required "description" Decode.string


encode : Feedback -> Value
encode feedback =
    Encode.object <|
        [ ( "email", Encode.string feedback.email )
        , ( "institution", Encode.string feedback.institution )
        ]
