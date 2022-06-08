package main

import "net/http"

func main() {
	http.HandleFunc("/", func(rw http.ResponseWriter, r *http.Request) {
		rw.Write([]byte("OK"))
	})

	http.ListenAndServe(":3000", nil)
}
