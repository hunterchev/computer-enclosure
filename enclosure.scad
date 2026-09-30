// =====================================================================
// SMALL-COMPUTER DISPLAY ENCLOSURE  --  v2 redesign
//
//   part="front"     front shell: bezel with window, walls, 4 corner bosses
//   part="back"      back plate: board standoffs, tray, vents, dovetail groove
//   part="stand"     stand: slides into the back plate's dovetail, 15 deg tilt
//   part="screws"    printed thumbscrews: 4 for the back plate + 1 stand lock
//   part="assembly"  everything standing on the stand (preview only)
//   part="fit_check" 3 mm slice of the back plate: quick print to check the
//                    board sits on the standoffs before printing everything
//
// All dimensions mm.  The case frame: X = width, Y = height (bottom = -Y),
// Z = depth with the bezel face at z=0 and the back plate outer face at
// z = depth + plate_t.  Same envelope (108 x 94) as the original files.
//
// THE COMPUTER IS NOT IDENTIFIED.  Everything under "BOARD" below is what the
// original back plate implied.  Measure the real board and edit:
//   standoffs  -> where its mounting holes / support points are
//   cutouts    -> where its ports come out
//   window     -> the visible area of its display
// Requires BOSL2 (vendored in ./BOSL2).
// =====================================================================

include <BOSL2/std.scad>
include <BOSL2/threading.scad>

part = "assembly";   // front | back | stand | screws | assembly | fit_check

$fn = 64;

// ---- envelope --------------------------------------------------------
OW        = 108;    // outer width  (X)
OH        = 94;     // outer height (Y)
depth     = 38;     // front shell, bezel face to open edge
wall      = 2.4;    // side walls (6 x 0.4 mm perimeters)
bezel     = 3;      // front plate thickness
corner_r  = 4;      // outer vertical corner radius
window    = [86, 65];   // opening in the bezel (display visible area)
window_chamfer = 1.2;   // 45 deg chamfer on the outside of the window edge

// ---- back plate ------------------------------------------------------
plate_t   = 6;      // thick enough to hold the dovetail groove (4) + 2 floor
lip_h     = 1.5;    // registration lip that enters the shell
lip_clear = 0.2;    // per side, lip to shell wall

// ---- fasteners (back plate to shell) ----------------------------------
fastener  = "printed";  // "printed" thumbscrews (below) or "m3" self-tapping
boss_d    = 12;         // corner boss diameter
// printed screw: coarse 45 deg-flank thread that prints upright without support
scr_d        = 7;       // thread major diameter
scr_pitch    = 2.5;
scr_depth    = 1.0;     // radial thread depth  (minor = 5.0)
scr_len      = 18;      // threaded shank length, back plate screws
lock_len     = 24;      // threaded shank length, stand lock screw
head_d       = 12;
head_h       = 4;
thread_clear = 0.25;    // radial clearance printed into the female threads
boss_thread  = 14;      // threaded depth in each corner boss
// M3 option
m3_pilot     = 2.5;     // self-tapping pilot in the bosses
m3_clear     = 3.4;

// ---- BOARD (edit for the real computer) ------------------------------
// Board supports, copied from the original back plate: a 5 mm post standing
// at the tray's edge, a 3 mm thick arm reaching inward at the top, and on
// four of them a 2.8 mm locating pin at the arm's end (pins 25 x 55 apart).
// Each entry: [x, post_y, arm_end_y, has_pin], same coordinates as the
// original file (printed plate seen from the inside, pins on the right).
standoffs = [
    [ 34.5,  34.5,  27.5, true ], [ 34.5, -34.5, -27.5, true ],
    [  9.5,  34.5,  27.5, true ], [  9.5, -34.5, -27.5, true ],
    [-12.1,  34.5,  29.9, false], [-12.1, -34.5, -29.9, false],
    [-33.9,  34.5,  29.9, false], [-33.9, -34.5, -29.9, false],
];
standoff_h   = 12;      // inner face of the plate to the underside of the board
post_d       = 5;
arm_t        = 3;
mount_style  = "pin";   // "pin" (drop-on pins), "screw" (M2.5 holes), "none"
pin_d        = 2.8;
pin_h        = 2.1;
mount_hole_d = 2.2;     // M2.5 self-tapping
// small U-clip near the bottom wall, as in the original (12 mm slot, 5 deep, 9.5 tall)
edge_clip    = true;
clip_pos     = [1.5, -40.5];   // centre
// tray: a 6 mm rim on the plate under the board, as in the original
tray_on      = true;
tray         = [74.6, 56.6, 6];   // inner length, inner width, rim height
tray_wall    = 1.5;
tray_gap     = 12;      // cable gap in the rim
tray_gap_side = 1;      // +1 = right (+X) wall side as in the original, -1 = left

