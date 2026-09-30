# Handoff: small-computer display enclosure redesign

Written 2026-09-28 for whoever picks this up next (human or another chat).
Project folder: `~/3-D Print/computer enclosure/`. Everything below is true of
the files as they sit there now. The README.md in the same folder is the
user-facing print guide; this file is the engineering trail.

## 1. What the user asked for

Hunter (hunter.chevaillier@reardenresearch.com) dropped three STLs from
`~/Downloads` (`front.stl`, `back.stl`, `foot.stl`) plus a PDF, and asked:

1. redesign it so the stand "actually goes into the back plate",
2. redesign the whole thing to be better, because the screws looked wrong,
3. print some screws,
4. fit it to "this exact computer", model unknown.

Follow-ups in the same conversation:
- "make me one with a regular angle too" -> an upright (0 degree) stand was
  exported as `stand_upright.stl`, then the user said "actually dont". The
  file was left in place and marked optional. A reclined wedge variant was
  started and deliberately abandoned; nothing of it remains.
- "are all the pegs the same on the backplate" -> no, and the user then said
  "make them align like the back plate i gave you at the start". The pegs
  were rebuilt to the original's exact geometry (section 5).

The PDF was a FedEx shipping label with personal names and addresses on it,
not a datasheet. It contains nothing about the computer. Don't reproduce its
contents anywhere.

## 2. What the original files were (measured, not guessed)

Measured with trimesh cross-sections; originals are kept untouched in
`reference/`.

| part | size (mm) | what it is |
|---|---|---|
| front | 108 x 94 x 38 | open shell: 3 mm bezel with an 86 x 65 window, 2.4 mm walls, r=4 corners, four corner posts with 2.5 mm blind holes 8.3 deep at (±49, ±42), four 4.4 mm through-holes in the -Y wall at x=±30, z=10 and 28, one 10 x 4 notch in the -Y wall at the open edge |
| back | 108 x 94 x 3 | flat plate, 3.4 mm corner holes at (±49, ±42). On the inside: a 1.5 mm rim 77.6 x 59.6 outer, 6 tall, with a 12 mm gap on the +X side; eight 5 mm posts at y=±34.5 (x = 34.5, 9.5, -12.1, -33.9), 12 tall, each with a 3 mm arm reaching inward at the top; the four at x=34.5 and 9.5 carry 2.8 mm pins 2.1 tall at y=±27.5; the four at x=-12.1 and -33.9 are plain rests ending at y=±29.9; a 12 mm U-clip (two 1.5 mm fins, 5 deep, 9.5 tall) at x -6..9, y 38..43 |
| foot | 90 x 60 x 19 | wedge, 3 mm at one end to 19 mm at the other (14.9 degrees), four 4 mm blind holes 3 to 4 mm deep on the slope at x=±30 |

The foot's holes match the four holes in the front shell's -Y (bottom) wall.
So the case sat on the wedge by its bottom wall, screen leaning back 15
degrees, and the screws had to be driven from inside the case. The foot's
holes were unthreaded and too shallow to hold an M4. That is the "screws
don't work" complaint, and it is correct. The corner M3 self-tap layout was
sound but thin (about 1.7 mm of plastic around each thread).

Nothing in these files identifies the computer. The 25 x 55 pin pattern,
74.6 x 56.6 tray and 86 x 65 window don't match a Raspberry Pi, Jetson,
LattePanda, or anything else I could name. Earlier sessions on this machine
were searched (`~/LSRV Lab`, SLANT, Mac Studio) and none mention it.

## 3. What was built

One parametric OpenSCAD file, `enclosure.scad`, with BOSL2 as a git submodule in
`./BOSL2` (copied from the `low water pickup` project; version 2.0.751).
`part=` selects the output:

| part | file | print orientation as exported |
|---|---|---|
| front | `front.stl` | bezel face down |
| back | `back.stl` | outer face down (features up) |
| stand | `stand.stl` (tilt=15) and `stand_upright.stl` (tilt=0) | on its side, z 0..70 |
| screws | `screws.stl` | heads down; 4 x 18 mm shank + 1 x 24 mm |
| fit_check | `fit_check.stl` | top 1 mm of the plate plus everything on it, z from 0 |
| assembly | preview only | standing on the desk, tilted |
| chk_* | interference tests, should render empty | see section 6 |

Design decisions and why:

