.PHONY: all depend clean

CC       = g++
INCLUDES = -g
CFLAGS   = $(INCLUDES) -Wall -Wsign-compare
LIBS     = 

EXE      = 
CPP      = main.cpp
OBJS     = $(CPP:.cpp=.o)



all: $(EXE)

# link
$(EXE): $(OBJS)
	$(CC) $(LIBS) -o $(EXE) $(OBJS) $(LIBS)

# compile
.cpp.o:
	$(CC) $(CFLAGS) -c $< -o $@

depend:
	\makedepend -- $(CFLAGS) -- $(CPP)

clean:
	\rm -f $(OBJS) $(EXE)
# DO NOT DELETE

main.o: main.h
