module Data.Questions exposing (Questions, questionListDecoder)

import Json.Decode as Decode exposing (Decoder)
import Data.Questions.Evaluation as Evaluation exposing (Evaluation)
import Data.Questions.Question as Question exposing (Question)


type alias Questions =
    { index : Int
    , question : List Question
    , answers : List Evaluation
    , score : String
    , errorMessage : Maybe String
    }



-- SERIALIZATION --


questionListDecoder : Decoder (List Question)
questionListDecoder =
    Decode.list Question.decoder