- **Envelope kept at 108 x 94.** The bezel window is still 86 x 65. Interior
  clear space is 103.2 x 89.2 by 35 deep, minus four 12 mm corner bosses.
- **Back plate is 6 mm thick** (was 3) so a 4 mm dovetail groove can be cut
  into its outer face with a 2 mm floor and the plate still prints flat,
  outer face down. A raised pad on the outside was tried first and rejected
  because it would have lifted the plate off the bed.
- **Stand attaches by dovetail.** Groove 14 mm wide at the face, 12 degree
  flanks, open at the plate's bottom edge, closed 4 mm above where the tongue
  ends. Tongue is on the stand, 42 mm long, with 0.15 mm per-side clearance
  (`dt_slop`). Case lowers onto the stand and sits on a shelf; the tongue
  stops it tipping either way. Dovetail profiles are hand-written polygons
  (`dovetail_profile`), not BOSL2's `dovetail()`, so the clearance math is
  explicit.
- **Stand shape** (side profile, world frame y=back, z=up): a block 10 mm
  behind the plate, 45 mm up it, a 30 mm shelf under the bottom wall, two
  8 mm gussets reaching 45 mm back with a 4 mm foot pad. The seat is made by
  subtracting the whole case envelope with 0.3 mm clearance, then the tongue
  is unioned on afterwards (it lives inside that envelope; the first attempt
  cut it off).
- **Printed thumbscrews.** 7 mm major, 2.5 mm pitch, 1.0 mm depth,
  90 degree thread angle (45 degree flanks, prints upright), 12 mm knurled
  head with a coin slot. `trapezoidal_threaded_rod` from BOSL2. Female
  threads use `internal=true` with `$slop = thread_clear/2` (BOSL2 adds
  `2*$slop` to the radius), so 0.25 mm radial clearance. Corner bosses are
  12 mm round fused into the wall corners, threaded 14 deep. `fastener="m3"`
  swaps in 2.5 mm pilots and 3.4 mm countersunk clearance holes.
- **Stand lock screw.** Fifth thumbscrew from behind the stand, through the
  block and the plate, into an 11 mm boss on the inside of the plate. It is
  at `lock_x=20, lock_y=-38` (20 mm right of centre, 9 mm above the bottom
  edge) so it misses the groove, the U-clip and the tray. The head sits in
  the open bay between the gussets. `stand_lock=false` removes all of it.
