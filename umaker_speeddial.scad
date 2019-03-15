module torus(outerRadius, innerRadius)
{
    r=(outerRadius-innerRadius)/2;
    rotate_extrude() translate([innerRadius+r,0,0]) circle(r);
}

module torus_scaled(r_torus, r_ring, scale_w=[1,1])
{
    rotate_extrude() translate([r_torus,0,0]) scale(scale_w) circle(r_ring);
}

module dial (r=30, h=4, holespacing=9) {
    // radius of fingerhole
    r_hole=(20-(10/2)-2*1)/2;
    // diameter of dial's disc
    diam=2*3.1415692653*r+h/2;
    // …
    numDents=19;
    // distance between dents as a ratio of the dent's width
    spaceFac=0.3;
    // width of dent + space next to it
    t_rad=diam/numDents/(1+spaceFac)/2;
    // width of plug
    plug_w=9;
    old_holespacing = 1;
    difference() {
        difference() {
            // main disc
            union() {
                cylinder(r=r, h=h, center=true);
                torus(outerRadius=r+h/2, innerRadius=r-h/2);
            }
            // holes for finger
            for( rot = [0:60:360] ) {
                assign (zhscale=1.75) {
                    rotate([0,0,rot]) translate([(10/2)+holespacing+r_hole,0,0]) scale([1,1,zhscale]) difference() {
                        cylinder(r=r_hole, h=2*h/zhscale, center=true);
                        torus(outerRadius=r_hole+h/2/zhscale, innerRadius=r_hole-h/2/zhscale);
                    }
                }
            }
        }
        // dents
        for ( rot2 = [1:numDents/2]) {
            rotate([90,0,rot2*360/numDents]) torus_scaled(r_torus=r+h/2,r_ring=t_rad, scale_w=[0.35,1]);
        }
    }
    // plug
    translate([0,0,h/2])
    union() {
        difference() {
            cylinder(r=plug_w/2, h=10, center=false);
            difference() {
                cylinder(r=6/2+0.1, h=21, center=true);
                translate([5+1.6,0,0]) cube([10,10,100], center=true);
            }
        }
        difference() {
            cylinder(r=10/2+old_holespacing,h=(10-plug_w)/2+old_holespacing);
            translate([0,0,(10-plug_w)/2+old_holespacing]) torus_scaled(10/2+old_holespacing,(10-plug_w)/2+old_holespacing);
        }
    }
}

$fn=64;
dial();
