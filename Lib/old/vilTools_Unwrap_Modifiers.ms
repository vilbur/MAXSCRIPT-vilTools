fn Convert_To_UVelement_v =
(	
	--activeMod = modPanel.getCurrentObject()
	selection[1].unwrap_uvw.unwrap2.selectElement() 
)

fn round_to_v val n = 
(
&nbsp;&nbsp;&nbsp;&nbsp;local mult = 10.0 ^ n
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(floor ((val * mult) + 0.5)) / mult
)

fn isUVEditorOpen_VT = 
(
	curObj = modpanel.getcurrentobject()
	if classof curObj == unwrap_uvw then
	(		
		local win =  curObj.GetWindowW()
		if  win != 0 then UVEditorIsOpen = true else UVEditorIsOpen = false
	
	)
	else  UVEditorIsOpen = false
	
	UVEditorIsOpen
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
		if selected == undefined then selected = #{}
		
		append allSelected selected
		
	)
	allSelected
)

fn setUVselection objArray origSel UVch =
(
	uv = modPanel.getCurrentObject ()	
-- 	uv = modPanel.getCurrentObject ()
	objArrayCount = objArray.count
-- 	UVch = 1 
-- 	objArray = selection as array
-- 	ElementFlags.count
-- 	o=objArray[1]
	 for oI = 1 to objArrayCount do
	(	
		o = objArray[oI]
		objArrayObj = origSel[oI]
-- 		/*local*/ selected = #{}
		
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
	selected = #()
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

fn getEdgesOfSel objArray UVch = 
(
-- 	 getEdgesOfSel (selection as array) 1 
	allSelected = #()
	selected = #()
	uv = modPanel.getCurrentObject ()	
-- 	o=objArray[1]
	 for o in objArray do
	(	
		/*local*/ selected = #()		
		case subobjectLevel of
		(
			1:(uv.vertToEdgeSelect();selected = uv.getselectedEdgesByNode o )
			2:(selected = uv.getselectedEdgesByNode o )
			3:(uv.FaceToEdgeSelect();selected = uv.getselectedEdgesByNode o )
		)
		
		append allSelected selected
	)
	
	for a=1 to allSelected.count where allSelected[a] == undefined do allSelected[a]  = #()
-- 		allSelected.count
-- 		edgeSel.count
-- 	allSelected[46]

	allSelected	
)

fn getGEOEdgesOfSel objArray = 
(
 	
	polyEdgesFinal = #()
	uvmod = modPanel.getCurrentObject ()	
	UVch = uvmod.getMapChannel ()
	if UVch == 0 then UVch = 1
	edgeSel = getEdgesOfSel objArray UVch
	
/*	
	o=objArray[1]
	o=objArray[46]
	oi=46
	edgeSel.count
		for a in edgeSel do print a
	(i=0;	for a in objArray do print (( i+=1  ) as string + "   ---  " + a.name)	)
	(i=0;	for a in edgeSelObj do print (( i+=1  ) as string + "   ---  " + a as string)	)
	*/
	
	for oi=1 to objArray.count do
	(
		o=objArray[oi]
--  		edgeSelObj = uvmod.getselectedFacesByNode o
  		edgeSelObj = edgeSel[oi] as array
		uvEdges = #()
 		uvEdgesObj = #()
 		subobjectlevel = 1
		
 		
 		-- Get the vertices of each edge
-- 		theE = edgeSelObj[1]
 		for theE in edgeSelObj do (
 			uvmod.selectEdges #{theE}
 			uvmod.edgeToVertSelect()
 			append uvEdges (uvmod.getSelectedGeomVertsbynode o as array)
 		)
 		
 		-- Restore the edge selection
-- 		subobjectlevel = 2
 		uvmod.selectEdgesByNode (edgeSelObj  as bitarray) o
 		
 		-- Get the corresponding poly edges
--  		modPanel.setCurrentObject $.baseObject
 		cGetVerts = polyop.getEdgesUsingVert
 		polyEdges = for v in uvEdges collect (((cGetVerts o #{v[1]}) * (cGetVerts o #{v[2]})) as array)[1]
 		
 		-- Set the edge selection
--  		polyop.setEdgeSelection o polyEdges
-- 		modPanel.setCurrentObject uvmod
	
 		subobjectlevel = 2
		for theE in polyEdges do appendifunique uvEdgesObj theE
		uvEdgesObj = (sort uvEdgesObj) as bitarray
		append polyEdgesFinal uvEdgesObj
		
 	)
 	
 	polyEdgesFinal
	
	
)
 
fn SetGEOEdgesOfSel obj GeoEdgeArray  = 
(
--  	GeoEdgeArray = #{8}
--  	GeoEdgeArray =  #{52}
-- 	GeoEdgeArray =  EdgesSelGeoObj
-- 	SetGEOEdgesOfSel selection[1] #{11}
-- 	obj=selection[1]
	/*local*/ ObjArray =  getGeometrySel()	
	uvEdges = #()
	EdgesFinal = #()
	uvmod = modPanel.getCurrentObject ()	
	UVch = uvmod.getMapChannel ()
	if UVch == 0 then UVch = 1
	EP = obj.baseObject
	edgeSel = (getEdgesOfSel obj UVch)[1]

	objIndex = (finditem ObjArray obj)
	
--  		modPanel.setCurrentObject obj.baseObject
-- 		theEdge = (#{(GeoEdgeArray as array)[1]} as array)[1]
-- 		theEdge = (#{(GeoEdgeArray as array)[2]} as array)[1]


	for theEdge in (GeoEdgeArray as array) do
	(
-- 		EP.SetSelection #Edge #{theEdge}
-- 		uvmod.selectEdgesByNode #{theEdge} obj
-- 			( theE = edgeSel as array)[1]
			for theE in edgeSel do (
 			uvmod.selectEdgesbyNode #{theE} obj
 			uvmod.edgeToVertSelect()
--  			append uvEdges (getGEOEdgesOfSel #(obj))
 		)
		subobjectLevel = 1
-- 		for o in objArray do uv.selectVerticesByNode #{} o
-- 	uvmod.selectEdgesByNode #{} obj

		GeoEdgeVerts = polyop.getVertsUsingEdge  obj #{theEdge}
		uvmod.setSelectedGeomVertsByNode GeoEdgeVerts obj
		uvmod.vertToEdgeSelect()
		
		for newEdgeSel in  (uvmod.getselectedEdgesByNode obj) do append EdgesFinal newEdgeSel
-- 		uv.setSelectedGeomVertsByNode GeoEdgeVerts obj	
	
	)
	
	uvmod.selectEdgesByNode (EdgesFinal as bitarray) obj
	subobjectLevel = 2

-- 	uvmod.edgeVerts (EdgesFinal as bitarray) obj
--  	polyEdgesFinal = polyEdgesFinal as bitarray
	
	
)
 
fn convertUVedgeToGeo =
(
	
		undo "convertUVedgeToGeo" on
	(
-- 		max modify mode
		/*local*/ objArray = getGeometrySel()

		if objArray.count > 0 and classof (modpanel.getcurrentobject()) == Unwrap_UVW then
		(
-- 			/*local*/ subobj = subobjectlevel
-- 			/*local*/ ArrayCounter = #()
			/*local*/ uv = modpanel.getcurrentobject()
			/*local*/ UVch = uv.unwrap.getMapChannel ()
					if UVch == 0 then UVch = 1
-- 				EdgesSelUV = getEdgesOfSel objArray UVch
				EdgesSelGeo = getGEOEdgesOfSel objArray 				

				
			for o=1 to  objArray.count do
			(
				obj = objArray[o]
-- 				EdgesSelUVObj = EdgesSelUV[o] as array
				EdgesSelGeoObj = EdgesSelGeo[o]
					
				SetGEOEdgesOfSel obj EdgesSelGeoObj	
				
			)


			
		)
	)
)

fn getVertOfSel objArray UVch = 
(
	allSelected = #()
	-- 	objArray = selection as array

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
		
		if selected != undefined then  append allSelected (selected as array) else append allSelected #()
	)
	allSelected	
)

fn SaveVertPos objArray UVch = 
(
-- 	o=$
	max modify mode
	allPositions = #()
	vertPos = #()
	alluvP3 = #()
	allSelVerts = #()
	 	for o in objArray do
			(		
				uv = modPanel.getCurrentObject ()	
				uvP3 = #()
				selVerts = uv.getSelectedVerticesByNode o 
				append allSelVerts (uv.getSelectedVerticesByNode o)
				for v=1 to  polyop.getNumMapVerts o UVch	do append uvP3	(polyop.getMapVert o UVch v )
				append alluvP3 uvP3
			)
			
	alluvP3	
)

fn getUVElements =
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

fn getFaceArea vertPositions =
(
	
	--  getFaceArea   #([-7819.82,14716.7,0], [-7819.82,20135,0], [-9184.17,17425.8,0])  -- positions of vertexes
-- 	vertPositions = GeoPos
-- 	vertPositions = uvPos
	
	if vertPositions.count >= 3 then
	(
-- 		print ("vertPositions: " + vertPositions as string)
		/*local*/ triArea_1
		/*local*/ triArea_2
	
		Auv = vertPositions[1] -- get vertics of triangle
		Buv = vertPositions[3]
		Cuv = vertPositions[2]


		triArea_1 =  	( CROSS  (Auv- Buv)   (Cuv- Buv)	)/2
		triArea_1 = abs  (triArea_1.x + triArea_1.y + triArea_1.z)

		if vertPositions.count > 3 then 
		(
			Cuv = vertPositions[4]
			triArea_2 =   ( CROSS  (Auv- Buv)   (Cuv- Buv)	)/2
			triArea_2 = abs ( triArea_2.x + triArea_2.y + triArea_2.z)

		)							
		if triArea_2 != undefined then FaceUvArea = triArea_1 + triArea_2 else FaceUvArea = triArea_1
		
		FaceUvArea
	)
)

fn setUnWrapMod_VT objArray  =
(
--	 setUnWrapMod_VT (selection as array)
-- 	objArray= (selection as array)
			max modify mode		
			/*local*/ uv = modPanel.getCurrentObject ()
			if classof uv != Unwrap_UVW then 
			(
				applyModSel = vilTools_InstanceTest objArray  -- exclude instancs	
				uvNew = (Unwrap_UVW ()) 
				addModifier applyModSel	uvNew
-- 				select objArray
-- 				uvNew.setMapChannel 1

-- 				uv = modPanel.getCurrentObject ()
				uv = uvNew
				
			)
		uv
)

fn alignByEdge =
(
--fn align_uv_edge_to_axis =(
	print("align uv shell to axis");
	undo on(
		local uv = modPanel.getCurrentObject();
		--local objs = modPanel.getCurrentObject();
		if classof (uv) == Unwrap_UVW then(
			local _mode = uv.unwrap2.getTVSubObjectMode();
			if (_mode == 2)then(

				local _array = uv.unwrap2.getSelectedEdges();
				
				if (_array.numberSet == 1)then(--only 1 edge selected!!!
					
					
					--calculate the angle difference between 2 deltas
					function get2VertsAngleDiff dx dy= (
						local _a_abs = mod ((atan2 dy dx)+4*360) 360;--the angle in closed 360 degrees
						local _a_off = (mod _a_abs 90);--angle offset
						if (_a_off > 45)then(
							_a_off = -(90 - _a_off);
						)
						return _a_off;
					)
					
					local _edge = (_array as array)[1] as integer;

					--get the transformation info
					uv.unwrap2.edgeToVertSelect();
					_points = uv.unwrap.getSelectedVertices() as array;
					local ptA = uv.getVertexPosition 1 _points[1];
					local ptB = uv.getVertexPosition 1 _points[2];
					local dx = ptB.x - ptA.x;
					local dy = ptB.y - ptA.y;
					
					local a_off = get2VertsAngleDiff dx dy;

					uv.unwrap2.selectElement();
					uv.unwrap2.RotateSelected (-a_off  * PI/180) [(ptA.x + dx/2),(ptA.y + dy/2),0]
					uv.unwrap2.selectEdges #{_edge};

					local ptA = uv.getVertexPosition 1 _points[1];
					local ptB = uv.getVertexPosition 1 _points[2];
					local dx = ptB.x - ptA.x;
					local dy = ptB.y - ptA.y;
					local a_off = get2VertsAngleDiff dx dy;
					
					if (a_off != 0)then(--stupid angle snap is on
						print("shut off the angle snap..");
						max angle snap toggle ;--shut it up
						uv.unwrap2.selectElement();
						uv.unwrap2.RotateSelected (-a_off  * PI/180) [(ptA.x + dx/2),(ptA.y + dy/2),0]
						uv.unwrap2.selectEdges #{_edge};
					)
				)else(
					print("select just 1 edge!");
				)
			)
		)
	)
)

fn alignByEdgeSelection =
(
	if selection.count > 0 then --start
	(
		undo "alignByEdgeSelection" on
		(	
			/*local*/ ObjArray =  getGeometrySel()	
			/*local*/ uv = modpanel.getcurrentobject()
			/*local*/ UVch = uv.unwrap.getMapChannel ()
			if UVch == 0 then UVch = 1
-- 			 EdgeGeoSel = getGEOEdgesOfSel objArray	
			 EdgeUVSel = getEdgesOfSel objArray	UVch
			
			
			for o=1 to ObjArray.count do
			(
				obj = ObjArray[o]
				EdgeUVSelObj = EdgeUVSel[o] as array
-- 				UVedge= EdgeUVSelObj[1]
				for UVedge in EdgeUVSelObj do
				(
					uv.selectEdgesByNode #{ } obj	
					uv.selectEdgesByNode #{UVedge} obj
					alignByEdge ()	
				)
			)
			
	
		)
	)
)

fn normalizeUVs averageUV = --start
(	
	
	if selection.count > 0 then --start
	(
		max modify mode
		if classof (modpanel.getcurrentobject()) == Unwrap_UVW then 
		(
			undo "normalizeUVs" on
			(
				/*local*/ OrigObjArray =  getGeometrySel()
				objArray = vilTools_InstanceTest OrigObjArray
				noEditablePoly = for o in objArray where classof o.baseobject != Editable_Poly collect o

				if noEditablePoly.count > 0 then
				(			
		-- 			noEditablePoly=selection as array
					if yesNoCancelBox "Some of selected objects ar not Editable Poly, Do you want to convert it?"  title:"Convert to Editabe Poly"	== #yes	then 
					(
						addModifier noEditablePoly (Edit_Poly ()) 
						for o in noEditablePoly do maxOps.CollapseNodeTo o 1 off
						normalizeUVs objArray
					)
					else
					(
						for o in noEditablePoly do deleteitem objArray (finditem objArray o )
		-- 				select objArray
					)
				)
			
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
					/*local*/ scaleCoef = 0
					/*local*/ subObjSelected = false
					/*local*/ uv = setUnWrapMod_VT objArray
							
					/*local*/ subObj = subobjectLevel
					/*local*/ UVch = uv.getMapChannel ()
							if UVch == 0 then UVch = 1
								
					/*local*/ origSel =  getUVselection objArray --uv
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
	-- 						local scaleCoefTemp = #()
							scaleCoefGlobal = 0
	-- 						ElementRatio = AllElementRatios[1]
							count=0
							for ElementRatioX in AllElementRatios do 
							(
								for r in ElementRatioX do 
								(
									count+=1
									scaleCoefGlobal+= r --append scaleCoefTemp r
									
								)
							)
							scaleCoef = scaleCoefGlobal/count
							
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
	-- 						scaleCoef = scaleCoef/AllElementRatios.count
						)
					else if mapDensity != 0 then scaleCoef = (mapResolution / mapDensity )
						
					print ("------------------scaleCoef: " + scaleCoef as string)
						
					print ("------------------AllElementRatios: " + AllElementRatios as string)

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
							ElemntRatioTmp = ElementRatio[i]
							if ElemntRatioTmp == undefined then ElemntRatioTmp = 1
							uv.scaleSelectedVerticesCenter ((1/ElemntRatioTmp)*scaleCoef) 0
	-- 						uv.scaleSelectedVerticesCenter (1/1.80034) 0
	-- 						if averageUV then uv.scaleSelectedVerticesCenter ((1/ElemntRatioTmp)*scaleCoefGlobal) 0


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
					
				
					
	-- 				max create mode	
	-- 				max modify mode	

					
					
				)	--end with redraw off
			)	-- end UNDO	
		)
	)	--end  selection.count > 0
)	--end FN

fn SetUVGrid =
(
	if selection.count > 0 then 
	(
		undo "SetUVGrid" on
		(

			/*local*/ OrigObjArray = selection as array
			/*local*/ objArray = vilTools_InstanceTest OrigObjArray  -- exclude instancs 
			/*local*/ uv =  setUnWrapMod_VT objArray  -- add unwrap
			/*local*/ UVch = uv.getMapChannel ()
			if UVch == 0 then UVch = 1

			MapResolution = rollBaking.btnResBake.text as integer
			Coef = MapResolution / 256
-- 			PaddingBase = (PaddingPX  as float/ Coef as float)
-- 			PxSpace = 0.00256
			PxGridS = 1.0/MapResolution
-- 			uv.setGridSize 0.1
-- 			uv.setGridSize PxSpace
			uv.setGridSize PxGridS 
			
		)
	)	
	
	PxGridS	
		
)

fn PackUVs_Vt mouseButton =
(
--		 PackUVs_Vt "LMB"
	if selection.count > 0 then 
	(
		undo "PackUVs" on
			
		(
			/*local*/ alluvP3 = #()
			/*local*/ subObjSelected = false
			/*local*/ OrigObjArray = getGeometrySel()
			/*local*/ objArray = vilTools_InstanceTest OrigObjArray  -- exclude instancs 
			/*local*/ subObjSelected = false
			/*local*/ origVertSel = #()
			
			
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
					for o in noEditablePoly do 
					(
						deleteitem objArray (finditem objArray o )
						deselect o
					)
			-- 				select objArray
				)
			)
		
			/*local*/ uv =  setUnWrapMod_VT objArray  -- add unwrap			
			/*local*/ subObj = subobjectLevel
			/*local*/ UVch = uv.getMapChannel ()
			if UVch == 0 then UVch = 1
			/*local*/ origSel =  getUVselection objArray --UVch
	-- 		theArray=origSel[1]
			for theArray in origSel do 
				(
					theArrayCount = theArray.Count
					if theArrayCount != 0 then
					(		
						subObjSelected = true 
						origVertSel =  getVertOfSel objArray UVch
						alluvP3 =  SaveVertPos objArray UVch
									
					)
					print theArray as string
				)
				
			 	
	-- 			getUVElements()
	
			
			PaddingPX = rollUnwrap.spnPadingUV.value 
			MapResolution = rollBaking.btnResBake.text as integer
			Coef = MapResolution / 256
			PaddingBase = (PaddingPX  as float/ Coef as float)
			PxSpace = 0.0625
			PxGridS = 1.0/MapResolution
				
			if (isUVEditorOpen_VT()) == true then	uv.setGridSize PxGridS

-- 			TheSpacing = ((PxGridS * Coef * PaddingBase * 10)/2) -- bak
			TheSpacing = ((PxGridS * Coef * PaddingBase * 10)/4) -- 

			
			TheRotate = getINISetting iniFile "PackOptions" "btxPackRotate"
			TheFillHoles =  getINISetting iniFile "PackOptions" "btxFillHoles"
			TheLinear = getINISetting iniFile "PackOptions" "btxPackLinear"
	-- 		if TheFillHoles == "" then TheFillHoles = false
			if TheFillHoles == "" then TheFillHoles = false else  TheFillHoles = TheFillHoles as booleanclass
			if TheRotate == "" then TheRotate = false else  TheRotate = TheRotate as booleanclass
			if TheLinear == "" then TheLinear = false else  TheLinear = TheLinear as booleanclass				
			if mouseButton == "LMB" then  TheNormalize = false else TheNormalize = true				
	-- 		print ("--------TheSpacing:" + TheSpacing as string)			
			if not subObjSelected  then
			(
				if subObj == 0 then subobjectLevel = 1
				for oI = 1 to objArray.Count do
				(	
					o = objArray[oI]
-- 					OVertNum = o.numverts		
					case subobjectLevel of
					(
						1:(uv.selectVerticesByNode #{1..o.numverts} o )
						2:(uv.selectEdgesByNode #{1..o.numvert} o )
						3:(uv.selectFacesByNode #{1..o.numverts} o )
					)
				)
			)
						
			if TheLinear then TheLinear = 0 else TheLinear = 1		
			uv.pack TheLinear TheSpacing TheNormalize TheRotate TheFillHoles
-- 			TheLinear= undefined
	-- 		if not subObjSelected then max select all
	-- 		uv.MoveSelected [PxGridS/2,PxGridS/2,0]
	-- 		if not subObjSelected then max select none			
-- 			if origSel.count > 0 then		
-- 			(	
-- 				subobjectlevel = 1
-- 				for oI=1 to objArray.count do
-- 				(
-- 					o = objArray[oI]
-- 					objUvP3 = alluvP3[oI]
-- 					objVertSel = origVertSel[oI]
-- 					
-- 					for v=1 to  polyop.getNumMapVerts o UVch where finditem objVertSel v == 0 do 
-- 					(					
-- 						vertP3 = objUvP3[v]
-- 						max select none
-- 						uv.selectVerticesByNode #{v} o

-- 						uv.moveY vertP3.y
-- 						uv.moveX vertP3.x
-- 					)
-- 				)
-- 				subobjectlevel = subObj		
-- 				setUVselection objArray origSel UVch
-- 	-- 			max select invert

-- 			)
-- 			else if rollUvViewer.cbxViewerRefresh.state then  select OrigObjArray

			if subObjSelected then setUVselection objArray origSel UVch
			subobjectlevel = subObj
			if not (isUVEditorOpen_VT()) and rollUvViewer.cbxViewerRefresh.state then select objArray
		
		)
	)		
		
		
)

fn vilTools_Relax RelaxAxis KeepBoundary =
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
		
	undo "vilTools_Relax" on
		(
			uvP3 = #()
			alluvP3 = #()
			allSelVerts = #()
			subobj = subobjectlevel
			sel = selection as array
			uv = modpanel.getcurrentobject()
			UVch = uv.unwrap.getMapChannel ()
			if UVch == 0 then UVch = 1
			/*local*/ subObjSelected = false
			origSel =  getUVselection sel --UVch
			for a=1 to origSel.count where (origSel[a] as array).count > 0 do subObjSelected = true   
-- 	a+=1
			
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
			
			
			uv.relaxByFaceAngle 100 0 1 KeepBoundary  -------RELAX
			
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
-----
fn selectSimilarUV = 
(	
	max modify mode
	if Selection.count > 0 and classof (modpanel.getcurrentobject()) == Unwrap_UVW then

	(		
		/*local*/ subobj = subobjectlevel
		/*local*/ objArray =  getGeometrySel()
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

)

fn multiStichUV = 

(
	undo "multiStichUV" on
	(
-- 		global Enter_Subobject_CallBack = undefined
-- 		max modify mode
		/*local*/ objArray = getGeometrySel()
		print ("DEBUG: multiStichUV -- objArray:" + objArray as string )

		if objArray.count > 0 and classof (modpanel.getcurrentobject()) == Unwrap_UVW then
		(
			/*local*/ subobj = subobjectlevel
			/*local*/ ArrayCounter = #()
			/*local*/ uv = modpanel.getcurrentobject()
			/*local*/ UVch = uv.unwrap.getMapChannel ()
					if UVch == 0 then UVch = 1

			EdgesSelUV = getEdgesOfSel objArray UVch
			EdgesSelGeo = getGEOEdgesOfSel objArray 				

			for obj in 	objArray do uv.selectEdgesByNode #{} obj

			for o=1 to  objArray.count do
			(
				obj = objArray[o]
				EdgesSelUVObj = EdgesSelUV[o] as array
				EdgesSelGeoObj = EdgesSelGeo[o] as array
				
				
-- 				GeoEdge = EdgesSelGeoObj[1]
-- 				GeoEdge = EdgesSelGeoObj[2]
-- 				GeoEdge = EdgesSelGeoObj[3]
-- 				GeoEdge = EdgesSelGeoObj[4]
				for GeoEdge in EdgesSelGeoObj do
				(
					uv.selectEdgesByNode  #{} obj
					SetGEOEdgesOfSel obj #{GeoEdge}  
					uvEdges =  (uv.getselectedEdgesByNode obj) as array
	-- 				theEdgeUV = uvEdges[1]
-- 					stichEdges = (uv.getselectedEdgesByNode obj) as array
					for theEdgeUV in uvEdges where finditem EdgesSelUVObj theEdgeUV != 0 do uv.selectEdgesByNode #{theEdgeUV} obj
					
				
					if uvEdges.count == 2 then
					(
						

						uv.selectEdgesByNode  #{(uvEdges)[1]} obj
					-- 				uv.selectEdgesByNode  #{} obj
	-- 				uvEdges[finditem uvEdges theEdge]
	-- 				uv.selectEdgesByNode  #{uvEdges[finditem uvEdges theEdge]} ob

						uv.edgeToVertSelect()
						uv.stitchVerts true 0.0
					)
				)
			)
		)
-- 		Enter_Subobject_CallBack()	3
		
-- 		Enter_Subobject_CallBack ()
		
	)
)

fn stitchRingBox =
(
	undo "stitchRingBox" on
	(
-- 		objArray = selection as array
-- 		obj=objArray[1]
		max modify mode
		/*local*/ objArray = getGeometrySel()
		uv = modpanel.getCurrentObject()
		UVch = uv.getMapChannel()
		if UVch == 0 then UVch = 1 
		obj = 	objArray[objArray.count]
		
		edgeSelUV = getEdgesOfSel objArray UVch
		edgeSelGeo = getGEOEdgesOfSel objArray 
-- 		 edgeselObj = edgeSel[1]
		
		for o in objArray do uv.selectEdgesByNode #{} o

-- 		for eSel = 1  to edgeSelGeo.count do
-- 		(
			edgeSelGeoObj = edgeSelGeo[1]
			UVedgeSelObj = edgeSelUV[1]
			firstEdgeGeo = (edgeSelGeoObj as array)[1]
			
			
			
			uv.selectEdgesByNode #{} obj
			setGEOEdgesOfSel obj #{firstEdgeGeo} 
			uv.geomEdgeRingSelection()
			edgeRing = (getGEOEdgesOfSel objArray)[1] as array
			deleteitem  edgeRing (finditem edgeRing firstEdgeGeo)
			SetGEOEdgesOfSel obj edgeRing
			uv.geomEdgeLoopSelection()
			stitchEdges =  (getGEOEdgesOfSel objArray)[1] as array
	
			
			for EdgeR in stitchEdges do 
			(
				SetGEOEdgesOfSel obj #{EdgeR}
				multiStichUV ()
			
			)
-- 		)
			
	)
)






