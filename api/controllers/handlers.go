package controllers

import (
	"encoding/json"
	"log"
	"net/http"
	"net/http/httputil"

	"github.com/kdchaires/selectormetodologias/api/models"
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

func (app *App) FeedbackCreateHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Getting JSON Data
	decoder := json.NewDecoder(r.Body)
	// TODO wont be clearer to use "var feedback models.Feedback"?
	feedback := models.Feedback{}

	err := decoder.Decode(&feedback)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	// Save to database
	err = app.Database.SaveFeedback(&feedback)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
	}

	json.NewEncoder(w).Encode(feedback)
}

// SuggestHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/sugerencia/coleccion-de-recomendacion/generar-una-recomendacion
func (app *App) SuggestHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode("Call OK!")
}

// TODO Move this to a utils/helpers package
func logRequest(request *http.Request) {
	// Debugging purpposes
	requestDump, err := httputil.DumpRequest(request, true)
	if err != nil {
		log.Println(err.Error())
	}

	log.Printf(string(requestDump))
}
