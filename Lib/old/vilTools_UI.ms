-- global RollPackOptionsFN
fn RollPackOptionsFN =(	
-- 	if (getINISetting iniFile "PackOptions" "btxRotate") == "true" then	TheRotateVar = false else TheRotateVar = true
-- 	if (getINISetting iniFile "PackOptions" "btxRotate")  == "true"  then	TheFillHolesVar = false else TheFillHolesVar = true
	if (getINISetting iniFile "PackOptions" "btxPackRotate") == "" then (setINISetting iniFile "PackOptions" "btxPackRotate" "false")
	if (getINISetting iniFile "PackOptions" "btxFillHoles") == "" then  (setINISetting iniFile "PackOptions" "btxFillHoles" "false")
	if (getINISetting iniFile "PackOptions" "btxPackLinear") == "" then  (setINISetting iniFile "PackOptions" "btxPackLinear" "false")

-- 	TheFillHolesVar =  (getINISetting iniFile "PackOptions" "btxFillHoles") as booleanclass
-- 		if TheFillHolesVar == "" then TheFillHolesVar = false else  TheFillHolesVar = TheFillHolesVar as booleanclass
-- 		if TheRotateVar == "" then TheRotateVar = false else  TheRotateVar = TheRotateVar as booleanclass
-- 		
	Rollout RollPackOptions "Pack Options"
	(
-- 		checkbox btxNormalize
-- 		on btxNormalize changed val do setINISetting iniFile "PackOptions" "btxNormalize" val
-- 		val=true
		checkbox btxPackRotate "Rotate      " pos:[btX = 1, btY = 0] checked: ((getINISetting iniFile "PackOptions" "btxPackRotate") as booleanclass )
		on btxPackRotate changed val do (setINISetting iniFile "PackOptions" "btxPackRotate" (val as string))
		checkbox btxFillHoles "Fill Holes    " pos:[btX, btY += 14] checked:((getINISetting iniFile "PackOptions" "btxFillHoles") as booleanclass )
		on btxFillHoles changed val do (setINISetting iniFile "PackOptions" "btxFillHoles" (val as string) )
		checkbox btxPackLinear "Linear Packing" pos:[btX, btY += 14] checked:((getINISetting iniFile "PackOptions" "btxPackLinear") as booleanclass )
		on btxPackLinear changed val do (setINISetting iniFile "PackOptions" "btxPackLinear" (val as string) )		
	)
	CreateDialog RollPackOptions width:90 pos:[(mouse.screenpos.x-70), mouse.screenpos.y +(-30)]
-- 	setDialogPos RollPackOptions [(mouse.screenpos.x-60), mouse.screenpos.y +(-30)]
 
)


-- global RollInfoOptionsFN
fn RollInfoOptionsFN =
(	
	if (getINISetting iniFile "InfoBox" "ObjectInfo") == "" then (setINISetting iniFile "InfoBox" "ObjectInfo" "false")
	if (getINISetting iniFile "InfoBox" "InfoBoxSelection") == "" then (setINISetting iniFile "InfoBox" "InfoBoxSelection" "false")
	if (getINISetting iniFile "InfoBox" "InfoBoxModPanel") == "" then  (setINISetting iniFile "InfoBox" "InfoBoxModPanel" "false")

-- 	InfoBoxSelectionVar =  (getINISetting iniFile "InfoBox" "btxFillHoles") as booleanclass
-- 		if InfoBoxSelectionVar == "" then InfoBoxSelectionVar = false else  InfoBoxSelectionVar = InfoBoxSelectionVar as booleanclass
-- 		if InfoBoxModPanel == "" then InfoBoxModPanel = false else  InfoBoxModPanel = InfoBoxModPanel as booleanclass
-- 		
	Rollout RollInfoOptions "Info Options"
	(
-- 		checkbox btxNormalize
-- 		on btxNormalize changed val do setINISetting iniFile "InfoBox" "btxNormalize" val
		checkbox btxObjectInfo "On postion" checked: ((getINISetting iniFile "InfoBox" "ObjectInfo") as booleanclass )
		on btxObjectInfo changed val do (setINISetting iniFile "InfoBox" "ObjectInfo" (val as string);	if val then showObjectNamesON () else showObjectNamesOFF())	
		checkbox btxInfoBoxSelection "Selection" checked: ((getINISetting iniFile "InfoBox" "InfoBoxSelection") as booleanclass )
		on btxInfoBoxSelection changed val do (setINISetting iniFile "InfoBox" "InfoBoxSelection" (val as string);InfoBoxToggle ())	
		checkbox btxInfoBoxModPanel "Modify Panel" checked: ((getINISetting iniFile "InfoBox" "InfoBoxModPanel") as booleanclass )
		on btxInfoBoxModPanel changed val do (setINISetting iniFile "InfoBox" "InfoBoxModPanel" (val as string) ; InfoBoxToggle ())	
		
	)
	CreateDialog RollInfoOptions width:100 pos:[(mouse.screenpos.x-60), mouse.screenpos.y +(-30)]
-- 	setDialogPos RollInfoOptions [(mouse.screenpos.x-60), mouse.screenpos.y +(-30)]
)

