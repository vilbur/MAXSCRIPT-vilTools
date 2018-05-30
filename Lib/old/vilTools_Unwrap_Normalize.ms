fn round_to_v val n = 
(
&nbsp;&nbsp;&nbsp;&nbsp;local mult = 10.0 ^ n
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(floor ((val * mult) + 0.5)) / mult
)

fn getUVselection objArray =
(
	allSelected = #()
	uv = modPanel.getCurrentObject ()	
-- 	uv = modPanel.getCurrentObject ()
	
-- 	UVch = 1 
-- 	objArray = selection as array
-- 	ElementFlags.count
-- 	o=objArray[1]
	
	 for o in objArray do
	(	
		
		/*local*/ selected = #{}
		
		case subobjectLevel of
		(
			1:(selected = uv.getselectedVerticesByNode o )
			2:(selected = uv.getselectedEdgesByNode o )
			3:(selected = uv.getselectedFacesByNode o )
		)
		
		append allSelected selected
		
	)
	
	allSelected
	
	
)

fn setUVselection objArray origSel UVch =
(
	uv = modPanel.getCurrentObject ()	
-- 	uv = modPanel.getCurrentObject ()
	
-- 	UVch = 1 
-- 	objArray = selection as array
-- 	ElementFlags.count
-- 	o=objArray[1]
	 for oI = 1 to objArray.count do
	(	
		o = objArray[oI]
		objArrayObj = origSel[oI]
		/*local*/ selected = #{}
		
		case subobjectLevel of
		(
			1:(uv.selectVerticesByNode objArrayObj o )
			2:(uv.selectEdgesByNode objArrayObj o )
			3:(uv.selectFacesByNode objArrayObj o )
		)
	
	)
	
)

fn getFacesOfSel objArray UVch = 
(
	allSelected = #()
	uv = modPanel.getCurrentObject ()	
	 for o in objArray do
	(	
		/*local*/ selected = #{}		
		case subobjectLevel of
		(
			1:(uv.vertToFaceSelect();selected = uv.getselectedFacesByNode o )
			2:(uv.edgeToFaceSelect(); selected = uv.getselectedFacesByNode o )
			3:(selected = uv.getselectedFacesByNode o )
		)
		
		append allSelected selected
	)
	allSelected	
)

fn getVertOfSel objArray UVch = 
(
	allSelected = #()
	uv = modPanel.getCurrentObject ()	
	 for o in objArray do
	(	
		/*local*/ selected = #{}		
		case subobjectLevel of
		(
			1:(selected = uv.getselectedVerticesByNode o )
			2:(uv.edgeToVertSelect(); selected = uv.getselectedVerticesByNode o )
			3:(uv.FaceToVertSelect();selected = uv.getselectedVerticesByNode o )
		)
		
		append allSelected (selected as array)
	)
	allSelected	
)

fn SaveVertPos objArray UVch = 
(
	allPositions = #()
	vertPos = #()
	alluvP3 = #()
	allSelVerts = #()

	uv = modPanel.getCurrentObject ()	
	 	for o in objArray do
			(		
				uvP3 = #()
				selVerts = uv.getSelectedVerticesByNode o 
				append allSelVerts (uv.getSelectedVerticesByNode o)
				for v=1 to  polyop.getNumMapVerts o UVch	do append uvP3	(polyop.getMapVert o UVch v )
				append alluvP3 uvP3
			)
			
	alluvP3	
)

fn getUVElements =---objArray UVch =
(
/*
		o = objArray[1]
		o = objArray[2]
		o = objArray[3]
*/
	/*local*/ allElementFlags = #()
	/*local*/ subObj = subobjectLevel
	/*local*/ uv = modPanel.getCurrentObject ()	
	/*local*/ UVch = uv.unwrap.getMapChannel ()
		if UVch == 0 then UVch = 1
	/*local*/ objArray = selection as array
	/*local*/ subObjSelected = false
	/*local*/ origSel =  getUVselection objArray --UVch
	for a=1 to origSel.count where (origSel[a] as array).count > 0 do subObjSelected = true   
-- 	ElementFlags.count
		
	for o in objArray do
	(	
		numVerts = uv.numberVerticesByNode o
		ElementFlags = #()
		for i=1 to numVerts do append ElementFlags	0 --rset array with 0
	 
		/*local*/ ElCounter = 0
		/*local*/ elemVerts = #{}
		
		subobjectLevel = 1
-- 			v+=1
			with redraw off
			for v = 1 to numVerts do 
			(
				-- If vertex has no element assigned yet, create a new element.
				if ElementFlags[v] == 0 then 
				(
					max select none
					uv.selectVerticesByNode #{v} o
					uv.selectElement()
					elemVerts = uv.getSelectedVerticesByNode o
					-- Ignore ElCounter with less than 3 UV vertices.
				
					ElCounter += 1
					for i in elemVerts do ElementFlags[i] = ElCounter -- Mark these vertices with their element number in ElementFlags.
				)
			)
			append allElementFlags ElementFlags	 	 
	) 	 
	
	if subObjSelected then 
	(
		subobjectLevel = subObj
		setUVselection objArray origSel UVch
		
	)
	allElementFlags

)

