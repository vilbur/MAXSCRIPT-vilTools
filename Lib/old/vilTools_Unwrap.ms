fn vil_Unwrap_reset modi: = 	--start
(
	if modi == unsupplied do modi = modpanel.getcurrentobject()
	if iskindof modi Unwrap_UVW do
	(
		DialogMonitorOPS.unRegisterNotification id:#resetWatcher

		local enabled = DialogMonitorOPS.enabled
		fn notification act:enabled = 
		(
			hwnd = DialogMonitorOPS.GetWindowHandle()
			if (UIAccessor.isWindow hwnd) and (UIAccessor.GetWindowText hwnd) == "Unwrap UVW" do
			(
				UIAccessor.PressButtonByName hwnd "&Yes"
			)
			DialogMonitorOPS.enabled = act
			DialogMonitorOPS.unRegisterNotification id:#resetWatcher
		)
		enabled = DialogMonitorOPS.enabled
		DialogMonitorOPS.RegisterNotification notification id:#resetWatcher
		DialogMonitorOPS.enabled = on
		
		modi.reset()
	)
)

--end
fn setModifierChannel chMod = 	--start
(
	-- 	chMod = 1
	-- 	chMod = 2
	UvEditorIco_B = "$userScripts\\vilTools\\Icons\\UvEditor_B.bmp"
	UvEditorIco_G =	"$userScripts\\vilTools\\Icons\\UvEditor_G.bmp"
	(try (setINISetting iniFile "modifiers UV" "channel" (chMod as string) )catch())
		
	ThIcon = chMod +1

	rollUnwrap.btnUnwrapAdd1.images = #(UvEditorIco_B,undefined,6,2,2,2,0)	
	rollUnwrap.btnUnwrapAdd2.images = #(UvEditorIco_B,undefined,6,3,3,3,0)	
	rollUnwrap.btnUnwrapAdd3.images = #(UvEditorIco_B,undefined,6,4,4,4,0)	
	rollUnwrap.btnUnwrapAdd4.images = #(UvEditorIco_B,undefined,6,5,5,5,0)	
-- 	rollUnwrap.btnUnwrapAdd5.images = #(UvEditorIco_B,undefined,6,6,6,6,0)	
		
	case of
	(
		(chMod == 1):	rollUnwrap.btnUnwrapAdd1.images = #(UvEditorIco_G,undefined,6,ThIcon,ThIcon,ThIcon,0)	
		(chMod == 2):	rollUnwrap.btnUnwrapAdd2.images = #(UvEditorIco_G,undefined,6,ThIcon,ThIcon,ThIcon,0)	
		(chMod == 3):	rollUnwrap.btnUnwrapAdd3.images = #(UvEditorIco_G,undefined,6,ThIcon,ThIcon,ThIcon,0)	
		(chMod == 4):	rollUnwrap.btnUnwrapAdd4.images = #(UvEditorIco_G,undefined,6,ThIcon,ThIcon,ThIcon,0)	
-- 		(chMod == 5):	rollUnwrap.btnUnwrapAdd5.images = #(UvEditorIco_G,undefined,6,ThIcon,ThIcon,ThIcon,0)	
	)
	
	origSel = #()
	origSel = for o in selection   where superclassof o == GeometryClass collect o
	
	if origSel.count > 0 do
	(
		unwrap = modpanel.getcurrentobject ()		
		if classof unwrap == Unwrap_UVW do 
		(
			max modify mode	
			unwrap.setMapChannel chMod
-- 			vil_Unwrap_reset()
-- 			unwrap.edit ()
		)
	)
)

