fn TTip UIcontrol = 
(
	local TheToolTip
	case UIcontrol of
	(
		--------------------------------rollVilTools
		"btnObjPivot": TheToolTip =  "LMB: Only pivot mode\nRMB: Center Pivot"
		"btnNames": TheToolTip =  "LMB: Show Names\nRMB: Renamer Tool"
		
		
		--------------------------------Unwrap
		"btnNormalizeUV":TheToolTip = "Rescale Selected UVs or All UVs if nothing is selected \nLMB: by Pixel Density\nRMB: by Average"

	)
		
	if TheToolTip == undefined then TheToolTip = "Try It, but maybe your computer will explode..."
	TheToolTip	
)