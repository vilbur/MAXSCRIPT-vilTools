fn TTip UIcontrol = 
(
	local TheToolTip
	case UIcontrol of
	(
		/*
		"xxxxxxxxxxx" :  TheToolTip = "xxxxxxxxxxx"
		
		"xxxxxxxxxxx" :  TheToolTip = "LMB: xxxxxxxxxxx\nRMB: xxxxxxxxxxx"
		*/
	
		--------------------------------rollVilTools
		"btnObjPivot": TheToolTip =  "LMB: Only pivot mode\nRMB: Center Pivot"
		"btnObjPivot": TheToolTip =  "LMB: Reset Xform - Keep Instances r\nRMB: "
		"btnNames": TheToolTip =  "LMB: Show Names\nRMB: Renamer Tool"
		
		
		--------------------------------RolloutsUnwrapOptionsFN
		"btxSetGrid" :  TheToolTip = "Set grid per pixel by resolution"
		"btxSetMap" :  TheToolTip = "Show texture when editor is opened"
		"btxSetResAuto" :  TheToolTip = "Set resolution by assigned texture\nwhen editor is opened.\nYou don`t need change resolution on every object"

		
		
		--------------------------------Unwrap
		"btnEditUv":TheToolTip = "LMB: Open or Add Unwrap by object`s texture channel \nRMB: Open existing Unwrap"
		
		"btnNormalizeUV":TheToolTip = "Rescale Selected UVs or All UVs if nothing is selected \nLMB: by Pixel Density\nRMB: by Average"
		"btnPack" : TheToolTip = "LMB: Pack UVs\nRMB: Rescale and Pack\n*\nApplied on whole UVs,\nif nothing is selected"
		"btnPackOptions" : TheToolTip = "LMB: Pack Options\nRMB: Set Grid per pixel"
		
		
	)
		
	if TheToolTip == undefined then TheToolTip = "Try It, but maybe your computer will explode..."
	TheToolTip	
)