/* 
RendererClass.classes
renderers.current = mental_ray_renderer ()
renderers.current = Default_Scanline_Renderer ()

obj=$
UVchan = 1
PaddingX = 1
bakeType="Ao"
bckgColor= (color 128 128 0 0)
size=256
*/
-- checkPhotoshop true
fn checkPhotoshop val = 
(	
	if val then
	(
		local PsPath
		local PsPath_1
		local PsPath_2
		local adobePath = "c:\\Program Files\\Adobe\\"		
		
		if hasINISetting iniFile "Photoshop" "PhtoshopPath_1" then PsPath_1 = getINISetting iniFile "Photoshop" "PhtoshopPath_1"
		if hasINISetting iniFile "Photoshop" "PhtoshopPath_2" then PsPath_2 = getINISetting iniFile "Photoshop" "PhtoshopPath_2"
	
		
		if PsPath_1 == PsPath_2 then (PsPath_2 == undefined; setINISetting iniFile "Photoshop" "PhtoshopPath_2" "")
		
		
		
		if PsPath_1 != undefined then
		(
			if doesFileExist PsPath_1 then PsPath = PsPath_1
		)
		
		if  PsPath_2 != undefined then 
		(
			if doesFileExist PsPath_2 then PsPath = PsPath_2
		)
		
		if  PsPath == undefined then
		(
			
			try(
				PsPath = getOpenFileName caption: "Choose Phtoshop.exe"\
										filename:adobePath \
										types:"Phtoshop.exe(*.exe)|*.exe"

				if (matchpattern PsPath  pattern:"*Photoshop.exe") ==true then
				(
					setINISetting iniFile "Photoshop"  "PhtoshopPath_1" PsPath	
				)
				else messagebox "Hey Man, it`s not Photosop.exe, try it again"
				)
				catch()
			
		)
	)
	PsPath
	
)

fn getBakingPath = 
(
/*
outPutPath = undefined
savedPutPath = undefined
BrowsedPath = undefined
*/	
	outPutPath = rollBaking.outPutPath.text 
	if not (dotnetclass "System.IO.Directory").exists outPutPath then 
	(
		if not hasINISetting iniFile "EditTextControl" "BakingPathBackup" then
		(
			BrowsedPath = getSavePath  caption:"Browse Output Path" initialDir:"C:\\"
			if BrowsedPath != undefined then
			(	
				setINISetting iniFile "EditTextControl" "BakingPathBackup" outPutPath
				rollBaking.outPutPath.text = BrowsedPath
			)
		)
		else
		(
			savedPutPath = getINISetting iniFile "EditTextControl" "BakingPathBackup" 
			if  (dotnetclass "System.IO.Directory").exists savedPutPath then
			(
				setINISetting iniFile "EditTextControl" "BakingPathBackup" outPutPath				
				rollBaking.outPutPath.text = savedPutPath
			)
			else
			(
				BrowsedPath = getSavePath  caption:"Browse Output Path" initialDir:"C:\\"
				if BrowsedPath != undefined then
				(	
					setINISetting iniFile "EditTextControl" "BakingPathBackup" outPutPath
					rollBaking.outPutPath.text = BrowsedPath
				)
			)
		)
		
	)	
	outPutPath
)

