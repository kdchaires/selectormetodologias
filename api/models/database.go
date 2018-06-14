package models

import (
	"errors"
	"fmt"
	"log"
	"os"
	"strconv"

	"github.com/globalsign/mgo"
)

// Datastore is the interface that should be implemented by any other structure
// wanting to be used as database access layer. It's defined because simplifies
// testing of handlers that access the database.
type Datastore interface {
	AllQuestions() ([]*Question, error)
	SaveFeedback(*Feedback) error
	AllMethodologies() ([]*SimplifiedMethodology, error)
	Methodology(id string) ([]*Methodology, error)
}

// DB wraps a reference to the database cursor. It is expected for this struct
// to implement the interface Datastore. It's defined because simplifies testing
// of handlers that acess the database.
type DB struct {
	*mgo.Database
}

// NewDBConnection starts a new session with the database, it access environment
// variables to know which host and port to dial to. It's intended to be called
// once in the bootsraping process unless dedicated extra connections are
// required later on.
// TODO Move to a more general file/package?
func NewDBConnection(databaseName string) (*DB, error) {
	var dbName = os.Getenv("MONGODB_NAME")
	var mongoURL = os.Getenv("MONGODB_HOST") + ":" + os.Getenv("MONGODB_PORT")

	authEnabled, _ := strconv.ParseBool(os.Getenv("MONGODB_AUTH_ENABLED"))
	if authEnabled {
		dbUsername := os.Getenv("MONGODB_USERNAME")
		dbPassword := os.Getenv("MONGODB_PASSWORD")

		// When using authentication, the dial format is different
		// See: https://godoc.org/github.com/globalsign/mgo#Dial
		mongoURL = fmt.Sprintf(
			"mongodb://%s:%s@%s/%s",
			dbUsername,
			dbPassword,
			mongoURL,
			dbName)
	} else {
		// If in production then we must not allow usage of unsecured database
		if os.Getenv("APP_ENV") == "production" {
			log.Println("*** Refusing to run in production without DB Authentication ***")
			log.Println("See Go project's README.md for more information.")
			return nil, errors.New("Should set MONGODB_AUTH_ENABLED=true in .env file")
		}
	}

	session, err := mgo.Dial(mongoURL)

	if err != nil {
		log.Println("*** Unable to connect to the database server ***")
		return nil, err
	}

	if err = session.Ping(); err != nil {
		log.Println("*** Connected to database, but can't ping it ***")
		return nil, err
	}

	return &DB{session.DB(dbName)}, nil
}
