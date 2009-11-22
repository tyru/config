.PHONY: all release test leak-test deps clean tags
.SUFFIXES: .cpp .o

CC = g++
PROG =
CFLAGS_RELEASE = -O2 -Wall -std=gnu99
CFLAGS = -g -Wall -std=gnu99
LDFLAGS =


STRIP = strip
CTAGS = ctags
RM = rm


SRC =
OBJS = $(SRC:.cpp=.o)




all: deps tags $(PROG)

release: clean
	-@\echo -n "\n\n"
	CFLAGS=$(CFLAGS_RELEASE) make $(PROG)
	$(STRIP) $(PROG)



test: $(PROG)
	-@\echo -n "\n\n"
	# no tests yet.
leak-test: $(PROG)
	-@\echo -n "\n\n"
	valgrind --leak-check=full $(PROG)



$(PROG): $(OBJS)
	-@\echo -n "\n\n"
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

.cpp.o:
	$(CC) $(CFLAGS) -c $< -o $@


deps:
	-@\echo -n "\n\n"
	$(CC) -MM $(SRC) > deps

clean:
	-@\echo -n "\n\n"
	-$(RM) -f $(PROG) $(OBJS)

tags:
	$(CTAGS)


include deps
