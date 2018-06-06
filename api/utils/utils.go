package utils

import (
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
)

// LogRequest receives a HTTP Request and dumps the contents of the given
// request to the log. Is useful for debuging purposes to see what comes
// in the request.
func LogRequest(request *http.Request) {
	// Debugging purpposes
	requestDump, err := httputil.DumpRequest(request, true)
	if err != nil {
		log.Println(err.Error())
	}

	log.Printf(string(requestDump))
}

// CleanAndValidateEmail takes an email address, removes white spaces characters
// that it may have and check it is a valid formated address. If the enviroment
// variable STRICT_EMAIL_VERIFICATION is set to true then it will also validate
// that the given address exists.
func CleanAndValidateEmail(address string) (string, error) {
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
