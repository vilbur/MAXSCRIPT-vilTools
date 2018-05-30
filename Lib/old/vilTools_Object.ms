fn getGeometrySel =
(
	if Selection.count > 0 then
	(
		/*local*/ objArray = for o in selection where superclassof o == GeometryClass collect o 
	)
	objArray
)	
fn vil_rotate_tools direction =	--start
(
	undo "RotateTools" on
	(
		sel = #()
		sel=(for o in selection  where (superclassof o == GeometryClass) collect o)
		axis = toolmode.axisConstraints
		--		direction =1				
		case axis of
			(
				#X: rot_axis = [1,0,0]
				#Y: rot_axis = [0,1,0]
				#Z: rot_axis = [0,0,1]
				
				#XY: rot_axis = [0,0,1]
				#YZ: rot_axis = [0,0,1]
				#ZX: rot_axis = [0,0,1]
			)	
		
			cordSys =	getRefCoordSys ()
		--	world	
			cordSysCenter = getCoordCenter() 		
			
		if cordSys == #hybrid or cordSys == #view do cordSys = #world 		
		if cordSysCenter == #local do cordSysCenter = #pivot 	

		if	cordSysCenter == #pivot then
		(	
			if cordSys == #local then 
			(					
				about cordSysCenter in coordsys cordSys  (rotate sel (angleaxis (rollTools.spnObjRotate.value*direction) rot_axis))
			)
			else if cordSys == #world   then 
			(
			
			 about cordSysCenter in coordsys cordSys  (rotate sel (angleaxis (rollTools.spnObjRotate.value*direction) rot_axis))
			)
			else
			(
			  (rotate sel (angleaxis (rollTools.spnObjRotate.value*direction) rot_axis))
			)
		)
		else if	cordSysCenter == #selection then
		(
			about selection in coordsys #world   (rotate sel (angleaxis (rollTools.spnObjRotate.value*direction) rot_axis))
		)
	)
)
/* 	select instances
* 
* 	print 	instanceArray
* 	select instanceArray
* 	select instanceArray[1]
* 	instanceArray.count
* 	
* 	o =$
*/
--end
fn objXformNormal = 	--start
(	
	with redraw off
	(
	--		o=$
		max create mode
		sel = #()
		sel=(for o in selection  where (superclassof o == GeometryClass) collect o)

		instances = #()
		tmpInst= #()
		instanceArray = #()

		for obj in sel where (InstanceMgr.GetInstances obj &obj_instance) as integer > 1 do
		(	
			local obj_instance			
			tempList = #()
			
				InstanceMgr.GetInstances obj &obj_instance		
				join tmpInst obj_instance	
			--	if  (finditem sel obj) > 0 and  (finditem instances obj) == 0 do instanceArray[instanceArray.count +1] = tmpInst

		--	if o  (finditem instanceArray[1] o)	instanceArray[instanceArray.count +1] = tmpInst
					
				--	rndColor = color (random 0 255) (random 0 255) (random 0 255) --DEBUG
			--	select tmpInst
			--	i=tmpInst[1]
			for i in tmpInst where (finditem sel i) > 0 and  (finditem instances i) == 0  do 
			(
				append instances i
				append tempList i
			--	i.wirecolor = rndColor --DEBUG
				--	 instanceArray[instanceArray.count +1] = tmpInst	
			--	if (finditem instances obj) > 0 do instanceArray[instanceArray.count +1] = obj	
			--	instanceArray[instanceArray.count +1] = i 
			)
			instanceArray[instanceArray.count +1] = tempList		
		)

		for o in sel do
		(
			if (classof o  != Editable_Poly) do
				(
					addModifier o (Edit_Poly ())
					maxOps.CollapseNodeTo o 1 off
				)
		
				if o.scale.x < 0 or o.scale.y < 0  or o.scale.z < 0 do flip = 1
				
				resetxform o
				maxOps.CollapseNodeTo o 1 off	
				
				if flip==1 do
					(			
					addModifier o (Normalmodifier ()) 
					o.Normal.flip = on
				)
		)
	
		for o in instanceArray  do 
		(
			select o
			selAll =#()
			selAll=(for o in selection collect o)
			
			instancer = selAll[selAll.count]
			select instancer
			
			forInstance = #()
			
			i=1
			for o in selAll do
			(
				if i < (selAll.count) do append forInstance o		
				i=i+1
			)
			select forInstance
			
			for o in forInstance do o.baseObject = instancer.baseObject
		)
	select sel
	)
)--end

