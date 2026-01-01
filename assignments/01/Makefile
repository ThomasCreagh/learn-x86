BIN_DIR = .
DEBUG_DIR = debug

# server
NASMFLAGS = -f elf32 -g
GCCFLAGS = -no-pie -m32 -g -nostartfiles
LDFLAGS = -m elf_i386

COMMON_SRCS = \
    src/server/core/add_friend.asm \
    src/server/core/create_user.asm \
    src/server/core/display_wall.asm \
    src/server/core/post_message.asm \
    src/server/core/server.asm \
    src/server/lib/io/close.asm \
    src/server/lib/io/open.asm \
    src/server/lib/io/print.asm \
    src/server/lib/io/printf.asm \
    src/server/lib/io/read.asm \
    src/server/lib/io/read_line.asm \
    src/server/lib/io/write.asm \
    src/server/lib/string/strcat.asm \
    src/server/lib/string/strcmp.asm \
    src/server/lib/string/strcpy.asm \
    src/server/lib/string/strlen.asm \
    src/server/lib/string/tokenize_str.asm \
    src/server/lib/append_line.asm \
    src/server/lib/cat.asm \
    src/server/lib/exit.asm \
    src/server/lib/get_txt.asm \
    src/server/lib/mkdir.asm \
    src/server/lib/parse_input.asm \
    src/server/lib/touch.asm \
    src/server/lib/user_exists.asm \
    src/server/lib/user_in_file.asm

ADD_FRIEND_MAIN  = src/server/add_friend_main.asm
CREATE_USER_MAIN = src/server/create_user_main.asm
POST_MESSAGE_MAIN  = src/server/post_message_main.asm
DISPLAY_WALL_MAIN  = src/server/display_wall_main.asm
SERVER_MAIN  = src/server/server_main.asm

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

# client
RISCV_AS = riscv64-unknown-linux-gnu-as
RISCV_CC = riscv64-unknown-linux-gnu-gcc
RISCV_OBJS = src/client/client.o src/client/strcpy.o src/client/strlen.o
CLIENT_DRIVER = src/client/driver.c

CLIENT_BIN  = $(BIN_DIR)/client
CLIENT_DEBUG = $(DEBUG_DIR)/client

# main compile
all: $(CREATE_USER_BIN) $(ADD_FRIEND_BIN) $(POST_MESSAGE_BIN) $(DISPLAY_WALL_BIN) $(SERVER_BIN) $(CREATE_USER_DEBUG) $(ADD_FRIEND_DEBUG) $(POST_MESSAGE_DEBUG) $(DISPLAY_WALL_DEBUG) $(SERVER_DEBUG) $(CLIENT_BIN) $(CLIENT_DEBUG)

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

$(CLIENT_BIN): $(RISCV_OBJS) $(CLIENT_DRIVER)
	$(RISCV_CC) -o $@ $(CLIENT_DRIVER) $(RISCV_OBJS)

$(CLIENT_DEBUG): $(RISCV_OBJS) $(CLIENT_DRIVER)
	$(RISCV_CC) -g -o $@ $(CLIENT_DRIVER) $(RISCV_OBJS)

%.o: %.asm
	nasm $(NASMFLAGS) $< -o $@

%.o: %.s
	$(RISCV_AS) -o $@ $<

clean-o:
	rm -f $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o) $(ADD_FRIEND_MAIN:.asm=.o) $(POST_MESSAGE_MAIN:.asm=.o) $(DISPLAY_WALL_MAIN:.asm=.o) $(SERVER_MAIN:.asm=.o) $(RISCV_OBJS)

clean:
	rm -rf $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o) $(ADD_FRIEND_MAIN:.asm=.o) $(POST_MESSAGE_MAIN:.asm=.o) $(DISPLAY_WALL_MAIN:.asm=.o) $(SERVER_MAIN:.asm=.o) \
	$(ADD_FRIEND_BIN) $(CREATE_USER_BIN) $(POST_MESSAGE_BIN) $(DISPLAY_WALL_BIN) $(SERVER_BIN) $(ADD_FRIEND_DEBUG) $(CREATE_USER_DEBUG) $(POST_MESSAGE_DEBUG) $(DISPLAY_WALL_DEBUG) $(SERVER_DEBUG) $(RISCV_OBJS) $(CLIENT_BIN) $(CLIENT_DEBUG) \
	debug