// ---- port cutouts in the shell walls ---------------------------------
// [side, along, z_centre, width, height]
//   side  : "left" (-X), "right" (+X), "top" (+Y), "bottom" (-Y)
//   along : position along that wall (x for top/bottom, y for left/right)
//   z     : centre measured from the bezel face; > depth-h/2 makes a notch
cutouts = [
    ["right", 0, 34, 12, 8],   // cable notch at the back edge of the right wall, by the tray gap
];

// ---- ventilation ------------------------------------------------------
vents_top   = true;   // slits in the top wall
vents_back  = true;   // slots in the back plate under the board
vent_w      = 1.6;

// ---- stand ------------------------------------------------------------
// tilt=15 -> stand.stl (leaning back), tilt=0 -> stand_upright.stl. The back
// plate is the same for any angle.
tilt        = 15;     // lean-back angle
stand_w     = 70;     // width across
shelf_len   = 30;     // shelf under the bottom wall
stand_back  = 45;     // how far the feet reach behind the back plate
block_t     = 10;     // stand material behind the back plate
block_h     = 45;     // contact height up the back plate
gussets     = true;   // two side gussets reaching back to stand_back (off for a flat wedge)
gusset_t    = 8;      // the two side gussets
gusset_h    = 35;
dt_w        = 14;     // dovetail width at the plate face
dt_h        = 4;      // dovetail depth into the plate
dt_ang      = 12;     // dovetail flank angle
dt_len      = 42;     // tongue length up the plate (ends inside the block)
dt_slop     = 0.15;   // per-side clearance in the groove
stand_lock  = true;   // lock thumbscrew through the stand into the plate
lock_up     = 9;      // lock screw height above the bottom edge
lock_x      = 20;     // lock screw offset to the right, clear of the clip and the groove
lock_boss_d = 11;
shelf_t     = 3;      // stand material under the case's lowest edge

// ---- derived ----------------------------------------------------------
Zb   = depth + plate_t;            // back plate outer face
bx   = OW/2 - wall - boss_d/2;     // corner boss centres
by   = OH/2 - wall - boss_d/2;
boss_xy = [[bx,by],[-bx,by],[bx,-by],[-bx,-by]];
lock_y  = -OH/2 + lock_up;
dt_wt   = dt_w + 2*dt_h*tan(dt_ang);   // dovetail width at the bottom of the groove
eps = 0.01;

// ---- 2D helpers ------------------------------------------------------
module rrect(w, h, r) offset(r=r) square([w-2*r, h-2*r], center=true);

// =====================================================================
// PRINTED SCREW
// =====================================================================
module screw_thread(len, internal=false) {
    trapezoidal_threaded_rod(d=scr_d, l=len, pitch=scr_pitch,
        thread_angle=90, thread_depth=scr_depth,
        internal=internal, bevel2=internal?false:true,
        anchor=BOTTOM, $slop = internal ? thread_clear/2 : 0);
}
// modelled head-down, ready to print
module printed_screw(len) {
    difference() {
        union() {
            // knurled head
            difference() {
                cylinder(d=head_d, h=head_h);
                for (a=[0:30:359]) rotate(a) translate([head_d/2, 0, -1])
                    cylinder(d=1.6, h=head_h+2, $fn=12);
            }
            translate([0,0,head_h-eps]) screw_thread(len+eps);
        }
        // coin / flat-blade slot in the exposed face
        translate([0,0,-1]) cube([head_d+2, 1.4, 2*1.6], center=true);
    }
}
// female thread cutter, anchored at the mouth (z=0), going down -Z
module screw_hole(depth_mm) {
    if (fastener == "printed")
        translate([0,0,-depth_mm]) screw_thread(depth_mm + 1, internal=true);
    else
        translate([0,0,-depth_mm]) cylinder(d=m3_pilot, h=depth_mm+1);
}

