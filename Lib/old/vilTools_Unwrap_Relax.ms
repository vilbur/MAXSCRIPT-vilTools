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
			sel = selection as array
			uvChannel = sel[1].modifiers[#unwrap_uvw].unwrap.getMapChannel ()
			if uvChannel == 0 then uvChannel = 1
			uv = modpanel.getcurrentobject()
			
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
				for v=1 to  polyop.getNumMapVerts o uvChannel	do append uvP3	(polyop.getMapVert o uvChannel v )
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
					for v = 1 to (polyop.getNumMapVerts obj  uvChannel) do 
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
		)
	)
)
