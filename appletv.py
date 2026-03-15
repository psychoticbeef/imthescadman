import sys
sys.path.append('/Users/da/.local/pipx/shared/lib/python3.12/site-packages')

import cadquery as cq

# If you have cq_hull installed:
from cq_hull import hull2D

base_size = 93.24
extrude_height = 31.0

# Corner profile points in "bottom-left" orientation:
corner_pts = [
    (0.00, 0.00),   (2.00, 0.01),   (4.00, 0.03),   (6.00, 0.09),   (8.00, 0.23),
    (10.00, 0.49),  (11.99, 0.89),  (13.98, 1.46),  (15.93, 2.21),  (17.85, 3.15),
    (19.71, 4.27),  (21.47, 5.55),  (23.13, 6.99),  (24.66, 8.57),  (26.05, 10.27),
    (27.27, 12.06), (28.33, 13.94), (29.21, 15.87), (29.89, 17.84), (30.40, 19.83),
    (30.75, 21.83), (30.96, 23.83), (31.07, 25.83), (31.12, 27.83), (31.14, 29.83)
]

def transform_corner_points(pts, corner, base_size):
    """
    Reposition a BL-oriented corner into the given corner of the square.
      corner = 'BL', 'BR', 'TL', or 'TR'.
    """
    if corner == "BL":
        # bottom-left: no transform
        return pts
    elif corner == "BR":
        # bottom-right: flip in X about base_size
        return [(base_size - x, y) for (x, y) in pts]
    elif corner == "TL":
        # top-left: flip in Y about base_size
        return [(x, base_size - y) for (x, y) in pts]
    elif corner == "TR":
        # top-right: flip both X and Y
        return [(base_size - x, base_size - y) for (x, y) in pts]
    else:
        raise ValueError("Corner must be one of: BL, BR, TL, TR")

# Build up a list of corner wires
corner_wires = []
for corner_name in ["BL", "BR", "TL", "TR"]:
    pts_2d = transform_corner_points(corner_pts, corner_name, base_size)
    wire   = cq.Workplane("XY").polyline(pts_2d).close().val()
    corner_wires.append(wire)

# Create one 2D shape by hulling all four corner wires together
shape_2d = hull2D(*corner_wires)

# Now extrude downward
final_solid = cq.Workplane("XY").add(shape_2d).extrude(-extrude_height)

show_object(final_solid, name="RoundedSquareHull")