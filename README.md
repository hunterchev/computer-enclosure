# Small-computer display enclosure, v2

Redesign of the three files that came in (`reference/front.stl`, `back.stl`,
`foot.stl`). Same 108 x 94 mm footprint and the same 86 x 65 mm display window,
but the stand now plugs into the back plate, every fastener is a printed
thumbscrew that actually has threads to bite into, and the whole thing is one
parametric OpenSCAD file so it can be re-cut for the real board.

| file | print it? | what it is |
|---|---|---|
| `enclosure.scad` | – | the generator (needs the `BOSL2/` submodule) |
| `front.stl` | yes | bezel + walls + 4 threaded corner bosses, 108 x 94 x 38 |
| `back.stl` | yes | 6 mm back plate: standoffs, tray, vents, dovetail groove |
| `stand.stl` | yes | tilt stand (15 degree lean-back), prints on its side |
| `stand_upright.stl` | optional | same stand at 0 degrees (`tilt=0`), case stands straight up |
| `screws.stl` | yes | 5 thumbscrews: 4 x 18 mm (back plate), 1 x 24 mm (stand lock) |
| `fit_check.stl` | first | just the top 1 mm of the back plate with the standoffs. 15 min print to confirm the board sits where the model thinks it does |
| `renders/` | – | previews of everything |
| `reference/` | – | the original three STLs, untouched |

## Getting the files

BOSL2 is a git submodule pinned to the commit this was built with, so clone
with it:

    git clone --recurse-submodules https://github.com/hunterchev/computer-enclosure.git

If you already cloned without it: `git submodule update --init`. The STLs
are committed, so you only need BOSL2 to change the design and re-export.

## What was wrong with the original

- **The foot screwed to the wrong part.** Its four holes lined up with four
  4.4 mm holes in the *side wall* of the front shell, so the screws had to go
  in from inside the case, behind the computer. The foot's own holes were
  4 mm, 3 to 4 mm deep, and unthreaded: an M4 in that is a friction fit,
  not a fastening.
- **The corner screws were marginal.** 2.5 mm pilots in the shell posts with
  3.4 mm clearance holes in the plate is a correct M3 self-tap layout, but
  the posts were about 6 mm across in a 2.4 mm wall, so there was ~1.7 mm of
  plastic around each thread. Usable, not durable, and it needed bought M3s.
- **Nothing located the back plate** on the shell except those four screws.
- **No ventilation and no port openings** apart from one 10 x 4 mm notch in
  the bottom wall, which the foot then covered.
- The front's mystery: an 86 x 65 window and eight pegs on the back plate
  (posts at the tray edge with arms reaching inward, four of them carrying
  2.8 mm pins on a 25 x 55 mm pattern) around a 74.6 x 56.6 mm tray. The
  pegs, tray, and the small U-clip are reproduced at the original coordinates. None of this identifies a specific computer, and the
  PDF that came with the files was a FedEx label, not a datasheet.

## What changed

**Stand.** The back plate has a 14 mm dovetail groove down its lower half,
open at the bottom edge. The stand carries the matching tongue: lower the case
onto it and it seats on the stand's shelf, leaning back 15 degrees. It cannot
tip forward or back because the tongue is captive in the groove. A fifth
thumbscrew goes through the stand into a threaded boss on the inside of the
plate as a lock, 20 mm right of centre so it misses the groove and the clip;
the head sits in the open bay between the two gussets, so it is reachable
with the case assembled. Set `stand_lock = false` to drop it.

**Fasteners.** Printed thumbscrews: 7 mm major, 2.5 mm pitch, 45 degree
flanks (prints upright, no support), 12 mm knurled head with a coin slot. The
corner bosses are 12 mm round, fused into the wall corners, threaded 14 mm
deep, so each screw engages about 12 mm of thread. The female threads are cut
with 0.25 mm radial clearance (`thread_clear`); the mating was checked by
boolean intersection in the model. If your printer runs tight, raise it to
0.3. If you would rather use metal: `fastener = "m3"` switches the bosses to
2.5 mm pilots and the plate to 3.4 mm holes with a countersink.

**Fit.** The plate has a 1.5 mm lip that enters the shell (0.2 mm per side),
so it locates itself before the screws go in.

**Cooling.** Ten slits in the top wall and ten slots in the back plate under
the board. With the case leaning back, air enters the plate slots and leaves
through the top.

**Ports.** `cutouts` is a list of `[side, along, z, w, h]`; the default is
one 12 x 8 mm notch at the back edge of the right wall, next to the tray's cable gap.

## Fitting the real computer

The interior is what the original implied, not what any datasheet says.
Measure the board and change these in `enclosure.scad`:

| variable | default | measure |
|---|---|---|
| `standoffs` | the original 8 pegs | `[x, post_y, arm_end_y, pin]`: post at the tray edge, arm reaching inward, pin on the arm end. Pins on the right pair at (34.5, ±27.5) and (9.5, ±27.5), plain rests on the left |
| `mount_style` | `"pin"` | `"screw"` gives 2.2 mm holes for M2.5 self-tappers instead of pins |
| `standoff_h` | 12 | clearance needed under the board (tallest part on its underside + 1) |
| `tray` / `tray_on` | 74.6 x 56.6 x 6 | the rim under the board, cable gap on the right; turn off if nothing lives there |
| `edge_clip` | on | the small 12 mm U-clip by the bottom wall that the original had |
| `window` | 86 x 65 | visible area of the display, plus 0.5 mm each way |
| `cutouts` | one notch | one entry per port: which wall, where along it, how far from the bezel face |
| `depth` | 38 | bezel face to plate: display + board + standoffs + 6 mm plate must fit in `depth - bezel` |

Clear interior is 103.2 x 89.2 mm by 35 mm deep (bezel inner face to plate
inner face), minus the four 12 mm corner bosses. Print `fit_check.stl` first
and drop the board on it before printing `back.stl`.

## Printing

| part | orientation | notes |
|---|---|---|
| front | bezel face down | as exported. No supports; the window chamfer is on the bed side. 0.2 mm layers, 4 walls |
| back | outer face down | as exported. The groove's undercuts print as a widening void, no supports. 4 walls, 40 % infill |
| stand | on its side | as exported (a flat side face is on the bed). 30 % infill is plenty |
| screws | heads down | as exported. 0.16 mm layers if you have them, 100 % infill or 6 walls. PETG threads better than PLA |
| fit_check | as exported | anything |

Assembly: drop the board on the pins, put the plate on (lip locates it), four
screws from the back, finger-tight. Slide the case down onto the stand's tongue,
then the lock screw from behind, between the gussets.

## Regenerating

    openscad --backend=manifold -o front.stl  -D 'part="front"'  enclosure.scad
    openscad --backend=manifold -o back.stl   -D 'part="back"'   enclosure.scad
    openscad --backend=manifold -o stand.stl  -D 'part="stand"'  enclosure.scad
    openscad --backend=manifold -o screws.stl -D 'part="screws"' enclosure.scad

`part="assembly"` previews it standing on the stand. The `chk_*` parts are
interference checks and should each come out empty (OpenSCAD prints "Current
top level object is empty"); the screw checks use `chk_phase` because a screw
at the wrong rotation always looks like it collides with its nut.
