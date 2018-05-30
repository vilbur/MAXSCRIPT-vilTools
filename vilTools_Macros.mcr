macroScript Relax_XY
	category:"vilTools"
	toolTip:"Relax_XY"
(
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	vilTools_Relax "xy"	false	
)
macroScript Relax_XY_KeepBorder
	category:"vilTools"
	toolTip:"Relax_XY_KeepBorder"
(
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	vilTools_Relax "xy"	true	
)
macroScript Relax_X
	category:"vilTools"
	toolTip:"Relax_X"
(
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	vilTools_Relax "x"	false	
)
macroScript Relax_Y
	category:"vilTools"
	toolTip:"Relax_Y"
(
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	vilTools_Relax "y"	false	
)


macroScript selectSimilarUV
	category:"vilTools"
	toolTip:"selectSimilarUV"
(
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	selectSimilarUV()	
)

macroScript multiStichUV
	category:"vilTools"
	toolTip:"multiStichUV"
(
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	multiStichUV ()		
)
macroScript stitchRingBox

	category:"vilTools"
	toolTip:"stitchRingBox"
(
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	stitchRingBox()
	
)

macroScript SelectGeoEdges
	category:"vilTools"
	toolTip:"SelectGeoEdges"
(
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	convertUVedgeToGeo ()		
)
macroScript Convert_To_UVelement_v
	category:"vilTools"
	buttontext:"Convert to Element"
(	
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	Convert_To_UVelement_v()
)
macroScript alignByEdge
	category:"vilTools"
	buttontext:"alignByEdge"
(	
	filein "$userScripts\\vilTools\\vilTools_Unwrap_Modifiers.ms"
	alignByEdgeSelection()
)