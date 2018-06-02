package models

import (
	"errors"
	"fmt"
	"net"
	"net/smtp"
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"
)

type Feedback struct {
	Email       string    `json:"email" bson:"_id"`
	CreatedAt   time.Time `json:"created_at" bson:"created_at"`
	Institution string    `json:"institution"`
	Finished    bool      `json:"finished"`
	Description string    `json:"description"`
}

func (db *DB) SaveFeedback(feedback *Feedback) error {
	// Data validation
	feedback.CreatedAt = time.Now()
	feedback.Institution = strings.TrimSpace(feedback.Institution)

	// Clean and validate email address format
	email, err := cleanAndValidateEmail(feedback.Email)
	if err != nil {
		return err
	}
	feedback.Email = email

	// TODO What if email exists in database? should update entry?

	// Save to database
	c := db.C("feedbacks")
	return c.Insert(feedback)
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
		if env == "production" {
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
