PKGS = --pkg gtk+-3.0

SRC = src/edge_panel.vala \
      src/apps_menu.vala \
      src/clock_menu.vala \
      src/user_menu.vala \
      src/utils.vala

BIN = edge-panel

all:
	valac $(PKGS) $(SRC) -o $(BIN) 
