# Compiler
FC = gfortran

# Compiler flags (Debug)
FFLAGS = -Wall -Wextra -fsanitize=leak -fcheck=all -g -O0

# Include path for C headers
C_INCLUDE = -I/path/to/external/SZ3library/include

# External libraries (if any)
LIBS = -L/path/to/external/SZ3library/lib -lSZ3c

# Runtime library search path
RPATH = -Wl,-rpath=/path/to/external/SZ3library/lib

# Module and test program names
MODULE = fsz3
TEST_PROGRAM = test_fsz3

# Source files
MODULE_SRC = $(MODULE).f90
TEST_PROGRAM_SRC = $(TEST_PROGRAM).f90

# Object files
MODULE_OBJ = $(MODULE).o

# Targets
all: $(TEST_PROGRAM)

$(MODULE_OBJ): $(MODULE_SRC)
	$(FC) $(FFLAGS) $(C_INCLUDE) -c $< -o $@

$(TEST_PROGRAM): $(TEST_PROGRAM_SRC) $(MODULE_OBJ)
	$(FC) $(FFLAGS) $^ -o $@ $(LIBS) $(RPATH)

clean:
	rm -f *.o *.mod $(TEST_PROGRAM)