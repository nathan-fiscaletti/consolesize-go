package main

import (
	"os"

	"github.com/nathan-fiscaletti/consolesize-go"
)

func main() {
	cols, rows := consolesize.GetConsoleSize()
	// Keep the syscall on the critical path (avoid dead-code elimination of the import).
	os.Exit((cols + rows) & 0xff)
}
