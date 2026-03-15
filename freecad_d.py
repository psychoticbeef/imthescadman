import FreeCAD as App
import FreeCADGui as Gui
import Part

doc = App.ActiveDocument
if not doc:
    doc = App.newDocument("AppleTVDesign")

corner1 = doc.getObject("Corner1")
corner2 = doc.getObject("Corner2")
corner3 = doc.getObject("Corner3")
corner4 = doc.getObject("Corner4")
infill  = doc.getObject("Corner_Infill")  # or doc.getObject("AppleTV_Solid") ?

# 1) Fuse all shapes in memory
fused_shape = corner1.Shape.fuse(
    corner2.Shape
).fuse(
    corner3.Shape
).fuse(
    corner4.Shape
).fuse(
    infill.Shape
)

# 2) Optional removeSplitter() to unify coplanar faces if possible
fused_shape_refined = fused_shape.removeSplitter()

# 3) Create a new Part::Feature with that final shape
final_obj = doc.addObject("Part::Feature","FusedFinal")
final_obj.Label = "AppleTV_Fused_Final"
final_obj.Shape = fused_shape_refined

doc.recompute()
Gui.activeDocument().activeView().viewAxometric()
Gui.SendMsgToActiveView("ViewFit")

extruded_solid = fused_shape_refined.extrude(App.Vector(0,0,31))
extrude_obj = doc.addObject("Part::Feature", "AppleTV_Extruded")
extrude_obj.Shape = extruded_solid