--end
fn vil_Unwrap_add ch =	--start
(
	objArray = for o in selection where classof o.baseobject == Editable_Poly collect o
-- 	max create mode
-- 	vil_Unwrap_add 1
--	clearlistener()
-- 	o=objArray[1]
-- 	o=undefined
	if objArray.count > 0 then 
	(
				--		ch=1
				--		ch=2
		Enter_Subobject_CallBackKill()

		faceIDs = #()
		max modify mode	
		o=objArray[objArray.count]
		uv = modpanel.getcurrentobject()
		
		if ch == undefined then ch = uv.getMapChannel()
		if ch == 0 then ch = 1
-- 		theBitmap
-- 					defUnwrapMod = modpanel.getcurrentobject ()

		if (getINISetting iniFile "UnwrapOptions" "btxSetResAuto") == "true" or  (getINISetting iniFile "UnwrapOptions" "btxSetMap") == "true" then
		(
			if classof o.material == Standardmaterial then 
			(
				MapID = 1
				if o.material.diffusemap != undefined then 
				(
					theBitmap = o.material.diffusemap
					theBitmapUVch = theBitmap.coords.mapChannel
				)
			)
			else if classof o.material == Multimaterial then
			(
-- 				for obj in objArray do
-- 				(	
					for f=1 to (polyop.getnumfaces o) do
					(
						fID = polyop.getFaceMatID o f
						if faceIDs[fID] == undefined then faceIDs[fID] = 0
						faceIDs[fID] = 	faceIDs[fID] += 1
					)
					for i=1 to faceIDs.count where faceIDs[i] == undefined do faceIDs[i] = 0
-- 				)
					MapID = finditem faceIDs (amax faceIDs)
					
					print ("MATERIAL:" + o.material.name as string)
					
					
					if MapID > o.material.numsubs then MapID = 1	
					if o.material[MapID] == undefined then while o.material[MapID] == undefined do MapID-=1
					if o.material[MapID].diffusemap != undefined then
						(
						theBitmap = o.material[MapID].diffusemap
						theBitmapUVch = theBitmap.coords.mapChannel
						)
						
			)
						
		)
		
		
		
		
	if (getINISetting iniFile "UnwrapOptions" "btxSetResAuto") == "true" and theBitmap != undefined then 
		(
			
			if theBitmap.filename != undefined then Print ("-DEBUG---------theBitmap:" + theBitmap.filename as string)

			nativeRes = #(256,512,1024,2048,4096)
			
			if doesFileExist  theBitmap.filename then
			(
				theBitmapSize = theBitmap.bitmap.width 
				
				if finditem nativeRes theBitmapSize != 0 then
				(
	-- 				theBitmapSize = 512
	-- 				theBitmapSize = 2048
	-- 				oldSize = rollUnwrap.btnResNorm.text as integer	
					if (rollUnwrap.btnResNorm.text as integer) > theBitmapSize then(while  (rollUnwrap.btnResNorm.text as integer) > theBitmapSize do setRes "ResBake" -1 5)
					else while  (rollUnwrap.btnResNorm.text as integer) < theBitmapSize do setRes "ResBake" 1 5
				)
			)
		)
		
		/* local*/ finSel = #()
		/* local*/ allInstances = #()
		/* local*/ unSelInstances = #()
		/* local*/ finSel = vilTools_InstanceTest objArray 
		/* local*/ defUnwrapMod = Unwrap_UVW()
		/* local*/ curmod = modpanel.getcurrentobject ()
		/* local*/ EditorOpened = false
	

		if classof curmod == Unwrap_UVW then  -- OpenEditor if unwrap is allready apllied
		(
	-- 		curCh = curmod.getMapChannel()
			if	curmod.getMapChannel() == 0 then curCh = 1 else curCh = curmod.getMapChannel()
			if curCh == ch then 
			(
				win =  (modpanel.getcurrentobject()).GetWindowW();
	-- 			if ( win > 0 and win < 1600) then defUnwrapMod.edit ()
				if  win == 0 then curmod.edit ()
				curmod.setIgnoreBackFaceCull  false
				EditorOpened = true 
			)
		)
			
		if not  EditorOpened then	--add unwrap mdifier with differend channel if unwrp is already applied
		(
			if finSel.count !=  finSel.count then select finSel
-- 			defUnwrapMod.setMapChannel ch
-- 			max modify mode	
			if ch == undefined then ch = 1
			defUnwrapMod.setMapChannel ch
			addmodifier finSel defUnwrapMod
			max create mode	
			max modify mode	
-- 			defUnwrapMod.setMapChannel ch
-- 			select finSel
			defUnwrapMod.setIgnoreBackFaceCull  false
-- 			defUnwrapMod.setCurrentMap MapID 
--			defUnwrapMod.DisplayMap on
-- 			/* 		
					
			if (getINISetting iniFile "UnwrapOptions" "btxSetMap") == "true" and theBitmap != undefined then 
			(
				if theBitmapUVch == ch then
				(
					defUnwrapMod.addMap theBitmap 
-- 					defUnwrapMod.setCurrentMap defUnwrapMod.numberMaps
					defUnwrapMod.DisplayMap on
					print ("theBitmap: " + theBitmap as string)

				)
			)
-- 			print ("--------DEBUG MapID: " + (MapID +1 ) as string)
-- 			 */		
			defUnwrapMod.edit ()
			
			
			
			wText "UnWrap Added" ("   Channel: " + ch as string) "" ""
		)	
		
		if (getINISetting iniFile "UnwrapOptions" "btxSetGrid") == "true" then SetUVGrid()
		if (getINISetting iniFile "UnwrapOptions" "btxSetElement") == "true" then ((modPanel.getCurrentObject()).setTVElementMode true) else ((modPanel.getCurrentObject()).setTVElementMode false)

-- 		/* local*/ defUnwrapMod = modpanel.getcurrentobject ()
		
		newCH = (defUnwrapMod.getMapChannel ()) 
		if newCH == 0 then newCH = 1
		print ("ch: " +  ch as string)
		print ("newCH: " + newCH as string)
		
		
		if ch != newCH then 
		(
-- 			defUnwrapMod.setMapChannel 1
-- 			vil_Unwrap_reset()
-- 			actionMan.executeAction 2077580866 "40119"  -- All Commands: Save Current Settings As Default
			messagebox "Please set channel to 1\nand save it as defaults"
-- 		
		)
	)
	
	
)


