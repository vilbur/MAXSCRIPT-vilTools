--global UvViewer
fn plot img coord steep col =
(
    if steep then
    (
        swap coord[1] coord[2]
    )
    setPixels img coord col
)
 
fn drawLine img start end col =
(
    /*local*/ steep = (abs (end.y - start.y)) > (abs (end.x - start.x))
 
    if steep then
    (
        swap start.x start.y
        swap end.x end.y
    )
 
    if start.x > end.x then
    (
        swap start.x end.x
        swap start.y end.y
    )
 
    /*local*/ deltaX = end.x - start.x
    /*local*/ deltaY = abs (end.y - start.y)
    /*local*/ error = deltaX / 2.0
    /*local*/ yStep = -1
    /*local*/ y = start.y
 
    if start.y < end.y then
    (
        yStep = 1
    )
 
    for x in start.x to end.x do
    (
        plot img [x, y] steep col
        error -= deltaY
        if error < 0 then
        (
            y += yStep
            error += deltaX
        )
    )
    img
)
 
fn AttachSel_VT AttachObj =
(	
	--		i=$
-- 		AttachObj=$ as array
		max create mode
		for i in AttachObj do 
			(
				if (classof i !=Editable_Poly OR classof i !=PolyMeshObject) do
				(
					AddModifier i (Edit_Poly())
					maxOps.CollapseNode i off
				)	
			)

			while AttachObj.count > 1 do
			(
				selcount = AttachObj.count
				for i = selcount to 2 by -2 do
				(
					polyop.attach AttachObj[i] AttachObj[i-1]
					
					deleteitem AttachObj (finditem AttachObj  AttachObj[i-1])
				)
			)
			AttachObj
-- 			update sw election[1]
-- 		print ("Result : " + AttachObj as string)
)

fn vil_UvViewer = 
(	
	if rollUvViewer.open == true then
	(
		
		try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_CallBack_UVViewer)catch()

		/*local*/ sel = #()
		/*local*/ AttachObj = #()
		/*local*/ theObj 
		/*local*/ allLines = #()
		theChannel = rollUvViewer.rbtnUvwViewer.state	as integer		
		UVViewerRefresh = rollUvViewer.cbxViewerRefresh.state 
-- 		rollUvViewer.cbxViewerRefresh.state = false
		-- 		clearlistener ()
	-- 		start = timeStamp ()
	-- 		theObj = $
		sel = for o in selection where superclassof o == GeometryClass collect o 

		if sel.count > 0 and sel.count <= 50  then
			(
				with redraw off
				(
					sel = vilTools_InstanceTest	sel
					copy sel  name:"tmp_UvObj"
				
					AttachObj = for o in geometry where o.name == "tmp_UvObj" collect o
				--	select AttachSel_VT
					if AttachObj.count > 1 then 
					(
						theObj = (AttachSel_VT AttachObj)[1]
					)
					else
					(
						theObj = AttachObj[1]		
	-- 					EditPoly = Edit_Poly()				
						AddModifier theObj (Edit_Poly())	
						maxOps.CollapseNode theObj off
					)					
					
-- 					print( "Attached >>>>>> " +  theObj as string)
					if  polyop.getMapSupport theObj theChannel == true then
					(
											
						max create mode
						global UvViewerSwitch
						
						bitmapX = bitmapY = 256
						bitmapx_1 = bitmapx-1
						bitmapy_1 = bitmapy-1
						currentPos = lastPos = [0,0]
						myBitmap = bitmap 256 256 color:(color 0 0 0)
					
						faceCount = polyop.getNumMapFaces theObj theChannel
					
						
						for f = 1 to faceCount do
						(
							theFace = polyop.getMapFace theObj theChannel f
							
							for v=1 to theFace.count do
							(	
								if v < theFace.count then	
								(
									vert1= polyop.getMapVert theObj theChannel theFace[v]
									vert2= polyop.getMapVert theObj theChannel theFace[v+1]
								)
								else
								(
									vert1= polyop.getMapVert theObj theChannel theFace[v]
									vert2= polyop.getMapVert theObj theChannel theFace[1]																	
								)
								
								
								vert1X = vert1.x
								vert1Y = vert1.y
								vert2X = vert2.x
								vert2Y= vert2.y
								
-- 								if vert1X <= 1 and vert1X >= 0 and vert1y <= 1 and vert1Y >= 0 and vert2X <= 2 and vert2X >= 0 and vert2y <= 2 and vert2Y >= 0  then drawLine myBitmap [vert1X  * bitmapx_1, bitmapy_1 - vert1Y * bitmapy_1] [vert2X * bitmapx_1, bitmapy_1 - vert2Y * bitmapy_1]  #((color 255 255 255))  -- Optimalization , dont drw verts hgher then 1 and lower then 0
-- 								if vert1X <= 4 and vert1X >= -4 and vert1y <= -4 and vert1Y >= -4 and vert2X <= 4 and vert2X >= -4 and vert2y <= 4 and vert2Y >= -4  then drawLine myBitmap [vert1X  * bitmapx_1, bitmapy_1 - vert1Y * bitmapy_1] [vert2X * bitmapx_1, bitmapy_1 - vert2Y * bitmapy_1]  #((color 255 255 255))
								drawLine myBitmap [vert1X  * bitmapx_1, bitmapy_1 - vert1Y * bitmapy_1] [vert2X * bitmapx_1, bitmapy_1 - vert2Y * bitmapy_1]  #((color 255 255 255))  --DRAWW EVERTHNG

							)
			
						)

-- 						display myBitmap
						UvViewerSwitch = 1													
						delete theObj
						rollUvViewer.btnUvViewer.images = #(myBitmap,undefined,1,1,1,1,0) 
						print "vil_UvViewer UPDATED"
						
					)
					else
					(
						delete theObj
						rollUvViewer.btnUvViewer.images = undefined
						rollUvViewer.btnUvViewer.text = "Unsupported Channel"	
					)
				)
			)
		else
		(
			rollUvViewer.btnUvViewer.images = undefined
	-- 		rollUvViewer.btnUvViewer.text = "No valid geometry selected"	
			if sel.count > 50 then rollUvViewer.btnUvViewer.text = "More then 50 objects selected"	else  rollUvViewer.btnUvViewer.text = "Nothing selected"
		)
			
-- 			if rollUvViewer.cbxViewerRefresh.state == true do callbacks.addScript #selectionSetChanged "vil_UvViewer()" id: #SelectionChange_CallBack_UVViewer
		if  UVViewerRefresh == true then SelectionChange_CallBack_UVViewer()
		
	)
)
fn vil_UvVieweroFF =
(
			callbacks.removeScripts #selectionSetChanged id: #SelectionChange_CallBack_UVViewer
			rollUvViewer.btnUvViewer.text = "Show UV`s!"
			rollUvViewer.btnUvViewer.images = undefined
-- 			rollUvViewer.cbxViewerRefresh. state = false
		--	print "UvViewer: OFF"
			UvViewerSwitch = 0

)






