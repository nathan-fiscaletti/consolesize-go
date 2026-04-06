package main

import (
	"os"

	"golang.org/x/term"
)

func main() {
	w, h, err := term.GetSize(int(os.Stdout.Fd()))
	if err != nil {
		os.Exit(1)
	}
	os.Exit((w + h) & 0xff)
}
