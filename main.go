package main

import (
	"fmt"
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
	log.Printf("Run GO HTTP MOCK server, instance: %s\n", instance)

	r := mux.NewRouter()
	r.PathPrefix("/").HandlerFunc(theHandleFunc).Methods("GET", "POST", "PUT", "CONNECT", "PATCH", "DELETE", "HEAD", "OPTIONS", "TRACE")
	http.Handle("/", r)

	log.Fatal(http.ListenAndServe(":80", nil))
}

func theHandleFunc(w http.ResponseWriter, r *http.Request) {
	currentTime := time.Now()
	response := fmt.Sprintf(
		"GO HTTP MOCK\nhttp://github.com/mmalessa/go-http-mock\n\nServer instance: %s\nServer time: %s\nHost: %s\nMethod: %s\nPath: %s\n",
		instance,
		currentTime.Format("2006-01-02 15:04:05-07:00"),
		r.Host,
		r.Method,
		r.URL.Path,
	)
	w.Header().Add("Content-Type", "text/plain")
	io.WriteString(w, response)
	log.Printf("Got request: %s", r.URL.Path)
}
