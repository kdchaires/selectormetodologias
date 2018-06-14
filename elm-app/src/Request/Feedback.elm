module Request.Feedback exposing (postFeedback)

import Data.Feedback as Feedback exposing (Feedback)
import Http
import Json.Decode exposing (int, string, float, nullable, Decoder)
import Json.Encode
import Json.Decode.Pipeline as Pipe
import Request.Helpers exposing (apiUrll)
import Util exposing ((=>))


feedbackDecoder : Json.Decode.Decoder Feedback
feedbackDecoder =
    Pipe.decode Feedback
        |> Pipe.required "email" Json.Decode.string
        |> Pipe.required "institution" Json.Decode.string
        |> Pipe.required "created_at" Json.Decode.string
        |> Pipe.required "finished" Json.Decode.bool
        |> Pipe.required "description" Json.Decode.string



-- TODO Define Encoders and Decoders for custom types in its own module


feedbackEncoder : Feedback -> Json.Encode.Value
feedbackEncoder feedback =
    Json.Encode.object <|
        [ ( "email", Json.Encode.string feedback.email )
        , ( "institution", Json.Encode.string feedback.institution )
        ]


postFeedback : { r | institution : String, email : String } -> Http.Request Feedback
postFeedback { institution, email } =
    let
        feedback =
            Json.Encode.object
                [ "institution" => Json.Encode.string institution
                , "email" => Json.Encode.string email
                ]

        url =
            apiUrll ("/feedback")
    in
        Http.post url (Http.jsonBody (feedback)) feedbackDecoder
