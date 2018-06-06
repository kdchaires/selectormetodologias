package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/kdchaires/selectormetodologias/api/utils"
)

// TODO Use a helper to create a Json response type improving DRYness

// HealthCheckHandler generates a simple server response that can be used to
// check running status of the application.
func (app *App) HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode("Still alive!")
}

// DebugRequestHandler helps to see how the request arrives to the Go side, it's
// meant to be used only in the development stage and it is safe to remove once
// app is in the production environment.
func (app *App) DebugRequestHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	utils.LogRequest(r)
	json.NewEncoder(w).Encode("Check the logs.")
}