// =====================================================================
// FRONT SHELL
// =====================================================================
module wall_cut(c) {
    side=c[0]; along=c[1]; zc=c[2]; w=c[3]; h=c[4];
    if (side=="left")   translate([-OW/2, along, zc]) cube([3*wall, w, h], center=true);
    if (side=="right")  translate([ OW/2, along, zc]) cube([3*wall, w, h], center=true);
    if (side=="top")    translate([along,  OH/2, zc]) cube([w, 3*wall, h], center=true);
    if (side=="bottom") translate([along, -OH/2, zc]) cube([w, 3*wall, h], center=true);
}

module front_shell() {
    difference() {
        union() {
            difference() {
                linear_extrude(depth) rrect(OW, OH, corner_r);
                // cavity
                translate([0,0,bezel]) linear_extrude(depth)
                    rrect(OW-2*wall, OH-2*wall, corner_r-wall);
                // window with an outside chamfer
                translate([0,0,-1]) linear_extrude(bezel+2) square(window, center=true);
                translate([0,0,-eps]) linear_extrude(window_chamfer, scale=[
                        window[0]/(window[0]+2*window_chamfer),
                        window[1]/(window[1]+2*window_chamfer)])
                    square([window[0]+2*window_chamfer, window[1]+2*window_chamfer], center=true);
                // ports
                for (c = cutouts) wall_cut(c);
                // vent slits in the top wall
                if (vents_top) for (x=[-27:6:27])
                    translate([x, OH/2, depth/2+2]) cube([vent_w, 3*wall, 20], center=true);
            }
            // corner bosses, fused into the corner
            for (p = boss_xy) translate([p[0], p[1], bezel-eps]) {
                cylinder(d=boss_d, h=depth-bezel+eps);
                translate([0,0,(depth-bezel)/2])
                    cube([boss_d, boss_d, depth-bezel], center=true);
            }
        }
        // threaded holes in the bosses
        for (p = boss_xy) translate([p[0], p[1], depth]) {
            screw_hole(boss_thread);
            translate([0,0,-boss_thread-3]) cylinder(d=scr_d-2*scr_depth-0.5, h=4);
        }
        // re-cut the cavity's corner rounding the cube spilled over
        difference() {
            translate([0,0,-1]) linear_extrude(depth+2) square([OW+10, OH+10], center=true);
            translate([0,0,-2]) linear_extrude(depth+4) rrect(OW, OH, corner_r);
        }
    }
}

// =====================================================================
// BACK PLATE  (case frame: outer face at z=Zb, inner face at z=depth)
// =====================================================================
module dovetail_profile(extra_w=0, extra_h=0, top_ext=1) {
    // (x,z): z=0 at the plate face, tongue goes to -dt_h
    w0 = dt_w + 2*extra_w;  wt = dt_wt + 2*extra_w;  h = dt_h + extra_h;
    polygon([[-w0/2, top_ext], [w0/2, top_ext], [w0/2, 0], [wt/2, -h], [-wt/2, -h], [-w0/2, 0]]);
}
// tongue on the stand (male), in the case frame
module dovetail_tongue() {
    translate([0, -OH/2 + dt_len/2, Zb])
        rotate([90,0,0]) linear_extrude(dt_len, center=true)
            dovetail_profile(0, 0, 0.3 + 0.5);     // extends into the stand block
}
// groove in the plate (female), open at the bottom edge
module dovetail_groove() {
    L = dt_len + 1 + 5;
    translate([0, -OH/2 + L/2 - 5, Zb])
        rotate([90,0,0]) linear_extrude(L, center=true)
            dovetail_profile(dt_slop, dt_slop, 1);
}

