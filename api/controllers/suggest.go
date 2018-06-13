package controllers

import (
	"encoding/json"
	"net/http"
)

// SuggestHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/sugerencia/coleccion-de-recomendacion/generar-una-recomendacion
func (app *App) SuggestHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var fakeResponse = `
{
    "name": "Scrum",
    "score" 23,
    "links": [
        {
            "href": "methodologies/223",
            "rel": "methodologies",
            "type": "GET"
        }
    ]
}
`
	json.NewEncoder(w).Encode(fakeResponse)
}
