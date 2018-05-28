package controllers

import "github.com/kdchaires/selectormetodologias/api/models"

// App is a structure dedicated to hold shared references to other structures
// needed by multiple handlers in the application.
type App struct {
	Database models.Datastore
	// TODO Move this to a shared package?
	// TODO Add a reference to the logger?
}