fn bakeMap bakeType bakeSel =	--start	
(
	size= rollBaking.btnResBake.text as integer	
	outPutPath = rollBaking.outPutPath.text
	showVfb = rollBaking.cbxVfb.state
	UVchan = rollBaking.btnUvCh.text as integer								
	Padding = rollBaking.spnPadding.value as integer	 		
	Samples = rollBaking.btnSamples.text as integer		
	selectedSelSet = #()
	outPutMaps = #()
	MapList = #()

/* 	
	if not ((dotnetclass "System.IO.Directory").exists outPutPath) then 
	(
		outPutPath = getSavePath  caption:"Browse Output Path" initialDir:"C:\\"
		rollBaking.outPutPath.text = outPutPath
	)
 */	
		outPutPath = getBakingPath ()

		if outPutPath != undefined then
		(
	
			if	substring outPutPath (outPutPath.count) -1 != "\\" then outPutPath = outPutPath + "\\"		
			if bakeType == "AoPrev" then 
			(
				size = (size / 4)
				Samples = (Samples / 8)
				bakeType = "Ao"
			)	
			----------------------	Assign MentalRay for AO
			if bakeType == "Ao" or bakeType=="AoPrev"  then renderers.current = mental_ray_renderer()	
			else renderers.current = Default_Scanline_Renderer ()

		-- 	bakeType="Di"
		-- 	bakeType="Ao"
		-- 		obj=$
		-- 		obj=bakeSel[1]
		-- 		obj=bakeSel[2]
			
			for obj in bakeSel do 
			(
				case of 
					(
						(bakeType == "Ao"or bakeType=="AoPrev"): be1 = Ambient_Occlusion()
						(bakeType == "Di" or bakeType == "ID"): be1 = DiffuseMap ()
						(bakeType == "Nm"): be1 = NormalsMap ()
						(bakeType == "UvA"): be1 = AlphaMap()
					)
				obj.iNodeBakeProperties.removeAllBakeElements() 		
				--Preparing the Bake Elements:
				 --instance of the bake element class
				if bakeType == "Di" then BckgColor =  rollBaking.BgColor.color	
				else if bakeType == "Ao" or bakeType =="AoPrev" then BckgColor =  (color 128 128 128)			
				else BckgColor =  (color 0 0 0)			

				
			-- 	obj.INodeBakeProperties.getBakeElement 1

				if bakeType == "Ao" or bakeType=="AoPrev" do 
				(
					be1.maxDistance = (rollBaking.spnDistance.value *10) --multilply milimetres to centimeters
					be1.falloff = rollBaking.spnFalloff.value
					be1.spread  = rollBaking.spnSpread.value
					be1.samples  = samples
				)
				
				be1.backgroundColor =  BckgColor

				obj.INodeBakeProperties.bakeEnabled = true --enabling baking
				obj.INodeBakeProperties.bakeChannel = UVchan-- UVchan --channel to bake
				obj.INodeBakeProperties.nDilations = Padding --expand the texturea bit
				be1.outputSzX = be1.outputSzY = size --set the size of the baked map --specifythe full file path, name and type:
				be1.fileType = (outPutPath + (obj.name as string) + "_" + bakeType + ".bmp" )
				be1.fileName = filenameFromPath be1.fileType		
				obj.INodeBakeProperties.addBakeElement be1 --add first element
			


				select obj --we are baking the selection, so we select the object --Call the rendererto bake both elements:
				render rendertype:#bakeSelected vfb:false progressBar:true outputSize:[size,size]
				append outPutMaps be1.fileType
					
				print ( "!!!!!!!!!!CLASSOF single texture: " + (classof be1.fileType) as string)
				
			)
			
			if rollBaking.cbxSetCompose.state == true and bakeSel.count > 1 then 
						--		deleteFile be1.fileType --delete the temp. file
			(
				objCount = bakeSel.count
				
				theComp = CompositeTextureMap() --create a composite map
		-- 		meditMaterials[1].diffusemap = theComp
				for i=1 to objCount-1 do theComp.add() --add a second layer		
		-- 		theComp.blendMode = #(0,5) --set second layer to Multiply --Create two maps, one with the diffuse, one with the lighting map
		-- 		theMap1 =bitmaptexture filename:be1.fileType
		-- 		theMap2=bitmaptexture filename:be2.fileType
		-- 		theComp.mapList = #(theMap1,theMap2) --composite the two maps
				for m in outPutMaps do append MapList (bitmaptexture filename:m)		
				theComp.mapList = MapList--composite the two maps
		-- 		theComp.opacity = #(100,70) --set the lighting map to 70% opacity --Create a standard self-illum material using the Composite map
				
				blendModes = theComp.blendMode
				for b=1 to  blendModes.count do blendModes[b] = 8
				theComp.blendMode = blendModes

		-- 		bakedMat = standard diffusemap:theComp selfIllumAmount:100
				--Assign a Shell Material to the object, --keep the old material as original material, --set the new bakedMat as the baked material:
		-- 		bakedMaterial:bakedMat viewportMtlIndex:1 renderMtlIndex:1
				--Show the textures of the baked material in the viewport
					
				finalMap =  bitmap size size
		-- 		openBitMap finalMap
				renderMap theComp into:finalMap size:[size,size] filename:outPutMaps[1]  display:false
				for m in outPutMaps do deletefile m
					
				
				selectedSelSet = getSelectedSet bakeSel 
				
				if selectedSelSet.count > 0 then FinalComposePath = (outPutPath + selectedSelSet[1] + "_" + bakeType + ".bmp" ) else FinalComposePath = outPutMaps[1]

				
				finalMap.fileName = FinalComposePath			
				save finalMap
				outPutMaps = #(finalMap.filename)

		-- 		if rollBaking.cbxSetMat.state then
		-- 		(		
		-- 			
		-- 			BakeMat =   Standardmaterial name:"BakeMat"
		-- 			BakeMat.diffusemap = bitmaptexture bitmap:finalMap
		-- 			bakeSel.material = BakeMat 
		-- 			showTextureMap BakeMat  BakeMat.diffusemap on		
		-- 		)
		-- 		print ( "!!!!!!!!!!CLASSOF CompositeTextureMap : " + (classof finalMap) as string)
	-- 				print ( "!!!!!!!!!!CLASSOF CompositeTextureMap : " + (classof finalMap) as string)
			
				
			)
				
			print ( "!!!!!!!!!! outPutMaps : " + ( outPutMaps) as string)

			if rollBaking.cbxSetMat.state == true and bakeType != "UvA"do
			(	
			
					for m=1 to outPutMaps.count do
					(

						finalPath = outPutMaps[m]
						if classof finalPath == bitmap then finalPath = finalPath.filename

						print ( "!!!!!!!!!! finalPath : " + ( finalPath) as string)
			
						
						saveOrigMat()
		-- 				revertOrigMat()
						bakedMat = standard selfIllumAmount:100
						bakedMat.diffuseMap = bitmaptexture filename: finalPath
						bakedMat.name = "bakedMat"
		-- 				meditMaterials[1]=	bakedMat
						bakedMat.diffuseMap.coords.mapChannel = UVchan
						bakeSel[m].material = bakedMat 
						showTextureMap bakedMat  bakedMat.diffusemap on

						if rollBaking.cbxSetCompose.state == true  then bakeSel.material = bakedMat 

					)			
			)

	-- 			bm = outPutMaps[1]
				
				for bm in outPutMaps do
				(
					if classof bm != bitmap then  bm = openBitMap bm
					
					
					if rollBaking.cbxVfb.state == true  then display  bm 
	-- 				if rollBaking.cbxOpenViewer.state == true then 	ShellLaunch  bm.filename ""
									
	-- 				PhtoshopPath = @"c:\Program Files\Adobe\Adobe Photoshop CS5 (64 Bit)\Photoshop.exe"
					
	-- 				if (getfiles PhtoshopPath).count != 0 then 
					
	-- 				if rollBaking.cbxOpenPS.state == true then 	DOSCommand	("start \"c:\Program Files\Adobe\Adobe Photoshop CS5 (64 Bit)\" \"c:\Program Files\Adobe\Adobe Photoshop CS5 (64 Bit)\Photoshop.exe\"  \"/open  " +  bm.filename + "\"")
				
				
						if rollBaking.cbxCopy.state	then
						(
							clipboardClass = dotNetClass "System.Windows.Forms.Clipboard" --create a Clipboard dotNetClass
							theImage = dotNetClass "System.Drawing.Image" --create an Image dotNetClass
							theBitmap = theImage.FromFile  bm.filename --get the saved image from file as bitmap
							clipboardClass.setImage theBitmap --copy the image to clipboard
							theBitmap.Dispose() --release the bitmap 
							clipboardClass.ContainsImage() --return true if the clipboard contains image
						)
				)

		-- 	if rollBaking.cbxOpenPS.state == true do 	DOSCommand	("start \"c:\Program Files\Adobe\Adobe Photoshop CS5 (64 Bit)\" \"c:\Program Files\Adobe\Adobe Photoshop CS5 (64 Bit)\Photoshop.exe\"  /open " + be1.fileType )
			
			PsExePath = checkPhotoshop true
			if  PsExePath != undefined then
			(
				PsDirPath = getFilenamePath PsExePath  
				
				if rollBaking.cbxOpenPS.state == true do 	
				(
					(
						
						clearlistener ()
	-- 					for m in outPutMaps do (	"\""  + PsExePath +	"\"  /open \"" + m.filename + "\"")	
						
	-- 					for m in outPutMaps do print  (   "\"" + PsExePath +  "\"" + " /open \"" + m.filename  +  "\"")	
				
	-- 					for m in outPutMaps do shelllaunch  PsExePath ( " /open \"" + m  +  "\"")	
						

	-- 					for m in outPutMaps do print ("\"" + PsExePath +	"\"  /open \"" + m.filename + "\"")	
						for m in outPutMaps do  print  ("start \"" +	PsDirPath + "\" \"" +	PsExePath +	"\"  /open \"" + m + "\"")	

						sleep 5

						
						for m in outPutMaps do  doscommand ("start \"" +	PsDirPath + "\" \"" +	PsExePath +	"\"  /open \"" + m + "\"")	

	-- 					for m in outPutMaps do "start \"" +	PsDirPath + "\" \"" +	PsExePath +	"\"  /open \"" + m.filename + "\"")	
		

					)
				)	
			
			)	
			select bakesel
		)

	
)--end 
/*
(bakeType="Ao")
bakeType="Di"
RenderButton "UvLayout" 1
BakePrev=1
bakeType="UvLayout"
bakeType="Di" 

*/

