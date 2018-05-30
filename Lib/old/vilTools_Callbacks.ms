
fn SelectionChange_vilToolsUVchFN = 
(
		channelIcons = "$userScripts\\vilTools\\Icons\\ChannelIcons.bmp"

	if selection.count > 0  then
	(
		print ("SelectionChange_vilToolsUVchFN ------DEBUG")	

	
		obj =  selection[1]
		if obj.material != undefined then
		(
			if 	classof obj.material == standard then mat = obj.material				
			else if (classof obj.material == Multimaterial or classof obj.material == compositematerial ) then 
			(
				mat= obj.material[1]
			)
			else if (classof obj.material == Shell_Material ) then 
			(
				mat= obj.material[2]
			)
	
			if mat.diffusemap != undefined then 
			(
				mCH =  mat.diffuseMap.coords.mapChannel	
				rollMaterials.btnCircleCh.text = mCH as string		
				rollMaterials.btnCircleCh.tooltip = mCH as string		
				rollMaterials.btnCircleCh.images = #(channelIcons,undefined,10,mCH,mCH,mCH,0) 
			)
			else
			(
			rollMaterials.btnCircleCh.images = #(channelIcons,undefined,10,10,10,10,0) 
			rollMaterials.btnCircleCh.text = 1 as string		

			)
		)
		else
		(
		rollMaterials.btnCircleCh.images = #(channelIcons,undefined,10,10,10,10,0) 
		rollMaterials.btnCircleCh.text = 1 as string		

		)
	)	
	else 
	(
		rollMaterials.btnCircleCh.images = #(channelIcons,undefined,10,10,10,10,0) 
		rollMaterials.btnCircleCh.text = 1 as string		

	)
	
)

