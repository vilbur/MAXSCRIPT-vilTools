fn setMatID MatID = 	
(
	/*
	MatID = 1
	*/
	closedGroups =  #()
	sel = for o in selection where classof o.baseobject == Editable_Poly collect o
	for o in selection where isgroupmember o and isOpenGroupMember o == false do 
	(
		appendifunique closedGroups o.parent
	)
	
	subObj = subobjectLevel
	-- 	theIDmin = 1
-- 	theIDmax = 1
	
	if sel.count > 0  then
	(
		with redraw off
		(
			if closedGroups.count > 0 then for g in closedGroups do setGroupOpen g true
			
			for o in sel do
			(
		-- 		o = $
-- 				o=sel[1]
				select o 
				max modify mode	
				local EditPolyMode
				curMod = modPanel.getcurrentObject ()	

				if classof curMod != Editable_Poly then   -----try find edit poly mdifier
				(
					EditPolyMode = (for m in o.modifiers where  classof m == Edit_Poly collect m)[1]
					
					if EditPolyMode != undefined then
					(		

					if curMod != EditPolyMode then modPanel.setcurrentObject EditPolyMode
						
						if subObj == 0 then 
						(
							
							subobjectLevel = 4
							EditPolyMode.Select #Face #{1..(polyop.getNumFaces o) } node:o
						)
						if subobjectLevel == 4 or  subobjectLevel == 5 then 
						(
							EditPolyMode.SetOperation #SetMaterial
							EditPolyMode.materialIDToSet = MatID-1
							EditPolyMode.Commit ()
						)
					)
				)
				
				if classof curMod == Editable_Poly then  --- edit editabe poly if edit poly mdifiers is not on object
				(		
-- 					max modify mode	
-- 					modPanel.setCurrentObject o.baseObject	
-- 					modPanel.getCurrentObject ()
					
					
					curMod = o.baseObject
					
					if subObj == 0 then 
					(
						print ("DEBOG o" + o.name)
	-- 					o = sel[1]
						subobjectLevel = 4
						curMod.SetSelection #Face #{1..(polyop.getNumFaces o) }
					)
					
					if subobjectLevel == 4 or  subobjectLevel == 5 then 
					(
						facelist = (curMod.GetSelection #Face) as array
						polyop.setFaceMatID o facelist MatID
					)
				)
				
				if subObj != undefined then subobjectLevel = subObj
				select sel
			)
			
				if closedGroups.count > 0 then for g in closedGroups do setGroupOpen g false

			
		)
	)
)

fn setIDcmd MatID = 
(
	local NumbersBlue = #( "$userScripts\\vilTools\\Icons\\NumbersID_B.bmp",undefined,9,MatID,MatID,MatID,0)
	execute ("rollMaterials.MatID" + MatID as string + ".images = " + NumbersBlue as string)
	setMatID MatID
)

fn getMatID MatID  = 	
(
	/*
	MatID = 1
	*/
	max modify mode	
	if classof objArray != array then sel = for o in selection where classof o.baseobject == Editable_Poly collect o

	subObj = subobjectLevel
	fnalSel = #()
	
	if objArray.count > 0  then
	(
			for o in sel do
			(
		-- 		o = $
	-- 			if sel.count > 1 then 
					select o 
				local EditPolyMode
				curMod = modPanel.getcurrentObject ()	

				if classof curMod != Editable_Poly then
				(
					EditPolyMode = (for m in o.modifiers where  classof m == Edit_Poly collect m)[1]
					
					if EditPolyMode != undefined then
					(
						EditPolyMode.SetSelection #Face #{}
						
						if subObj != 4 or  subObj != 5  then subobjectLevel = 4
						if subobjectLevel == 4 or  subobjectLevel == 5 then 
						(
							for f= 1 to polyop.getNumFaces o do
							(
								if (polyop.getFaceMatID o f) == MatID then EditPolyMode.Select #Face #{f}
							)
						)
					)
				)
	-- 			curMod.SetSelection #Face #{3}
				if EditPolyMode == undefined then
				(		
					curMod = modPanel.getcurrentObject ()	
					if  subObj != 4 or  subObj != 5 then subobjectLevel = 4
					
					if subobjectLevel == 4 or  subobjectLevel == 5 then 
					(
						for f= 1 to polyop.getNumFaces o do (if polyop.getFaceMatID o f == MatID then append fnalSel f)

					)
					curMod.SetSelection #Face (fnalSel as bitarray)
				)
				
				subobjectLevel = 4
				select objArray
				redrawviews()
			)	
		)
)
-------------------------------RANDOM ID--------------------------------
fn RandomMatIDRollout = 
(
	try(DestroyDialog rollRanmdomID )catch()
	
		rollout rollRanmdomID "Random"
		(
			spinner IDmin "ID min" range:[1,100,1]  type:#integer  fieldWidth: 30 align:#right
			spinner IDmax "ID max" range:[1,100,10]  type:#integer  fieldWidth: 30 align:#right 
								   
			button btnRandom "Randomize" 
			on btnRandom pressed do RandomMatID rollRanmdomID.IDmin.value rollRanmdomID.IDmax.value
			on btnRandom rightclick do (RandomMatID rollRanmdomID.IDmin.value rollRanmdomID.IDmax.value;DestroyDialog rollRanmdomID )

		)

	CreateDialog rollRanmdomID width:100 
	setDialogPos rollRanmdomID [(mouse.screenpos.x-83), mouse.screenpos.y +(-30)]
)

fn RandomMatID theIDmin theIDmax = 	
(
	/*
	theIDmin = 5
	theIDmax = 10
	
	*/
	global GetMatIDEvent = undefined 	--turnoff callback
	
	max modify mode	
	sel = for o in selection where classof o.baseobject == Editable_Poly collect o
	subObj = subobjectLevel
	
	with redraw off
	(		
		if sel.count > 0 then
		(
			for o in sel do
			(
		-- 		o = $
				if sel.count > 1 then select o 
				local EditPolyMode = undefined
				curMod = modPanel.getcurrentObject ()	

				if classof curMod != Editable_Poly then
				(
					EditPolyMode = (for m in o.modifiers where  classof m == Edit_Poly collect m)[1]
					
					if EditPolyMode != undefined then
					(						
						if subObj == 0 then 
						(
							subobjectLevel = 4
							EditPolyMode.Select #Face #{1..(polyop.getNumFaces o) } node:o
						)
						if subobjectLevel == 4 or  subobjectLevel == 5 then 
						(
							
							facelist =	EditPolyMode.getSelection #Face AS Array
							
							for f in facelist do 
							(
								EditPolyMode.SetSelection #Face #{}	
								EditPolyMode.Select #Face #{f}
								EditPolyMode.SetOperation #SetMaterial
								EditPolyMode.materialIDToSet =( (random theIDmin theIDmax)-1)
								EditPolyMode.Commit ()
							)							
							EditPolyMode.SetSelection #Face (facelist as bitarray)
						)
					)
				)
				
				if EditPolyMode == undefined then
				(							
					curMod = modPanel.getcurrentObject ()	
					if subObj == 0 then 
					(
						subobjectLevel = 4
						curMod.SetSelection #Face #{1..(polyop.getNumFaces o) }
					)
					
					 if subobjectLevel == 4 or  subobjectLevel == 5 then 
					(
						facelist = (curMod.GetSelection #Face) as array
						for f in facelist do polyop.setFaceMatID o #{f} (random theIDmin theIDmax)
	-- 					f=1
			-- 			FaceSel =  (curMod.GetSelection #Face) as array
					)
				)			
				subobjectLevel = subObj
				if sel.count > 1 then  select sel
					
			
				fn SelectionChange_vilTools_MatID_event  ev nd  = SelectionChange_vilTools_MatIDFN()	---------Turn off callback	
				GetMatIDEvent = nodeEventCallback subobjectSelectionChanged:SelectionChange_vilTools_MatID_event	

			)
		)
	)
)

--end
fn ClearNodeUserProps =	--start
(
	
	for o in selection   where superclassof o == GeometryClass do
	(	
		if(o != undefined) then
		(
			allKeys=""
			--	whichNode =$
			--Get current object's all userdefined properties			
			--gives a huge string with every other key/value 
			--pair separated by \r\n
			allProps = (getUserPropBuffer o)
				
			--Split the properies into key value pairs
			allKeyValuePairs = (filterString allProps "\r\n")
				
			for currentKeyValuePair in allKeyValuePairs do
			(
				--Get the key and value individually
				currentItem = (filterString allKeyValuePairs[1]  "=")
				allKeys+= (currentItem[1]+" =\r\n")
			)
				
			--Remove all the existing user defined properties
			setUserPropBuffer o ""
				
			--Now set all the keys as blank
			setUserPropBuffer o allKeys 
		)
	)
)
--end

--end
fn MapFromClipboard =		--start
(
	
	fileFormats = #()
	Sel = #()
	fileFormats = #(".jpg",".tga",".bmp",".psd",".png",".JPG",".TGA",".BMP",".PSD",".PNG")
	Sel = for o in selection   where superclassof o == GeometryClass collect o
	ClpipboardText = getclipboardText()
	imageFormat = getfilenametype ClpipboardText


	if Sel.count > 0 do 
	(	
		if ClpipboardText != undefined do
		(
			if (finditem fileFormats imageFormat != 0 ) do 
			(	
				mat = sel[1].material
				
				if mat != undefined do 
				(
					if classof mat == Standard then
					(
						
						if mat.diffusemap != undefined then	MapChannel =  mat.diffusemap.coords.mapChannel 

					)
					else 
					(
						MapChannel = 2
					)
				)
				if MapChannel == undefined then MapChannel = 1
	
				ClpipboardMat = standard selfIllumAmount:100 
				ClpipboardMat.name = filenameFromPath ClpipboardText
				ClpipboardMat.diffuseMap = bitmaptexture filename:ClpipboardText		
				ClpipboardMat.diffuseMap.filename
			--	ClpipboardMat.diffuseMap.coords.mapChannel = MapChannel
				--Show the textures of the baked material in the viewport
				for o in sel do setUserProp o "origMat" o.material --s ave old material

				for o in sel do o.material=ClpipboardMat
				for o in sel do showTextureMap o.material o.material.diffusemap  true	
			--	o = $		
				print "MapChannel:  " + MapChannel as string
				sel[1].material.diffuseMap.coords.mapChannel = MapChannel
			)
		)
	)
	
)

--end
fn Circle_UvChannel varX =	--start
(
	--	obj=$
	--	varX = 1
	sel = #()
	selMaterials = #()
	mat=#()
	sel =  for o in selection where superclassof o == geometryclass collect o
	for m  in selection do appendifunique selMaterials m.material
		--  	m=selMats[1]
	if (selMaterials.count > 0) then
	(
		mCH = rollMaterials.btnCircleCh.text as integer
	
		if mCH == 10 then
		(
			newCh = 1
		)
		else if mCH == 1 then
		(
			if varX == 1 then
			(newCh = 2)
			else
			(newCh = 1)
		)
		else
		( 
			newCh = mCH + varX
		)
		
		for  m in selMaterials do
		(
	/*		if (classof   m == Standard and   m.diffuseMap != undefined) then
			(
			
				m.diffuseMap.coords.mapChannel = newCh								
			--	showTextureMap m m.diffuseMap off	
			 	showTextureMap m m.diffusemap on
				rollMaterials.btnCircleCh.tooltip = newCh as string
			--	print (mCH+1)
							
			)
			else if (classof m == Multimaterial) then
			(
				--		m=$.material
				--			subMat=2
				for subMat=1 to m.numsubs do 
				(
					if m[submat] != undefined and m[submat].diffusemap != undefined do
					(
						m[submat].diffuseMap.coords.mapChannel = newCh								
					--	showTextureMap m m.diffuseMap off	
						showTextureMap m[submat] m[submat].diffusemap on
						rollMaterials.btnCircleCh.tooltip = newCh as string
					)
					subMat+=1
				)				
			)
			else if (classof obj.material == Shell_Material ) then 
			(
				mat= obj.material[2]
			)/*/	
			
			if classof  m == standard and m.diffuseMap != undefined then 
			(
			
				m.diffuseMap.coords.mapChannel = newCh								
			--	showTextureMap m m.diffuseMap off	
			 	showTextureMap m m.diffusemap on
				rollMaterials.btnCircleCh.text = newCh as string		
				rollMaterials.btnCircleCh.tooltip = newCh as string
				
			)	
			else if classof   m == Multimaterial then 
			(
				for subMat=1 to m.numsubs do 
				(
					if m[submat] != undefined and m[submat].diffusemap != undefined do
					(
						m[submat].diffuseMap.coords.mapChannel = newCh								
					--	showTextureMap m m.diffuseMap off	
						showTextureMap m[submat] m[submat].diffusemap on
						rollMaterials.btnCircleCh.text = newCh as string		
						rollMaterials.btnCircleCh.tooltip = newCh as string
						)
					subMat+=1
				)
			)
			else if classof m == Shell_Material  then 
			(
				m[2].diffuseMap.coords.mapChannel = newCh								
			--	showTextureMap m m.diffuseMap off	
				showTextureMap m[2] m[2].diffusemap on
				rollMaterials.btnCircleCh.text = newCh as string		
				rollMaterials.btnCircleCh.tooltip = newCh as string		

			)	

			rollMaterials.btnCircleCh.images = #("$userScripts\\vilTools\\Icons\\channelIcons.bmp",undefined,10,newCh,newCh,newCh,0) 						

		)
		
	)
		
)

--end
fn vil_checker click =	--start
(	
	if selection.count > 0 then
	(	
		
		sel = #()
		mat=#()
		noMat = #()
		sceneMat =  #()
		checkerMapA =  "$userScripts\\vilTools\\icons\\checkermap_a.jpg"
		checkerMapB =  "$userScripts\\vilTools\\icons\\checkermap_b.jpg"
		
		sel =  for o in selection where superclassof o == geometryclass collect o
			
		for o in sel where o.material != undefined do (if o.material.name != "checkermat" do append noMat o)
		for o in sel where o.material == undefined do append noMat o

		
		for m in  scenematerials where m.name == "checkermat" do append sceneMat m
		for m in  meditMaterials  where m.name == "checkermat"  do appendifunique sceneMat m

		local checkermat = sceneMat[1]	
			
			
		if click == "LMB" then
		(
			--local checkermat
			--		o=$

			if  rollMaterials.btnCircleCh.text as integer != 0 then   uvCH = rollMaterials.btnCircleCh.text as integer
			else uvCH = 1 
				
			if 	sceneMat.count == 0 do 
			(
				checkermat = standard selfIllumAmount:100 name: "checkermat"
				checkermat.diffuseMap = bitmaptexture filename:checkerMapA
				showTextureMap checkermat checkermat.diffusemap on	
				checkermat.diffuseMap.coords.mapChannel = uvCH
	-- 			checkermat.diffuseMap.coords.mapChannel = rollMaterials.btnCircleCh.tooltip	as integer
				--Show the textures of the baked material in the viewport
			--	showTextureMap selection[1].material sel.material.diffusemap on	
			)

			if noMat.count != 0 do
			(		
				saveOrigMat ()
				sel.material = checkermat
				showTextureMap checkermat checkermat.diffusemap on	
				rollMaterials.btnChecker.text = 2 as string 
				checkermat.diffuseMap.coords.mapChannel = uvCH
	-- 			SelectionChange_vilToolsUVchFN()
				

-- 				UVtile = rollMaterials.btnChecker.tooltip as integer
-- 				
-- 				checkermat.diffusemap.coords.U_Tiling = UVtile
-- 				checkermat.diffusemap.coords.V_Tiling = UVtile
-- 		
		
			)
			
			if noMat.count == 0 do 
			(
				origState = rollMaterials.btnChecker.text as integer
				
				if 	origState == 1 then
					(
						newState = 2
						checkermat.diffuseMap.filename =checkerMapA
						showTextureMap sel[1].material sel[1].material.diffusemap on	
						sel.material = checkermat
						rollMaterials.btnChecker.text = newState as string
						
					)
				else if origState == 2 then
					(
						newState = 3
						showTextureMap sel[1].material sel[1].material.diffusemap on	
						checkermat.diffuseMap.filename =checkerMapB
						rollMaterials.btnChecker.text = newState as string
						
					)
				else if origState == 3 do
					(
						newState = 1
						rollMaterials.btnChecker.text = newState as string
						checkermat.diffuseMap.filename =checkerMapA
						revertOrigMat()	
						
					)
			)	
			
	-- 	select sel
			
		)
		else if click == "RMB" then
		(
			checkermat = sceneMat[1]	
			origtile = checkermat.diffusemap.coords.U_Tiling 
			
			if origtile !=8 then
			(
				checkermat.diffusemap.coords.U_Tiling = origtile*2
				checkermat.diffusemap.coords.V_Tiling = origtile*2
				rollMaterials.btnChecker.tooltip = ((1024*origtile as integer)) as string
			)
			else
			(
				checkermat.diffusemap.coords.U_Tiling = 0.5
				checkermat.diffusemap.coords.V_Tiling = 0.5
				rollMaterials.btnChecker.tooltip = "256"
			)
		
			newTile = checkermat.diffusemap.coords.U_Tiling 
			case of
			(
				(newTile==0.5): newIcon = 1
				(newTile==1): newIcon = 2
				(newTile==2): newIcon = 3
				(newTile==4): newIcon = 4
				(newTile==8): newIcon = 5
			)
			
			rollMaterials.btnChecker.images = #("$userScripts\\vilTools\\Icons\\checkerIcons.bmp",undefined,5,newIcon,newIcon,newIcon,0) 

		)
		
		redrawViews() 

				
		
			--	showTextureMap selection[1].material selection[1].material.diffusemap on	
-- 		select sel
	
		try(SelectionChange_vilToolsUVchFN	())catch()


	)

)	