fn getTextureChannel objArray =
(
	
	if classof objArray != array then objArray = for o in selection   where superclassof o == GeometryClass collect o
-- 	max create mode
-- 	vil_Unwrap_add 1
--	clearlistener()
-- 	o=objArray[1]
	if objArray.count > 0 then 
	(
				--		ch=1
				--		ch=2
		faceIDs = #()
		max modify mode	
		o=objArray[objArray.count]
		print (objArray as string)
-- 		theBitmap
-- 					defUnwrapMod = modpanel.getcurrentobject ()

			
		if classof o.material == Standardmaterial then 
		(
			MapID = 1
			if o.material.diffusemap != undefined then theBitmap = o.material.diffusemap
		)
		else if classof o.material == Multimaterial then
		(
-- 			for obj in objArray do
-- 			(	
				obj = o
				for f=1 to (polyop.getnumfaces obj) do
				(
					fID = polyop.getFaceMatID obj f
					if faceIDs[fID] == undefined then faceIDs[fID] = 0
					faceIDs[fID] = 	faceIDs[fID] += 1
				)
				for i=1 to faceIDs.count where faceIDs[i] == undefined do faceIDs[i] = 0
-- 			)
				 
				MapID = finditem faceIDs (amax faceIDs)
				if MapID > o.material.numsubs then MapID = 1	
				if o.material[MapID] == undefined then while o.material[MapID] == undefined do MapID-=1
				if o.material[MapID].diffusemap != undefined then theBitmap = o.material[MapID].diffusemap
		)	
			
		if theBitmap != undefined then theBitmap.coords.mapChannel


			
		
	)
	
	
)
	

--end
fn vil_textureToggle FnMod  = 	--start
(
	/*
		--		o=$	
	vil_textureToggle "Scene" 
	vil_textureToggle "Selected"
	*/
	if rollMaterials.btnDiffuse.text == "false"
	then theSwitch = on 
	else theSwitch = off

	rollMaterials.btnDiffuse.text = theSwitch as string		
	sel = #()
	sceneMat =  #()
	sel =  for o in selection where superclassof o == geometryclass collect o
	
	--	FnMod="Selected"
	if FnMod == "Scene" then
	(
		if displayColor.shaded ==  #material then displayColor.shaded = #object
		else displayColor.shaded = #material 		
	)
	else if FnMod == "Selected" then
	(
		for o in  sel do appendifunique sceneMat o.material
			--		m=scenemat[1]
			--		m= $.material
			--		theSwitch =off
		for m in sceneMat do
		(		
			if (classof m == standard) then 
			(
				if m.diffusemap != undefined do showTextureMap m m.diffusemap theSwitch
			)	
			else if (classof m == Multimaterial or classof m == Shell_Material ) then 
			(				 
				for subMat=1 to m.numsubs do 
				(
					if 	m[submat] != undefined and m[submat].diffusemap != undefined then
					(
						showTextureMap m[submat] m[submat].diffusemap theSwitch
						submat+=1
					)
					else
					(
						submat+=1	
					)
				)
			)	
		)
	)
)

