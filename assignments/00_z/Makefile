NASMFLAGS = -f elf32 -g
GCCFLAGS = -no-pie -m32 -g -nostartfiles

COMMON_SRCS = \
    add_friend.asm \
    create_user.asm \
    display_wall.asm \
    post_message.asm \
    server.asm \
    close.asm \
    open.asm \
    print.asm \
    printf.asm \
    read.asm \
    read_line.asm \
    write.asm \
    strcat.asm \
    strcmp.asm \
    strcpy.asm \
    strlen.asm \
    tokenize_str.asm \
    append_line.asm \
    cat.asm \
    exit.asm \
    get_txt.asm \
    mkdir.asm \
    parse_input.asm \
    touch.asm \
    user_exists.asm \
    user_in_file.asm

ADD_FRIEND_MAIN  = add_friend_main.asm
CREATE_USER_MAIN = create_user_main.asm
POST_MESSAGE_MAIN  = post_message_main.asm
DISPLAY_WALL_MAIN  = display_wall_main.asm
SERVER_MAIN  = server_main.asm

COMMON_OBJS = $(COMMON_SRCS:.asm=.o)

CREATE_USER_OBJS = $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o)
ADD_FRIEND_OBJS  = $(COMMON_OBJS) $(ADD_FRIEND_MAIN:.asm=.o)
POST_MESSAGE_OBJS  = $(COMMON_OBJS) $(POST_MESSAGE_MAIN:.asm=.o)
DISPLAY_WALL_OBJS  = $(COMMON_OBJS) $(DISPLAY_WALL_MAIN:.asm=.o)
SERVER_OBJS  = $(COMMON_OBJS) $(SERVER_MAIN:.asm=.o)

all: add_friend create_user post_message display_wall server

create_user: $(CREATE_USER_OBJS)
	@gcc $(GCCFLAGS) -o $@ $^

add_friend: $(ADD_FRIEND_OBJS)
	@gcc $(GCCFLAGS) -o $@ $^

post_message: $(POST_MESSAGE_OBJS)
	@gcc $(GCCFLAGS) -o $@ $^

display_wall: $(DISPLAY_WALL_OBJS)
	@gcc $(GCCFLAGS) -o $@ $^

server: $(SERVER_OBJS)
	@gcc $(GCCFLAGS) -o $@ $^

%.o: %.asm
	@nasm $(NASMFLAGS) $< -o $@

clean-o:
	@rm -f $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o) $(ADD_FRIEND_MAIN:.asm=.o) $(POST_MESSAGE_MAIN:.asm=.o) $(DISPLAY_WALL_MAIN:.asm=.o) $(SERVER_MAIN:.asm=.o)

clean:
	@rm -f $(COMMON_OBJS) $(CREATE_USER_MAIN:.asm=.o) $(ADD_FRIEND_MAIN:.asm=.o) $(POST_MESSAGE_MAIN:.asm=.o) $(DISPLAY_WALL_MAIN:.asm=.o) $(SERVER_MAIN:.asm=.o) \
	add_friend create_user post_message display_wall server
