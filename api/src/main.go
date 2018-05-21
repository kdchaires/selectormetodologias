package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
)

func healthCheck(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode("Still alive!")
}

func questionsList(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode(QuestionsList())
}

func main() {
	var router = mux.NewRouter()
	router.HandleFunc("/healthcheck", healthCheck).Methods("GET")
	router.HandleFunc("/questions", questionsList).Methods("GET")

	headersOk := handlers.AllowedHeaders([]string{"Authorization"})
	originsOk := handlers.AllowedOrigins([]string{"*"})
	methodsOk := handlers.AllowedMethods([]string{"GET", "POST", "OPTIONS"})
	middlewareCORS := handlers.CORS(originsOk, headersOk, methodsOk)

	fmt.Println("Running server!")
	log.Fatal(http.ListenAndServe(":3000", middlewareCORS(router)))
}
