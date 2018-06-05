package controllers

import (
	"encoding/json"
	"net/http"
)

// QuestionsListHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/preguntas/coleccion-de-preguntas/listar-todas-las-preguntas
func (app *App) QuestionsListHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	questions, err := app.Database.AllQuestions()

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	json.NewEncoder(w).Encode(questions)
}
