package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/globalsign/mgo"
	"github.com/globalsign/mgo/bson"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
)

func HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode("Still alive!")
}

func DatabaseCheckHandler(w http.ResponseWriter, r *http.Request) {
	session, err := mgo.Dial("localhost:27017")

	if err != nil {
		log.Fatal(err)
	}

	var q Question

	// modify structure to take the mongo ID and remove the published at
	c := session.DB("selector_metodologias").C("questions")
	oerr := c.Find(bson.M{}).One(&q)

	if oerr != nil {
		log.Fatal(oerr)
	}

	json.NewEncoder(w).Encode(q)
}

func QuestionsListHandler(w http.ResponseWriter, r *http.Request) {
	session, err := mgo.Dial("localhost:27017")

	if err != nil {
		json.NewEncoder(w).Encode("Can't connect to the database, check connection setting")
		return
	}

	var questions []Question
	// TODO Read DB settings from environment
	c := session.DB("selector_metodologias").C("questions")
	oerr := c.Find(bson.M{}).All(&questions)

	if oerr != nil {
		log.Fatal("Can't read from database, check permissions and resource names")
		return
	}

	json.NewEncoder(w).Encode(questions)
}

func main() {
	var router = mux.NewRouter()
	router.HandleFunc("/healthcheck", HealthCheckHandler).Methods("GET")
	router.HandleFunc("/questions", QuestionsListHandler).Methods("GET")
	router.HandleFunc("/dbcheck", DatabaseCheckHandler).Methods("GET")

	headersOk := handlers.AllowedHeaders([]string{"Authorization"})
	originsOk := handlers.AllowedOrigins([]string{"*"})
	methodsOk := handlers.AllowedMethods([]string{"GET", "POST", "OPTIONS"})
	middlewareCORS := handlers.CORS(originsOk, headersOk, methodsOk)

	fmt.Println("Running server!")
	// TODO Read bind address and port from environment
	log.Fatal(http.ListenAndServe(":8000", middlewareCORS(router)))
}
