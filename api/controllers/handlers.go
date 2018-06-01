package controllers

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net"
	"net/http"
	"net/http/httputil"
	"net/smtp"
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"

	"github.com/kdchaires/selectormetodologias/api/models"
)

// TODO Use a helper to create a Json response type improving DRYness

// HealthCheckHandler generates a simple server response that can be used to
// check running status of the application.
func (app *App) HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode("Still alive!")
}

// QuestionsListHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/preguntas/coleccion-de-preguntas/listar-todas-las-preguntas
func (app *App) QuestionsListHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(app.Database.AllQuestions())
}

func (app *App) FeedbackCreateHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Getting JSON Data
	decoder := json.NewDecoder(r.Body)
	feedback := models.Feedback{}
	err := decoder.Decode(&feedback)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	feedback.CreatedAt = time.Now()
	feedback.Institution = strings.TrimSpace(feedback.Institution)

	// Clean and validate email address format
	feedback.Email, err = cleanAndValidateEmail(feedback.Email)
	if err != nil {
		w.WriteHeader(http.StatusUnprocessableEntity)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	// TODO What if email exists in database? should update entry?

	// Save to database
	err = app.Database.SaveFeedback(&feedback)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
	}

	json.NewEncoder(w).Encode(feedback)
}

// SuggestHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/sugerencia/coleccion-de-recomendacion/generar-una-recomendacion
func (app *App) SuggestHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode("Call OK!")
}

// TODO Move this to a utils/helpers package
func logRequest(request *http.Request) {
	// Debugging purpposes
	requestDump, err := httputil.DumpRequest(request, true)
	if err != nil {
		log.Println(err.Error())
	}

	log.Printf(string(requestDump))
}

// TODO Move this to a utils/helpers package
func cleanAndValidateEmail(address string) (string, error) {
	email := strings.TrimSpace(address)   // Trim extra spaces
	email = strings.TrimRight(email, ".") // Trim extra dot in hostname.
	email = strings.ToLower(email)        // Lowercase

	if len(email) < 6 || len(email) > 254 {
		return address, errors.New("Invalid format")
	}

	at := strings.LastIndex(email, "@")
	if at <= 0 || at > len(email)-3 {
		return address, errors.New("Invalid format")
	}

	user := email[:at]
	host := email[at+1:]

	if len(user) > 64 {
		return address, errors.New("Invalid format")
	}

	// As per RFC 5332 secion 3.2.3: https://tools.ietf.org/html/rfc5322#section-3.2.3
	// Dots not allowed at beginning, end or occurances > 1 in the email address
	userDotRegexp := regexp.MustCompile("(^[.]{1})|([.]{1}$)|([.]{2,})")
	userRegexp := regexp.MustCompile("^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~.-]+$")
	hostRegexp := regexp.MustCompile("^[^\\s]+\\.[^\\s]+$")

	if userDotRegexp.MatchString(user) ||
		!userRegexp.MatchString(user) ||
		!hostRegexp.MatchString(host) {
		return address, errors.New("Invalid format")
	}

	switch host {
	case "localhost", "example.com":
		env := os.Getenv("APP_ENV")
		if env != "production" {
			return address, errors.New("Invalid host")
		}

		return email, nil
	}

	strict, _ := strconv.ParseBool(os.Getenv("STRICT_EMAIL_VERIFICATION"))
	if strict {
		err := validateEmailHost(user, host)
		if err != nil {
			return address, err
		}
	}

	return email, nil
}

// TODO Move this to a utils/helpers package
func validateEmailHost(user, host string) error {
	mx, err := net.LookupMX(host)
	if err != nil {
		return errors.New("Unresolvable email addresss: " + err.Error())
	}

	client, err := smtp.Dial(fmt.Sprintf("%s:%d", mx[0].Host, 25))
	defer client.Close()
	if err != nil {
		return errors.New("Unresolvable email addresss: " + err.Error())
	}

	t := time.AfterFunc(time.Second*10, func() { client.Close() })
	defer t.Stop()

	err = client.Hello("cimat.mx")
	if err != nil {
		return errors.New("Unresolvable email addresss: " + err.Error())
	}

	err = client.Mail("ayuda@cimat.mx")
	if err != nil {
		return errors.New("Unresolvable email addresss: " + err.Error())
	}

	err = client.Rcpt(user + "@" + host)
	if err != nil {
		return errors.New("Unresolvable email addresss: " + err.Error())
	}

	return nil
}
