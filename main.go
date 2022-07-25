package main

import (
	"fmt"
	"log"
	"os"
	"os/signal"
	"runtime"
	"syscall"
)

var build string = "develop"

func main() {
	fmt.Println("Hello ardanlabs dkravets service", build)
	g := runtime.GOMAXPROCS(0)
	log.Printf("Starting ardan-service[%s] CPU[%d]", build, g)
	defer log.Println("shutdown complete")

	// Make a channel to listen for an interrupt or terminate signal from the OS.
	// Use a buffered channel because the signal package requires it.
	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
	<-shutdown

	log.Println("stoping ardan-service")

}
