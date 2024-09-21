# Toolchain
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
FLAGS = -mthumb

NAME = MoreTracks
# File names
SRC = $(NAME).s
OBJ = $(NAME).o
ELF = $(NAME).elf
BIN = $(NAME).bin
LINKER_SCRIPT = linker.ld

# Default target
all: $(BIN)

# Assemble the source file into an object file
$(OBJ): $(SRC)
	$(AS) $(FLAGS) -o $@ $<

# Link the object file into an ELF using a linker script
$(ELF): $(OBJ) $(LINKER_SCRIPT)
	$(LD) -T $(LINKER_SCRIPT) -o $@ $<
	rm -f $(OBJ)

# Extract binary from ELF
$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
	rm -f $(ELF)

# Clean up generated files
clean:
	rm -f $(OBJ) $(ELF) $(BIN)

# Phony targets to prevent conflicts with files named 'clean' or 'all'
.PHONY: clean all