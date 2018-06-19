module Request.Methodology exposing (methodologyRequest)

import Data.Methodology as Methodology exposing (Methodology)
import Http
import Request.Helpers exposing (apiUrl, apiUrll)


methodologyRequest : Http.Request Methodology
methodologyRequest =
    let
        url =
            apiUrll ("/methodologies/1")
    in
        Http.get url Methodology.decoder
