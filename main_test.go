package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestFileMatch(t *testing.T) {

	cases := []struct {
		name  string
		path  string
		match bool
	}{
		{"go path matches", "teamserverlesss/foo/bar/utils.go", true},
		{"non-go path does not match", "teamserverlesss/foo/bar/utils.py", false},
		{"relative vendor path matches", "vendor/github.com/teamserverlesss/foo/bar/utils.go", false},
		{"absolute vendor path matches", "/vendor/github.com/teamserverlesss/foo/bar/utils.go", false},
		{"non-go path in vendor does not match", "/vendor/github.com/teamserverlesss/foo/bar/utils.yaml", false},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			isMatch := matchValidFile(tc.path)
			if isMatch != tc.match {
				t.Errorf("expected %v, got %v for %s", tc.match, isMatch, tc.path)
			}
		})
	}
}

func TestHasValidLicense(t *testing.T) {

	cases := []struct {
		name     string
		fileData string
		authors  []string
		want     bool
	}{
		{
			name:     "valid author matches",
			fileData: "// Copyright (c) Alex Ellis 2017. All rights reserved.\n\npackage main",
			authors:  []string{"Alex Ellis", "OpenFaaS Author(s)"},
			want:     true,
		},
		{
			name:     "unrecognised author does not match",
			fileData: "// Copyright (c) Jane Doe 2020. All rights reserved.\n\npackage main",
			authors:  []string{"Alex Ellis", "OpenFaaS Author(s)"},
			want:     false,
		},
		{
			name:     "prefix must not bleed into longer names",
			fileData: "// Copyright (c) Alex Daniel Ellis 2017. All rights reserved.\n\npackage main",
			authors:  []string{"Alex Ellis"},
			want:     false,
		},
		{
			name:     "file without copyright header is valid",
			fileData: "package main\n\nfunc main() {}",
			authors:  []string{"Alex Ellis"},
			want:     true,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := hasValidLicense(tc.fileData, tc.authors)
			if got != tc.want {
				t.Errorf("expected %v, got %v", tc.want, got)
			}
		})
	}
}

func TestWalkFlagsViolations(t *testing.T) {

	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "good.go"), []byte("// Copyright (c) Alex Ellis 2017. All rights reserved.\n\npackage main"), 0600); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "bad.go"), []byte("// Copyright (c) Jane Doe 2020. All rights reserved.\n\npackage main"), 0600); err != nil {
		t.Fatal(err)
	}

	violations, err := walk(dir, func(path string) bool {
		data, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("failed to read %s: %s", path, err)
		}
		return hasValidLicense(string(data), []string{"Alex Ellis"})
	}, matchValidFile)

	if err != nil {
		t.Fatalf("expected no error, got %s", err)
	}

	if len(violations) != 1 {
		t.Fatalf("expected 1 violation, got %d: %v", len(violations), violations)
	}

	if got, want := violations[0], filepath.Join(dir, "bad.go"); got != want {
		t.Errorf("expected violation %q, got %q", want, got)
	}
}
