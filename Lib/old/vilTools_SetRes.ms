fn setRes buttonX varX maxRes = 	--start
(
	
	/*
	setRes "ResBake" 1 5
	
	varX = -1
	varX = 1
	MAXx=5
	setResolution "setRes" 0.5
	buttonX= "UvCh" 
	setResolution "setAoSample" 2

	*/
	origRes = undefined
	
	case of 
	(
	(buttonX ==  "UvCh"): (
-- 								setbutton = rollBaking.btnUvCh.text
								setbutton = rollBaking.btnUvCh
								IconPath = "$userScripts\\vilTools\\Icons\\UvChannelNo.bmp"
								)
	(buttonX =="ResBake" or buttonX =="ResNorm" ): 
												(
					 								setbutton = rollBaking.btnResBake
														
													buttonX ==  "ResBake"

													
													IconPath = "$userScripts\\vilTools\\Icons\\BakeResolution.bmp"
												
													origRes = setbutton.text as integer 
													ResCoef = origRes / 256
													
													case origRes of
													(
														256:(origRes = 1)
														512:(origRes = 2)
														1024:(origRes = 3)
														2048:(origRes = 4)
														4096:(origRes = 5)
													)
													
											

												)
						
	(buttonX ==  "Samples"): (
								setbutton = rollBaking.btnSamples
								IconPath = "$userScripts\\vilTools\\Icons\\AoSamples.bmp"
								origRes = setbutton.text as integer 

								case origRes of
								(
									8:(origRes = 1)
									16:(origRes = 2)
									32:(origRes = 3)
									64:(origRes = 4)
									128:(origRes = 5)
									256:(origRes = 6)
									512:(origRes = 7)
								
								)
		
		
								)
-- 		
-- 	(buttonX ==  "UvAo"): (
-- 								setbutton = rollBaking.btnUvBakeAo
-- 								IconPath = "$userScripts\\vilTools\\Icons\\UvChannelIcons.bmp"
-- 								)	
-- 	(buttonX ==  "UVmod"): (
-- 								setbutton = rollUnwrap.btnUVmod
-- 								IconPath = "$userScripts\\vilTools\\Icons\\UvChannelIcons.bmp"
-- 								)										
	(buttonX ==  "UVcopyFrom"): (
							setbutton = rollUnwrap.btnUvCopyFrom
							IconPath = "$userScripts\\vilTools\\Icons\\Numbers_green.bmp"
							)	

	(buttonX ==  "UVcopyTo"): (
							setbutton = rollUnwrap.btnUvCopyTo
							IconPath = "$userScripts\\vilTools\\Icons\\Numbers_blue.bmp"
							)					

							
	)	-- case of  END		

	if  origRes == undefined then origRes = setbutton.text as integer 


-- varX=1
	if origRes == maxRes then
	(
		if varX == 1 then
		(newRes = 1)
		else
		(newRes = maxRes - 1)
	)
	else if origRes == 1 then
	(
		if varX == 1 then
		(newRes = 2)
		else
		(newRes = 1)
	)
	else
	( 
		newRes = origRes + varX
	)
	
	setbutton.images = #(IconPath,undefined,maxRes,newRes,newRes,newRes,0) 

	if buttonX == "ResBake" or  buttonX == "ResNorm" then
	(

		IconPathNorm = "$userScripts\\vilTools\\Icons\\Resolution.bmp"
		rollUnwrap.btnResNorm.images = #(IconPathNorm,undefined,maxRes,newRes,newRes,newRes,0) 
		
-- 	baseResolution = 256	
-- 	oldVal = getINISetting iniFile "SpinnerControl" "spnPadding"  as integer
-- 		newRes = 2
-- 		newRes = 4
			oldPadding = rollBaking.spnPadding.value
			basePadding = oldPadding/ResCoef
		
		
		
		if origRes == 5 and newRes == 1 then NewPadding = basePadding
			else
			(
				if VarX > 0 then NewPadding = oldPadding * 2
				else if ResCoef != 1 then NewPadding = oldPadding / 2
				else NewPadding = oldPadding 
			)
	
			rollBaking.spnPadding.value = NewPadding
			rollUnwrap.spnPadingUV.value = NewPadding
				
		case newRes of
		(
			1:(newRes = 256)
			2:(newRes = 512)
			3:(newRes = 1024)
			4:(newRes = 2048)
			5:(newRes = 4096)
		)
-- 			print( "newRes " + newRes as string)
	
-- 		oldPadding = 2

		
		
		
		
	rollUnwrap.btnResNorm.text = newRes as string
	rollUnwrap.btnResNorm.tooltip = newRes as string
	
		
		
	)	
	else if buttonX == "Samples" then
	(
		case newRes of
		(
			1:(newRes = 8)
			2:(newRes = 16)
			3:(newRes = 32)
			4:(newRes = 64)
			5:(newRes = 128)
			6:(newRes = 256)
			7:(newRes = 512)
		)
	
	)	
	
-- 	
-- 	setbutton.text = "sht"
-- 	setbutton.tooltip ="sht"	
	setbutton.text = newRes as string
	setbutton.tooltip = newRes as string
	
	
	
-- 	
	
	
) --end

-- fn setSamples varX = 
-- (
-- 	setbutton = rollBaking.spnSamples.value
-- 	newValue = setbutton * varX
-- 	if newValue==0 then  newValue = 1
-- 	rollBaking.spnSamples.value = newValue
-- )


fn setPxDensity val inSpin_arg =
(
	-- 	oldVal = rollUnwrap.spnPxDensity.value
-- 	print ("VAL: " + val as string)
-- 	val = 1
-- 	val = 257
-- 	val = 511
	
	if inSpin_arg then
	(
		oldVal = (getINISetting iniFile "SpinnerControl" "spnPxDensity") as integer										
		if oldVal < val then newVal = oldVal * 2 else newVal = oldVal / 2

		if val == 1 or val ==  0 then newVal = 256

		
		setINISetting iniFile "SpinnerControl" "spnPxDensity" (newVal as string)
		rollUnwrap.spnPxDensity.value = newVal
		
	)
)


fn setSpnPadding val inSpin_arg  =
(
-- 	print( "val: " + val as string)
-- 	Val = 10
	newVal = 0
-- 	Val = 5
-- 	oldVal=4
-- 	baseResolution = 256	
	oldVal = getINISetting iniFile "SpinnerControl" "spnPadding"  as integer
	MapResolution = rollBaking.btnResBake.text as integer
	ResCoef = MapResolution / 256
	
-- 	if val == undefined then val = rollBaking.spnPadding.value 
-- 	if oldVal < 0 then oldVal = 0
	
	paddingBase = oldVal / ResCoef
		
-- 	if not inSpin_arg then
	
-- 	if val == 0 then val = 1
		
-- 	val = 2

-- 	val =7
-- 	val = 27
	
-- 	val = 15
-- 	val = 17
-- 	if val == 0 then
-- 	(
-- 		newVal =  ResCoef	
-- 		
-- 	)
	if inSpin_arg then
	(
		print "INSPIN_ARG"

		if oldVal < val then  -- value goes UP
		(
			
			if ResCoef == 1 then newVal = val
			else newVal = (paddingBase + 1 ) * ResCoef 

			
		)
		else	-- value goes DOWN
		(
			if ResCoef == 1 then newVal = val
			else newVal = (paddingBase - 1) * ResCoef 

		)

	)
	else newVal =  val

	
	
	setINISetting iniFile "SpinnerControl" "spnPadding" (newVal as string)
	
	rollBaking.spnPadding.value = newVal as integer
	rollUnwrap.spnPadingUV.value = newVal as integer

)


