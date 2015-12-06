namespace Edge {

    public class AppsMenu: Edge.MenuWindow {

        public Edge.AppsManager apps_manager;

        public Gtk.Box box;
        public Gtk.Revealer entry_revealer;
        public Gtk.SearchEntry search_entry;
        public Gtk.Stack stack;
        public Gtk.StackSwitcher switcher;
        public Gtk.Box box_today;
        public Gtk.FlowBox box_apps;

        public class AppsMenu() {
            this.set_title("Edge Apps Menu");
            this.set_size_request(510, 475);

            this.apps_manager = new Edge.AppsManager();

            this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.add(this.box);

            Gtk.Box hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.box.pack_start(hbox, false, false, 0);

            Gtk.Button button = Edge.make_button("open-menu", 24);
            hbox.pack_start(button, false, false, 0);

            this.entry_revealer = new Gtk.Revealer();
            hbox.pack_start(this.entry_revealer, true, true, 0);

            this.search_entry = new Gtk.SearchEntry();
            this.search_entry.set_placeholder_text("Search an application");
            this.search_entry.set_can_focus(true);
            this.search_entry.changed.connect(() => { this.search_apps(this.search_entry.get_text()); });
            this.entry_revealer.add(this.search_entry);
            this.entry_revealer.set_reveal_child(false);

            button = Edge.make_button("edit-find", 24);
            button.clicked.connect(this.reveal_search_entry);
            hbox.pack_end(button, false, false, 0);

            this.stack = new Gtk.Stack();
            this.stack.set_margin_top(5);
            this.stack.set_margin_start(40);
            this.stack.set_margin_end(40);
            this.box.pack_start(this.stack, true, true, 0);

            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            hbox.set_margin_top(4);
            this.box.pack_end(hbox, false, false, 0);

            this.switcher = new Gtk.StackSwitcher();
            this.switcher.set_stack(this.stack);
            hbox.set_center_widget(this.switcher);

            this.make_today();
            this.make_apps();

            this.key_release_event.connect(this.key_release_cb);
            this.hide.connect(this.hide_cb);
        }

        private bool key_release_cb(Gtk.Widget self, Gdk.EventKey event) {
            return false;
        }

        private void hide_cb(Gtk.Widget self) {
            this.entry_revealer.set_reveal_child(false);
        }

        private void make_today() {
            this.box_today = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.stack.add_titled(this.box_today, "Today", "Today");
        }

        private void make_apps() {
            Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow(null, null);
            this.stack.add_titled(scroll, "Apps", "Apps");

            this.box_apps = new Gtk.FlowBox();
            this.box_apps.set_min_children_per_line(4);
            this.box_apps.set_max_children_per_line(4);
            this.box_apps.set_row_spacing(1);
            this.box_apps.set_column_spacing(1);
            this.box_apps.set_selection_mode(Gtk.SelectionMode.NONE);
            this.box_apps.set_homogeneous(true);
            scroll.add(this.box_apps);

            this.search_apps("");
        }

        private void run_app(Edge.AppButton button) {
            this.hide();
            bool runned = Edge.run_app(button.app);
            if (!runned) {
                // Make a notification
            }
        }

        public void reveal_search_entry(Gtk.Button button) {
            this.entry_revealer.set_reveal_child(!this.entry_revealer.get_child_revealed());
            this.search_entry.set_text("");

            if (!this.entry_revealer.get_child_revealed()) {
                this.search_entry.grab_focus();
            }
        }

        public void search_apps(string text) {
            GLib.Idle.add(() => {
                foreach (Gtk.Widget widget in this.box_apps.get_children()) {
                    this.box_apps.remove(widget);
                }

                this.apps_manager.reload_apps(text);

                foreach (Edge.App app in this.apps_manager.apps) {
                    Edge.AppButton button = new Edge.AppButton(app);
                    button.run_app.connect(this.run_app);
                    this.box_apps.add(button);
                }

                this.box_apps.show_all();
                return false;
            });
        }
    }
}