module back_plate() {
    inner = depth;              // inner face z
    difference() {
        union() {
            translate([0,0,inner]) linear_extrude(plate_t) rrect(OW, OH, corner_r);
            // registration lip, notched around the bosses
            translate([0,0,inner-lip_h]) difference() {
                linear_extrude(lip_h+eps) rrect(OW-2*wall-2*lip_clear, OH-2*wall-2*lip_clear, corner_r-wall);
                translate([0,0,-1]) linear_extrude(lip_h+3) rrect(OW-2*wall-2*lip_clear-2*2.4, OH-2*wall-2*lip_clear-2*2.4, 1);
                for (p = boss_xy) translate([p[0], p[1], lip_h/2]) cube([boss_d+0.6, boss_d+0.6, lip_h+4], center=true);
            }
            // board supports: post at the edge, arm inward at the top, pin on the arm's end
            for (s = standoffs) {
                x=s[0]; py=s[1]; ay=s[2];
                translate([x, py, inner - standoff_h]) cylinder(d=post_d, h=standoff_h+eps);
                translate([0, 0, inner - standoff_h]) linear_extrude(arm_t)
                    hull() { translate([x,py]) circle(d=post_d); translate([x,ay]) circle(d=post_d); }
                if (s[3] && mount_style=="pin")
                    translate([x, ay, inner - standoff_h - pin_h + eps]) cylinder(d1=pin_d-0.5, d2=pin_d, h=pin_h);
                if (s[3] && mount_style=="screw")
                    translate([x, ay, inner - standoff_h]) cylinder(d=post_d+1, h=standoff_h+eps);
            }
            // U-clip by the bottom wall
            if (edge_clip) translate([clip_pos[0], clip_pos[1], inner - 9.5]) {
                for (x=[-6.75, 6.75]) translate([x, 0, 4.75]) cube([1.5, 5, 9.5+eps], center=true);
                translate([0, 0, 9.5-0.75]) cube([15, 5, 1.5+eps], center=true);
            }
            // tray rim
            if (tray_on) translate([0,0,inner - tray[2]]) difference() {
                linear_extrude(tray[2]+eps) square([tray[0]+2*tray_wall, tray[1]+2*tray_wall], center=true);
                translate([0,0,-1]) linear_extrude(tray[2]+3) square([tray[0], tray[1]], center=true);
                translate([tray_gap_side*(tray[0]/2+tray_wall), 0, tray[2]/2]) cube([3*tray_wall, tray_gap, tray[2]+3], center=true);
            }
            // stand-lock boss on the inside
            if (stand_lock) translate([lock_x, lock_y, inner - 10]) cylinder(d=lock_boss_d, h=10+eps);
        }
        // corner screw clearance + spot face
        for (p = boss_xy) translate([p[0], p[1], 0]) {
            translate([0,0,inner-1]) cylinder(d=(fastener=="printed"?scr_d+0.6:m3_clear), h=plate_t+2);
            if (fastener=="printed") translate([0,0,Zb-0.6]) cylinder(d=head_d+0.6, h=2);
            else translate([0,0,Zb-3.2]) cylinder(d1=m3_clear, d2=6.6, h=3.2+eps);
        }
        // screw holes in the standoffs
        if (mount_style=="screw") for (s = standoffs) if (s[3])
            translate([s[0], s[2], inner - standoff_h - 1]) cylinder(d=mount_hole_d, h=7);
        // vent slots under the board
        if (vents_back) for (x=[-36:6:36]) if (abs(x) > dt_wt/2 + 3)
            translate([x, 0, inner+plate_t/2]) cube([vent_w, 40, plate_t+2], center=true);
        // dovetail groove
        dovetail_groove();
        // stand lock: clearance through the plate, thread in the boss
        if (stand_lock) translate([lock_x, lock_y, 0]) {
            translate([0,0,inner-eps]) cylinder(d=scr_d+0.6, h=plate_t+2);
            translate([0,0,inner]) screw_hole(9);
        }
    }
}

// =====================================================================
// STAND  (world frame: X across, Y backward, Z up, desk at z=0)
// =====================================================================
c = cos(tilt); s = sin(tilt);
Q  = [0, shelf_t];                 // case's bottom-back edge (y,z)
nv = [ c, -s];                     // normal to the back plate, pointing back
pv = [ s,  c];                     // up the back plate
fv = [-c,  s];                     // along the bottom wall, forward
function Y0(p, v) = [v[0], 0];    // drop to the desk
Pcase = [0, -OH/2, Zb];            // that edge in the case coordinates
// case -> world: M = [[-1,0,0],[0,s,c],[0,c,-s]], then translate
MP = [0, s*Pcase[1] + c*Pcase[2], c*Pcase[1] - s*Pcase[2]];
Tw = [0, Q[0] - MP[1], Q[1] - MP[2]];
module place_case() multmatrix([[-1,0,0,Tw[0]],[0,s,c,Tw[1]],[0,c,-s,Tw[2]],[0,0,0,1]]) children();

