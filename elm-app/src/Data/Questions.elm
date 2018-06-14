module Data.Questions exposing (Questions, questionListDecoder, encodeNewAnswers)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Data.Questions.Evaluation as Evaluation exposing (Evaluation)
import Data.Questions.Question as Question exposing (Question)


-- import Data.Suggest as Suggest exposing (Suggest)


type alias Questions =
    { index : Int
    , question : List Question
    , answers : List Evaluation

    -- , suggestion : Suggest
    , errorMessage : Maybe String
    }



-- SERIALIZATION --


encodeNewAnswers : List Evaluation -> Encode.Value
encodeNewAnswers listsAnswers =
    Encode.list (List.map encodeNewAnswer listsAnswers)



-- TODO Probablemente va en Data/Questions/Evaluation.elm?


encodeNewAnswer : Evaluation -> Encode.Value
encodeNewAnswer evaluation =
    let
        object =
            [ ( "question", Encode.string evaluation.idQuestion )
            , ( "value", Encode.int evaluation.value )
            ]
    in
        Encode.object object


questionListDecoder : Decoder (List Question)
questionListDecoder =
    Decode.list Question.decoder
