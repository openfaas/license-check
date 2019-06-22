package main

import (
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
