package apps

import (
	"embed"
)

//go:embed helx-apps/*
var Content embed.FS

// This file ensures /helx-apps folder and all
// subdirectories are embedded within the go binary.
