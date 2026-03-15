import FreeCAD as App
import FreeCADGui as Gui

import FreeCAD as App
import Part

doc = App.ActiveDocument
if not doc:
    doc = App.newDocument("AppleTVDesign")

br = doc.getObject("Corner1")
tr = doc.getObject("Corner2")
tl = doc.getObject("Corner3")
bl = doc.getObject("Corner4")

br_bb = br.Shape.BoundBox
bl_bb = bl.Shape.BoundBox
tl_bb = tl.Shape.BoundBox
tr_bb = tr.Shape.BoundBox

line_br_bl = Part.LineSegment(App.Vector(br_bb.XMin, br_bb.YMin, 0), App.Vector(bl_bb.XMax, bl_bb.YMin, 0)).toShape()
line_bl_bl = Part.LineSegment(App.Vector(bl_bb.XMax, bl_bb.YMin, 0), App.Vector(bl_bb.XMin, bl_bb.YMax, 0)).toShape()
line_bl_tl = Part.LineSegment(App.Vector(bl_bb.XMin, bl_bb.YMax, 0), App.Vector(tl_bb.XMin, tl_bb.YMin, 0)).toShape()
line_tl_tl = Part.LineSegment(App.Vector(tl_bb.XMin, tl_bb.YMin, 0), App.Vector(tl_bb.XMax, tl_bb.YMax, 0)).toShape()
line_tl_tr = Part.LineSegment(App.Vector(tl_bb.XMax, tl_bb.YMax, 0), App.Vector(tr_bb.XMin, tr_bb.YMax, 0)).toShape()
line_tr_tr = Part.LineSegment(App.Vector(tr_bb.XMin, tr_bb.YMax, 0), App.Vector(tr_bb.XMax, tr_bb.YMin, 0)).toShape()
line_tr_br = Part.LineSegment(App.Vector(tr_bb.XMax, tr_bb.YMin, 0), App.Vector(br_bb.XMax, br_bb.YMax, 0)).toShape()
line_br_br = Part.LineSegment(App.Vector(br_bb.XMax, br_bb.YMax, 0), App.Vector(br_bb.XMin, br_bb.YMin, 0)).toShape()

wire = Part.Wire([line_br_bl, line_bl_bl, line_bl_tl, line_tl_tl, line_tl_tr, line_tr_tr, line_tr_br, line_br_br])
face = Part.Face(wire)
face_obj = doc.addObject("Part::Feature", "Corner_Infill")
face_obj.Label = "AppleTV_BottomRight_Corner_Infill"
face_obj.Shape = face

'''
solid = face.extrude(App.Vector(0,0,31))  # 31 mm tall
extrude_obj = doc.addObject("Part::Feature", "AppleTV_Solid")
extrude_obj.Shape = solid
'''

doc.recompute()
Gui.activeDocument().activeView().viewAxometric()
Gui.SendMsgToActiveView("ViewFit")