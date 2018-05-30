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

fn getMatID MatID = 	
(
	/*
	MatID = 1
	*/
	max modify mode	
	sel = for o in selection where classof o.baseobject == Editable_Poly collect o
	subObj = subobjectLevel
	fnalSel = #()
	
	if sel.count > 0  then
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
				select sel
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