// side profile (y,z) extruded across x
module yz_extrude(w) multmatrix([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
    linear_extrude(w, center=true) children();

function ptA() = Q + shelf_len*fv;
function rear(h) = Q + block_t*nv + h*pv;
function rear_desk() = let(q = Q + block_t*nv, lam = -q[1]/pv[1]) q + lam*pv;

module case_envelope(cl) {
    translate([0,0,-cl]) linear_extrude(Zb+2*cl) rrect(OW+2*cl, OH+2*cl, corner_r+cl);
}

module stand() {
    A = ptA(); C = rear_desk(); D = rear(block_h); E = Q + block_h*pv; G = rear(gusset_h);
    difference() {
        union() {
            difference() {
                union() {
                    // cradle block + shelf
                    yz_extrude(stand_w) polygon([[A[0],0], C, D, E, Q, A]);
                    // two side gussets with a foot pad
                    if (gussets) for (x = [-1,1]) translate([x*(stand_w/2 - gusset_t/2), 0, 0])
                        yz_extrude(gusset_t) polygon([C, [stand_back,0], [stand_back,4], G]);
                }
                // seat for the case
                place_case() case_envelope(0.3);
            }
            // dovetail tongue (added after the seat is cut: it lives inside the case envelope)
            place_case() dovetail_tongue();
        }
        // lock screw clearance through block and tongue
        if (stand_lock) place_case() translate([lock_x, lock_y, Zb-dt_h-1]) cylinder(d=scr_d+0.6, h=40);
        // trim below the desk
        translate([0,0,-50]) cube([500,500,100], center=true);
    }
}

// =====================================================================
// OUTPUT
// =====================================================================
if (part == "front")  front_shell();

if (part == "back")   rotate([180,0,0]) translate([0,0,-Zb]) back_plate();   // outer face down

if (part == "fit_check") translate([0,0,-(plate_t-1)]) intersection() {
    rotate([180,0,0]) translate([0,0,-Zb]) back_plate();
    translate([0,0,plate_t-1]) linear_extrude(standoff_h+pin_h+2) square([OW, OH], center=true);
}

if (part == "stand")  rotate([0,90,0]) translate([-stand_w/2,0,0]) stand();    // on its side, z from 0 to stand_w

if (part == "screws") {
    for (i=[0:3]) translate([(i%2)*(head_d+4), floor(i/2)*(head_d+4), 0]) printed_screw(scr_len);
    if (stand_lock) translate([2*(head_d+4), 0, 0]) printed_screw(lock_len);
}

if (part == "assembly") {
    place_case() {
        color("goldenrod") front_shell();
        color("peru") back_plate();
        if (fastener=="printed") color("silver") for (p = boss_xy)
            translate([p[0], p[1], Zb - 0.6 + head_h]) rotate([180,0,0]) printed_screw(scr_len);
        if (stand_lock) color("silver")
            translate([lock_x, lock_y, Zb + block_t + 0.3 + head_h]) rotate([180,0,0]) printed_screw(lock_len);
    }
    color("slategray") stand();
    // desk
    %translate([0,0,-1]) cube([200, 160, 1], center=true);
}

// ---- interference checks: each should render as an empty solid ------------
chk_phase = 90;
module asm_screws(phase=chk_phase) {   // phase: screws self-align when turned; 180 is the mating pose
    for (p = boss_xy) translate([p[0], p[1], Zb - 0.6 + head_h]) rotate([180,0,phase]) printed_screw(scr_len);
    if (stand_lock) translate([lock_x, lock_y, Zb + block_t + 0.3 + head_h]) rotate([180,0,phase]) printed_screw(lock_len);
}
if (part == "chk_stand_plate") intersection() { place_case() back_plate(); stand(); }
if (part == "chk_front_back")  intersection() { front_shell(); back_plate(); }
if (part == "chk_screws_front") intersection() { front_shell(); asm_screws(); }
if (part == "chk_screws_back")  intersection() { back_plate(); asm_screws(); }
if (part == "chk_screws_stand") intersection() { stand(); place_case() asm_screws(); }
