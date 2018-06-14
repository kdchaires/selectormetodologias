package controllers

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/kdchaires/selectormetodologias/api/models"
)

// MethodologiesListHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/metodologias/coleccion-de-metodologias/listar-todas-las-metodologias
func (app *App) MethodologiesListHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	methodologies, err := app.Database.AllMethodologies()

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	// Loop retrieved methodologies to add "links" attribute to each of them
	for _, methodology := range methodologies {
		link := &models.Hateoas{
			Href: "methodologies/" + strconv.Itoa(methodology.ID),
			Rel:  "self",
			Type: "GET",
		}

		methodology.Links = []*models.Hateoas{link}
	}

	// TODO Avoid creating new json encoders?
	json.NewEncoder(w).Encode(methodologies)
}

// MethodologyHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/metodologias/metodologia/consultar-detalles-de-una-metodologia
func (app *App) MethodologyHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.Header().Set("Content-Type", "application/json")

	methodology, err := app.Database.Methodology(vars["methodology_id"])

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	// TODO Avoid creating new json encoders?
	json.NewEncoder(w).Encode(methodology)
}
