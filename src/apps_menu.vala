namespace Edge {

    public class AppsMenu: Gtk.Window {

        public Gtk.Box box;
        public Gtk.Stack stack;
        public Gtk.StackSwitcher switcher;
        public Gtk.Box box_today;
        public Gtk.Box box_apps;

        public class AppsMenu() {
            this.set_type_hint(Gdk.WindowTypeHint.DOCK);
            this.set_border_width(8);
            this.set_size_request(480, 420);

            this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.add(this.box);

            Gtk.Box hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.box.pack_start(hbox, false, false, 0);

            hbox.pack_start(Edge.make_button("open-menu", 24), false, false, 0);
            hbox.pack_end(Edge.make_button("edit-find", 24), false, false, 0);

            this.stack = new Gtk.Stack();
            this.box.pack_start(this.stack, true, true, 0);

            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.box.pack_end(hbox, false, false, 0);

            this.switcher = new Gtk.StackSwitcher();
            this.switcher.set_stack(this.stack);
            hbox.set_center_widget(this.switcher);

            this.make_today();
            this.make_apps();
        }

        private void make_today() {
            this.box_today = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.stack.add_titled(this.box_today, "Today", "Today");
        }

        private void make_apps() {
            this.box_apps = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.stack.add_titled(this.box_apps, "Apps", "Apps");
        }
    }
}
