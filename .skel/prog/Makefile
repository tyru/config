.PHONY: all depend clean

CC       = g++
INCLUDES = -g
CFLAGS   = $(INCLUDES) -Wall -Wsign-compare
LIBS     = 

EXE      = 
CPP      = Main.cpp
OBJS     = $(CPP:.cpp=.o)



all: $(EXE)

# link
$(EXE): $(OBJS)
	$(CC) $(LIBS) -o $(EXE) $(OBJS) $(LIBS)

# compile
.cpp.o:
	$(CC) $(CFLAGS) -c $< -o $@

# depend
depend:
	\makedepend -- $(CFLAGS) -- $(CPP)

# clean
clean:
	\rm -f $(OBJS) $(EXE)
