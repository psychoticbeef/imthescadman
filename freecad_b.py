import FreeCAD as App
import FreeCADGui as Gui
import Part

doc = App.ActiveDocument
if not doc:
    doc = App.newDocument("AppleTVDesign")

# Dimensions of the Apple TV square
base_size = 93.24  # e.g. 93.24mm side
maxX = 27.14
# Convenience constant: leftover between corner's 27.14mm and total 93.24mm
gap = base_size - maxX  # = 66.10 mm

# 1) Retrieve the single corner face.

face_obj = doc.getObject("CornerFace")
if not face_obj:
    raise ValueError("Could not find an object named 'CornerFace001'.")

# Optionally, hide the original so we can see the duplicates more clearly.
face_obj.ViewObject.Visibility = False

# 2) Create four corners (Corner1..Corner4) with different placements.

#
# Corner 1: BOTTOM-RIGHT
#
corner1 = doc.addObject("Part::Feature", "Corner1")
corner1.Label = "Corner_BottomRight"
corner1.Shape = face_obj.Shape.copy()
corner1.Placement = App.Placement(App.Vector(0,0,0), App.Rotation(App.Vector(0,0,1), 0), App.Vector(0,0,0))

'''App.Placement(
    App.Rotation(App.Vector(0,0,1), 0),      # 0 degrees about Z
    App.Vector(0, 0, 0)                      # translation
)
'''
#
# Corner 2: TOP-RIGHT
#
corner2 = doc.addObject("Part::Feature", "Corner2")
corner2.Label = "Corner_TopRight"
corner2.Shape = face_obj.Shape.copy()
corner2.Placement = App.Placement(App.Vector(maxX,gap,0), App.Rotation(App.Vector(0,0,1), 90), App.Vector(0,0,0))


#
# Corner 3: TOP-LEFT
#
corner3 = doc.addObject("Part::Feature", "Corner3")
corner3.Label = "Corner_TopLeft"
corner3.Shape = face_obj.Shape.copy()
corner3.Placement = App.Placement(App.Vector(maxX-gap,maxX+gap,0), App.Rotation(App.Vector(0,0,1), 180), App.Vector(0,0,0))


#
# Corner 4: BOTTOM-LEFT
#
corner4 = doc.addObject("Part::Feature", "Corner4")
corner4.Label = "Corner_BottomLeft"
corner4.Shape = face_obj.Shape.copy()
corner4.Placement = App.Placement(App.Vector(-gap,maxX,0), App.Rotation(App.Vector(0,0,1), 270), App.Vector(0,0,0))

'''
solid1 = corner1.Shape.extrude(App.Vector(0,0,31))  # 31 mm tall
extrude_obj1 = doc.addObject("Part::Feature", "AppleTV_Corner1_Solid")
extrude_obj1.Shape = solid1
solid2 = corner2.Shape.extrude(App.Vector(0,0,31))  # 31 mm tall
extrude_obj2 = doc.addObject("Part::Feature", "AppleTV_Corner2_Solid")
extrude_obj2.Shape = solid2
solid3 = corner3.Shape.extrude(App.Vector(0,0,31))  # 31 mm tall
extrude_obj3 = doc.addObject("Part::Feature", "AppleTV_Corner3_Solid")
extrude_obj3.Shape = solid3
solid4 = corner4.Shape.extrude(App.Vector(0,0,31))  # 31 mm tall
extrude_obj4 = doc.addObject("Part::Feature", "AppleTV_Corner4_Solid")
extrude_obj4.Shape = solid4
'''

# 3) Recompute to see the changes
doc.recompute()
Gui.activeDocument().activeView().viewAxometric()
Gui.SendMsgToActiveView("ViewFit")