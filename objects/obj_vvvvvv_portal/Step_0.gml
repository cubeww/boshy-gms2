// Groups 795–796 orbit the authored location by 25 pixels.
portal_angle = (portal_angle + 5) mod 360;
x = floor(xstart + dcos(portal_angle) * 25);
y = floor(ystart - dsin(portal_angle) * 25);
