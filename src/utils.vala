namespace Edge {

    public Gdk.Pixbuf make_pixbuf(string name, int size, bool symbolic = true) {
        Gtk.IconLookupFlags flag = (symbolic)? Gtk.IconLookupFlags.FORCE_SYMBOLIC: Gtk.IconLookupFlags.USE_BUILTIN;
        try {
            var screen = Gdk.Screen.get_default();
            var theme = Gtk.IconTheme.get_for_screen(screen);
            var pixbuf = theme.load_icon(name, size, flag);

            if (pixbuf.get_width() != size || pixbuf.get_height() != size) {
                pixbuf = pixbuf.scale_simple(size, size, Gdk.InterpType.BILINEAR);
            }

            return pixbuf;
        } catch (GLib.Error e) {
            return Edge.make_pixbuf("image-missing", size);
        }
    }

    public Gtk.Image make_image(string name, int size, bool symbolic = true) {
        return new Gtk.Image.from_pixbuf(Edge.make_pixbuf(name, size, symbolic));
    }

    public Gtk.Button make_button(string icon_name, int size = 56, bool symbolic = true) {
        Gtk.Button button = new Gtk.Button();
        button.set_border_width(0);
        button.set_relief(Gtk.ReliefStyle.NONE);
        button.set_image_position(Gtk.PositionType.LEFT);
        button.set_image(Edge.make_image(icon_name, size, symbolic));

        return button;
    }

    public string[] array_sort_string(string[] array) {
        bool swapped = true;
        int current = 0;
        string tmp;

        while (swapped) {
            swapped = false;
            current ++;
            for (int i = 0; i < array.length - current; i++) {
                if (array[i] > array[i + 1]) {
                    tmp = array[i];
                    array[i] = array[i + 1];
                    array[i + 1] = tmp;
                    swapped = true;
                 }
            }
        }
        return array;
    }

    public bool run_app(Edge.App app) {
        GLib.Thread<bool> thread = new GLib.Thread<bool>(app.name, () => {
            try {
                GLib.Process.spawn_command_line_async(app.exec);
            } catch (GLib.SpawnError e) {
                return false;
            }

            return true;
        });

        return thread.join();
    }

    public bool run_cmd(string cmd) {
        return true;
    }
}