fn showObjectNames= --start
(
-- 	o=$
	gw.setTransform(Matrix3 1)
	for o in selection where not o.isHidden do
	(
		
		mdZpos = o.pos.z
		
		
		nameString = o.name 
		newName = ""


			if findstring nameString "\\" != 0 then 
			(
				
				NameTokens = filterString nameString "\\"

				for w=1 to NameTokens.count do 
				(	
					word = NameTokens[w]
					append newName word
					
					if w <  NameTokens.count  then append newName "\\\\"
				)
				
				nameString = newName
		
			)

					
-- 		Print ("DEBUG ----- showObjectNames: " + nameString )
		
-- 		gw.text o.pos nameString color:yellow
		gw.text o.center nameString color:yellow
			
	
-- 		gw.text o.pos (o.modifiers[1].name as string) color:yellow
		
-- 		if o.modifiers.count > 0 then
-- 		(
		for m in o.modifiers do	gw.text  [o.pos.x,o.pos.y,(mdZpos -= 140)] "SHIT" color:yellow
-- 		gw.text  [o.pos.x,o.pos.y,(mdZpos -= 140)] "SHIT" color:yellow
-- 		)
	
	) 
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
)--end

fn showObjectNamesON = --start
(
-- 	unRegisterRedrawViewsCallback showObjectNames
	showObjectNames()	
	registerRedrawViewsCallback showObjectNames
	showObjectNames()
	global showObjectNamesCallback = true
)--end
-- unRegisterRedrawViewsCallback 

fn showObjectNamesOFF = --start
(
	unRegisterRedrawViewsCallback showObjectNames
	global showObjectNamesCallback = false
)--end

