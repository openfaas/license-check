package main

import (
	"flag"
	"fmt"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"strings"
)

var (
	verbose bool
	// GitCommit is the git commit SHA at build time
	GitCommit string
	// Version is the release version at build time
	Version string
)

func main() {
	var (
		filePath string
		version  bool
	)
	flag.StringVar(&filePath, "path", "", "path to scan for licensing")
	flag.BoolVar(&verbose, "verbose", false, "verbose output")
	flag.BoolVar(&version, "version", false, "Print version")
	flag.Parse()

	authorArgs := flag.Args()

	if version {
		fmt.Printf("Version: %s\tCommit: %s\n", Version, GitCommit)
		os.Exit(0)
	}

	if len(filePath) == 0 {
		fmt.Println("-path is required")
		os.Exit(1)
	}

	if len(authorArgs) == 0 {
		fmt.Println("Pass authors as arguments in quotes such as \"Author1\" \"Author 2\" ")
		os.Exit(1)
	}

	licenseAudit := func(path string) bool {

		if verbose {
			fmt.Printf("Checking %s for %s\n", path, authorArgs)
		}

		data, err := os.ReadFile(path)
		if err != nil {
			log.Printf("Error - %s", err)
			return false
		}

		return hasValidLicense(string(data), authorArgs)
	}

	violations, err := walk(filePath, licenseAudit, matchValidFile)

	if err != nil {
		fmt.Println(err)
		os.Exit(2)
	}

	if len(violations) > 0 {
		fmt.Fprintln(os.Stderr,
			`License compliance issue(s) found. See contributing guide, or contact a maintainer.`)
		for _, violation := range violations {
			fmt.Println(violation)
		}
		os.Exit(3)
	}
}

func hasValidLicense(fileData string, validAuthors []string) bool {
	// Found "// Copyright (c) "
	if !strings.HasPrefix(fileData, "// Copyright (c) ") {
		return true
	}

	for _, validAuthor := range validAuthors {
		if strings.HasPrefix(fileData, fmt.Sprintf("// Copyright (c) %s", validAuthor)) {
			return true
		}
	}

	return false
}

func walk(rootPath string, passLicenseAudit func(string) bool, matchValidFile func(string) bool) ([]string, error) {
	violations := []string{}

	err := filepath.WalkDir(rootPath, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if !d.IsDir() &&
			matchValidFile(path) &&
			!passLicenseAudit(path) {

			violations = append(violations, path)
		}

		return nil
	})

	return violations, err
}

func matchValidFile(path string) bool {
	// capture cases where the path is relative and doesn't start with a slash,
	// e.g. vendor/github.com/*
	abspath, err := filepath.Abs(path)
	if err != nil {
		abspath = path
	}

	return strings.HasSuffix(abspath, ".go") &&
		strings.Contains(abspath, "/vendor/") == false
}
