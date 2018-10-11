package main

import (
	"net/http"

	"log"
	"os"

	"github.com/brendandburns/topz/pkg/topz"
)

func main() {
	http.HandleFunc("/topz", topz.HandleTopz)
	bindHttp := os.Getenv("TOPZ_BIND")
	if bindHttp == "" {
		bindHttp = "localhost:8080"
		log.Printf("environment variable TOPZ_BIND not set using default: %v\n", bindHttp)
	}
	log.Printf("Starting ... : %v\n", bindHttp)
	log.Fatal(http.ListenAndServe(bindHttp, nil))
}
