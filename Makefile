NAME = exe
SRCS =  src/main.c3
SRCS += src/engine/main.c3 \
	src/engine/math.c3 \
	src/engine/utils.c3 \
        src/engine/scene.c3 \
        src/engine/logger.c3 \
	src/engine/message.c3 \
        src/engine/gameobject.c3
SRCS += src/asset/main.c3 \
	src/asset/map.c3
SRCS += src/objects/label.c3 \
	src/objects/rect.c3
SRCS += src/player.c3 \
	src/appIcon.c3
SRCS += src/scenes/main.c3 \
	src/scenes/logo.c3 \
	src/scenes/os.c3 \
	src/scenes/desktop.c3 \
	src/scenes/memo.c3 \
	src/scenes/editor.c3 \
	src/scenes/quit.c3

all: $(NAME)

$(NAME): raylib c3c $(SRCS)
	./c3/c3c compile -o $(NAME) $(SRCS) src/raylib.c3i -z libraylib.a

raylib: libraylib.a src/raylib.c3i

libraylib.a:
	@wget https://github.com/c3lang/vendor/raw/refs/heads/main/libraries/raylib55.c3l/linux-x64/libraylib.a

src/raylib.c3i:
	@wget https://raw.githubusercontent.com/c3lang/vendor/refs/heads/main/libraries/raylib55.c3l/raylib.c3i
	@mv raylib.c3i src 

c3c: c3/c3c

c3/c3c: 
	@wget https://github.com/c3lang/c3c/releases/download/v0.7.3/c3-linux.tar.gz
	@tar -xf c3-linux.tar.gz
	@rm -fr c3-linux.tar.gz

run: all
	./$(NAME)

clean:
	@rm -fr c3
	@rm -fr src/raylib.c3i
	@rm -fr libraylib.a
	@rm -fr .build
	@rm -fr memo.sav

fclean: clean
	@rm -fr $(NAME)
