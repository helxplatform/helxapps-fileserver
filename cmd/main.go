package main

import (
	"encoding/json"
	"log"
	"net/http"

	apps "github.com/helxplatform/helxappsFS/apps"
)

// This will be populated by Github Actions
// through makefile, via Dockerfile.
var embeddedBranch = "ordrd"

func main() {

	mux := http.NewServeMux()
	// Handler will listen on /helx-apps endpoint
	// serving embedded files from apps directory
	mux.Handle("/helx-apps/", http.StripPrefix("/helx-apps", http.FileServer(http.FS(apps.Content))))

	// Handler to validate liveness of server
	mux.HandleFunc("/liveness", func(w http.ResponseWriter, r *http.Request) {
		resp := map[string]string{
			"status":    "ok",
			"helx-apps": embeddedBranch,
		}

		w.Header().Set("Content-Type", "application/json")
		js, err := json.Marshal(resp)
		if err != nil {
			http.Error(w, "The server encountered and error", http.StatusInternalServerError)
		}
		w.Write(js)
	})

	// TODO: Add slog and graceful shutdown
	log.Println("Starting fileserver ... ")
	log.Fatal(http.ListenAndServe(":8323", mux))
	log.Println("Closing fileserver")
}
