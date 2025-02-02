/*
 * Copyright (c) 2011-2021 elementary LLC. (https://elementary.io)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

public class Power.Widgets.ScreenBrightness : Gtk.Grid {
    private Gtk.Scale brightness_slider;
    private Power.Services.DeviceManager dm;

    construct {
        dm = Power.Services.DeviceManager.get_default ();
        column_spacing = 6;

        var image = new Gtk.Image.from_icon_name ("brightness-display-symbolic", Gtk.IconSize.DIALOG);
        image.margin_start = 6;

        brightness_slider = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 10);
        brightness_slider.adjustment.page_increment = 10;
        brightness_slider.margin_end = 12;
        brightness_slider.hexpand = true;
        brightness_slider.draw_value = false;
        brightness_slider.width_request = 175;

        brightness_slider.value_changed.connect (() => {
            on_scale_value_changed.begin ();
        });

        dm.brightness_changed.connect ((brightness) => {
            brightness_slider.value_changed.disconnect (on_scale_value_changed);
            brightness_slider.set_value ((double)brightness);
            brightness_slider.value_changed.connect (on_scale_value_changed);
        });

        brightness_slider.set_value (dm.brightness);

        attach (image, 0, 0);
        attach (brightness_slider, 1, 0);
    }

    private async void on_scale_value_changed () {
        dm.brightness = (int) brightness_slider.get_value ();
    }
}
