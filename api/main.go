package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"

	"github.com/kdchaires/selectormetodologias/api/controllers"
	"github.com/kdchaires/selectormetodologias/api/models"
)

func main() {
	// TODO Centralize access to os env to allow defaults and ease maintenance
	// Load settings file
	err := godotenv.Load()
	if err != nil {
		log.Println("*** Unable to load settings file ***")
		log.Fatal(err)
	}

	// Initialize database
	// TODO When DB server is unavailable print message instead of hanging
	database, err := models.NewDBConnection(os.Getenv("MONGODB_NAME"))
	if err != nil {
		log.Panic(err)
	}
	defer database.Session.Close()

	app := &controllers.App{Database: database}

	// Router initialization
	var router = mux.NewRouter()
	// TODO Would be better if handlers' name align to ActionResourceHandler
	// TODO Move this to a routes file?
	router.HandleFunc("/healthcheck", app.HealthCheckHandler).Methods("GET")
	router.HandleFunc("/questions", app.QuestionsListHandler).Methods("GET")
	router.HandleFunc("/suggest", app.SuggestHandler).Methods("POST")
	router.HandleFunc("/feedback", app.FeedbackCreateHandler).Methods("POST")
	router.HandleFunc("/methodologies", app.MethodologiesListHandler).Methods("GET")
	router.HandleFunc("/methodologies/{methodology_id}", app.MethodologyHandler).Methods("GET")

	headersOk := handlers.AllowedHeaders([]string{"Content-Type"})
	originsOk := handlers.AllowedOrigins([]string{"*"})
	methodsOk := handlers.AllowedMethods([]string{"GET", "POST", "OPTIONS"})
	middlewareCORS := handlers.CORS(originsOk, headersOk, methodsOk)

	severAddress := os.Getenv("APP_BIND_ADDRESS")
	severPort := os.Getenv("APP_BIND_PORT")
	log.Println("Starting application...")
	log.Printf("Listening on http://%s:%s/\n", severAddress, severPort)

	// Start application server
	log.Fatal(http.ListenAndServe(
		severAddress+":"+severPort,
		middlewareCORS(router)))
}
