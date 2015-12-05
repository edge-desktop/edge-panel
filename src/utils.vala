namespace Edge {

    public Gdk.Pixbuf make_pixbuf(string name, int size) {
        try {
            var screen = Gdk.Screen.get_default();
            var theme = Gtk.IconTheme.get_for_screen(screen);
            var pixbuf = theme.load_icon(name, size, Gtk.IconLookupFlags.FORCE_SYMBOLIC);

            if (pixbuf.get_width() != size || pixbuf.get_height() != size) {
                pixbuf = pixbuf.scale_simple(size, size, Gdk.InterpType.BILINEAR);
            }

            return pixbuf;
        } catch (GLib.Error e) {
            return Edge.make_pixbuf("image-missing", size);
        }
    }

    public Gtk.Image make_image(string name, int size) {
        return new Gtk.Image.from_pixbuf(Edge.make_pixbuf(name, size));
    }

    public Gtk.Button make_button(string icon_name, int size = 56) {
        Gtk.Button button = new Gtk.Button();
        button.set_border_width(0);
        button.set_relief(Gtk.ReliefStyle.NONE);
        button.set_image_position(Gtk.PositionType.LEFT);
        button.set_image(Edge.make_image(icon_name, size));

        return button;
    }
}
