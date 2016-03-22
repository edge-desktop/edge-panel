namespace Edge
{

	public class MenuWindow: Gtk.Window
	{

		public MenuWindow()
		{
			this.set_name("EdgeMenu");

			this.stick();
			this.set_border_width(8);
			this.set_can_focus(true);
			this.set_decorated(false);
			this.set_resizable(false);
			this.set_keep_above(true);
			this.set_skip_pager_hint(true);
			this.set_skip_taskbar_hint(true);
			this.set_type_hint(Gdk.WindowTypeHint.DIALOG);

			this.focus_out_event.connect(this.foucus_out_event_cb);
		}

		private bool foucus_out_event_cb(Gtk.Widget self, Gdk.EventFocus event)
		{
			this.hide();
			return false;
		}
	}
}
