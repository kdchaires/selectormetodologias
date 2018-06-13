package controllers

import (
	"encoding/json"
	"net/http"
)

// TODO Use a helper to create a Json response type improving DRYness

// HealthCheckHandler generates a simple server response that can be used to
// check running status of the application.
func (app *App) HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode("Still alive!")
}

// QuestionsListHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/preguntas/coleccion-de-preguntas/listar-todas-las-preguntas
func (app *App) QuestionsListHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(app.Database.AllQuestions())
}

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