-- global InfoBoxSelection
fn InfoBoxSelection =--start
(
	-- set a chocolate matrix with caramel topping, vanilla is so boring these days.
	gw.setTransform(Matrix3 1)
		-- check the selection count, because we shouldn't tickle more than 1 thing at a time! 
	
-- 	Print "InfoBoxSelection Start"
	if selection.count > 0 then
	(		
-- 		ycount=14
		GroupMembers = #()

		--starting Y point in screenEstate
		local ycount = 110
		--starting X point in screenEstate
		local xcount = 10
		-- Accumulate to track available space for rows and tally 'em up guvna!
		local rowcount = 1
		-- hold the viewport's YScreenEstate in high regard
		local ymax = (gw.getWinSizeY())	- 10 
			 
		namesLenght = 0
-- 		o=$	
-- 		gw.wText ([10,ycount,0]) ("Selection Info:") color:green
			
		ycount += 10	
		for o in selection do if o.name.count > namesLenght then namesLenght = o.name.count
		namesLenght = namesLenght *	8	
			-- Let's spit out the selection's name in white and then preset the location for the next text to spit into the y screenEstate
		
		objArray =  selection as array
-- 		objArray = undefined
			----separte group members and group dummies
		Groups =  for g in objArray where isgrouphead g collect g
		for g in Groups do ( for ch in g.children do append GroupMembers ch)
		for ch in GroupMembers do 
		(
			index = (finditem objArray ch)
			if index != 0 then deleteitem objArray (finditem objArray ch)
		)
		
		if objArray.count > 0 then
		(
			i=0
			for o in objArray do
			(	
				i+=1
				if i <= 65 then
				(

					if ycount > ymax then ( xcount = namesLenght + 20; ycount = 150	)

					
					if isgrouphead o then oWireColor = (color 255 127 178) else  oWireColor = o.wirecolor 
			
-- 					gw.wText [xcount,ycount+=14,0] ( i as string + " " + o.name) color:oWireColor --white;
					gw.wText [xcount,ycount+=14,0] ( o.name) color:oWireColor --white;
					
					if isgrouphead o  and not isOpengrouphead o then  gw.wText [(xcount + (o.name.count * 6) + 10),ycount,0] " [CLOSED]" color:yellow --white;)
					
					
					
					if isgroupMember o  then
					(
-- 						o=$
						xOffset = (xcount + (o.name.count * 6) + 10)
						 gw.wText [xOffset,ycount,0] " [ OPEN ]" color: (color 255 127 178) --white;)
						
						
						if	isgroupMember o.parent	then
						(
							
							theGroup = o.parent
							
							while isgroupMember	theGroup do
							(
								
								 gw.wText [xOffset +=45 ,ycount,0] " [ OPEN ]" color: (color 255 127 178) --white;)
								
								theGroup = theGroup.parent
							)
							
							
						)
						
						
						
						
						
						
						
						
						
						
					)
		-- 			ycount+=14
					
				
		-- 			for m in o.modifiers do	gw.wText [xcount,ycount+=14,0] m.name color:oWireColor --white;
					
		-- /* 			--------------------Child and Parents
				/*	
					if o.parent != undefined then
					(
						gw.setColor #line white ;
						gw.polyline #(o.pos,o.parent.pos) false;
						
						if isgrouphead o.parent then pWireColor = (color 255 127 178) else pWireColor = oWireColor

						
						gw.wText ([xcount,ycount+=14,0]) ("P:  "+ o.parent.name) color:pWireColor --white;
					)
					
					/*
					if o.children.count > 0 then
					(
						oCHildren = o.children
			
						for ch in oCHildren do
						(
						
							gw.setColor #line o.wirecolor
							gw.polyline #(ch.pos,ch.pos) false
							gw.wText ([xcount,ycount+=14,0]) ("Ch: "+ ch.name) color:oWireColor
						)
					)
					
		-- 			 */
					
					
-- 					gw.wText ([xcount,ycount+=8,0]) ("---------") color:green --white;

-- 					ycount+= 2

				)
			)
		)
		
	)
	global InfoBoxSelectionOn = true
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	completeredraw()
)--end

-- global InfoBoxModPanel

