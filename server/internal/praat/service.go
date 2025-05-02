package praat

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

type Service struct {
	praatPath string
	scriptDir string
}

func NewService(praatPath, scriptDir string) *Service {
	return &Service{
		praatPath: praatPath,
		scriptDir: scriptDir,
	}
}

func (s *Service) AnalyzePitch(audioPath string) ([]float32, error) {
	// Ensure the script exists
	wavPath := audioPath // We now expect the input to already be WAV format
	scriptPath := filepath.Join(s.scriptDir, "get_pitches.praat")
	if _, err := os.Stat(scriptPath); os.IsNotExist(err) {
		return nil, fmt.Errorf("praat script not found at %s", scriptPath)
	}

	cmd := exec.Command(s.praatPath, "--run", scriptPath, wavPath)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	if err := cmd.Run(); err != nil {
		return nil, fmt.Errorf("praat execution failed: %v, stderr: %s", err, stderr.String())
	}

	// Parse the output
	lines := strings.Split(strings.TrimSpace(stdout.String()), "\n")
	var pitches []float32
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		val, err := strconv.ParseFloat(line, 32)
		if err != nil {
			return nil, fmt.Errorf("failed to parse pitch value '%s': %v", line, err)
		}
		pitches = append(pitches, float32(val))
	}
	return pitches, nil
}
