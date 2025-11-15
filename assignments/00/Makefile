NASMFLAGS = -f elf32 -g
GCCFLAGS = -no-pie -m32 -g -nostartfiles
LDFLAGS = -m elf_i386

BIN_DIR = .
DEBUG_DIR = debug

COMMON_SRCS = \
    src/core/add_friend.asm \
    src/core/create_user.asm \
    src/core/display_wall.asm \
    src/core/post_message.asm \
    src/core/server.asm \
    src/lib/io/close.asm \
    src/lib/io/open.asm \
    src/lib/io/print.asm \
    src/lib/io/printf.asm \
    src/lib/io/read.asm \
    src/lib/io/read_line.asm \
    src/lib/io/write.asm \
    src/lib/string/strcat.asm \
    src/lib/string/strcmp.asm \
    src/lib/string/strcpy.asm \
    src/lib/string/strlen.asm \
    src/lib/string/tokenize_str.asm \
    src/lib/append_line.asm \
    src/lib/cat.asm \
    src/lib/exit.asm \
    src/lib/get_txt.asm \
    src/lib/mkdir.asm \
    src/lib/parse_input.asm \
    src/lib/touch.asm \
    src/lib/user_exists.asm \
    src/lib/user_in_file.asm

ADD_FRIEND_MAIN  = src/add_friend_main.asm
CREATE_USER_MAIN = src/create_user_main.asm
POST_MESSAGE_MAIN  = src/post_message_main.asm
DISPLAY_WALL_MAIN  = src/display_wall_main.asm
SERVER_MAIN  = src/server_main.asm

COMMON_OBJS = $(COMMON_SRCS:.asm=.o)

CREATE_USER_OBJS = $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o)
ADD_FRIEND_OBJS  = $(COMMON_OBJS) $(ADD_FRIEND_MAIN:.asm=.o)
POST_MESSAGE_OBJS  = $(COMMON_OBJS) $(POST_MESSAGE_MAIN:.asm=.o)
DISPLAY_WALL_OBJS  = $(COMMON_OBJS) $(DISPLAY_WALL_MAIN:.asm=.o)
SERVER_OBJS  = $(COMMON_OBJS) $(SERVER_MAIN:.asm=.o)

ADD_FRIEND_BIN  = $(BIN_DIR)/add_friend
CREATE_USER_BIN = $(BIN_DIR)/create_user
POST_MESSAGE_BIN  = $(BIN_DIR)/post_message
DISPLAY_WALL_BIN  = $(BIN_DIR)/display_wall
SERVER_BIN  = $(BIN_DIR)/server

ADD_FRIEND_DEBUG  = $(DEBUG_DIR)/add_friend
CREATE_USER_DEBUG = $(DEBUG_DIR)/create_user
POST_MESSAGE_DEBUG  = $(DEBUG_DIR)/post_message
DISPLAY_WALL_DEBUG  = $(DEBUG_DIR)/display_wall
SERVER_DEBUG  = $(DEBUG_DIR)/server

all: $(CREATE_USER_BIN) $(ADD_FRIEND_BIN) $(POST_MESSAGE_BIN) $(DISPLAY_WALL_BIN) $(SERVER_BIN) $(CREATE_USER_DEBUG) $(ADD_FRIEND_DEBUG) $(POST_MESSAGE_DEBUG) $(DISPLAY_WALL_DEBUG) $(SERVER_DEBUG)

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

$(POST_MESSAGE_BIN): $(POST_MESSAGE_OBJS)
	@mkdir -p $(BIN_DIR)
	gcc $(GCCFLAGS) -o $@ $^
$(POST_MESSAGE_DEBUG): $(POST_MESSAGE_OBJS)
	@mkdir -p $(DEBUG_DIR)
	ld $(LDFLAGS) -o $@ $^

$(DISPLAY_WALL_BIN): $(DISPLAY_WALL_OBJS)
	@mkdir -p $(BIN_DIR)
	gcc $(GCCFLAGS) -o $@ $^
$(DISPLAY_WALL_DEBUG): $(DISPLAY_WALL_OBJS)
	@mkdir -p $(DEBUG_DIR)
	ld $(LDFLAGS) -o $@ $^

$(SERVER_BIN): $(SERVER_OBJS)
	@mkdir -p $(BIN_DIR)
	gcc $(GCCFLAGS) -o $@ $^
$(SERVER_DEBUG): $(SERVER_OBJS)
	@mkdir -p $(DEBUG_DIR)
	ld $(LDFLAGS) -o $@ $^

%.o: %.asm
	nasm $(NASMFLAGS) $< -o $@

clean-o:
	rm -f $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o) $(ADD_FRIEND_MAIN:.asm=.o) $(POST_MESSAGE_MAIN:.asm=.o) $(DISPLAY_WALL_MAIN:.asm=.o) $(SERVER_MAIN:.asm=.o)

clean:
	rm -rf $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o) $(ADD_FRIEND_MAIN:.asm=.o) $(POST_MESSAGE_MAIN:.asm=.o) $(DISPLAY_WALL_MAIN:.asm=.o) $(SERVER_MAIN:.asm=.o) \
	$(ADD_FRIEND_BIN) $(CREATE_USER_BIN) $(POST_MESSAGE_BIN) $(DISPLAY_WALL_BIN) $(SERVER_BIN) $(ADD_FRIEND_DEBUG) $(CREATE_USER_DEBUG) $(POST_MESSAGE_DEBUG) $(DISPLAY_WALL_DEBUG) $(SERVER_DEBUG) \
	debug