fn RolloutsQueue roll val =
(	
-- 		RollQueue = #(rollVilTools.NAME,rollLazyWall.NAME,rollUnwrap.NAME,rollBaking.NAME,rollMaterials.NAME)	
-- 	roll = rollVilTools
-- 	roll = rollMaterials
-- 	roll = rollUnwrap
-- 	roll = rollBaking
-- 	roll = rollLazyWall
	if hasINISetting iniFile "RolloutsQueue" "MaxRollouts" then maxRollOpen =  (getINISetting iniFile "RolloutsQueue" "MaxRollouts") as integer 
	else maxRollOpen = VilToolsFloater.rollouts.count

	vilToolsRollouts = VilToolsFloater.rollouts
	vilToolsRolloutsNames = for r in vilToolsRollouts collect r.name
	local	Labels = "$userScripts\\vilTools\\Icons\\Labels.bmp"	
	
	if val == true and roll.name != "rollUvViewer" then		
	(		
		print ( "ROLLOUT "+ roll.name +" OPEN")
		if not hasINISetting iniFile "RolloutsQueue"  then
			setINISetting iniFile "RolloutsQueue" "RolloutsQueue" (#(roll.name)  as string) 
		else
		(		
			RollQueue = execute( getINISetting iniFile "RolloutsQueue"  "RolloutsQueue")
			if RollQueue.count >= maxRollOpen then 
			(		
				maxDif = RollQueue.count - maxRollOpen
				if maxDif > 1 then
				(
-- 					r=RollQueue[1]
					for r in vilToolsRollouts do 
					(
						i = finditem RollQueue r.name
						if i > 0 then 
						(
							deleteitem RollQueue (finditem RollQueue r.name)
							if r.name != "rollUvViewer" then r.open = false	
						)
					)
				)
				else if maxDif == 0 then
				(
					theRollout = vilToolsRollouts[finditem vilToolsRolloutsNames RollQueue[1]]
-- 					RollQueue = #()
					if theRollout.name != "rollUvViewer" then theRollout.open = false	
					deleteitem RollQueue 1
				)
				appendifunique RollQueue roll.name
				setINISetting iniFile "RolloutsQueue" "RolloutsQueue" (RollQueue as string)
			)
			else
			(
				appendifunique RollQueue roll.name
				setINISetting iniFile "RolloutsQueue" "RolloutsQueue" (RollQueue  as string) 			
			)
		)
	)
	else
	(
			RollQueue = execute(getINISetting iniFile "RolloutsQueue"  "RolloutsQueue")
			try(deleteitem RollQueue (finditem RollQueue roll.name))catch()
			setINISetting iniFile "RolloutsQueue" "RolloutsQueue" (RollQueue as string)	
	)
)

fn RolloutsUnwrapOptionsFN  =
(	
	
	if (getINISetting iniFile "UnwrapOptions" "btxSetGrid") == "" then  (setINISetting iniFile "UnwrapOptions" "btxSetGrid" "true")
	if (getINISetting iniFile "UnwrapOptions" "btxSetMap") == "" then  (setINISetting iniFile "UnwrapOptions" "btxSetMap" "true")
	if (getINISetting iniFile "UnwrapOptions" "btxSetResAuto") == "" then  (setINISetting iniFile "UnwrapOptions" "btxSetResAuto" "true")

		Rollout RolloutsUnwrapOptions "Pack Options"
		(
			checkbox btxSetGrid "Set Grid         " pos:[btX=1, btY=0] checked: ((getINISetting iniFile "UnwrapOptions" "btxSetGrid") as booleanclass ) tooltip:(tTip "btxSetGrid")
			on btxSetGrid changed val do (setINISetting iniFile "UnwrapOptions" "btxSetGrid" (val as string))		

			checkbox btxSetMap "Set Texture      " pos:[btX, btY+=16] checked: ((getINISetting iniFile "UnwrapOptions" "btxSetMap") as booleanclass ) tooltip:(tTip "btxSetMap")
			on btxSetMap changed val do (setINISetting iniFile "UnwrapOptions" "btxSetMap" (val as string))	
				
			checkbox btxSetResAuto "Set Resolution" pos:[btX, btY+=16] checked: ((getINISetting iniFile "UnwrapOptions" "btxSetResAuto") as booleanclass ) tooltip:(tTip "btxSetResAuto")
			on btxSetResAuto changed val do (setINISetting iniFile "UnwrapOptions" "btxSetResAuto" (val as string))					
		)
		CreateDialog RolloutsUnwrapOptions width:100 pos:[(mouse.screenpos.x-90), mouse.screenpos.y +(-30)]
		
	
)

fn vilTools_UI =	--start
(
		global	Label_Line = "$userScripts\\vilTools\\Icons\\Label_Line.bmp"
		
		try (getINISetting iniFile "modifiers UV channel" "" )catch()
		try(cui.UnRegisterDialogBar VilToolsFloater)catch() --try to unregister if already registered
		try(closeRolloutFloater VilToolsFloater)catch() --try to destroy the dialog if already existing
		
		VilToolsFloater = newRolloutFloater "VilToolsFloater" 270 1000 0 90
		cui.RegisterDialogBar VilToolsFloater style:#(#cui_dock_left,#cui_dock_right,#cui_floatable,#cui_handles)				
		cui.DockDialogBar  VilToolsFloater #cui_dock_right
		
	global outPutPathText = ""	
	
	rollout rollVilTools "vilTools" rolledup: on	--start
	(
		local	Labels = "$userScripts\\vilTools\\Icons\\Labels.bmp"
        on rollVilTools rolledUp val do  RolloutsQueue rollVilTools val

		-----------------------REMOTE CONTROLS-------------------------------------------------------------
		local OsetTools = 18
		
		button btnDockL "<>" width:32 height: 16  pos:[btx=0,0]	tooltip:"Dock left"-- border:false
			on btnDockL pressed do (cui.RegisterDialogBar VilToolsFloater;cui.DockDialogBar  VilToolsFloater #cui_dock_left)
			on btnDockL rightclick do (cui.RegisterDialogBar VilToolsFloater;cui.DockDialogBar  VilToolsFloater #cui_dock_right)
		
		spinner spnMaxRollouts "Rollouts" range:[1,10,5]  type:#integer  fieldWidth: 20  pos:[btx+=40,2] 		
			on  spnMaxRollouts changed  val do setINISetting iniFile "RolloutsQueue" " MaxRollouts" (val as string)
			on  spnMaxRollouts entered  do setINISetting iniFile "RolloutsQueue" " MaxRollouts" (rollVilTools.spnMaxRollouts.value as string)
	
		button btnDef "def" width:20 height: 16  pos:[btx+=140,0] tooltip:"Load defaults" --border:false
			on btnDef pressed do ( try(cui.UnRegisterDialogBar VilToolsFloater)catch();closeRolloutFloater VilToolsFloater;deletefile iniFile ;macros.run "vilTools" "vilTools")
		button btnFloat "~" width:16 height: 16  pos:[btx+=30,0] tooltip:"Floatable window" --border:false
			on btnFloat pressed do (try(cui.UnRegisterDialogBar VilToolsFloater)catch())
		button btnclose "x" width:16 height: 16  pos:[btx+=20,0] tooltip:"Close window" --border:false
			on btnclose pressed do 
				(
					callbacks.removeScripts #selectionSetChanged  id: #SelectionChange_CallBack_UVViewer
					iniSave()
					vilTools_KilCallBacks()
					try(cui.UnRegisterDialogBar VilToolsFloater)catch();closeRolloutFloater VilToolsFloater
				)	
				
		button btnObjPivot "" width:48 height: 24 pos:[btY=3,OsetTools]	images:#(Labels,undefined,40,7,7,7,0)  pos:[114,gPosObj+24] tooltip:(tTip "btnObjPivot") border:false
			on btnObjPivot pressed do (if maxops.pivotmode != #pivotonly;then maxops.pivotmode = #pivotonly; else maxops.pivotmode = #none)
			on btnObjPivot rightclick  do (for i in selection do i.pivot = i.center)		
		button btnObjXform "" width:48  height: 24  pos:[btY+=50,OsetTools]	images:#(Labels,undefined,40,6,6,6,0)  pos:[68,gPosObj+24] tooltip:(tTip "btnObjXform") border:false
			on btnObjXform pressed do objXformNormal ()
-- 		button btnObjNormal "" width:48  height: 24	pos:[btY+=50,OsetTools] images:#(Labels,undefined,40,8,8,8,0)  pos:[150,gPosObj+24] border:false		 		
		
		button btnNames "" width:48  height: 24   pos:[btY+=50,OsetTools] images:#(Labels,undefined,40,20,20,20,0) tooltip:(tTip "btnNames")  border:false	--images:#(Labels,undefined,40,2,2,2,0)
			on btnNames pressed do (if showObjectNamesCallback == undefined or showObjectNamesCallback == false then showObjectNamesON() else showObjectNamesOFF ())
			on btnNames rightclick  do macros.run "Tools" "RenameObjects"
	

-- 			on btnInfo rightclick  do macros.run "Tools" "RenameObjects"

				
	) --end
	
	rollout rollSelection "Selection Tools" rolledup: on	--start
	(
        on rollSelection rolledUp val do  RolloutsQueue rollSelection val
		local	Labels = "$userScripts\\vilTools\\Icons\\Labels.bmp"
		
		button btnSelSetAdd "Add" width:24 height:24 pos:[bu=4,bv=4]  images:#(Labels,undefined,80,23,23,23,0)  border:false
			on btnSelSetAdd pressed do selSetAdd 0
			on btnSelSetAdd rightclick do selSetAdd 1
		button btnSelSetRem "Rem" width:24 height:24 pos:[bu+=32,bv]  images:#(Labels,undefined,80,24,24,24,0)  border:false
			on btnSelSetRem pressed do selSetRem 0
			on btnSelSetRem rightclick do selSetRem 1
		button btnSelSetSel "Select" width:24 height:24 pos:[bu+=32,bv] images:#(Labels,undefined,80,25,25,25,0)  border:false
			on btnSelSetSel pressed do selSetSelectByObject()
			on btnSelSetSel rightclick do selSetSelectGoThrough()

-- 			on btnSelSetSel pressed do print "btnSelSetSel: LeftClick"
-- 			on btnSelSetSel rightclick do print "btnSelSetSel: RightClick"		
			
			
-- 		button btnWirecolor "Wirecolor" width:24 height:24 pos:[bu+=32,bv] images:#(Labels,undefined,80,26,26,26,0)   border:false
			
	
			button btnInfo "" width:24  height: 24   pos:[bu+=32,bv] images:#(Labels,undefined,80,27,27,27,0)  tooltip:(tTip "btnInfo")  border:false	--images:#(Labels,undefined,40,2,2,2,0)
			on btnInfo pressed do InfoBoxToggle ()
			on btnInfo rightclick do  RollInfoOptionsFN ()
																						
																						
		button btnSelSetDialog "Dialog" width:24 height:24 pos:[bu+=32,bv]   images:#(Labels,undefined,80,28,28,28,0)  border:false
				on btnSelSetDialog pressed do macros.run  "Edit" "namedSelSets" 
-- 				on btnSelSetDialog rightclick do

				
	)--ends
				
	rollout rollMaterials "Materials & Textures" rolledup: on	--start
	(
		
		on rollMaterials rolledUp val do  RolloutsQueue rollMaterials val

		local UnwrapIcons = "$userScripts\\vilTools\\Icons\\UnwrapIcons.bmp"
		local CheckerIcons = "$userScripts\\vilTools\\Icons\\CheckerIcons.bmp"
		local channelIcons = "$userScripts\\vilTools\\Icons\\ChannelIcons.bmp"
		local Labels = "$userScripts\\vilTools\\Icons\\Labels.bmp"
		local NumbersFade = "$userScripts\\vilTools\\Icons\\NumbersID_F.bmp"
		local NumbersBlue = "$userScripts\\vilTools\\Icons\\NumbersID_B.bmp"
		
				------------------------------------MATERIALS & TEXTURES-----------------------------------------------			
		button btnChecker "1" width:32 height:32 pos:[btx=0,4] images:#(CheckerIcons,undefined,5,1,1,1,0)  border:false tooltip:"512"
				on btnChecker pressed do  vil_checker "LMB"
				on btnChecker rightclick do  vil_checker "RMB" 
		
		button btnCircleCh "10" width:32 height:32 pos:[btx+=32,4]  images:#(channelIcons,undefined,10,10,10,10,0)  border:false 
					on btnCircleCh pressed do Circle_UvChannel 1
					on btnCircleCh rightclick do Circle_UvChannel (-1)
	
		button btnDiffuse "" width:32 height:32 pos:[btx+=32,4]  images:#(UnwrapIcons,undefined,8,3,3,3,0)  border:false tooltip:"LMB: toogle diffuse on SELECTED object`s material \nRMB: toogle diffuse on SCENE"
				on btnDiffuse pressed do vil_textureToggle "Selected" 
				on btnDiffuse rightclick do vil_textureToggle "Scene" 


		button btnPasteClip "" width:32 height:32  pos:[btx+=32,4] images:#(UnwrapIcons,undefined,8,4,4,4,0)  border:false 
				on btnPasteClip pressed do MapFromClipboard()
				on btnPasteClip rightclick do revertOrigMat()

		button tblank5 "" width:32  height: 32   pos:[btx+=32,4] border:false	--images:#(Labels,undefined,40,2,2,2,0)
		button tblank6 "" width:32  height: 32   pos:[btx+=32,4] border:false	--images:#(Labels,undefined,40,2,2,2,0)
		button tblank7 "" width:32  height: 32   pos:[btx+=32,4] border:false	--images:#(Labels,undefined,40,2,2,2,0)
		button tblank8 "" width:32  height: 32   pos:[btx+=32,4] border:false	--images:#(Labels,undefined,40,2,2,2,0)
	
	
		local OsetID = 38

			
		--------------MATERIAL ID`s							
				
		button btnMatID "" width:52  height: 22   pos:[btx=0,OsetID] images:#(Labels,undefined,40,10,10,10,0) border:false  tooltip:"RMB: Random Material Dialog"
			on btnMatID rightclick do  RandomMatIDRollout ()
			
		button MatID1 "" width:22  height: 22   pos:[btx+=54,OsetID] images:#(NumbersFade,undefined,9,1,1,1,0) border:false
			on MatID1 pressed do  (setMatID 1 ; SelectionChange_vilTools_MatIDFN())
			on MatID1 rightclick do  (getMatID 1)
		button MatID2 "" width:22  height: 22   pos:[btx+=22,OsetID] images:#(NumbersFade,undefined,9,2,2,2,0) border:false
			on MatID2 pressed do  (setMatID 2 ; SelectionChange_vilTools_MatIDFN())
			on MatID2 rightclick do  (getMatID 2)
		button MatID3 "" width:22  height: 22   pos:[btx+=22,OsetID] images:#(NumbersFade,undefined,9,3,3,3,0) border:false
			on MatID3 pressed do  (setMatID 3 ; SelectionChange_vilTools_MatIDFN()) 
			on MatID3 rightclick do  (getMatID 3)
		button MatID4 "" width:22  height: 22   pos:[btx+=22,OsetID] images:#(NumbersFade,undefined,9,4,4,4,0) border:false					
			on MatID4 pressed do  (setMatID 4 ; SelectionChange_vilTools_MatIDFN()) 
			on MatID4 rightclick do  (getMatID 4)
		button MatID5 "" width:22  height: 22   pos:[btx+=22,OsetID] images:#(NumbersFade,undefined,9,5,5,5,0) border:false
			on MatID5 pressed do  (setMatID 5 ; SelectionChange_vilTools_MatIDFN()) 
			on MatID5 rightclick do  (getMatID 5)
		button MatID6 "" width:22  height: 22   pos:[btx+=22,OsetID] images:#(NumbersFade,undefined,9,6,6,6,0) border:false
			on MatID6 pressed do  (setMatID 6 ; SelectionChange_vilTools_MatIDFN()) 
			on MatID6 rightclick do  (getMatID 6)
		button MatID7 "" width:22  height: 22   pos:[btx+=22,OsetID] images:#(NumbersFade,undefined,9,7,7,7,0) border:false
			on MatID7 pressed do  (setMatID 7 ; SelectionChange_vilTools_MatIDFN())
			on MatID7 rightclick do  (getMatID 7)
		button MatID8 "" width:22  height: 22   pos:[btx+=22,OsetID] images:#(NumbersFade,undefined,9,8,8,8,0) border:false		
			on MatID8 pressed do  (setMatID 8 ; SelectionChange_vilTools_MatIDFN()) 
			on MatID8 rightclick do  (getMatID 8)
		button MatID9 "" width:22  height: 22   pos:[btx+=22,OsetID] images:#(NumbersFade,undefined,9,9,9,9,0) border:false		
			on MatID9 pressed do  (setMatID 9 ; SelectionChange_vilTools_MatIDFN())
			on MatID9 rightclick do  (getMatID 9)
				
				
	)	--end rollout
	 
	rollout rollUnwrap "Unwrap" rolledup: on--start
	(
		on rollUnwrap rolledUp val do  RolloutsQueue rollUnwrap val

		local Numbers_green = "$userScripts\\vilTools\\Icons\\Numbers_green.bmp"
		local Numbers_blue = "$userScripts\\vilTools\\Icons\\Numbers_blue.bmp"		
		local UvEditorIcons = "$userScripts\\vilTools\\Icons\\UvEditor_G.bmp"
		local Unwrap_Small = "$userScripts\\vilTools\\Icons\\Unwrap_Small.bmp"
		local UV_ToolsIcons = "$userScripts\\vilTools\\Icons\\UV_ToolsIcons.bmp"
		local Labels = "$userScripts\\vilTools\\Icons\\Labels.bmp"
		local ResolutionIco = "$userScripts\\vilTools\\Icons\\Resolution.bmp"

			------------TEMPORARY
		local UvChannelNoIco = "$userScripts\\vilTools\\Icons\\UvChannelNo.bmp"
		local AoSamples = "$userScripts\\vilTools\\Icons\\AoSamples.bmp"
			
-- 		button lblUV1 ""  width:256  height:1  pos:[0,btY=0]  border:true --images:#(Label_Line,undefined,1,1,1,1,0) 				

		button btnEditUv "Edit" width:46 pos:[btx=4,btY=2]  images:#(UvEditorIcons,undefined,6,1,1,1,0) border:false
			on btnEditUv pressed do vil_Unwrap_add (getTextureChannel "")
			on btnEditUv rightclick do (uv = modpanel.getcurrentobject (); if classof uv == Unwrap_UVW then uv.edit ())


				
		button btnUnwrapAdd1 "UV 1" width:46 pos:[btx+=46,btY]  images:#(UvEditorIcons,undefined,6,2,2,2,0)	border:false
			on btnUnwrapAdd1 pressed do setModifierChannel 1		
			on btnUnwrapAdd1 rightclick do vil_Unwrap_add 1
	
		button btnUnwrapAdd2 "UV 2" width:46 pos:[btx+=46,btY]  images:#(UvEditorIcons,undefined,6,3,3,3,0)   border:false
			on btnUnwrapAdd2 pressed do setModifierChannel 2			
			on btnUnwrapAdd2 rightclick do vil_Unwrap_add 2
		
		button btnUnwrapAdd3 "UV 3" width:46 pos:[btx+=46,btY]  images:#(UvEditorIcons,undefined,6,4,4,4,0)   border:false
			on btnUnwrapAdd3 pressed do setModifierChannel 3			
			on btnUnwrapAdd3 rightclick do vil_Unwrap_add 3
	
		button btnUnwrapAdd4 "UV 4" width:46 pos:[btx+=46,btY]  images:#(UvEditorIcons,undefined,6,5,5,5,0)   border:false
			on btnUnwrapAdd4 pressed do setModifierChannel 4			
			on btnUnwrapAdd4 rightclick do vil_Unwrap_add 4
		
-- 		button btnUnwrapAdd5 "UV 5" width:40 pos:[btx+=40,btY]  images:#(UvEditorIcons,undefined,6,6,6,6,0)   border:false
-- 			on btnUnwrapAdd5 pressed do setModifierChannel 5			
-- 			on btnUnwrapAdd5 rightclick do vil_Unwrap_add 5
		
-- 		button btnWrapOptions "..." width:16 height:24 pos:[btx+=48,btY+1] tooltip: ( tTip "btnPackOptions")  border:false 
-- 			on btnWrapOptions pressed do RolloutsUnwrapOptionsFN ()
-- 			on btnWrapOptions rightclick do SetUVGrid ()
			
			
			checkbox btxSetGrid "Grid" pos:[btX=2, btY+=22] tooltip:(tTip "btxSetGrid")
			on btxSetGrid changed val do (setINISetting iniFile "UnwrapOptions" "btxSetGrid" (val as string))		
-- 			
			checkbox btxSetElement "Element" pos:[btX+=45,btY] tooltip:(tTip "btxSetElement")
			on btxSetElement changed val do (
				setINISetting iniFile "UnwrapOptions" "btxSetElement" (val as string)
				
				
				if val then (try(((modPanel.getCurrentObject()).setTVElementMode true))catch() )else (try(((modPanel.getCurrentObject()).setTVElementMode false))catch())
				
											)		
-- 			
			checkbox btxSetMap "Texture" pos:[btX+=65, btY] tooltip:(tTip "btxSetMap")
			on btxSetMap changed val do (setINISetting iniFile "UnwrapOptions" "btxSetMap" (val as string))	
-- 				
			checkbox btxSetResAuto "Resolution" pos:[btX+=70, btY] tooltip:(tTip "btxSetResAuto")
			on btxSetResAuto changed val do (setINISetting iniFile "UnwrapOptions" "btxSetResAuto" (val as string))		
			
			
			
		button lblUV2 ""  width:256  height:1  pos:[0,btY+=20]  border:true images:#(Label_Line,undefined,1,1,1,1,0)  border:false
			
		button btnUVOffSet "OffSet" width:48  height:20	images:#(Labels,undefined,40,1,1,1,0)  pos:[0,btY+=5] border:false
		button btnUVScale  "Scale" width:48  height:20  images:#(Labels,undefined,40,2,2,2,0)  pos:[50,btY] border:false
		button btnUVRotate "Rotate" width:48  height:20	images:#(Labels,undefined,40,3,3,3,0)  pos:[100,btY] border:false
		button btnUVMirror "Mirror" width:48  height:20	images:#(Labels,undefined,40,4,4,4,0)  pos:[150,btY] border:false	 
		button btnUVRand "Random" width:52 height:20 images:#(Labels,undefined,40,5,5,5,0) pos:[198,btY]	border:false
			on btnUVrand pressed do random_UV_vt()	
	
		spinner Uscale "U" range:[-100,100,0.50]  type:#float scale: 0.01 fieldWidth: 30  pos:[btx=2,btY+=25] 		
		button btnLinkLabel  width:16  height:16  pos:[btx+=50,btY] images:#(Unwrap_Small,undefined,4,1,1,1,0) border:true
			
		spinner Vscale "V" range:[-100,100,0.50]  type:#float scale: 0.01 fieldWidth: 30  pos:[btx+=20,btY] 	
		button btnRotateLabel  width:16  height:16  pos:[btx+=50,btY] images:#(Unwrap_Small,undefined,4,3,3,3,0) border:false
		spinner UVRotate "" range:[-360,360,90]  type:#integer scale: 45 fieldWidth: 27  pos:[btx+=16,btY] 
		checkbox UVrandElement "Element" checked:true pos:[btx+=50,btY] 		

		-------------------------------------------------------------------------------------------------------------
			
		button lblUV3 ""  width:256  height:1  pos:[0,btY+=22]  border:true --images:#(Label_Line,undefined,1,1,1,1,0)  border:false

		button btnMapPlanarX "" width:30 height:32  pos:[btx=0,btY+=2] images:#(UV_ToolsIcons,undefined,24,1,1,1,0) tooltip:""  border:false
-- 				on btnUvBox pressed do UnFoaldBox()
		button btnMapPlanarY"" width:30 height:32  pos:[btx+=30,btY] images:#(UV_ToolsIcons,undefined,24,2,2,2,0) tooltip:""  border:false
-- 				on btnUvCyl pressed do UnFoaldCylinder()
		button btnMapPlanarZ"" width:30 height:32  pos:[btx+=30,btY] images:#(UV_ToolsIcons,undefined,24,3,3,3,0) tooltip:""  border:false

		button btnMapCylinderX "" width:30 height:32  pos:[btx+=30,btY] images:#(UV_ToolsIcons,undefined,24,4,4,4,0) tooltip:""  border:false
-- 				on btnUvBox pressed do UnFoaldBox()
		button btnMapCylinderY"" width:30 height:32  pos:[btx+=30,btY] images:#(UV_ToolsIcons,undefined,24,5,5,5,0) tooltip:""  border:false
-- 				on btnUvCyl pressed do UnFoaldCylinder()
		button btnMapCylinderZ"" width:30 height:32  pos:[btx+=30,btY] images:#(UV_ToolsIcons,undefined,24,6,6,6,0) tooltip:""  border:false


		button btnUvCopyFrom "1" width:20 height:32 pos:[btx+=32,btY] images:#(Numbers_green,undefined,9,1,1,1,0) 	border:false 
			on btnUvCopyFrom pressed do setRes "UVcopyFrom" 1 9
			on btnUvCopyFrom rightclick do setRes "UVcopyFrom" -1 9

		button btnUvCopy "" width:30 height:32 pos:[btx+=20,btY] images:#(Labels,undefined,40,11,11,11,0) tooltip:"Copy UV`s on 1 or more same object`s \nLMB: Copy green to blue \nRMB: Copy blue to green"	border:false 
			on btnUvCopy pressed do ( global wTC1 = (color 47 166 34)/*green*/ ;global wTC2 = (color 61 135 195)/*blue*/;vilTools_UV_Copy ((rollUnwrap.btnUvCopyFrom.text) as integer)  ((rollUnwrap.btnUvCopyTo.text) as integer) 	)
-- 			on btnUvCopy rightclick do (global wTC1 = (color 61 135 195)/*blue*/;global wTC2 = (color 47 166 34)/*green*/ ;vilTools_UV_Copy ((rollUnwrap.btnUvCopyTo.text) as integer)   ((rollUnwrap.btnUvCopyFrom.text) as integer)  	)
			on btnUvCopy rightclick do ( global wTC2 = (color 47 166 34)/*green*/ ;global wTC1 = (color 61 135 195)/*blue*/;vilTools_UV_Copy ((rollUnwrap.btnUvCopyTo.text) as integer) ((rollUnwrap.btnUvCopyFrom.text) as integer)   	)
				
	
		button btnUvCopyTo "2" width:20 height:32 pos:[btx+=30,btY] images:#(Numbers_blue,undefined,9,2,2,2,0) border:false 
			on btnUvCopyTo pressed do setRes "UVcopyTo" 1 9
			on btnUvCopyTo rightclick do setRes "UVcopyTo" -1 9
				
		button lblUV4 ""  width:256  height:1  pos:[0,btY+=34]  border:true --images:#(Label_Line,undefined,1,1,1,1,0)  border:false

-- 		button btnUvPlanX "" width:32 height:32  pos:[btx=0,btY] images:#(UV_ToolsIcons,undefined,24,1,1,1,0) tooltip:""  border:false
-- 		on btnUvCyl pressed do UnFoaldCylinder()
-- 		button btnRelax "" width:48  height:24	images:#(Labels,undefined,40,17,17,17,0)  pos:[btx = 0, btY += 32] border:false
-- 			on btnRelax pressed do vilTools_Relax "xy"
-- 		button btnRelaxXY "" width:32  height:24	images:#(Labels,undefined,80,35,35,35,0)  pos:[btx = 0 ,btY+=32 ] border:false
-- 			on btnRelaxXY pressed do vilTools_Relax "x"
-- 			on btnRelaxXY rightclick do vilTools_Relax "y"
		button btnNormalizeUV "" width:56  height:24	images:#(Labels,undefined,40,19,19,19,0)  pos:[btx = 2, btY+=6] tooltip: ( tTip "btnNormalizeUV") border:false 
			
			on btnNormalizeUV pressed do normalizeUVs false
			on btnNormalizeUV rightclick do normalizeUVs true

-- 			button btnUvChNorm "1" width:48 height:20 pos:[btx += 48, btY] images:#(UvChannelNoIco,undefined,10,1,1,1,0)  tooltip: "1" border:false
-- 			on btnUvChNorm pressed do setRes "UvCh" 1 10
-- 			on btnUvChNorm rightclick do setRes "UvCh" -1 10
		button btnResNorm "1024" width:46  height: 24 pos:[btx += 56, btY] images:#(ResolutionIco,undefined,5,3,3,3,0)  tooltip: "1024" border:false		
			on btnResNorm pressed do setRes "ResBake" 1 5
			on btnResNorm rightclick do setRes "ResBake" -1 5
-- 		button btnDensity "256"   width:32   height:24 pos:[btx +=48, btY] images:#(AoSamples,undefined,7,6,6,6,0) tooltip: "256" border:false
-- 			on btnDensity pressed do setRes "Samples" 1 7
-- 			on btnDensity rightclick do setRes "Samples" -1 7			

		spinner spnPxDensity "Px/m" range:[0,16384,256]  type:#integer fieldWidth: 36   pos:[btx +=48, btY+4]
			on spnPxDensity changed  val inSpin_arg do setPxDensity val inSpin_arg
			on spnPxDensity entered  do (setINISetting iniFile "SpinnerControl" "spnPxDensity" (rollUnwrap.spnPxDensity.value as string))	
			on spnPxDensity buttonup inCancel_arg do (if not inCancel_arg then setINISetting iniFile "SpinnerControl" "spnPxDensity" (0 as string))
		
		button btnPack "" width:24 height:24 pos:[btx+=76,btY+1] images:#(Labels,undefined,80,36,36,36,0) tooltip: ( tTip "btnPack")  border:false 
			on btnPack pressed do PackUVs_Vt "LMB"
			on btnPack rightclick do PackUVs_Vt "RMB"
				
		spinner spnPadingUV "" range:[0,256,6]  type:#integer fieldWidth:22   pos:[btx +=22, btY+4]
			on spnPadingUV changed  val inSpin_arg do setSpnPadding val inSpin_arg --setSpnPadding val 
-- 			on spnPadingUV entered do (setSpnPadding rollBaking.spnPadding.value false) --setSpnPadding val 

		button btnPackOptions "..." width:16 height:24 pos:[btx+=36,btY+1] tooltip: ( tTip "btnPackOptions")  border:false 
			on btnPackOptions pressed do RollPackOptionsFN ()
			on btnPackOptions rightclick do SetUVGrid ()

			
	)--end rollout
	

	
	rollout rollUvViewer "UV Viewer"	 rolledup: on 	--start
	(
			
--         on rollUvViewer rolledUp val do  RolloutsQueue rollUvViewer val
		on rollUvViewer rolledUp val do 
		(
			if val then
			(
				RolloutsQueue rollUvViewer val
				vil_UvViewer()
			)
			else 
			(
				RolloutsQueue rollUvViewer val
-- 				vil_UvVieweroFF()
			)
		)
		
		Label rbtnUvwViewerUvCh "Channel" pos:[1,5] 

		radiobuttons rbtnUvwViewer labels:#("1","2","3","4","5") default:1 columns:5 pos:[43,5]
				on rbtnUvwViewer changed true do  vil_UvViewer()
					

		checkbox cbxViewerRefresh "Refresh" checked:false pos:[194,5] 
			on cbxViewerRefresh changed theState  do  -- vil_UvViewer()
			(
				if theState == true then
				(
					
					vil_UvViewer()
					SelectionChange_CallBack_UVViewer()
				)
				else
				(
					try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_CallBack_UVViewer)catch()
					vil_UvVieweroFF()	
				)
		--	on cbxViewerRefresh changed false do 	callbacks.removeScripts id: #RefreshCallback
			)

		button btnUvViewer "Show UV`s!" width:254 height:254  pos:[0,25]
			on btnUvViewer pressed do 	(
											
										--	filein "$userScripts\\vil_develop\\vil_Instance_Test.ms"
										--	callbacks.addScript #selectionSetChanged "UvViewer()" id: #UvViewer
-- 											rollUvViewer.cbxViewerRefresh.state = (getINISetting iniFile "vil_UvViewer" "State" ) as booleanclass
											vil_UvViewer()
											
										)
			on btnUvViewer rightclick do 
			(
				if UvViewerSwitch == 0 then
					(
						rollUvViewer.open = false
						
					)
				else
				(
					try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_CallBack_UVViewer)catch()
-- 					rollUvViewer.cbxViewerRefresh.state = false
					vil_UvVieweroFF()
					print "Viewer OFF"
					setINISetting iniFile "vil_UvViewer" "State" (rollUvViewer.cbxViewerRefresh.state as string)
				)
			)

-- 		on rollUvViewer rolledUp val do if val then try(UvViewer())catch() else try(vil_UvVieweroFF())catch()
				
	)	--end rollout
	
		-------------------------------------------------------BAKING----------------------------------------------------------------
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-	
	rollout rollBaking "Baking" rolledup: on 	--start
	(	
		on rollBaking rolledUp val do  RolloutsQueue rollBaking val

		local bakeIcons = "$userScripts\\vilTools\\Icons\\BakeIcons.bmp"
		local UvChannelNoIco = "$userScripts\\vilTools\\Icons\\UvChannelNo.bmp"
		local BakeResolutionIco = "$userScripts\\vilTools\\Icons\\BakeResolution.bmp"
		local AoPreviewIco = "$userScripts\\vilTools\\Icons\\AoPreview.bmp"
		local AoSamples = "$userScripts\\vilTools\\Icons\\AoSamples.bmp"

		----------------------------------------------PROPERTIES SETUP----------------------------------------------	
		
		checkbox cbxVfb "Show"  pos:[Xb= 5,Yb=2] checked:true
		checkbox cbxCopy "ClipBoard"  pos:[Xb+=83,Yb] checked:true
		checkbox cbxOpenPS "PhotoShop"  pos:[Xb+=86,Yb] 
			on cbxOpenPS changed val do checkPhotoshop val
		
	
		checkbox cbxSetMat "Material"  pos:[Xb = 5,Yb+=22] checked:true
		checkbox cbxSetCompose "Compose"  pos:[Xb += 83,Yb] 
		checkbox cbxSetProjection "Projection"  pos:[Xb +=86,Yb] 
		
		
		button lblbake1 "_______________________________________________________________"  width:256  height:3  pos:[0,Yb+=18]  border:true  images:#(Label_Line,undefined,1,1,1,1,0) 

-- 		
-- 		----------------------------------------------RENDER SETUP----------------------------------------------	
		button btnUvCh "1" width:48 height:24  pos:[Xb=8,Yb+=5] images:#(UvChannelNoIco,undefined,10,1,1,1,0)  tooltip: "1" border:false
			on btnUvCh pressed do setRes "UvCh" 1 10
			on btnUvCh rightclick do setRes "UvCh" -1 10
		button btnResBake "1024" width:96  height: 24 pos:[Xb+=55,Yb] images:#(BakeResolutionIco,undefined,5,3,3,3,0)  tooltip: "1024" border:false		
			on btnResBake pressed do setRes "ResBake" 1 5
			on btnResBake rightclick do setRes "ResBake" -1 5			
		button btnSamples "256"  pos:[Xb+=105,Yb] width:32   height:24 images:#(AoSamples,undefined,7,6,6,6,0) tooltip: "256" border:false
			on btnSamples pressed do setRes "Samples" 1 7
			on btnSamples rightclick do setRes "Samples" -1 7		
		colorpicker BgColor "" fieldWidth: 32 height: 14 color:[0,0,0] pos:[210,Yb+5] modal:false
-- 				
-- 		----------------------------------------------BAKE BUTTONS----------------------------------------------
-- 			
-- 	
		button btnRenderDi "Diffuse Map"  width:34 height:32 border:false pos:[btx=5,Yb+= 24] images:#(bakeIcons,undefined,7,1,1,1,0) tooltip:"Diffuse Map"
				on btnRenderDi pressed do RenderButton "Di"
		button btnRenderNM "Normal Map"  width:34 height:32 border:false pos:[btx+=44,Yb]  images:#(bakeIcons,undefined,7,2,2,2,0) tooltip:"Normal Map"
			
		button btnRenderAO "Ambient Occluison"  width:34  height:32 border:false pos:[btx+=44,Yb]  images:#(bakeIcons,undefined,7,6,6,6,0) tooltip:"Ambient Occluison"
				on btnRenderAO pressed do RenderButton "Ao"
				on btnRenderAO rightclick do RenderButton "AoPrev"

		button btnRenderUV "UV Layout"  width:34 height:32  border:false pos:[btx+=44,Yb]  images:#(bakeIcons,undefined,7,3,3,3,0) tooltip:"UV Layout"
				on btnRenderUV pressed do RenderButton "UvLayout" 	

		button btnRenderID "MaterialID"  width:34  height:32 border:false pos:[btx+=40,Yb]  images:#(bakeIcons,undefined,7,5,5,5,0) tooltip:"MaterialID"
				on btnRenderID pressed do RenderButton "ID"
		button btnRenderAplha "UV Alpha"  width:34 height:32  border:false  pos:[btx+=37,Yb]  images:#(bakeIcons,undefined,7,4,4,4,0) tooltip:"UV Alpha"
				on btnRenderAplha pressed do RenderButton "UvA" 		


-- 		 ----------------------------------------------  AMBIENT OCCLUSION  ----------------------------------------------

			button lblbake2 ""  width:256  height:3  pos:[0,Yb+=33]  images:#(Label_Line,undefined,1,1,1,1,0)  border:true
												  
			spinner spnFalloff "Falloff " range:[0.1,2.0,0.7] type:#float fieldWidth: 26  pos:[4,Yb+=7] 
					 
			button btnAoPreview "" width:88 height: 32 images:#(AoPreviewIco,undefined,100,87,87,87,0)  pos:[80,Yb]  border:false
				 on btnAoPreview pressed do aoPreview "LMB" --RenderButton "Ao" 0
				 on btnAoPreview rightclick do aoPreview "RMB" --RenderButton "Ao" 1

			spinner spnDistance"Distance" range:[0,100000,300]  type:#integer fieldWidth: 30  pos:[169,Yb]  
			
			spinner spnSpread "Spread " range:[0.1,2.0,0.9] type:#float fieldWidth: 26 pos:[0,Yb+=20] 

			spinner spnPadding "Padding" range:[0,256,6]  type:#integer fieldWidth: 32  pos:[171,Yb] 
				on spnPadding changed  val inSpin_arg do setSpnPadding val inSpin_arg --setSpnPadding val 
				
			button lblbake3 "_______________________________________________________________"  width:256  height:1  pos:[0,Yb+=20]  border:true -- images:#(Label_Line,undefined,1,1,1,1,0) 
	
			edittext outPutPath "" text:outPutPathText width:255  pos:[-2,Yb+=6]

		
	) --end rollout
-- /*
	rollout rollLazyWall "Lazy Wall" rolledup: on
	(
		
			on rollLazyWall rolledUp val do  RolloutsQueue rollLazyWall val

		
			spinner spnInterpolation "Int" range:[-2000,2000,0] fieldWidth:20 type: #integer pos:[bX=2,cY=7] 

			spinner spnOutline "Width" scale: 0.1 range:[-2000,2000,0] fieldWidth:40 type: #worldunits  pos:[bX+=50,cY]
			on  spnOutline changed val do OutlineFn ( for o in selection collect o) 
			on  spnOutline entered   do OutlineFn ( for o in selection collect o) 

			button btnOutlinePreview "Preview" width:45 pos:[bX+=83,cY-3]
			on   btnOutlinePreview pressed do OutlinePreview_v 1
			on   btnOutlinePreview rightclick do OutlinePreview_v 0	
		
			spinner spnExtrude "H" scale: 0.1 range:[-10000,100000,250] fieldWidth:50 type: #worldunits pos:[bX+=48,cY]
			on  spnExtrude changed val do WallExtrude false
			on  spnExtrude entered do WallExtrude false

			button lbllazy1 ""  width:256  height:3  pos:[0,cY+=20]  border:true  images:#(Label_Line,undefined,1,1,1,1,0) 

			button btncutWall "Add \ Ectract" width:85 pos:[bX=1,cY+=5] border:false 
			on  btncutWall pressed do Wall_Add ( for o in selection collect o) 
			on  btncutWall rightclick do ExtractSel ( for o in selection collect o) 

			button btnWallEdit "EDIT \ EXIT" width:85  pos:[bX+=85,cY] border:false 

			button btnCreateFloor "Create Floor" width:85  pos:[bX+=85,cY] border:false 
			on btnCreateFloor pressed do CreateFloor "Floor" 1
			on btnCreateFloor rightclick do CreateFloor "Ceil" 1
			

			on  btnWallEdit pressed do 
			(
				if selection[1].wstate == "BooleanWall" then 
				try(	WallEdit();max modify mode)catch()
				else if  selection[1].wstate == "EditableWall"  then
				try(	WallSplineEdit();max modify mode)catch()
				else if  selection[1].wstate == "WallOutline"  then
				try(	WallSplineEdit();max modify mode)catch()
					else
					(
						x = (random 1 1000)
						if x == 1 then	shelllaunch "https://en.wikipedia.org/wiki/Do_it_yourself"	"m"
						else  if x == 2 then	shelllaunch "http://www.youtube.com/watch?v=5JYzbzqYzm0"	"m"
					)
			)
			on  btnWallEdit rightclick do 
			(
				if  selection[1].wstate == "WallEditSpline" then 
					(
						WallSplineExit()
						max modify mode
					)
				else if selection[1].wstate == "WallOutline"  then
					(
						WallSplineExit()
						max modify mode
					)
				else if  selection[1].wstate == "EditableWall"  then
					(
						try(WallEditExit()
						max modify mode)catch()
					
					)
					else (x = (random 1 1000);if x == 1 then shelllaunch "http://en.wikipedia.org/wiki/Hard_Work"	"m")
			)
		
	-- 	Group "Operands Scale"
	-- 	(
			
			button lbllazy2 ""  width:256  height:3  pos:[0,cY+=25]  border:true  images:#(Label_Line,undefined,1,1,1,1,0) 		
			label lbScale "Scale" pos:[bx=6,cY+=8] 
						
			spinner BBScaleY "X" scale: 0.01 range:[0,20,1] fieldWidth:30  pos:[bx=40,cY] 
			on BBScaleY changed val do BBScale "Yvalue" val 
			on BBScaleY entered  do  BBScale "Yvalue"  rollLazyWall.BBScaleY.value

			spinner BBScaleX "Y" scale: 0.01 range:[0,20,1] fieldWidth:30  pos:[bx+=55,cY]
			on BBScaleX changed val do BBScale "Xvalue" val
			on BBScaleX entered  false true do  BBScale "Xvalue" rollLazyWall.BBScaleX.value

			spinner BBScaleZ "Z" scale: 0.01 range:[0,20,1] fieldWidth:30  pos:[bx+=55,cY]
			on BBScaleZ changed val do BBScale "Zvalue" val
			on BBScaleZ entered  do  BBScale "Zvalue"  rollLazyWall.BBScaleZ.value
			
			button btnResetCollisions "Reset" width:40  tooltip:"z" pos:[bx+=55,cY-3] border:false 
			on  btnResetCollisions pressed do ResetCollisions "center"
			on  btnResetCollisions rightclick do 
			(
				mode = rollLazyWall.btnResetCollisions.tooltip			
	-- 			ResetCollisions "x"
				ResetCollisions mode
				
				case mode of
				(
					"x":rollLazyWall.btnResetCollisions.tooltip = "y"
					"y":rollLazyWall.btnResetCollisions.tooltip = "z"
					"z":rollLazyWall.btnResetCollisions.tooltip = "x"
				)
			)
	-- 	 )
		
		on VilToolsFloater close do killCallbacks()

	)	
-- */
-- 	if hasinisetting iniFile "Rollouts"  "allRolls" then allRolls = execute (getINISetting  iniFile "Rollouts"  "allRolls")
-- 	else (allRolls =  #("rollvilTools"," rollSelection"," rollMaterials"," rollUnwrap"," rollUvViewer "," rollBaking"," rollLazyWall" ))

-- 	roll = allRolls[1]
-- 	for r=1 TO allRolls.count do execute ( "addRollout " + allRolls[r] + " VilToolsFloater")

-- execute ( "addRollout " + allRolls[1] + " VilToolsFloater")	
-- execute ( "addRollout " + allRolls[2] + " VilToolsFloater")	
-- execute ( "addRollout " + allRolls[3] + " VilToolsFloater")	
-- execute ( "addRollout " + allRolls[4] + " VilToolsFloater")	
-- execute ( "addRollout " + allRolls[5] + " VilToolsFloater")	
-- execute ( "addRollout " + allRolls[6] + " VilToolsFloater")	
-- execute ( "addRollout " + allRolls[7] + " VilToolsFloater")	
	addRollout rollvilTools VilToolsFloater
	addRollout rollSelection VilToolsFloater
	addRollout rollMaterials VilToolsFloater
 	addRollout rollUnwrap VilToolsFloater
 	addRollout rollUvViewer VilToolsFloater 
	addRollout rollBaking VilToolsFloater
	addRollout rollLazyWall VilToolsFloater 



	
)--end



