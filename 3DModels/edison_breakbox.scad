/*
Intel Edison Breakout Board simple case
Copyright (C) 2014 Andrew Litt

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

wall_th=2.0;

edge_sphere=2.5; //minkowski corner radius

//From measurements
brk_w=59.8; // dimensions of breakout board
brk_l=29.0; 
mod_h=10.0; // total height of breakout + Edison

// USB header cutouts
usb_otg_x=58;
usb_otg_y=6.6;
usb_otg_z=2.92;
usb_otg_w=16.8;
usb_otg_h=3.25;
usb_otg_l=8.60;

usb_tty_x=58;
usb_tty_y=18.86;
usb_tty_z=2.92;
usb_tty_w=16.8;
usb_tty_h=3.25;
usb_tty_l=8.60;

// dimensions of 2-pin 2.54mm headers with connector / jumper clearance
hdr2_h=12.2;
hdr2_w=5.4;
hdr2_l=2.9;

// power in header
hdr2_pwr_x=54.4;
hdr2_pwr_y=1.44;
hdr2_pwr_z=3.25;

// LiPo thermistor header
hdr2_lipo_therm_x=0.49;
hdr2_lipo_therm_y=15.70;
hdr2_lipo_therm_z=3.25;

// LiPo battery header
hdr2_lipo_bat_x=0.49;
hdr2_lipo_bat_y=19.68;
hdr2_lipo_bat_z=3.25;

// fudge for the length of the button extender plunger - decrease if
// the button isn't tactile enough, increase if the plunger is activating the
// button without being pressed
button_plunger_gap=0.3;

// button params
button_r=2.00;
button_x=3.00;
button_y=8.36;
button_z=4.60;
button_cutout_h=mod_h+wall_th;

// radius of the outer gap around the button spring
button_cutter_r=button_r+0.5;

// length of the button spring
button_cutter_l=18;

button_cutter_h=8;

// hole for battery charger LED
bat_led_r=0.875;
bat_led_h=20;
bat_led_x=43.5;
bat_led_y=15.60;
bat_led_z=0;


// box that we cut the model out of
module ext_box() {
	$fn=50;

	translate([-wall_th+edge_sphere, -wall_th+edge_sphere, -wall_th+edge_sphere])
		minkowski() {
			cube([brk_w+(wall_th*2)-edge_sphere*2, brk_l+(wall_th*2)-edge_sphere*2, mod_h+(wall_th*2)-edge_sphere*2] );
			sphere(edge_sphere,$fn=30);
		}
}


// cutout for the Edison breakout
module edison_breakout() {
	union() {
		cube([brk_w, brk_l, mod_h]);
		translate([usb_otg_x, usb_otg_y, usb_otg_z])
			cube([usb_otg_w, usb_otg_l, usb_otg_h]);
		translate([usb_tty_x, usb_tty_y, usb_tty_z])
			cube([usb_tty_w, usb_tty_l, usb_tty_h]);
		translate([hdr2_pwr_x, hdr2_pwr_y, hdr2_pwr_z])
			cube([hdr2_w, hdr2_l, hdr2_h]);
		translate([hdr2_lipo_therm_x, hdr2_lipo_therm_y, hdr2_lipo_therm_z])
			cube([hdr2_w, hdr2_l, hdr2_h]);
		translate([hdr2_lipo_bat_x, hdr2_lipo_bat_y, hdr2_lipo_bat_z])
			cube([hdr2_w, hdr2_l, hdr2_h]);
		translate([bat_led_x, bat_led_y, bat_led_z])
			cylinder(r=bat_led_r, h=bat_led_h, $fn=24);
	}
}

// cutout for the power button spring
module flex_button_cutter() {
	translate([button_x, button_y, button_z]) 
		difference() {
			union() {
				cylinder(r=button_cutter_r, h=button_cutter_h, $fn=24);
				translate([0,-button_cutter_r,0])
					cube([button_cutter_l, button_cutter_r*2,button_cutter_h]);
			}
			union() {
				cylinder(r=button_r, h=button_cutter_h, $fn=24);
				translate([0,-button_r,0])
					cube([button_cutter_l, button_r*2,button_cutter_h]);
			}

		}
}

// plunger for the power button spring
module flex_button_plunger() {
	translate([button_x, button_y, button_z+button_plunger_gap])
		cylinder(r=button_r, h=wall_th+mod_h-button_z-button_plunger_gap-1, $fn=24);

}

// case base instance
difference() {
	ext_box();
	edison_breakout();

	translate([-wall_th/2,-wall_th/2,wall_th + mod_h-5])
		cube([brk_w+wall_th, brk_l+wall_th, mod_h+wall_th] );
	translate([-wall_th*2,-wall_th*2,wall_th + mod_h-4])
		cube([brk_w+(wall_th*4), brk_l+(wall_th*4), mod_h+(wall_th*4)] );
}

// case top instance
translate([0,-10,mod_h]) 
rotate([180,0,0])
union() {
	difference() {
		ext_box();
		edison_breakout();
		difference() {
			translate([-wall_th*2,-wall_th*2,-wall_th-0.01])
				cube([brk_w+(wall_th*4), brk_l+(wall_th*4), mod_h+(wall_th*2)-4] );
			translate([-wall_th/2,-wall_th/2,-wall_th-0.001+mod_h+(wall_th*2)-5])
				cube([brk_w+wall_th, brk_l+wall_th, mod_h+(wall_th*2)-5] );
		}
		flex_button_cutter();	
	}
	flex_button_plunger();
}
