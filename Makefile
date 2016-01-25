PKGS = --pkg gtk+-3.0

SRC = src/edge_panel.vala \
      src/apps_manager.vala \
      src/today_scope.vala \
      src/notifications_manager.vala \
      src/menu_window.vala \
      src/apps_menu.vala \
      src/clock_menu.vala \
      src/user_menu.vala \
      src/utils.vala \
      src/globals.vala

OPTIONS = --target-glib 2.32

BIN = edge-panel

all:
	valac $(PKGS) $(SRC) $(OPTIONS) -o $(BIN) 