fn vertDist vA vB =
(
	EdgeLenght = sqrt ((pow (vA.x-vA.y) 2 ) + (pow (vB.x-vB.y) 2 ))
	EdgeLenght
)

fn VectorDir vect =
(
	dir = atan (vect.y/vect.x)
	if vect.x < 0 and vect.y > 0 then dir = 180+dir
	if vect.x < 0 and vect.y < 0 then dir = -180+dir
	dir
)	

fn getFaceArea vectors =
(
-- 	vectors = GeoPos
-- 	vectors = uvPos
	
	if vectors.count >= 3 then
	(
-- 		print ("vectors: " + vectors as string)
		/*local*/ triArea_1
		/*local*/ triArea_2
	
		Auv = vectors[1] -- get vertics of triangle
		Buv = vectors[3]
		Cuv = vectors[2]


		triArea_1 =  	( CROSS  (Auv- Buv)   (Cuv- Buv)	)/2
		triArea_1 = abs  (triArea_1.x + triArea_1.y + triArea_1.z)

		if vectors.count > 3 then 
		(
			Cuv = vectors[4]
			triArea_2 =   ( CROSS  (Auv- Buv)   (Cuv- Buv)	)/2
			triArea_2 = abs ( triArea_2.x + triArea_2.y + triArea_2.z)

		)							
		if triArea_2 != undefined then FaceUvArea = triArea_1 + triArea_2 else FaceUvArea = triArea_1
		
		FaceUvArea
	)
)

-- setUnWrapMod (selection as array)
fn setUnWrapMod objArray  =
(
			max modify mode		
			/*local*/ curObj = modPanel.getCurrentObject ()
			applyModSel = vilTools_InstanceTest objArray  -- exclude instancs
			if classof curObj != Unwrap_UVW then 
			(
			addModifier applyModSel (Unwrap_UVW ()) 
			select objArray
			)
			/*local*/ curObj = modPanel.getCurrentObject ()
		curObj
)

