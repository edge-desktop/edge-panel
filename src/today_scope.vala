namespace Edge
{

	public class TodayScope: Gtk.Box
	{

		public Edge.NotificationsManager notifications_manager;
		public Gtk.Box today_box;
		public Gtk.Label day_label;
		public Gtk.Label date_label;
		public Gtk.Image weather_image;
		public Gtk.Label temp_label;
		public Gtk.Label weather_label;
		public Gtk.Label weather_name_label;
		public Gtk.Box notifications_box;

		public string day = "";
		public string date = "";
		public string weather;

		public TodayScope()
		{
			this.set_orientation(Gtk.Orientation.VERTICAL);

			this.notifications_manager = new Edge.NotificationsManager();

			this.today_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
			this.pack_start(this.today_box, false, false, 0);

			Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			this.today_box.pack_start(box, false, false, 0);

			this.day_label = new Gtk.Label(null);
			this.day_label.set_xalign(0);
			this.day_label.override_font(Pango.FontDescription.from_string("Segoe UI 50"));
			box.pack_start(this.day_label, false, false, 0);

			this.date_label = new Gtk.Label(null);
			this.date_label.set_xalign(0);
			this.date_label.override_font(Pango.FontDescription.from_string("Segoe UI 15"));
			box.pack_start(this.date_label, false, false, 0);

			Gtk.Label label = new Gtk.Label(null);
			label.set_markup("Notifications:");
			label.set_xalign(0);
			label.set_margin_top(10);
			//box.pack_start(label, false, false, 0);

			box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			this.today_box.pack_end(box, false, false, 0);

			this.weather_label = new Gtk.Label("2°C");
			this.weather_label.override_font(Pango.FontDescription.from_string("Segoe UI 30"));
			label.set_xalign(0);
			box.pack_start(this.weather_label, false, false, 0);

			this.weather_name_label = new Gtk.Label("clear");
			label.set_xalign(0);
			box.pack_start(this.weather_name_label, false, false, 0);

			this.weather_image = Edge.make_image("weather-clear", 64);
			this.today_box.pack_end(this.weather_image, false, false, 0);

			Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow(null, null);
			this.pack_start(scroll, true, true, 0);

			this.notifications_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			scroll.add(this.notifications_box);

			this.update();
		}

		public void update()
		{
			GLib.DateTime datetime = new GLib.DateTime.now_local();
			this.day = Edge.get_week_day(datetime.get_day_of_week() - 1);
			this.day_label.set_label(this.day);

			int day = datetime.get_day_of_month();
			int month = datetime.get_month();
			int year = datetime.get_year();

			this.date = @"$day. $(Edge.get_month_name(month - 1)) $year";
			this.date_label.set_label(this.date);
		}
	}
}
