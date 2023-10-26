package main

import (
	"fmt"
	"strings"
	"io"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
)

var instance string = "default"

func main() {
	if len(os.Args) == 2 {
		instance = os.Args[1]
	}
	log.Printf("Run GO DUMMY SERVER, instance: %s\n", instance)

	r := mux.NewRouter()
	r.PathPrefix("/").HandlerFunc(theHandleFunc).Methods("GET", "POST", "PUT", "CONNECT", "PATCH", "DELETE", "HEAD", "OPTIONS", "TRACE")
	http.Handle("/", r)

	log.Fatal(http.ListenAndServe(":80", nil))
}

func theHandleFunc(w http.ResponseWriter, r *http.Request) {
	currentTime := time.Now()
	response := fmt.Sprintf(
`GO DUMMY HTTP
http://github.com/mmalessa/go-dummy-http

Server instance: %s
    Server time: %s
           Host: %s
         Method: %s
           Path: %s
        Headers:
%s
`,
		instance,
		currentTime.Format("2006-01-02 15:04:05-07:00"),
		r.Host,
		r.Method,
		r.URL.Path,
		prettyHeader(r.Header),
	)
	w.Header().Add("Content-Type", "text/plain")
	io.WriteString(w, response)
	log.Printf("Got request: %s", r.URL.Path)
}

func prettyHeader(header http.Header) string {
	ret := ""
	maxLength := maxHeaderNameLength(header)
	for name, values := range header {
		ret = ret + fmt.Sprintf("  %*s: %s\n", maxLength, name, strings.Join(values, ", "))
	}
	return ret
}

func maxHeaderNameLength(header http.Header) int {
	m := 0
	for name, _ := range header {
		l := len(name)
		if m < l {
			m = l
		}
	}
	return m
}