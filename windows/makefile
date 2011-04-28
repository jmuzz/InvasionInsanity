# Settings you need to set to compile
SFML_DIR = C:/devel/SFML-1.6

# You shouldn't need to change these
OBJ = o/insanity.o
BIN = Insanity.exe
CPP = g++.exe -g
INC = -I"$(SFML_DIR)\include"
LIB = $(SFML_DIR)/lib/libsfml-graphics.a $(SFML_DIR)/lib/libsfml-window.a $(SFML_DIR)/lib/libsfml-system.a

clean:
	rm -rf $(OBJ) $(BIN)

$(BIN): $(OBJ)
	$(CPP) $(OBJ) -o "$(BIN)" $(LIB)

o:
	mkdir o

o/%.o: src/%.cpp o
	$(CPP) -c $< -o $@ $(INC)
