NAME = miniRT

CC = cc
RM = /bin/rm -rf

SRC = test.c
OBJ = $(SRC:.c=.o)

SRCDIR = src
LIBDIR = libft_with_additions
MLXDIR = MLX42

MAKEFLAGS = --no-print-directory
CFLAGS = -Wall -Werror -Wextra -g3
IFLAGS	:= -I $(LIBDIR) -I $(MLXDIR)/include -I $(SRCDIR)

ifeq ($(shell uname -s), Darwin)
	LFLAGS = -L $(LIBDIR) -L $(MLXDIR)/build -lft -lmlx42 -lglfw \
				-L "/opt/homebrew/Cellar/glfw/3.3.8/lib"
else ifeq ($(shell uname -s), Linux)
	LFLAGS = -L $(LIBDIR) -L $(MLXDIR)/build -lft -lm -lmlx42 -ldl -lglfw \
				-pthread
endif

all : $(NAME)

$(NAME) : MLX libft $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $(NAME) $(LFLAGS)

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $< $(IFLAGS)

libft : update
	make -C $(LIBDIR) all >/dev/null

MLX : update
	cd $(MLXDIR); cmake -B build; cmake --build build -j4

update :
	git submodule init && git submodule update

clean :
	@$(RM) $(OBJ)  2>/dev/null
	@make clean -C $(LIBDIR) >/dev/null

fclean :
	@$(RM) $(OBJ)  2>/dev/null
	@$(RM) $(NAME) 2>/dev/null
	@make fclean -C $(LIBDIR) >/dev/null

re : fclean all

.PHONY : libft MLX update clean fclean re
