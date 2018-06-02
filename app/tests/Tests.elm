module Tests exposing (..)

-- TODO Later organize tests in different modules

import Test exposing (..)
import Expect
import String
import Main
import SampleResponses as Sample
import Json.Decode


all : Test
all =
    describe "Questions decoders"
        [ test "Correctly decodes a Question" <|
            \() ->
                let
                    question =
                        Main.Questions "1" "Es el presupuesto para el proyecto limitado?" "Dimensión del proyecto"

                    decodedQuestion =
                        Sample.questionResponse
                            |> Json.Decode.decodeString Main.questionDecoder
                in
                    Expect.equal decodedQuestion (Ok question)
        , test "Correctly decodes a List of Question" <|
            \() ->
                let
                    questions =
                        [ Main.Questions "1" "Es el presupuesto para el proyecto limitado?" "Dimensión del proyecto" ]

                    decodedQuestions =
                        Sample.questionsResponse
                            |> Json.Decode.decodeString Main.questionListDecoder
                in
                    Expect.equal decodedQuestions (Ok questions)
        ]
