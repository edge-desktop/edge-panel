namespace Edge {

    public class Panel: Gtk.Window {

        public int width = Gdk.Screen.width();
        public int height = 30;

        public Edge.UserMenu user_menu;
        public Edge.ClockMenu clock_menu;
        public Edge.AppsMenu apps_menu;

        public Gtk.ButtonBox box;
        public Gtk.ToggleButton expose_button;
        public Gtk.ToggleButton apps_button;
        public Gtk.ToggleButton clock_button;
        public Gtk.ToggleButton user_button;

        public Panel(GLib.File theme_file) {
            this.set_type_hint(Gdk.WindowTypeHint.DOCK);
            this.move(0, 0);
            this.set_size_request(this.width, this.height);
            this.set_border_width(0);
            this.set_app_paintable(true);
            this.set_visual(screen.get_rgba_visual());

            this.apps_menu = new Edge.AppsMenu();
            this.clock_menu = new Edge.ClockMenu();
            this.user_menu = new Edge.UserMenu();

            Gtk.Box hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.add(hbox);

            this.expose_button = this.make_button(null, "start-here");
            this.expose_button.toggled.connect(this.expose_toggled);
            hbox.pack_start(this.expose_button, false, false, 0);

            this.box = new Gtk.ButtonBox(Gtk.Orientation.HORIZONTAL);
            this.box.set_layout(Gtk.ButtonBoxStyle.EDGE);   // "EDGE" coincidence? I do not think so xD
            hbox.pack_start(this.box, true, true, 0);

            this.apps_button = this.make_button("Applications");
            this.apps_button.toggled.connect(this.apps_toggled);
            this.box.add(this.apps_button);
            this.apps_menu.hide.connect(() => { this.apps_button.set_active(false); });

            this.clock_button = this.make_button("00:00");
            this.clock_button.toggled.connect(this.clock_toggled);
            this.box.add(this.clock_button);
            this.clock_menu.hide.connect(() => { this.clock_button.set_active(false); });

            this.user_button = this.make_button();
            this.user_button.toggled.connect(this.menu_toggled);
            this.box.add(this.user_button);
            this.user_menu.hide.connect(() => { this.user_button.set_active(false); });

            Gtk.Box icons_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.user_button.add(icons_box);

            icons_box.pack_start(Edge.make_image("audio-volume-high", 24), false, false, 0);
            icons_box.pack_start(Edge.make_image("network-wireless-connected-symbolic", 24), false, false, 0);
            icons_box.pack_start(Edge.make_image("system-shutdown", 24), false, false, 0);

            GLib.Timeout.add(1000, this.update_clock);

            this.destroy.connect(Gtk.main_quit);
            this.realize.connect(this.realize_cb);
            this.draw.connect(this.draw_cb);

            this.update_clock();
            this.load_theme(theme_file);
            this.show_all();
        }

        private void realize_cb(Gtk.Widget self) {
            this.reserve_screen_space();
        }

        private bool draw_cb(Gtk.Widget self, Cairo.Context context) {
            int width = Gdk.Screen.width();
            int height = 30;

            if (width != this.width || height != this.height) {
                this.width = width;
                this.height = height;
                this.set_size_request(this.width, this.height);
            }

            context.set_source_rgba(0, 0, 0, 0.5411764705882353);
            context.set_operator(Cairo.Operator.SOURCE);
            context.paint();

            return false;
        }

        private void reserve_screen_space() {
            Gdk.Window window = this.get_window();
            Gdk.Atom atom = Gdk.Atom.intern("_NET_WM_STRUT_PARTIAL", false);
            long struts[12] = { 0, 0, this.get_allocated_height(), 0,
                                0, 0, 0, 0,
                                0, this.get_allocated_height(), 0, 0 };

            Gdk.property_change(window, atom, Gdk.Atom.intern("CARDINAL", false),
                                32, Gdk.PropMode.REPLACE, (uint8[])struts, 12);
        }

        private void load_theme(GLib.File file) {
            Gtk.CssProvider style_provider = new Gtk.CssProvider();
            try {
                style_provider.load_from_file(file);
            } catch (GLib.Error error) {
                GLib.warning("Error: cann't load edge-panel.css");
                return;
            }

            Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), style_provider,
                                                     Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        }

        private Gtk.ToggleButton make_button(string? text = null, string? icon_name = null) {
            Gtk.ToggleButton button = new Gtk.ToggleButton();
            button.set_border_width(0);
            button.set_relief(Gtk.ReliefStyle.NONE);

            if (text != null) {
                Gtk.Label label = new Gtk.Label(text);
                button.add(label);
            } else if (icon_name != null) {
                Gtk.Image image = Edge.make_image(icon_name, 24, true);
                button.add(image);
            }

            return button;
        }

        private void expose_toggled(Gtk.ToggleButton button) {
            Edge.run_cmd(Edge.EXPOSE_CMD);
        }

        private void apps_toggled(Gtk.ToggleButton button) {
            if (this.apps_button.get_active()) {
                this.apps_menu.show_all();
                this.clock_button.set_active(false);
                this.user_button.set_active(false);
            } else if (!this.apps_button.get_active() && this.apps_menu.get_visible()) {
                this.apps_menu.hide();
            }

            this.apps_menu.move(0, height);
        }

        private void clock_toggled(Gtk.ToggleButton button) {
            if (this.clock_button.get_active()) {
                this.apps_button.set_active(false);
                this.user_button.set_active(false);
                this.clock_menu.show_all();
            } else if (!this.clock_button.get_active() && this.clock_menu.get_visible()) {
                this.clock_menu.hide();
            }

            this.clock_menu.move(width / 2 - this.clock_menu.get_allocated_width() / 2, this.get_allocated_height());
        }

        private void menu_toggled(Gtk.ToggleButton button) {
            if (this.user_button.get_active()) {
                this.apps_button.set_active(false);
                this.clock_button.set_active(false);
                this.user_menu.show_all();
            } else if (!this.clock_button.get_active() && this.user_menu.get_visible()) {
                this.user_menu.hide();
            }

            this.user_menu.move(Gdk.Screen.width() - 300, this.get_allocated_height());
        }

        private bool update_clock() {
            GLib.DateTime datetime = new GLib.DateTime.now_local();
            string time = datetime.format("%H:%M");
            this.clock_button.set_label(time);

            return true;
        }
    }
}

void main(string[] args) {
    Gtk.init(ref args);

    GLib.File this_file = GLib.File.new_for_commandline_arg(args[0]);
    GLib.File file = GLib.File.new_for_path(GLib.Path.build_filename(this_file.get_parent().get_path(), "edge-panel.css"));

    new Edge.Panel(file);
    Gtk.main();
}