fn RenderButton bakeType = 	--start
(
	bakeSel = #()
	bakeSel = for o in selection where superclassof o == GeometryClass collect o 
-- 	for i = 1 to resButton-1 do
-- 	(
-- 		size  = size * 2 
-- 		i+=1
-- 	)
-- 	
	
	
	
	
	
	case of
	(
		(bakeType=="Di" or bakeType== "UvA" or bakeType=="Ao" or bakeType=="AoPrev"):
									(
												bakeSel = (for o in selection where superclassof o == GeometryClass collect o ) 
												bakeMap bakeType bakeSel
									)


		(bakeType == "UvLayout"):	(
										UVch = rollBaking.btnUvCh.text as integer
										outPutPath = getBakingPath ()
										PsExePath = checkPhotoshop true
										defUnwrapMod = Unwrap_UVW()
										max modify mode
										/*local*/ curObj = modPanel.getCurrentObject ()
	
										renderers.current = Default_Scanline_Renderer ()
-- 										max create mode
			
										size = rollBaking.btnResBake.text as integer 
										--		size = 4
										case size of
										(
											1:(size = 256)
											2:(size = 512)
											3:(size = 1024)
											4:(size = 2048)
											5:(size = 4096)
										)
								/*	
											o=$
											size = 256
											bakesel = $
											showVfb	= true
											UVchan = 1
								*/
									
										--	define Unwrap_UVW modifier
											
-- 												applyModSel = vilTools_InstanceTest objArray  -- exclude instancs
										if classof curObj == Unwrap_UVW then
										(
											curUVch =  curObj.getMapChannel() 
											if curUVch == 0  then  curUVch = 1 

											if curUVch == UVch then  defUnwrapMod = curObj
											else
											(
											addModifier bakeSel defUnwrapMod 
											defUnwrapMod.setMapChannel  UVch	
											)
											
										)											
										else
										(
											addModifier bakeSel defUnwrapMod 
											defUnwrapMod.setMapChannel  UVch
										)
-- 												/*local*/ curObj = modPanel.getCurrentObject ()
											
										--	add Unwrap_UVW modifier to baked object
										addModifier bakeSel defUnwrapMod
										max create mode
										--	define the size of UV template map
									--	select bakeSel
										defUnwrapMod.renderuv_width = size	

										defUnwrapMod.renderuv_height = size
									/*	defUnwrapMod.renderuv_fillmode = 0
										defUnwrapMod.renderuv_seamColor = green
									*/	
										defUnwrapMod.renderuv_showframebuffer = rollBaking.cbxVfb.state																						
									/*	defUnwrapMod.renderuv_force2sided = false
										defUnwrapMod.renderuv_fillColor = black
										defUnwrapMod.renderuv_showoverlap = false
										defUnwrapMod.renderuv_overlapColor = red
										defUnwrapMod.renderuv_edgeColor = white
										defUnwrapMod.renderuv_visibleedges = true
										defUnwrapMod.renderuv_invisibleedges = false
										defUnwrapMod.renderuv_seamedges = false				
									*/	
										--	define the path where to store UV template map
										uvSavePath = rollBaking.outPutPath.text + "\\" + bakeSel[1].name + "_UvL.bmp"
										uvRenderPath = uvSavePath
										--	render UV template
										defUnwrapMod.renderUV uvRenderPath	
										--	delete Unwrap_UVW modifier
										deleteModifier bakeSel 1				
								
										---- Copy to clipboard
										if rollBaking.cbxCopy.state	do 
										(
											clipboardClass = dotNetClass "System.Windows.Forms.Clipboard" --create a Clipboard dotNetClass
											theImage = dotNetClass "System.Drawing.Image" --create an Image dotNetClass
											theBitmap = theImage.FromFile uvSavePath --get the saved image from file as bitmap
											clipboardClass.setImage theBitmap --copy the image to clipboard
											theBitmap.Dispose() --release the bitmap 
									--		deleteFile uvSavePath --delete the temp. file
											clipboardClass.ContainsImage() --return true if the clipboard contains image
										)
										if  PsExePath != undefined then
										(
											PsDirPath = getFilenamePath PsExePath  
											if rollBaking.cbxOpenPS.state == true do 	DOSCommand	(	"start \"" +	PsDirPath + "\" \"" +	PsExePath +	"\"  /open \"" + uvRenderPath + "\"")	
										)		
								)
	
		(bakeType == "ID"):(							
								selMat = #()
								selMat = for o in bakeSel collect o.material
																
								Submat = multimaterial   numsubs:20 name: "IDmat" -- (getFilenamePath  loadedMat)
								Submat[1].diffuse =(color 0 0 0)
								Submat[2].diffuse =(color 255 0 0)
								Submat[3].diffuse =(color 0 255 0)
								Submat[4].diffuse =(color 0 0 255)
								Submat[5].diffuse =(color 128 0 255)
								Submat[6].diffuse =(color 255 128 0)
								Submat[7].diffuse =(color 255 255 0)
								Submat[8].diffuse =(color 64 255 255)
								for m = 9 to 20 do 	Submat[m].diffuse =  color (random 0 255) (random 0 255) (random 0 255)	 

								
								bakeSel.material = Submat
								bakeMap "ID" bakeSel
							
								for o=1 to bakeSel.count do bakeSel[o].material = selMat[o]	
							)
	)		
)

