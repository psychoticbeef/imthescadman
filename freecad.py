import FreeCAD as App
import FreeCADGui as Gui
import Part

doc = App.ActiveDocument
if not doc:
    doc = App.newDocument("AppleTVDesign")

# For the Apple TV corner, as provided by Apple’s guidelines:
maxX = 27.14
maxY = 25.83

raw_corner_coords = [
    (0.00, 0.00), (2.00, 0.01), (4.00, 0.03), (6.00, 0.09), (7.99, 0.23),
    (9.98, 0.49), (11.93, 0.89), (13.85, 1.46), (15.71, 2.21), (17.47, 3.15),
    (19.13, 4.27), (20.66, 5.55), (22.05, 6.99), (23.27, 8.57), (24.33, 10.27),
    (25.21, 12.06), (25.89, 13.94), (26.40, 15.87), (26.75, 17.84), (26.96, 19.83),
    (27.07, 21.83), (27.12, 23.83), (27.14, 25.83)
]

# ----------------------------------------------------------
# 1) Create a BSpline for the corner, but REVERSED in order.
#    By reversing the list, it will run from (maxX, maxY) to (0,0).
# ----------------------------------------------------------
corner_coords_reversed = list(reversed(raw_corner_coords))

corner_curve = Part.BSplineCurve()
corner_curve.interpolate([
    App.Vector(x, y, 0) for (x, y) in corner_coords_reversed
])
corner_edge = corner_curve.toShape()


# ----------------------------------------------------------
# 2) Add two lines:
#    - from (0,0) to (0, maxY)
#    - from (0, maxY) to (maxX, maxY)
# ----------------------------------------------------------
lineA = Part.LineSegment(App.Vector(0, 0, 0),
                         App.Vector(0, maxX, 0)).toShape()

lineB = Part.LineSegment(App.Vector(0, maxX, 0),
                         App.Vector(maxX, maxX, 0)).toShape()

lineC = Part.LineSegment(App.Vector(maxX, maxX, 0),
                         App.Vector(maxX, maxY, 0)).toShape()

# ----------------------------------------------------------
# 3) Make a wire from these 3 edges (lineA, lineB, corner_edge).
#    The order is important so they form a closed loop:
#    (0,0) -> (0,maxY) -> (maxX,maxY) -> (0,0)
# ----------------------------------------------------------
wire = Part.Wire([lineA, lineB, lineC, corner_edge])

# ----------------------------------------------------------
# 4) Convert that closed Wire into a Face (a filled 2D shape)
# ----------------------------------------------------------
face = Part.Face(wire)
face_obj = doc.addObject("Part::Feature", "CornerFace")
face_obj.Label = "AppleTV_BottomRight_Corner_Face"
face_obj.Shape = face

# Update the document and view
doc.recompute()
Gui.activeDocument().activeView().viewAxometric()
Gui.SendMsgToActiveView("ViewFit")