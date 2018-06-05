package test

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/kdchaires/selectormetodologias/api/controllers"
)

// Take this as a sample test
func TestHealthCheckHandler(t *testing.T) {
	rresponse := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/healthcheck", nil)
	req.Header.Set("Content-Type", "application/json")

	app := &controllers.App{Database: &mockDB{}}
	http.HandlerFunc(app.HealthCheckHandler).ServeHTTP(rresponse, req)

	var expected = "\"Still alive!\"\n"
	var obtained = rresponse.Body.String()

	if expected != obtained {
		t.Errorf(
			"\n...expected = %#v\n...obtained = %#v",
			expected,
			obtained)
	}
}

func TestQuestionsListHandler(t *testing.T) {
	rresponse := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/healthcheck", nil)
	req.Header.Set("Content-Type", "application/json")

	app := &controllers.App{Database: &mockDB{}}
	http.HandlerFunc(app.QuestionsListHandler).ServeHTTP(rresponse, req)

	// TODO Extract marshaling to a helper
	questions, _ := app.Database.AllQuestions()
	contents, err := json.Marshal(questions)
	if err != nil {
		t.Fatal("While marshaling sample data: " + err.Error())
	}

	var expected = string(contents) + "\n"
	var obtained = rresponse.Body.String()

	if expected != obtained {
		t.Errorf(
			"\n...expected = %#v\n...obtained = %#v",
			expected,
			obtained)
	}
}

func TestSuggestHandler(t *testing.T) {
	rresponse := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/suggest", nil)
	req.Header.Set("Content-Type", "application/json")

	app := &controllers.App{Database: &mockDB{}}
	http.HandlerFunc(app.SuggestHandler).ServeHTTP(rresponse, req)

	// Test response body
	var expectedBody = "\"Call OK!\"\n"
	var obtainedBody = rresponse.Body.String()

	if expectedBody != obtainedBody {
		t.Errorf(
			"\n...expectedBody = %#v\n...obtainedBody = %#v",
			expectedBody,
			obtainedBody)
	}

	// Test response code
	var expectedCode = http.StatusOK
	var obtainedCode = rresponse.Code

	if expectedCode != obtainedCode {
		t.Errorf(
			"\n...expectedCode = %#v\n...obtainedCode = %#v",
			expectedCode,
			obtainedCode)
	}

	// Test response headers
	var expectedContentType = "application/json"
	var obtainedContentType = rresponse.Header().Get("Content-Type")

	if expectedContentType != obtainedContentType {
		t.Errorf(
			"\n...expectedContentType = %#v\n...obtainedContentType = %#v",
			expectedContentType,
			obtainedContentType)
	}
}

// Only sends "institution" and "email"
func TestFeedbackCreateHandlerIncomplete(t *testing.T) {
	rresponse := httptest.NewRecorder()

	body := strings.NewReader(loadFixture(t, "feedback/incomplete.json"))
	req, _ := http.NewRequest("POST", "/feedback", body)
	req.Header.Set("Content-Type", "application/json")

	app := &controllers.App{Database: &mockDB{}}
	http.HandlerFunc(app.FeedbackCreateHandler).ServeHTTP(rresponse, req)

	// Test response code
	var expectedCode = http.StatusCreated
	var obtainedCode = rresponse.Code

	if expectedCode != obtainedCode {
		t.Errorf(
			"\n...expectedCode = %#v\n...obtainedCode = %#v",
			expectedCode,
			obtainedCode)
	}

	// Test response headers
	var expectedContentType = "application/json"
	var obtainedContentType = rresponse.Header().Get("Content-Type")

	if expectedContentType != obtainedContentType {
		t.Errorf(
			"\n...expectedContentType = %#v\n...obtainedContentType = %#v",
			expectedContentType,
			obtainedContentType)
	}

	var expectedLocation = "/feedback/some@example.com"
	var obtainedLocation = rresponse.Header().Get("Location")

	if expectedLocation != obtainedLocation {
		t.Errorf(
			"\n...expectedLocation = %#v\n...obtainedLocation = %#v",
			expectedLocation,
			obtainedLocation)
	}

	// Test response body
	var expectedBody = loadFixture(t, "feedback/allfields.json")
	var obtainedBody = rresponse.Body.String()

	if expectedBody != obtainedBody {
		t.Errorf(
			"\n...expectedBody = %#v\n...obtainedBody = %#v",
			expectedBody,
			obtainedBody)
	}
}

func TestFeedbackCreateHandler(t *testing.T) {
	rresponse := httptest.NewRecorder()

	body := strings.NewReader(loadFixture(t, "feedback/complete.json"))
	req, _ := http.NewRequest("POST", "/feedback", body)
	req.Header.Set("Content-Type", "application/json")

	app := &controllers.App{Database: &mockDB{}}
	http.HandlerFunc(app.FeedbackCreateHandler).ServeHTTP(rresponse, req)

	// Test response code

	// Test response headers

	// Test response body
	var expectedBody = loadFixture(t, "feedback/complete.json")
	var obtainedBody = rresponse.Body.String()

	if expectedBody != obtainedBody {
		t.Errorf(
			"\n...expectedBody = %#v\n...obtainedBody = %#v",
			expectedBody,
			obtainedBody)
	}
}
