package controllers

import (
	"encoding/json"
	"net/http"
)

// QuestionsListHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/preguntas/coleccion-de-preguntas/listar-todas-las-preguntas
func (app *App) QuestionsListHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(app.Database.AllQuestions())
}
