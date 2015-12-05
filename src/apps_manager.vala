namespace Edge {

    public class App: GLib.Object {

        public bool valid = true;

        public string? file = null;
        public string name;
        public string? generic_name = null;
        public string exec;
        public string[]? categories = null;
        public string app_comment;
        public string icon;
        //public string? icon_path = null;
        public string? path = null;
        public bool terminal;

        public App(string path) {
            this.file = path;
            this.load_data();
        }

        private void load_data() {
            GLib.KeyFile kf = new GLib.KeyFile();

            try {
                kf.load_from_file(this.file, GLib.KeyFileFlags.NONE);
            } catch (GLib.KeyFileError error) {
                this.valid = false;
                return;
            } catch (GLib.FileError e) {
                this.valid = false;
                return;
            }

            //Test if KeyFile is valid & load keys
            try {
                if (!kf.has_group("Desktop Entry")) {
                    this.valid = false;
                    return;
                }

                // --- <Name>
                try {
                    this.name = kf.get_value("Desktop Entry", "Name");
                } catch (KeyFileError e) {
                    this.valid = false;
                    return;
                }

                // --- <Type>
                if (!kf.has_key("Desktop Entry", "Type") || kf.get_value("Desktop Entry", "Type") != "Application") {
                    this.valid = false;
                    return;
                }

                // --- <Exec>
                try {
                    string command = kf.get_value("Desktop Entry", "Exec");
                    if ("%" in command) {
                        int index = command.index_of("%", 0);
                        this.exec = command.slice(0, index);
                    } else {
                        this.exec = command;
                    }

                } catch (KeyFileError e) {
                    this.valid = false;
                    return;
                }

                // --- <NoDisplay>
                if (kf.has_key("Desktop Entry", "NoDisplay")) {
                    if (kf.get_value("Desktop Entry", "NoDisplay") == "true") {
                        this.valid = false;
                        return;
                    }
                }

                // --- <Hidden>
                if (kf.has_key("Desktop Entry", "Hidden")) {
                    if (kf.get_value("Desktop Entry", "Hidden") == "true") {
                        this.valid = false;
                        return;
                    }
                }

                // --- <GenericName>
                try {
                    this.generic_name = kf.get_value("Desktop Entry", "GenericName");
                } catch (KeyFileError e) {
                }

                // --- <Comment>
                try {
                    this.app_comment = kf.get_value("Desktop Entry", "Comment");
                } catch (KeyFileError e) {
                }

                // --- <Icon>
                try {
                    this.icon = kf.get_value("Desktop Entry", "Icon");
                } catch (KeyFileError e) {
                    this.valid = false;
                }

                // --- <Categories>
                try {
                    this.categories = kf.get_value("Desktop Entry", "Categories").split_set(";", 0);
                } catch (KeyFileError e) {
                }

                // --- <Path>
                try {
                    this.path = kf.get_value("Desktop Entry", "Path");
                } catch (KeyFileError e) {
                }

                // --- <Terminal>
                if (kf.has_key("Desktop Entry", "Terminal")) {
                    this.terminal = (kf.get_value("Desktop Entry", "Terminal") == "true");
                }

            } catch (KeyFileError e) {
                this.valid = false;
                return;
            }
        }

        public bool is_valid() {
            return this.valid;
        }
     }

    public class AppsManager: GLib.Object {

        public string[] directories = {
            "/usr/share/applications",
            "/usr/local/share/applications",
            GLib.Path.build_filename(GLib.Environment.get_home_dir(), ".local/share/applications")
        };

        public GLib.List<Edge.App> apps;

        public AppsManager() {
            this.apps = new GLib.List<Edge.App>();
        }

        private void load_apps() {
            GLib.Cancellable cancellable = new GLib.Cancellable();
            string split_text = "#####";
            string[] names = { };
            Edge.App[] apps = { };

            foreach (string directory in this.directories) {
                GLib.File file = GLib.File.new_for_path(directory);

                try {
	                GLib.FileEnumerator enumerator = file.enumerate_children("standard::*", GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS, cancellable);
	                GLib.FileInfo info = null;

	                while (!cancellable.is_cancelled() && ((info = enumerator.next_file(cancellable)) != null)) {
		                if (info.get_file_type() == GLib.FileType.REGULAR) {
		                    string path = GLib.Path.build_filename(file.get_path(), info.get_name());
		                    if (!path.has_suffix(".desktop")) {
		                        continue;
		                    }

		                    Edge.App app = new Edge.App(path);
		                    if (app.is_valid()) {
		                        names += (app.name + split_text + app.file);
		                        apps += app;
    		                }
		                }
	                }
                } catch (GLib.Error error) {
                }
            }

            names = Edge.array_sort_string(names);
            foreach (string name_file in names) {
                string name = name_file.split(split_text)[0];
                string file = name_file.split(split_text)[1];

                foreach (Edge.App app in apps) {
                    if (app.name == name && app.file == file) {
                        this.apps.append(app);
                    }
                }
            }
        }

        public void reload_apps() {
            //foreach (Edge.App app in this.apps) {
            //    this.apps.remove(app);
            //}

            this.load_apps();
        }

        public GLib.List get_apps() {
            return this.apps.copy();
        }
    }

    public class AppButton: Gtk.Button {

        public signal void run_app();

        public Edge.App app;
        public Gtk.Box box;

        public AppButton(Edge.App app) {
            this.set_name("AppButton");
            this.set_border_width(0);
            this.set_relief(Gtk.ReliefStyle.NONE);

            this.app = app;

            this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 1);
            this.add(this.box);

            Gtk.Image image = Edge.make_image(this.app.icon, 86, false);
            this.box.pack_start(image, false, false, 0);

            Gtk.Label label = new Gtk.Label(this.app.name);
            label.set_ellipsize(Pango.EllipsizeMode.END);
            this.box.pack_start(label, false, false, 0);

            this.clicked.connect(() => { this.run_app(); });
        }
    }
}