fn normalizeUVs averageUV = --start
(	
	
	if selection.count > 0 then --start
	(
		/*local*/ OrigObjArray = selection as array
		objArray = vilTools_InstanceTest OrigObjArray
		
		noEditablePoly = for o in objArray where classof o.baseobject != Editable_Poly collect o

		if noEditablePoly.count > 0 then
		(			
-- 			noEditablePoly=selection as array
			if yesNoCancelBox "Some of selected objects ar not Editable Poly, Do you want to convert it?"  title:"Convert to Editabe Poly"	== #yes	then 
			(
				addModifier noEditablePoly (Edit_Poly ()) 
				for o in noEditablePoly do maxOps.CollapseNodeTo o 1 off
			)
			else
			(
				for o in noEditablePoly do deleteitem objArray (finditem objArray o )
				select objArray
			)
		)
		
		undo "normalizeUVs" on
		(
			clearListener ()
			with redraw off --start
			(
				max modify mode
				/*local*/ origSel = #()
				/*local*/ origVertSel = #()
				/*local*/ alluvP3 = #()
	-- 			/*local*/ origFaceSel = #()
				/*local*/ allFirstVerts = #()
				/*local*/ AllElementRatios = #()
				/*local*/  scaleCoef = 0
				/*local*/  subObjSelected = false
				/*local*/ uv = setUnWrapMod objArray
						
				/*local*/  subObj = subobjectLevel
				/*local*/ UVch = uv.getMapChannel ()
						if UVch == 0 then UVch = 1
				/*local*/ origSel =  getUVselection objArray --UVch

				origVertSel = getVertOfSel objArray UVch
-- 				theArray = origSel	[1]	
				

					
						
				for theArray in origSel where (theArray as array).count > 0  do subObjSelected = true	
					
				if subObjSelected then 
				(
-- 					origSel = getUVselection objArray UVch 
-- 					max select none
					uv.selectElement()
					origVertSel = (getVertOfSel objArray UVch)
				)
				else 
				(
					
					origVertSel = #()	
					for o=1 to objArray.count do  append origVertSel (#{1..uv.numberVerticesByNode objArray[o]} as array) --  if not subobject slected then gt all verts as slected
				)
	-- 				o=objArray[1]			--------------------------------------DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		
				indexObj = 1
				for o in objArray do  --start
				(		
	-- 				/*local*/ oFaceSel = origFaceSel[ObjIndex]
					/*local*/ firstVerts = #()
					/*local*/ UVelements = #()
					/*local*/ ElementRatio = #()
					/*local*/ ElementFlags  = #()
-- 					/*local*/ origVertSelObj  = #()
				
-- 					FirstVerts = allFirstVerts[indexObj]
					origVertSelObj = origVertSel[indexObj]

					
					numVerts = uv.numberVerticesByNode o
					for i=1 to numVerts do append ElementFlags	0 --reset array with 0
				 
					/*local*/ ElCounter = 0
					/*local*/ elemVerts = #{}				
					subobjectLevel = 1

					for v = 1 to numVerts do 
					(
						--  assign new elemnt number when is 0
						if ElementFlags[v] == 0 then 
						(
							max select none
							uv.selectVerticesByNode #{v} o
							uv.selectElement()
							elemVerts = uv.getSelectedVerticesByNode o
							-- Ignore ElCounter with less than 3 UV vertices.
						
							ElCounter += 1
							for i in elemVerts do ElementFlags[i] = ElCounter -- Mark these vertices with their element number in ElementFlags.
						)
					)
					 UVelements = ElementFlags

					for VertexNum=1 to UVelements.count do
						(if UVelements[VertexNum] == FirstVerts.count+1 then append FirstVerts VertexNum 
						VertexNum+=1)
						
					origVertSelObj = origVertSel[indexObj]	
						
-- 					for i = 1 to FirstVerts.count where finditem origVertSelObj FirstVerts[i] != 0  do		
					 --------------------FOR  ELEMENT
					for i = 1 to FirstVerts.count where finditem origVertSelObj FirstVerts[i] != 0 do --start for element
					(
						/*local*/ UvAreaOfElement = 0.0
						/*local*/ AreaGeoElement = 0.0
						subObjectLevel = 1
						
						max select none
						uv.selectVerticesByNode #{FirstVerts[i]} o
						uv.selectElement()
						uv.vertToFaceSelect()
						subObjectLevel = 3
						/*local*/ FaceSel = (uv.getSelectedPolygonsByNode o)as array
	-- 					Print ("DEBUG----------- FaceSel: " + FaceSel as string)

						--------------------FOR EVERY FACE
						for f = 1 to FaceSel.count do 
						(
		-- 					f+=1
							Face = FaceSel[f]
		-- 					uv.selectFacesByNode #{FaceSel[f]} o
							/*local*/ faceVerts = #()
							/*local*/ uvPos = #()
							/*local*/ GeoPos = #()
							/*local*/ vCountByFace = (uv.numberPointsInFaceByNode  Face o)
							FaceGeoVerts = polyop.getFaceVerts o Face
							FaceGeoVerts = sort FaceGeoVerts						
							for v = 1 to vCountByFace do faceVerts[v] =  uv.getVertexIndexFromFaceByNode Face v o
								
							faceVerts = sort faceVerts
							for v=1 to faceVerts.count do uvPos[v] =  uv.getVertexPositionByNode  0 faceVerts[v] o
							for v=1 to FaceGeoVerts.count do GeoPos[v] = polyOp.getVert o FaceGeoVerts[v]
	-- 						Print ("DEBUG----------- object: " + o.name)
	-- 						Print ("DEBUG----------- face: " + f as string)
	-- 						Print ("DEBUG----------- vCountByFace: " + vCountByFace as string)						
	-- 						Print ("DEBUG----------- faceVerts: " + faceVerts as string)
	-- 						Print ("DEBUG----------- FaceGeoVerts: " + FaceGeoVerts as string)
	-- 						Print ("DEBUG----------- GeoPos: " + GeoPos as string)
	-- 						Print ("DEBUG----------- uvPos: " + uvPos as string)
	-- 						
							AreaGeoElement += getFaceArea GeoPos
							UvAreaOfElement += getFaceArea uvPos
						)
						
						
						
						append ElementRatio (	(sqrt	( UvAreaOfElement / AreaGeoElement )	)	*1000	)
		-- 				i+=1
					)	--end  for element
					
-- 					print ("---------------------------------ElementRatio: " + o.name + ElementRatio as string)
				
					append AllElementRatios ElementRatio
					append AllFirstVerts FirstVerts 
					
					indexObj += 1
		
				) --end FOR O IN OBJARRAY
		
					-- if scaleCoef ==1 then UV 0-1 == 1000 world units
				mapResolution =  rollUnwrap.btnResNorm.text as float
				mapDensity =  rollUnwrap.spnPxDensity.value as float
				
				
-- 					if scaleCoef == undefined then scaleCoef = ElementRatio[1]
-- 				print ( "objArray: " + objArray as string)
-- 				print ( "AllElementRatios: " + AllElementRatios as string)
-- 				print ( "allFirstVerts: " + allFirstVerts  as string)
-- 				print ( "origVertSel: " + origVertSel  as string)
							
					--if density 0 then averge UVs
				if averageUV then
					(
						local scaleCoefTemp = #()
-- 						scaleCoef = 0
-- 						ElementRatio = AllElementRatios[1]
						for ElementRatio in AllElementRatios do for r in ElementRatio do scaleCoef+= r --append scaleCoefTemp r
							
-- 						r=1
-- 						while  r <= scaleCoefTemp.count and	(round_to_v scaleCoefTemp[1] 3) as float == (round_to_v scaleCoefTemp[r] 2) as float do 
-- 						(
-- 							print "yes"							
-- 							if r ==  scaleCoefTemp.count then 
-- 							(
-- 								scaleCoefTemp =  #(1.0)
-- 								for a=1 to scaleCoefTemp.count do scaleCoefTemp[a] = 1.0
-- 								print  "averageUV: TRUE"
-- 							)
-- 							r+=1	
-- 						)
						
-- 						for r in scaleCoefTemp do scaleCoef+= r
-- 							r = ElementRatio[1]
						scaleCoef = scaleCoef/AllElementRatios.count
					)
				else if mapDensity != 0 then scaleCoef = (mapResolution / mapDensity )
					
-- 				print ("------------------scaleCoef: " + scaleCoef as string)

-- 				obj=objArray[1]			--------------------------------------DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		
-- 				obj=objArray[2]			--------------------------------------DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		
-- 				obj=objArray[3]			--------------------------------------DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		
								
				indexObj=1
				for obj in objArray do  --start
				(	
-- 					obj = objArray[o]
					ElementRatio = AllElementRatios[indexObj]
					FirstVerts = allFirstVerts[indexObj]
					origVertSelObj = origVertSel[indexObj]
			
-- 					print ( "obj: " + obj as string)
-- 					print ( "ElementRatio: " + ElementRatio.count as string)
-- 					print ( "FirstVerts: " + FirstVerts.count  as string)
-- 					print ( "origVertSelObj: " + origVertSelObj.count  as string)	
					
-- 					if  not subObjSelected then origVertSelObj = FirstVerts -- if nothingh was selected then use all vertices as selected
				
					for i = 1 to FirstVerts.count where finditem origVertSelObj FirstVerts[i] != 0  do 
					(
						subObjectLevel = 1
						max select none
						uv.selectVerticesByNode #{ FirstVerts[i]} obj
						uv.selectElement()
						uv.scaleSelectedVerticesCenter ((1/ElementRatio[i])*scaleCoef) 0
-- 						uv.scaleSelectedVerticesCenter (1/1.80034) 0
					
					)
					indexObj+=1
	
				)
				----------------------------------------------------RESELECT----------------------------------------------------
				if subObjSelected then -- reselect original selection
				(
					subobjectlevel = subObj
-- 					o+=1
					for o=1 to objArray.count do
					(
						obj = objArray[o]
						toSel = origSel[o]
						
						case subObj of
						(
							1:(uv.selectVerticesByNode toSel obj )
							2:(uv.selectEdgesByNode toSel obj )
							3:(uv.selectFacesByNode toSel obj )
						)
					)
				)
				else if subObj != 0 then max select none
		
				if rollUvViewer.cbxViewerRefresh.state  then  select OrigObjArray
				
			
				
				
				
				
			)	--end with redraw off
		)	
			
	)	--end  selection.count > 0
)	--end FN


--		 PackUVs_Vt "LMB"

fn PackUVs_Vt mouseButton =
(
	if selection.count > 0 then 
	(
		/*local*/ alluvP3 = #()
		/*local*/ subObjSelected = false
		/*local*/ OrigObjArray = selection as array
		/*local*/ objArray = vilTools_InstanceTest OrigObjArray  -- exclude instancs 
		/*local*/ uv =  setUnWrapMod objArray  -- add unwrap
		/*local*/  subObj = subobjectLevel
		/*local*/ UVch = uv.getMapChannel ()
		if UVch == 0 then UVch = 1
		/*local*/ origSel =  getUVselection objArray --UVch
-- 		theArray=origSel[1]
		for theArray in origSel do 
			(
				theArrayCount = theArray.Count
				if theArrayCount != 0 then subObjSelected = true 
				print theArray as string
			)
-- 			getUVElements()
		/*local*/ origVertSel =  getVertOfSel objArray UVch
		/*local*/ alluvP3 =  SaveVertPos objArray UVch
		
		PaddingPX = rollUnwrap.spnPadingUV.value 
		MapResolution = rollBaking.btnResBake.text as integer
						
		Coef = MapResolution / 256
		PaddingBase = (PaddingPX  as float/ Coef as float)
		PxSpace = 0.00256
		PxGridS = 1.0/MapResolution
		uv.setGridSize (PxGridS / Coef)

-- 	TheSpacing = 1.0/MapResolution
		TheSpacing = PxSpace * PaddingBase * 4  -- multiply by 2 because of real rendering padding
-- 		TheSpacing = (round_to_v TheSpacing 11) as float 
-- 		TheNormalize = val do getINISetting iniFile "PackOptions" "TheNormalize"
-- 		TheNormalize = false
		TheRotate = getINISetting iniFile "PackOptions" "btxRotate"
		TheFillHoles =  getINISetting iniFile "PackOptions" "btxFillHoles"

-- 		if TheFillHoles == "" then TheFillHoles = false
		if TheFillHoles == "" then TheFillHoles = false else  TheFillHoles = TheFillHoles as booleanclass
		if TheRotate == "" then TheRotate = false else  TheRotate = TheRotate as booleanclass
			
		if mouseButton == "LMB" then  TheNormalize = false else TheNormalize = true
			
-- 		print ("--------TheSpacing:" + TheSpacing as string)
		
		uv.pack 1 TheSpacing TheNormalize TheRotate TheFillHoles
		
-- 		if not subObjSelected then max select all
-- 		uv.MoveSelected [PxGridS/2,PxGridS/2,0]
-- 		if not subObjSelected then max select none

		
	/*	if origSel.count > 0 then		
		(	
			subobjectlevel = 1
			for oI=1 to objArray.count do
			(
				o = objArray[oI]
				objUvP3 = alluvP3[oI]
				objVertSel = origVertSel[oI]
				
				for v=1 to  polyop.getNumMapVerts o UVch where finditem objVertSel v == 0 do 
				(					
					vertP3 = objUvP3[v]
					max select none
					uv.selectVerticesByNode #{v} o

					uv.moveY vertP3.y
					uv.moveX vertP3.x
				)
			)
			subobjectlevel = subObj		
			setUVselection objArray origSel UVch
-- 			max select invert

		)
		else if rollUvViewer.cbxViewerRefresh.state then  select OrigObjArray
*/
		if subObjSelected then setUVselection sel origSel UVch
	
	)
	
		
		
)


function vilTools_Relax RelaxAxis =
(
/*	
	RelaxAxis="x"
	o=sel[1]
	o=sel[2]
	vilTools_Relax "y"
	vilTools_Relax "x"
	*/
	
	
	if selection.count > 0 then
	(
		
	undo 	"vilTools_Relax" on
		
		(
			uvP3 = #()
			alluvP3 = #()
			allSelVerts = #()
			origSel = #()
			subobj = subobjectlevel
			sel = selection as array
			uv = modpanel.getcurrentobject()
			UVch = uv.unwrap.getMapChannel ()
			if UVch == 0 then UVch = 1
			/*local*/ subObjSelected = false
			origSel =  getUVselection sel --UVch
			for a=1 to origSel.count where (origSel[a] as array).count > 0 do subObjSelected = true   
	
			
			case subobjectlevel of
			(
				2:(actionMan.executeAction 2077580866 "40099")
				3:(actionMan.executeAction 2077580866 "40101")
			)
			
			subobjectlevel = 1

			for o in sel do
			(		
				uvP3 = #()
				selVerts = uv.getSelectedVerticesByNode o 
				append allSelVerts (uv.getSelectedVerticesByNode o)
				for v=1 to  polyop.getNumMapVerts o UVch	do append uvP3	(polyop.getMapVert o UVch v )
				append alluvP3 uvP3
			)	
			
			uv.relaxByFaceAngle 1000 0 1 false  -------RELAX
			
			for o in sel do uv.unwrap6.selectVerticesByNode #{} o
			
			if RelaxAxis != "xy" then
			(
				for o=1 to  sel.count do
				(	
					obj = sel[o]
					uvP3 = alluvP3[o]
					for v = 1 to (polyop.getNumMapVerts obj  UVch) do 
					(
						uv.unwrap6.selectVerticesByNode #{v} obj
						origPos = uvP3[v]
						case RelaxAxis of
						(
							"x":(uv.moveY origPos.Y)
							"y":(uv.moveX origPos.X) 
						)
						uv.unwrap6.selectVerticesByNode #{} obj
						v+=1
					)
					o+=1
				)
				
				for o=1 to sel.count do
				(
					obj = sel[o]
					uv.unwrap6.selectVerticesByNode allSelVerts[o] obj
				)
			)
			
			subobjectlevel = subobj
			if subObjSelected then setUVselection sel origSel UVch
			
		)
	)
)

fn selectSimilarUV = 
(	
	/*local*/ subobj = subobjectlevel
	/*local*/ objArray = selection as array
	/*local*/ firstVert = #()
	/*local*/ ArrayCounter = #()
	/*local*/ uv = modpanel.getcurrentobject()
	/*local*/ UVch = uv.unwrap.getMapChannel ()
	if UVch == 0 then UVch = 1
		
	/*local*/ origSel =  getUVselection objArray --UVch
	/*local*/ Elements = getUVElements()
-- 	for a in Elements do print a 
	
	VertSel = getVertOfSel objArray UVch
	for a=1 to origSel.count where (origSel[a] as array).count > 0 do subObjSelected = true   

	if subObjSelected then
	(
		
		for a=1 to VertSel.count do
		(
			obj = objArray[a]
			objVertSel = VertSel[a]
			if  objVertSel.count > 0 then 
			(
			 uv.selectVerticesByNode #{objVertSel[1]} obj
-- 			exit
			)
		)

		subobjectlevel = 1
		uv.selectElement ()
		OrigElement =  (getVertOfSel objArray UVch)
		for subA in OrigElement do (if subA.count > 0 then OrigElement = subA)
		

		max select none
-- 		oi+=1
		for oi=1 to objArray.count do
		(
			obj = objArray[oi]
			ElementsByVert = Elements[oi]
			ElementCount = (makeUniqueArray  ElementsByVert).count
			ArrayCounter = #() -- index of every item is number of elemt a item value is vertexcount of element
			/*local*/ FinSel = #()

			for i=1 to ElementCount do ArrayCounter[i] = 0
-- 		vertNum+=1
			for vertNum=1 to ElementsByVert.count do 
			(
				ElementIndex = ElementsByVert[vertNum]
				ArrayCounter[ElementIndex] = ArrayCounter[ElementIndex] += 1
			)	

			validIndexes = #()
			
			for eI=1 to ArrayCounter.count where ArrayCounter[eI] == OrigElement.count do  appendifunique validIndexes eI

			for eI in validIndexes do
			(

				for i=1 to ElementsByVert.count where ElementsByVert[i] == eI  do  appendifunique FinSel i
			)

			uv.selectVerticesByNode (FinSel as bitarray) obj

			
		)
	)
)




