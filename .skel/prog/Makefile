
CC       = g++
INCLUDES = 
DEBUG    =
CFLAGS   = $(INCLUDES) -Wall -Wsign-compare
LIBS     = 

EXE      = 
CPP      = main.cpp
OBJS     = $(CPP:.cpp=.o)



all: $(EXE)

# link
$(EXE): $(OBJS)
	$(CC) $(DEBUG) -o $(EXE) $(OBJS) $(LIBS)

# compile
.cpp.o:
	$(CC) $(DEBUG) $(CFLAGS) -c $< -o $@

depend:
	\makedepend -- $(CFLAGS) -- $(CPP)

clean:
	\rm -f $(OBJS) $(EXE)
