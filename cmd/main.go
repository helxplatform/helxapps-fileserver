package main

import (
	"fmt"
	"log"
	"net/http"

	apps "github.com/helxplatform/helxapps-fileserver/apps"
)

func main() {
	mux := http.NewServeMux()
	// Handler will listen on /helx-apps endpoint
	// serving embedded files from apps directory
	mux.Handle("/helx-apps/", http.StripPrefix("/helx-apps", http.FileServer(http.FS(apps.Content))))

	// Handler to validate liveness of server
	mux.HandleFunc("/liveness", func(w http.ResponseWriter, r *http.Request) {
		// TODO: format Json Response
		fmt.Fprint(w, "<h1> Alive </h1>")
	})

	// TODO: Add slog and graceful shutdown
	log.Println("Starting fileserver ... ")
	log.Fatal(http.ListenAndServe(":8323", mux))
	log.Println("Closing fileserver")
}
