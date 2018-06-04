package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/kdchaires/selectormetodologias/api/models"
)

// FeedbackCreateHandler generetes a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/feedback/coleccion-de-feedback/enviar-feedback
func (app *App) FeedbackCreateHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Getting JSON Data
	decoder := json.NewDecoder(r.Body)
	var feedback models.Feedback

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

	w.Header().Set("Location", r.URL.Path+"/"+feedback.Email)
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(feedback)
}
