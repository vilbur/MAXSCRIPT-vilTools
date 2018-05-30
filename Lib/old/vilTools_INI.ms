
fn iniSave =
(
	
-- 	allRolls = for r in  VilToolsFloater.rollouts collect r.name
	
	
-- 	setINISetting iniFile "Rollouts"  "allRolls"   (allRolls as string )
try(
	for roll in VilToolsFloater.rollouts do 
	(
		setINISetting iniFile "Rollouts"  (roll.name)   (roll.open as string )
		---print r.name
		for c in roll.controls do 
		(
			case of
			(
				(classof c == EditTextControl): setINISetting iniFile "EditTextControl" (c.name  as string)   (c.text as string )
				(classof c == CheckBoxControl): setINISetting iniFile "CheckBoxControl"  (c.name  as string)   (c.state as string )
				(classof c == SpinnerControl): setINISetting iniFile "SpinnerControl" (c.name  as string)   (c.value as string )
				(classof c == ColorPickerControl): setINISetting iniFile "ColorPickerControl"  (c  as string)   (c.color as string )
				(classof c == ButtonControl): if c.name == "btnResBake" or c.name == "btnUvCh" then setINISetting iniFile "ButtonControl"  (c.name  as string)   (c.text as string )
			)
		)
	)	
	
	----------EXEPTION FOR UVVIEWER
	
	 setINISetting iniFile "CheckBoxControl"   "cbxViewerRefresh"  "false"
	)catch()
)

fn vilToolsLoad_INI =
(
	--		roll =VilToolsFloater.rollouts[1]

	for roll in VilToolsFloater.rollouts do 
	(
		---print r.name		
		--		c= roll.controls [10]
		--		c= rollBaking.spnDistance
		
		
				for c in roll.controls do 
				(
					case of
					(
						(classof c == EditTextControl):	c.text  = if hasINISetting iniFile  "EditTextControl" (c.name as string ) then 	getINISetting iniFile  "EditTextControl" (c.name as string )
						(classof c == CheckBoxControl):	c.state  = if hasINISetting iniFile  "CheckBoxControl" (c.name as string )then 	(getINISetting iniFile  "CheckBoxControl" (c.name as string )	 as BooleanClass)	
						(classof c == SpinnerControl):	c.value  = if hasINISetting iniFile "SpinnerControl" (c.name as string ) then 	(getINISetting iniFile  "SpinnerControl" (c.name as string ) as float	)
						(classof c == ColorPickerControl):	
															(
																tempstring = if hasINISetting iniFile  "ColorPickerControl" (c as string ) then  filterstring (	(getINISetting iniFile  "ColorPickerControl" (c as string ))		as string) " )"
																c.color = (color (tempstring[2] as integer) (tempstring[3] as integer) (tempstring[4]	as integer) )																					
															)
																
						(classof c == ButtonControl): if c.name == "btnResBake" or c.name == "btnResNorm"  then 
																(
																	
																	if hasINISetting iniFile  "ButtonControl" "btnResBake"then 
																	(
																		TheText = getINISetting iniFile  "ButtonControl" "btnResBake"
																		if TheText != "" then
																		
																		(
																			

																			case TheText of
																			(
																				"256":(IconNum = 1)
																				"512":(IconNum = 2)
																				"1024":(IconNum = 3)
																				"2048":(IconNum = 4)
																				"4096":(IconNum = 5)
																			)
			-- 																		local UvChannelNoIco = "$userScripts\\vilTools\\Icons\\UvChannelNo.bmp"

																			
																			case c.name of
																			(
																				"btnResNorm": IconPath = "$userScripts\\vilTools\\Icons\\Resolution.bmp"
																				"btnResBake": IconPath = "$userScripts\\vilTools\\Icons\\BakeResolution.bmp"
																				
																			)
																			c.text  = TheText
																			c.tooltip  = TheText
																			c.images = #(IconPath,undefined,5,IconNum,IconNum,IconNum,0)
																		
																		)	
																	)
																)
																
		-- 													/* 	
																else if c.name == "btnUvCh" then 
																	(
-- 																		test = "btnUvCh"
																		IconPath = "$userScripts\\vilTools\\Icons\\UvChannelNo.bmp"
																		if hasINISetting iniFile  "ButtonControl" (c.name as string) then 
																		(
																			TheText  = 	getINISetting iniFile  "ButtonControl" (c.name as string )	
																			c.text  = TheText
																			c.tooltip  = TheText
																			IconNum = c.text as integer
																			c.images = #(IconPath,undefined,10,IconNum,IconNum,IconNum,0)																
																		)
																	)
		-- 														 */
																
																	

					)
					
			
					
					
				)
			
				
				
		
	)
-- 	roll = VilToolsFloater.rollouts[1]
	
	for roll in VilToolsFloater.rollouts do (if hasINISetting iniFile  "Rollouts" (roll.name as string) then  roll.open  = 	(getINISetting iniFile  "Rollouts" (roll.name as string) )  as BooleanClass)
	rollVilTools.spnMaxRollouts.range = [1,VilToolsFloater.rollouts.count,VilToolsFloater.rollouts.count]
	rollUvViewer.btnUvViewer.images = undefined
	rollUvViewer.cbxViewerRefresh.state = false


)
/*

command = #("rollUnwrap.Uvscale.value","0.5")
		f = openFile  iniFile mode:"r"		
	while not eof f do -- read until reach end of file
	(
	local IniLine=readline f -- read in a line
	if IniLine[1] == "[" then continue
		else
		(
		 command = filterstring iniline "=" 
		
		command[1] = command[2] 
			
	---	print command[1]
	--	print command[2]
		)		
	)

	close f


	/*
	
		(try (setINISetting iniFile "modifiers UV" "channel" (chMod as string) )catch())

	*/
	
	
	