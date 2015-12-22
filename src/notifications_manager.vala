namespace Edge {

    public class Notification: GLib.Object {

        public signal void closed();

        private string _name;
        private string _icon_name;
        private string _information;

        public bool valid = false;

        public GLib.File file;
        public Gtk.Button[] buttons;

        public Notification(GLib.File file) {
            this.file = file;
            this.buttons = {};

            this.load_data();
        }

        private void load_data() {
            GLib.KeyFile kf = new GLib.KeyFile();

            try {
                kf.load_from_file(this.file.get_path(), GLib.KeyFileFlags.NONE);
            } catch (GLib.KeyFileError e) {
                this.valid = false;
                GLib.warning("@Bad notification file: $e.message");
                return;
            } catch (GLib.FileError e) {
                this.valid = false;
                GLib.warning("@Bad notification file: $e.message");
                return;
            }
            
            if (!kf.has_group("Notification")) {
                GLib.warning("@Bad notification file: $e.message");
                return;
            }
            
            if (!kf.has_key("Notification", "Name")) {
                GLib.warning("@Bad notification file: $e.message");
            }
            
            this.name = kf.get_string("Notification", "Name");
        }

        public string name {
            set { this._name = value; }
            get { return this._name; }
        }

        public string icon_name {
            set { this._icon_name = value; }
            get { return this._icon_name; }
        }

        public string information {
            set { this._information = value; }
            get { return this._information; }
        }
    }

    public class NotificationsManager: GLib.Object {

        public signal void new_notification(Edge.Notification notification);
        public signal void notification_removed(Edge.Notification notification);

        private string path = Path.build_filename(GLib.Environment.get_home_dir(), ".edge_notifications/");

        public GLib.List<Edge.Notification> notifications;
        public GLib.File file;
        public GLib.FileMonitor monitor;

        public NotificationsManager() {
            this.notifications = new GLib.List<Edge.Notification>();

            bool check;

    		this.file = File.new_for_path(this.path);
    		if (!this.file.query_exists()) {
                try {
                    check = this.file.make_directory();
                } catch (GLib.Error error) {
                    GLib.warning(@"Error making notifications directory '$(this.path)'");
                    check = false;
                }
    		} else {
    		    check = true;
    		}

    		try {
    		    this.monitor = this.file.monitor(GLib.FileMonitorFlags.NONE, null);
    		} catch (GLib.Error error) {
    		    GLib.warning(@"Can't show notifications: $(error.message)");
    		}

            if (check) {
        		this.monitor.changed.connect(this.check_notifications);
            }
        }

        private void check_notifications(GLib.FileMonitor monitor, GLib.File file, GLib.File? other_file, GLib.FileMonitorEvent event) {
            switch (event) {
                case GLib.FileMonitorEvent.CREATED:
                    Edge.Notification notification = new Edge.Notification(file);
                    this.notifications.append(notification);
                    this.new_notification(notification);

                    break;

                case GLib.FileMonitorEvent.DELETED:
                    foreach (Edge.Notification notification in this.notifications) {
                        if (notification.file.get_path() == file.get_path()) {
                            this.notifications.remove(notification);
                            this.notification_removed(notification);
                            break;
                        }
                    }
                    break;
            }
        }
    }
}
