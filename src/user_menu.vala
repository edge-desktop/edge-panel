namespace Edge {

    public class UserMenu: Gtk.Window {

        public Gtk.Box box;

        public class UserMenu() {
            this.set_type_hint(Gdk.WindowTypeHint.DOCK);
            this.set_size_request(300, 350);
            this.set_border_width(8);
            this.add_events(Gdk.EventMask.FOCUS_CHANGE_MASK);

            this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.add(this.box);

            Gtk.Box hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.box.pack_start(hbox, false, false, 0);

            hbox.pack_start(Edge.make_button("audio-volume-high", 46), false, false, 0);

            Gtk.Scale scale = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1);
            scale.set_draw_value(false);
            hbox.pack_start(scale, true, true, 0);

            hbox.pack_end(Edge.make_button("emblem-system", 40), false, false, 0);

            Gtk.ButtonBox buttonbox = new Gtk.ButtonBox(Gtk.Orientation.HORIZONTAL);
            buttonbox.set_layout(Gtk.ButtonBoxStyle.SPREAD);
            this.box.pack_start(buttonbox, false, false, 0);

            buttonbox.add(Edge.make_button("network-wireless-connected-symbolic"));
            buttonbox.add(Edge.make_button("bluetooth-active"));

            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.box.pack_end(hbox, false, false, 0);

            Gtk.Button button = Edge.make_button("user-info");
            button.set_label("Cristian García");
            hbox.pack_start(button, false, false, 0);

            hbox.pack_end(Edge.make_button("system-shutdown"), false, false, 0);

            this.focus_out_event.connect(this.foucus_out_event_cb);
        }

        private bool foucus_out_event_cb(Gtk.Widget self, Gdk.EventFocus event) {
            print("focus out\n");
            return false;
        }
    }
}
