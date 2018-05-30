macroScript vilTools
	category:"vilTools"
	toolTip:"vilTools"
	--icon: #("Null",1)
	icon: #("Null",1)

(
	try(vilTools_KilCallBacks())catch()		
	try(iniSave())catch()
	try(showObjectNamesOFF())catch()		
		
-- 	callbacks.removeScripts #selectionSetChanged id: #SelectionChange_CallBack_UVViewer
-- 	if InfoBoxControl == undefined then global InfoBoxControl = true

	if selection.count > 0 then 
	(
		selRefresh = for o in selection collect o
		clearselection()
	)
	
-- 	UiPath = pathConfig.GetDir #userScripts   
	
-- 	(getINISetting vil_tools_UnwrapINI "Default State" "Channel"	)
-- 	global InfoBoxSelectionOn = false
	
	global iniFile = @"$userScripts\vilTools\vilTools_INI.ini"
	global vilTools_UvViewer
	global SelectionChange_CallBack_UVViewer

	-- 	global vil_tools_UnwrapINI = UiPath + "_In\unwrapuvw.ini"
	global VilToolsFloater
	global rollVilTools
	global rollSelection
	global rollMaterials
	global rollBaking
	global rollUnwrap
	global rollUvViewer
	global rollRanmdomID
	global rollLazyWall
	

	
	global wTxt1 = ""
	global wTxt2 = ""
	global wTxt3 = ""
	global wTxt4 = ""
	global wTC1 = Yellow
	global wTC2 = Yellow	 
	global wTC3 = Yellow
	global wTC4 = Yellow


	filein (getThisScriptFilename())		

	--filein "$userScripts\\vilTools\\vilTools.mcr"			
	filein "$userScripts\\vilTools\\Lib\\old\\vilTools_INI.ms"
	filein "$userScripts\\vilTools\\Lib\\old\\vilTools_Callbacks.ms"	
	filein "$userScripts\\vilTools\\Lib\\old\\vilTools_Object.ms"
	
	filein "$userScripts\\vilTools\\Lib\\old\\vilTools_UvViewer.ms"
	filein "$userScripts\\vilTools\\Lib\\old\\vilTools_UI.ms"
	

	-- include  "$userScripts\\LazyWall\\LazyWall.mcr"		
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_INI.ms"
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_wText.ms"	
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_setRes.ms"	
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_InstanceTest.ms"
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_Object.ms"
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_SaveOrigMat.ms"
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_Unwrap_Modifiers.ms"	
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_Unwrap.ms"
-- 	include "$userScripts\\vilTools\\Lib\\old\\vilTools_Callbacks.ms"	
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_UvViewer.ms"	
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_Material.ms"		
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_SelSets.ms"		
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_Baking.ms"

-- 	filein "$userScripts\\vilTools\\Lib\\old\\vilTools_Macros.mcr"


	include "$userScripts\\vilTools\\Lib\\old\\vilTools_TTip.ms"
	include "$userScripts\\vilTools\\Lib\\old\\vilTools_Callbacks.ms"	

	include "$userScripts\\vilTools\\Lib\\old\\vilTools_UI.ms"

	vilTools_UI()

-- 	rollUvViewer.cbxViewerRefresh.state = false

	global InfoBoxControl = false
	InfoBoxToggle ()

	
	
	
	if (getfiles iniFile).count != 0 then vilToolsLoad_INI()
	else iniSave()			
	
	if selRefresh != undefined then 
	(
		selRefresh = for o in selRefresh where not isDeleted o collect o
		if selRefresh.count > 0 then select selRefresh
	)	
	vil_UvVieweroFF()

	
		------------CAllBACKS
-- /* 	
	
	PostOpenScripts()
	SelectionChange_CallBack_vilToolsUVch()
	SelectionChange_vilTools_MatID()
	vilTools_PreNodeCloned()
	vilTools_PostNodeCloned()
-- 	Enter_Subobject_CallBack()
-- 	 */
-- 	
-- 	if hasINISetting iniFile "InfoBox" "InfoBoxControl" and getINISetting iniFile "InfoBox" "InfoBoxControl" != "undefined" then (global InfoBoxControl = (getINISetting iniFile "InfoBox" "InfoBoxControl"	) as booleanclass ) else (setINISetting iniFile "InfoBox" "InfoBoxControl" "false"	)
-- 	if InfoBoxControl == "undefined" then InfoBoxControl = false
-- 	wText "Hello" sysinfo.username "" ""
	
-- 		if InfoBoxControl == true then (setINISetting iniFile "InfoBox" "InfoBoxControl"	"false";InfoBoxToggle ())	


)

