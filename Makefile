########################################################################################
#----------------------------------EXEC_NAME-------------------------------------------#
########################################################################################

NAME		:=

########################################################################################
#-------------------------------COMPILER_OPTION----------------------------------------#
########################################################################################

COMP		:=	c++
CFLAGS		:=	-Wall -Wextra -Wuninitialized -Wshadow -Werror -MMD -MP -pedantic \
				-std=c++98
LFLAGS		:=

ifdef DEBUG
    CFLAGS += -DDEBUG
    ifeq ($(DEBUG), sanitize)
        CFLAGS += -O0 -fsanitize=address -g
        LFLAGS += -O0 -fsanitize=address -g
    endif
    ifeq ($(DEBUG), leaks)
        CFLAGS += -DLEAKS
    endif
endif

########################################################################################
#------------------------SOURCE+OBJECT+DEPENDANCE_FILE---------------------------------#
########################################################################################

SRC			:=

SRC_DIR		:=	./srcs/
INC_DIR		:=	./includes/
BIN_DIR		:=	./bin/
OBJS 		:=	$(addprefix $(SRC_DIR), $(SRC:.cpp=.o))
OBJS 		:=	$(addprefix $(BIN_DIR), $(SRC:.cpp=.o))
DEPS		:=	$(OBJS:.o=.d)

########################################################################################
#-----------------------------------COLOR_VAR------------------------------------------#
########################################################################################

GREEN		:=	\033[0;32m
RED 		:=	\033[0;31m
RED_BOLD 	:=	\033[1;31m
BLUE_BOLD	:=	\033[1;34m
WHITE 		:=	\033[0;0m

########################################################################################
#-------------------------------------MAKEFILE_RULE------------------------------------#
########################################################################################

all: $(NAME)

$(NAME): $(BIN_DIR) $(OBJS)
	@$(COMP) $(CFLAGS) $(OBJS) -o $@
	@echo "$(BLUE_BOLD)$(NAME) compilation: $(GREEN)OK$(WHITE)"

$(BIN_DIR):
	@mkdir $(BIN_DIR)

-include $(DEPS)
$(OBJS): $(BIN_DIR)%.o: $(SRC_DIR)%.cpp
	@$(COMP) $(CFLAGS) -I $(INC_DIR) -c $< -o $@

clean:
	@rm -rf $(BIN_DIR)
	@echo "$(RED_BOLD)$(NAME) clean: $(GREEN)OK$(WHITE)"

fclean:
	@rm -rf $(BIN_DIR) $(NAME)
	@echo "$(RED_BOLD)$(NAME) fclean: $(GREEN)OK$(WHITE)"

re: fclean all

run: $(NAME)
	@./$(NAME) $(ARG)

.PHONY: all clean fclean re run
