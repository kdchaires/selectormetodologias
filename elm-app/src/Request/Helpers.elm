module Request.Helpers exposing (apiUrl, apiUrll)


apiUrl : String -> String
apiUrl str =
    "https://conduit.productionready.io/api" ++ str


apiUrll : String -> String
apiUrll str =
    "http://localhost:3000" ++ str
