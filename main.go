package main

import (
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
)

var build string = "develop"

func main() {
	fmt.Println("Hello ardanlabs serivice", build)
	log.Println("starting ardan-service", "version", build)
	defer log.Println("shutdown complete")

	// Make a channel to listen for an interrupt or terminate signal from the OS.
	// Use a buffered channel because the signal package requires it.
	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
	<-shutdown

	log.Println("stoping ardan-service")

}
