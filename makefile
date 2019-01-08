#A simple make file.
#Use "make" just to create the rom, or use "make debug" to create symbol files.
#To clean the directories of the ROM, object files, and everything make made, use "make clean".

CC = rgbasm
CFLAGS = -i ./src/
LINK = rgblink
LINKFLAGS = -d
FIX = rgbfix
FFLAGS = -v -p 0
OUTPUT_NAME=shepard

SOURCES=./src/interrupts.asm\
		./src/globals.asm\
		./src/defines.asm\
		./src/main.asm\
		./src/controller.asm\
		./src/math.asm\
		./src/gfx_assets.asm\
		./src/ai.asm
OBJECTS=$(SOURCES:.asm=.o)



shepard: $(OBJECTS)
	@echo "Linking object files into image..."
	@$(LINK) $(LINKFLAGS) -o $(OUTPUT_NAME).gb $(OBJECTS)
	@echo "Tidying up image..."
	@$(FIX) $(FFLAGS) $(OUTPUT_NAME).gb
	@echo "ROM assembly complete."

debug:	$(OBJECTS)
	@echo "Linking object files into image..."
	@echo "Creating symbol and map files for debugging..."
	@$(LINK) $(LINKFLAGS) -m $(OUTPUT_NAME).map -n $(OUTPUT_NAME).sym -o $(OUTPUT_NAME).gb $(OBJECTS)
	@echo "Tidying up image..."
	@$(FIX) $(FFLAGS) $(OUTPUT_NAME).gb
	@echo "ROM assembly complete."


%.o: %.asm
	@echo "Making " $(@)
	@$(CC) $(CFLAGS) -o $(@) $(@:.o=.asm)

clean:
	-@rm $(OBJECTS) ./$(OUTPUT_NAME).* 2> /dev/null || true
	@echo "Directory cleaned."
