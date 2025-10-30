NASMFLAGS = -f elf32 -g
GCCFLAGS = -m32 -g -nostartfiles
LDFLAGS = -m elf_i386

BIN_DIR = bin
DEBUG_DIR = debug

COMMON_SRCS = \
    src/core/add_friend.asm \
    src/core/create_user.asm \
    src/lib/io/close.asm \
    src/lib/io/open.asm \
    src/lib/io/print.asm \
    src/lib/io/read.asm \
    src/lib/io/read_line.asm \
    src/lib/io/write.asm \
    src/lib/string/strcat.asm \
    src/lib/string/strcmp.asm \
    src/lib/string/strcpy.asm \
    src/lib/string/strlen.asm \
    src/lib/append_user.asm \
    src/lib/exit.asm \
    src/lib/get_txt.asm \
    src/lib/mkdir.asm \
    src/lib/touch.asm \
    src/lib/user_exists.asm \
    src/lib/user_in_file.asm

ADD_FRIEND_MAIN  = src/add_friend_main.asm
CREATE_USER_MAIN = src/create_user_main.asm

COMMON_OBJS = $(COMMON_SRCS:.asm=.o)
CREATE_USER_OBJS = $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o)
ADD_FRIEND_OBJS  = $(COMMON_OBJS) $(ADD_FRIEND_MAIN:.asm=.o)

CREATE_USER_BIN = $(BIN_DIR)/create_user
ADD_FRIEND_BIN  = $(BIN_DIR)/add_friend

CREATE_USER_DEBUG = $(DEBUG_DIR)/create_user
ADD_FRIEND_DEBUG  = $(DEBUG_DIR)/add_friend

all: $(CREATE_USER_BIN) $(ADD_FRIEND_BIN) $(CREATE_USER_DEBUG) $(ADD_FRIEND_DEBUG)

$(CREATE_USER_BIN): $(CREATE_USER_OBJS)
	@mkdir -p $(BIN_DIR)
	gcc $(GCCFLAGS) -o $@ $^
$(CREATE_USER_DEBUG): $(CREATE_USER_OBJS)
	@mkdir -p $(DEBUG_DIR)
	ld $(LDFLAGS) -o $@ $^

$(ADD_FRIEND_BIN): $(ADD_FRIEND_OBJS)
	@mkdir -p $(BIN_DIR)
	gcc $(GCCFLAGS) -o $@ $^
$(ADD_FRIEND_DEBUG): $(ADD_FRIEND_OBJS)
	@mkdir -p $(DEBUG_DIR)
	ld $(LDFLAGS) -o $@ $^


%.o: %.asm
	nasm $(NASMFLAGS) $< -o $@

clean:
	rm -f $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o) $(ADD_FRIEND_MAIN:.asm=.o)