fn SelectionChange_vilTools_MatIDFN = 
(	
	if  rollMaterials.open == true and selection.count > 0 and  subobjectLevel == 4 or subobjectLevel == 5 then
	(	
		
		print ("SelectionChange_vilTools_MatIDFN: CallBack DEBUG " )	

		curMod = modPanel.getcurrentObject ()	
		
		
		matIDs = #()	
		sel = for o in selection where classof o.baseobject == Editable_Poly collect o
		
		if  classof curMod == Editable_Poly  then
			(	
				faceCount = (polyop.getNumFaces $) 			
				facelist = (curMod.GetSelection #Face) as array
				for f in facelist where f< faceCount do appendifunique matIDs (polyop.getFaceMatID $ f)
			)
			
			else if classof curMod == Edit_Poly then
			(
				for o in sel  do
				(
					facelist = (curMod.getSelection #Face node:o) as array
					for f in facelist do appendifunique matIDs (polyop.getFaceMatID o f)
				)
			)	
-- 			(polyop.setFaceMatID $ 1 5	)
			
	
			
			for MatID= 1 to 9 do	
			(
	-- 			local NumbersGreen = #( "$userScripts\\vilTools\\Icons\\NumbersID_G.bmp",undefined,9,MatID,MatID,MatID,0)
					
				
				if finditem matIDs MatID == 0 then  
				(
					TheButton = execute ("rollMaterials.MatID" + MatID as string )
					if TheButton.text == MatID as string	then 
						(
							local NumbersFade = #( "$userScripts\\vilTools\\Icons\\NumbersID_F.bmp",undefined,9,MatID,MatID,MatID,0)
							TheButton.images =NumbersFade
							TheButton.text = ""	
							print ("rollMaterials.MatID" + MatID as string + "IconFaded")	
						)
	-- 				execute ("rollMaterials.MatID" + MatID as string + ".text = \"\"" )
				)
				else
				(
					
					 
-- 					MatID=1
					TheButton = execute ("rollMaterials.MatID" + MatID as string )
					if TheButton.text !=	MatID	then
					(
						local NumbersBlue = #( "$userScripts\\vilTools\\Icons\\NumbersID_B.bmp",undefined,9,MatID,MatID,MatID,0)
						TheButton.images =	NumbersBlue	
						print ("rollMaterials.MatID" + MatID as string + "IconChanged")
						TheButton.text = MatID as string 
					)
				)
			)
				rollMaterials.btnMatID.text = ""

		
	
	)
	else if  rollMaterials.open == true then
	(
			
		if rollMaterials.btnMatID.text != "reseted" then
		(
			print "SelectionChange_vilTools_MatIDFN --------------DEBUG-----id RESETED"
		
			for MatID= 1 to 9 do	
			(
				local NumbersFade = #( "$userScripts\\vilTools\\Icons\\NumbersID_F.bmp",undefined,9,MatID,MatID,MatID,0)
				execute ("rollMaterials.MatID" + MatID as string + ".images = " + NumbersFade as string)
			)
			
			rollMaterials.btnMatID.text = "reseted" 	
		)
		
	)
-- 	print "Selection ID changed"
	
)


fn SelectionChange_CallBack_UVViewer =
(	
		try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_CallBack_UVViewer)catch()
		try(callbacks.addScript #selectionSetChanged "vil_UvViewer()" id: #SelectionChange_CallBack_UVViewer)catch()
-- 		try(callbacks.addScript #selectionSetChanged "(print \"UV viewer callback\";if selection.count > 0 and rollUvViewer.cbxViewerRefresh.state then vil_UvViewer())" id: #SelectionChange_CallBack_UVViewer)catch()
-- 		try(callbacks.addScript #selectionSetChanged "Print \"Sabadbadbadaduuuu SelectionChange_CallBack_UVViewer\"" id: #SelectionChange_CallBack_UVViewer)catch()
	
)


fn PostOpenScriptsFN = 
(
	LayerManager.editLayerByName ""
	
	/* 
	-- ONLY NITROUS
	disp = NitrousGraphicsManager.GetActiveViewportSetting()
	disp.ShowSelectionBracketsEnabled = false 
	*/
)

fn PostOpenScripts = 
(
	callbacks.RemoveScripts    #filePostOpen  id:#vilTools_filePostOpen
-- 	callbacks.addScript    #postNodesCloned "(srcArray = (callbacks.notificationParam())[1];TrgArray = (callbacks.notificationParam())[2];Wall_SetID srcArray TrgArray;Wall_postNodesClonedFN())"	id:#Wall_SetID_copy      
	
-- /* 	
	callbacks.addScript    #filePostOpen "PostOpenScriptsFN()"	id:#vilTools_filePostOpen

)
fn SelectionChange_CallBack_vilToolsUVch = 

(
		 	try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_vilToolsUVchFN)catch()
			try(callbacks.addScript #selectionSetChanged "SelectionChange_vilToolsUVchFN()" id: #SelectionChange_vilToolsUVchFN)catch()
	
)

fn SelectionChange_vilTools_MatID = 

(
-- 		 	try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_vilTools_MatID)catch()
-- 			try(callbacks.addScript #selectionSetChanged "SelectionChange_vilTools_MatIDFN()" id: #SelectionChange_vilTools_MatID)catch()
	global GetMatIDEvent = undefined
	fn SelectionChange_vilTools_MatID_event  ev nd  = SelectionChange_vilTools_MatIDFN()
	GetMatIDEvent = nodeEventCallback subobjectSelectionChanged:SelectionChange_vilTools_MatID_event

)
--	try(if rollUvViewer.cbxViewerRefresh.state == true do callbacks.addScript #selectionSetChanged "vil_UvViewer" id: #vil_UvViewer)catch()
	
-- 	try(callbacks.addScript #selectionSetChanged "RefreshCallback()" id: #RefreshCallback)catch()
-- 	callbacks.addScript #filePostOpen "PostOpenScripts()" id: #PostOpenScripts
--	callbacks.removeScripts #filePostOpen  id: #LayerManager_open
--	callbacks.removeScripts #selectionSetChanged  id: #RefreshCallback
-- fn vilTools_PreNodeClonedFN =
-- (
-- 	
-- 	
-- 	
-- )


fn vilTools_PreNodeCloned =

(
	try(callbacks.RemoveScripts  #preNodesCloned id:#vilTools_PreNodeCloned)catch()
-- 	try(callbacks.addScript #preNodesCloned "try(rollUvViewer.cbxViewerRefresh.state = false)catch()" id: #vilTools_PreNodeCloned)catch()
	try(callbacks.addScript #preNodesCloned "if rollUvViewer.cbxViewerRefresh.state then (rollUvViewer.cbxViewerRefresh.state = false; global UVViewerRefresh = true )" id: #vilTools_PreNodeCloned)catch()

-- 	try(callbacks.addScript #preNodesCloned "Print \"PreNodeCloned_CallBack\"" id: #vilTools_PreNodeCloned)catch()
-- 	#preNodesCloned: Array of nodes 
	
	
)
fn vilTools_PostNodeCloned =
(
	callbacks.RemoveScripts    #postNodesCloned  id:#vilTools_PostNodeCloned
-- 	callbacks.addScript    #postNodesCloned "(srcArray = (callbacks.notificationParam())[1];TrgArray = (callbacks.notificationParam())[2];Wall_SetID srcArray TrgArray;Wall_postNodesClonedFN())"	id:#Wall_SetID_copy      
	
-- /* 	
	callbacks.addScript    #postNodesCloned "(if UVViewerRefresh != undefined then(
											srcArray = (callbacks.notificationParam())[1];\
											TrgArray = (callbacks.notificationParam())[2];\
											Type = (callbacks.notificationParam())[3];\
											rollUvViewer.cbxViewerRefresh.state = true)\
											 global UVViewerRefresh = undefined)"	id:#vilTools_PostNodeCloned  

--    */  
	
-- 	callbacks.addScript    #postNodesCloned "print \"Wall_PostNodeCloned  callbacks\" "	id:#Wall_SetID_copy      

)
fn vilTools_KilCallBacks = 
(
	print "vilTools_KilCallBacks: KILLED!!!"
	try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_vilToolsUVchFN)catch()
	try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_CallBack_UVViewer)catch()
	
	try(callbacks.RemoveScripts    #filePostOpen  id:#vilTools_filePostOpen)catch()
	try(callbacks.RemoveScripts  #selectionSetChanged id:#SelectionChange_vilTools_MatID)catch()
	try(callbacks.RemoveScripts  #preNodesCloned id:#vilTools_PreNodeCloned)catch()
	try(callbacks.RemoveScripts    #postNodesCloned  id:#vilTools_PostNodeCloned)catch()
-- 	try(registerRedrawViewsCallback InfoBoxSelection)catch()		
-- 	try(registerRedrawViewsCallback InfoBoxModPanel)catch()		
	unregisterRedrawViewsCallback InfoBoxSelection
	unregisterRedrawViewsCallback InfoBoxModPanel
-- 	 InfoBoxControl ==  false
-- unregisterRedrawViewsCallback InfoBoxSelection
	global GetMatIDEvent = undefined 	--turnoff callback

)









