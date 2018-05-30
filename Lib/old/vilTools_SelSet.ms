fn GetSet obj = 	--start
(
-- 	getSet $	
	ObjSets = for i=1 to selectionSets.count where finditem selectionSets[i] obj > 0 collect selectionSets[i]
	return ObjSets
		
)

fn selSetSelectByObject =
(
-- 	sel = selection
	FinSets = #()
	setIndex = 1
	if FinSet == undefined then global FinSet = ""
-- 	if LastSelSetObj == undefined then global LastSelSetObj = $
	
	
	for o in selection do
	(
		oSets = GetSet o
		for s in oSets do appendifunique FinSets s.name
	)
	
	
	if FinSets.count > 0 then 
	(
		
		setIndex = finditem FinSets FinSet	
		SetsCount = FinSets.count
		if setIndex != 0 and setIndex < SetsCount then FinSetName = FinSets[setIndex+1] else FinSetName = FinSets[1] 
		
-- 		if FinSet == undefined then FinSet = FinSets[1]

		
		selSet = selectionSets[FinSetName]
		
		if selSet != undefined then	
		(
			select selSet
			FinSet = selSet.name
		)
	)
	
)

fn selSetAdd byLast = 
(
	if selection.count > 0 then
	(	
		curObjSet = #()
		sel = selection as array
		lastSel = sel[sel.count]
		
		if byLast == 1 then curObjSet = (GetSet lastSel)[1]
		else
		(
			for o in sel do
			(
-- 				o=$
				selSets =  GetSet o
				for s in selSets do appendifunique curObjSet s.name
			)
			
			if curObjSet.count > 0 then
			(
-- 				curObjSetName = curObjSet[1].name
				curObjSet = selectionSets[curObjSet[1]]
			)
			else  curObjSet = undefined
			
		)
	-- 				o=sel[1]
	
	
		if curObjSet != undefined then

		(			
			setObjects = for o in  curObjSet collect o
			for o in sel do appendifunique setObjects o			
			selectionSets[curObjSet.name] = setObjects	
		)
		else				
		(	
			selectionSets[lastSel.name + "_Sel"]	= (selection as array)		
		)
	)
)
	


fn selSetRem byLast = 
(
	if selection.count > 0 then
	(
		sel = selection as array
		selSet = #()
		
		if byLast == 1 then
		(
			lastSel = selection[selection.count]
			
			curObjSets = GetSet lastSel	
			if curObjSets.count != 0 then
			(
				curObjSet = curObjSets[1]	
				curObjSetName = curObjSet.name	
				
				if curObjSet != undefined then
				(
					
					setObjects = for i in  curObjSet collect i
					selectionSets[curObjSetName] = #()					
					for o in sel where finditem setObjects o != 0 do deleteitem setObjects (finditem setObjects o)					
					selectionSets[curObjSetName] = setObjects					
					if selectionSets[curObjSetName].count ==  0  then deleteItem selectionSets selectionSets[curObjSetName]
					
				)
			)
		)
		else
		(
-- 				o=sel[2]

			for o in sel do
			(
				curObjSets =  GetSet o
-- 					oSet = selSet[1]
-- 		o=$
				if curObjSets.count != 0 then
				(
					for oSet in curObjSets do
					(
						curObjSetName = oSet.name	
						setObjects = for obj in oSet collect obj	
						deleteitem setObjects (finditem setObjects o)		
						selectionSets[curObjSetName] = setObjects					
						if oSet.count ==  0  then deleteItem selectionSets  oSet

					)
				)
			)
		)
	)	
)
fn selSetName var  =
(
			sel = selection as array	
	-- 		lastSel = sel[sel.count]
			curObjSet = #()		
			for o in sel do
			(
				selSets =  GetSet o
				for s in selSets do appendifunique curObjSet s.name
			)
			local curObjSet = selectionSets[curObjSet[1]]
			curObjSet.name = var

)

/*
fn selSetRename = 
(
	try(destroydialog rollSelSetName)catch()
	
	if selection.count > 0 then
	(	
		
		sel = selection as array	
-- 		lastSel = sel[sel.count]
		curObjSet = #()		
		for o in sel do
		(
			selSets =  GetSet o
			for s in selSets do appendifunique curObjSet s.name
		)
		local curObjSet = selectionSets[curObjSet[1]]
		
		mousepos = mouse.screenpos 
		
		if curObjSet != undefined then
		(
			rollout rollSelSetName ""
			(
-- 				var = "test"
				edittext ETselSetName text:curObjSet.name width:156 pos:[0,4]
				
				on ETselSetName entered var do 
				(
-- 					selSetName var 
					curObjSet.name = var
					destroydialog rollSelSetName
				)
			)
			createdialog rollSelSetName  width:160 height:24  pos:[mousepos.x-80,mousepos.y-32]
		)		
	)
)
*/