fn InfoBoxModPanel = --start
(
	-- set a chocolate matrix with caramel topping, vanilla is so boring these days.
	gw.setTransform(Matrix3 1)
		-- check the selection count, because we shouldn't tickle more than 1 thing at a time! 
	
-- 	Print "InfoBoxSelection Start"
	if selection.count > 0 then
	(
		--starting Y point in screenEstate
		local ycount = 250
		--starting X point in screenEstate
		local xcount = (gw.getWinSizeX()) - 90
		-- Accumulate to track available space for rows and tally 'em up guvna!
		local rowcount = 1
		-- hold the viewport's YScreenEstate in high regard
		local ymax = (gw.getWinSizeY())	
		allMods = #()
		oMOds = #()
		ModsShared = #()
			
		o = selection[selection.count]
		targetSel =  selection as array 	
		deleteitem targetSel selection.count
			
		if selection.count > 1 then
		(	
-- 			curObj = (modPanel.getCurrentObject ())
			
-- 			if curObj != undefined then 
-- 			(
-- 				gw.wText ([xcount,ycount+=14,0]) ((classof curObj ) as string)  color:(color 47 166 34)

				if o.modifiers.count > 0 then
				(
					oMOds = for m in o.modifiers collect m
					oModCount = o.modifiers.count
-- 					oSel = targetSel[1]
					
					for m=1 to oMods.count do
					(
						modCounter = 0
						TheMod = oMods[m]
-- 						t=targetSel[1]
						for t in targetSel where finditem t.modifiers TheMod != 0 do modCounter += 1
					
						if modCounter == targetSel.count then appendifunique ModsShared TheMod

					)
					
-- 		m=t.modifiers[1]
-- 				for m in allMods do	 gw.wText ([xcount,ycount+=14,0]) ((classof  m ) as string)  color:(color 47 166 34)
					if ModsShared.count > 0 then 
					(
						gw.wText ([xcount-5,ycount+=14,0]) "Shared Modifiers"  color:(color 47 166 34)	

						for m in MOdsShared do	 
						(
							
							if classof m == unwrap_uvw then toPrint = ( m.name + ": " + (	(m.getMapChannel ())as string) )
							else toPrint = m.name
			
							gw.wText ([xcount,ycount+=14,0])  toPrint  color:(color 47 166 34)
							
							
						)
					)
-- 				modPanel.getCurrentObject 1
-- 				for m in o.modifiers do print m

					 
				)	
	
-- 			)			
			ycount+=14			
		)	
	
		ycount = 320

-- 			o=$
		
		--------------------------OBJECT INFO
		if o.modifiers.count > 0 then
		(
			
			NameCount = o.name.count

			gw.wText ([xcount,ycount+=14,0]) o.name  color:(color 70 140 200)
			ycount+=6			
-- 			gw.wText ([xcount,ycount+=14,0]) "Modifers:" color:(color 70 140 200)
				
				-- Let's spit out the selection's name in white and then preset the location for the next text to spit into the y screenEstate
			
			for m in o.modifiers do 
			(
				if classof m == unwrap_uvw then toPrint = ( m.name + ": " + (	(m.getMapChannel ())as string) )
				else toPrint = m.name
				
				gw.wText ([xcount,ycount+=14,0]) toPrint color:white --white;
	
			)
			
			
		)
			
		gw.wText ([xcount,ycount+=14,0]) (o.baseobject as string)  color:(color 70 140 200)

		gw.enlargeUpdateRect #whole
		gw.updateScreen()
		completeredraw()
	)--	if selection.count > 0 END
)--end

-- InfoBoxToggle = undefined
fn InfoBoxToggle = 
(
/*
	 InfoBoxControl = true
	 InfoBoxControl = false
	*/
-- 	if InfoBoxControl == undefined then global InfoBoxControl = true
		
	if InfoBoxControl != true then	global InfoBoxControl = true else global InfoBoxControl = false 
	
	unregisterRedrawViewsCallback InfoBoxSelection
	unregisterRedrawViewsCallback InfoBoxModPanel
	completeredraw()

	if  InfoBoxControl ==  true then
		(
			------------------------InfoBoxSelection
			if getINISetting iniFile "InfoBox" "InfoBoxSelection" == "true"  then
			(
				InfoBoxSelection()
				registerRedrawViewsCallback InfoBoxSelection
-- 				completeredraw()

			)
			else 
			(
				unregisterRedrawViewsCallback InfoBoxSelection
-- 				completeredraw() 
			)	
			
			------------------------InfoBoxModPanel
			if getINISetting iniFile "InfoBox" "InfoBoxModPanel" == "true"    then
			(
				InfoBoxModPanel()
				registerRedrawViewsCallback InfoBoxModPanel
-- 				completeredraw()
			)
			else 
			(
				unregisterRedrawViewsCallback InfoBoxModPanel
			)
				completeredraw()
				setINISetting iniFile "InfoBox" "InfoBoxControl" (InfoBoxControl as string)
			
			
			------------------------
			if getINISetting iniFile "InfoBox" "ObjectInfo" == "true"    then
			(
				showObjectNamesON()
			)
			else 
			(
				showObjectNamesOFF()
			)
			
				completeredraw()
				setINISetting iniFile "InfoBox" "InfoBoxControl" (InfoBoxControl as string)
		
		)
		else
		(
				setINISetting iniFile "InfoBox" "InfoBoxControl" (InfoBoxControl as string)
		)

	
)
-- 		else
-- 		(

			
-- 			global InfoBox = false 
			
		
	






