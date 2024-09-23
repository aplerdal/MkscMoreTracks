# Project name
PROJECT = MoreTracks

# Input and output files
ROM = $(PROJECT).gba
ASM_FILES = $(PROJECT).s
PATCHED_ROM = $(PROJECT).gba

# ARMIPS executable path
ARMIPS = ./armips

# Default rule to assemble the project
all: $(PATCHED_ROM)

# Rule to create the patched ROM using armips
$(PATCHED_ROM): $(ASM_FILES)
	$(ARMIPS) $(ASM_FILES) -temp $(PROJECT).txt

# Clean up generated files
clean:
	rm -f $(PATCHED_ROM)

# PHONY targets are not actual files
.PHONY: all clean