fn vilTools_BottomBar =
(
	
			
		try (getINISetting iniFile "modifiers UV channel" "" )catch()
		try(cui.UnRegisterDialogBar vilToolsBottomBarFloater)catch() --try to unregister if already registered
		try(closeRolloutFloater vilTools_BottomBar)catch() --try to destroy the dialog if already existing
		
		vilTools_BottomBar = newRolloutFloater "vilTools_BottomBar" 1910 24 0 90
		cui.RegisterDialogBar vilTools_BottomBar style:#(#cui_dock_bottom ,#cui_floatable,#cui_handles)				
		cui.DockDialogBar  vilTools_BottomBar #cui_dock_bottom 
	
-- 		cui.UnRegisterDialogBar  vilTools_BottomBar  

	
	
	
	
	
	
	
	
	
	
	
)