fn aoPreview mode =	--start
(
	
	falloffAO = rollBaking.spnFalloff.value	
	spreadAo = rollBaking.spnSpread.value

	if mode == "spinner" then
	(
		spreadAo = (spreadAo*10) as integer
		falloffAO = ((falloffAO*10) as integer)-1	
	)
	else if mode == "LMB" then
	(
		if falloffAO <= 1 then
		(	
			rollBaking.spnFalloff.value = (falloffAO + 0.1)
			falloffAO =	(((falloffAO + 0.1) *10)	as integer)-1
			spreadAo = (spreadAo*10) as integer
		)
		else
		(
			rollBaking.spnFalloff.value = 0.1	
			falloffAO = 0
			spreadAo = (spreadAo*10) as integer
		)		
	)
	else if mode == "RMB" do
	(
		 if spreadAo < 1 then
		(	
			rollBaking.spnSpread.value = (spreadAo + 0.1)
			spreadAo =	((spreadAo + 0.1) *10)  as integer
			falloffAO = ((falloffAO*10) as integer)-1	
		)
		else
		(
			rollBaking.spnSpread.value = 0.1	
			spreadAo = 1
			falloffAO = ((falloffAO*10) as integer)-1	
		)
	)
	
	if falloffAO == -1 do falloffAO = 0
	if spreadAo == 10 do spreadAo = 0
	if spreadAo == 0 and falloffAO == 0 do spreadAo = 10	
	if spreadAo == 0 and falloffAO == 9 do (falloffAO = 0; spreadAo = 100)	
	btnImage = (falloffAO  as string + spreadAo as string  ) as integer
	rollBaking.btnAoPreview.images = #("$userScripts\\vilTools\\Icons\\AoPreview.bmp",undefined,100,btnImage,btnImage,btnImage,0)

)---end