- **Registration lip** 1.5 mm on the plate, 0.2 mm per side clearance,
  notched with squares around the corner bosses (round notches missed the
  bosses' square corner fill and collided).
- **Vents**: ten 1.6 x 20 slits in the top wall, ten 1.6 x 40 slots in the
  plate under the board, skipping the groove region.
- **Cutouts** are a list `[side, along, z, w, h]`; default is one 12 x 8
  notch at the back edge of the right wall, beside the tray's cable gap.

## 4. Coordinate frames (the part most likely to bite)

Case frame: X width, Y height with bottom = -Y, Z depth with the bezel face
at z=0, shell open edge at z=38, plate inner face at z=38, plate outer face
at `Zb = 44`. Everything in the shell and plate is modelled here; standoffs
point toward -Z.

`part="back"` outputs `rotate([180,0,0]) translate([0,0,-Zb])`, i.e. a
rotation about X: x is preserved, y is flipped. So the printed plate seen
from the inside has the same x as the case frame. The original `back.stl`
is also "print frame, features up", and its x matches the case frame
directly. That is why the peg coordinates in `standoffs` are copied verbatim
from the original.

World frame (stand and assembly): X across (mirrored, `x_w = -x_c`, so the
viewer's right is +X when looking at the screen), Y backward, Z up, desk at
z=0. `place_case()` is `multmatrix([[-1,0,0],[0,s,c],[0,c,-s]])` plus a
translation that puts the case's bottom-back edge (0, -47, 44) at
`Q = (0, shelf_t)`. `c, s = cos, sin(tilt)`. Unit vectors in (y,z):
`nv=(c,-s)` back-normal of the plate, `pv=(s,c)` up the plate, `fv=(-c,s)`
forward along the bottom wall. The stand profile is built from Q with these.

`part="stand"` outputs `rotate([0,90,0]) translate([-stand_w/2,0,0])` so a
flat side face is on the bed and z runs 0..70.

## 5. Peg rebuild (last change made)

`standoffs` entries are `[x, post_y, arm_end_y, has_pin]`. Each makes: a
`post_d=5` cylinder at (x, post_y) from the plate to `standoff_h=12`; a 3 mm
thick stadium (hull of two 5 mm circles) from (x, post_y) to (x, arm_end_y)
at the top; if `has_pin`, a pin at (x, arm_end_y), `pin_d=2.8`, `pin_h=2.1`,
tapered from 2.3 at the tip. `mount_style="screw"` instead puts a 6 mm full
height post at the arm end with a 2.2 mm hole. The U-clip is at
`clip_pos=[1.5,-40.5]`, the tray gap on +X.

Verified against the original by slicing both meshes 1.5 mm below the pin
tops and 1.5 mm into the arms: all four pin centres and all eight arm
bounding boxes are identical to one decimal.

## 6. How things were verified

- Every STL: watertight, single body, z starts at 0, extents sane
  (trimesh). Front 63 cm3, back 59, stand 63, screws 4.6 total.
- Interference: `chk_stand_plate`, `chk_front_back`, `chk_screws_front`,
  `chk_screws_back`, `chk_screws_stand` are boolean intersections. Each
  must render empty ("Current top level object is empty") or with zero
  volume (coplanar-face slivers show up as zero-volume facets; that is
  fine). All passed for tilt=15 and, for the two stand checks, tilt=0.
- Screw-vs-nut checks need the screw rotated to its mating phase or they
  always show overlap. `chk_phase=90` mates the corner screws, `225` mates
  the lock screw. Established by sweeping 0..315 in 45 degree steps.
  Physically the screw just turns until it engages, so this is only a
  modelling artefact.
- Thread clearance was confirmed by measuring the internal cutter's radii
  (2.754 / 3.754) against the rod's (2.5 / 3.5).

## 7. Tooling notes

- OpenSCAD 2026.09.12 at `/opt/homebrew/bin/openscad`. Always use
  `--backend=manifold`; threads render in seconds instead of minutes.
- System Python has no trimesh and pip is PEP-668 locked. A venv with
  `trimesh manifold3d shapely numpy` was made in the session scratchpad
  (gone now). Recreate: `python3.12 -m venv venv && venv/bin/pip install
  trimesh manifold3d shapely numpy`.
- The user's shell is zsh. `$VAR` does not word-split, so putting several
  `-D` flags in one variable passes them as a single argument and OpenSCAD
  reports a bogus "syntax error" on a line past the end of the file. Pass
  flags literally or use `${=VAR}`.
- Don't name a scratch script `inspect.py`; it shadows the stdlib and
  breaks numpy import.
- Renders: `openscad -o x.png -D 'part="..."' --camera=... --colorscheme=
  Tomorrow enclosure.scad`. Ortho top views come out looking at the wrong
  face; not worth fighting.

## 8. Status

Done and verified: all five printable STLs, README, renders, interference
checks. Nothing has been printed yet as far as I know.

Not done, because it can't be without the user:
- **Identify or measure the computer.** Until then the interior is a faithful
  copy of the original's assumptions, which may or may not fit. The user
  should print `fit_check.stl` first (about 15 minutes) and drop the board
  on it.
- Once the board is known, edit `standoffs`, `cutouts`, `window`,
  `standoff_h`, possibly `tray`/`edge_clip`, and regenerate `back.stl`,
  `front.stl`, `fit_check.stl`.
- Thread fit on the user's printer is unproven. If the printed screws are
  tight, raise `thread_clear` to 0.3 and re-export `front.stl`, `back.stl`,
  `screws.stl` (only the female side changes, but export all three to be
  safe).

Open judgement calls the next person may want to revisit:
- Whether the U-clip and tray should stay. They are there only because the
  original had them; if the real board doesn't use them, `edge_clip=false`
  and `tray_on=false` free up the floor.
- `stand_upright.stl` was asked for and then retracted in the same breath.
  It costs nothing to keep.
- The reclined "wedge under the back plate" idea (tilt near 75, no gussets,
  no lock screw) is achievable with the existing parameters if the user
  ever wants the original foot's posture back, but the stand profile was
  not tuned for it.

## 9. Regenerate everything

    cd "~/3-D Print/computer enclosure"
    for p in front back stand screws fit_check; do
      openscad --backend=manifold -o $p.stl -D "part=\"$p\"" enclosure.scad
    done
    openscad --backend=manifold -o stand_upright.stl -D 'part="stand"' -D tilt=0 enclosure.scad