--end
fn vilTools_UV_Copy fromUV toUV =	--start
(
	global wTC3 = yellow

	--		obj=$
	--		o=$
	--		o = selection[1]
	--		fromUv = 5
	--		toUV = 6
-- 				srcObj = selection as array
	if selection.count > 0 THEN
	(
		undo "Copy UV`s" on
		
		(
			srcObj = selection[selection.count]
-- 			sel= for o in selection where (classof o == Editable_Poly or classof o == PolyMeshObject)  and polyop.getNumVerts o == polyop.getNumVerts srcObj  collect o
			sel = for o in selection where superclassof o == Geometryclass collect o
			
			for o in sel where classof o != Editable_Poly or classof o != PolyMeshObject do 
			(
				addmodifier o (Edit_Poly ())
				maxOps.CollapseNodeTo o 1 off
			)
			sel =  for o in sel where getNumVerts o == getNumVerts srcObj collect o
			
			print Sel.count 
			print selection.count

			if polyop.getMapSupport srcObj fromUV then
			(
				if sel.count == selection.count then
				(	
					for obj in sel do
					(
						if (polyop.getMapSupport obj toUV == false ) do polyop.setMapSupport obj toUV true 
						
						--polyop.setNumMapVerts obj toUV (polyop.getNumMapVerts obj fromUV ) keep:false
						--polyop.setNumMapFaces obj toUV (polyop.getNumMapFaces obj fromUV)  keep:false
						
						polyop.setNumMapVerts obj toUV (polyop.getNumMapVerts srcObj fromUV) keep:false
						polyop.setNumMapFaces obj toUV (polyop.getNumMapFaces srcObj fromUV)  keep:false
						
						
						for v = 1 to (polyop.getNumMapVerts obj toUV) do 
						(
							polyop.setMapVert obj toUV v (polyop.getMapVert srcObj fromUV v)
						)

						for f = 1 to (polyop.getNumMapFaces obj toUV) do
						(
							polyop.setMapFace obj toUV f (polyop.getMapFace srcObj fromUV f)
						)
					)
				)
				else  
				(
					for obj in sel do
					(
						if (polyop.getMapSupport obj toUV == false ) do polyop.setMapSupport obj toUV true 
						
						--polyop.setNumMapVerts obj toUV (polyop.getNumMapVerts obj fromUV ) keep:false
						--polyop.setNumMapFaces obj toUV (polyop.getNumMapFaces obj fromUV)  keep:false
						
						polyop.setNumMapVerts obj toUV (polyop.getNumMapVerts obj fromUV) keep:false
						polyop.setNumMapFaces obj toUV (polyop.getNumMapFaces obj fromUV)  keep:false
						
						
						for v = 1 to (polyop.getNumMapVerts obj toUV) do 
						(
							polyop.setMapVert obj toUV v (polyop.getMapVert obj fromUV v)
						)

						for f = 1 to (polyop.getNumMapFaces obj toUV) do
						(
							polyop.setMapFace obj toUV f (polyop.getMapFace obj fromUV f)
						)
					)
				)
				select sel

				wText ("          Copy UV: " + fromUV as string)  ("          To     UV: " + toUV as string) ("Source Object: " + srcObj.name) ""

			)
			else
			(
-- 				messagebox "Source object does not support target channel"
				global wTC2 = red

				wText "	Hey Man!" "Source object does not support target channel" "" ""
			)
			
		)
		


		
		
	)
)
