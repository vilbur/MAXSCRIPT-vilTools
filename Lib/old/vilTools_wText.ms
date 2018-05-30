		/*
		
			wText "LMB: XXXXX" "RMB: XXXXX" "Front: XXXXX" "Back: XXXXX"
*/
		
		




fn wTextFN  = --	t1 t2 t3 timerClose =
(

		-- set a chocolate matrix with caramel topping, vanilla is so boring these days.
		gw.setTransform(Matrix3 1)
		-- check the selection count, because we shouldn't tickle more than 1 thing at a time! 
-- 		if selection.count > 0 then
-- 		(

		if wTOffsetY  == undefined then global wTOffsetY = 0
		--starting Y point in screenEstate
		/*local*/ ycount = 400
		--starting X point in screenEstate
		/*local*/ xcount = 500
		-- Accumulate to track available space for rows and tally 'em up guvna!
		/*local*/ rowcount = 1
		-- hold the viewport's YScreenEstate in high regard
		/*local*/ ymax = (gw.getWinSizeY())	
		/*local*/ xMid = (gw.getWinSizeX()/2)	
		
			-- for each in selection, grab and tickle with the following textings
-- 			for o in selection do
-- 			(
				--the line belwo is commented out, it was to force this function to a filtered class...
				--if superclassof o == geometryclass then(	
				-- set starttext location, name, & color
				gw.wText ([xMid,ycount,0])	    wTxt1 color:wTC1
				gw.wText ([xMid,ycount+=14,0])  wTxt2 color:wTC2			
				gw.wText ([xMid,ycount+=14,0])  wTxt3 color:wTC3		
				gw.wText ([xMid,ycount+=14,0])  wTxt4 color:wTC4		
				--this nest line doesn't matter..it's a remnant of when I allowed multiple selections to have their information stacked. This gave the stacked info a bit of the old "separation".		


	-- update the area for the text
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	-- make a more complete 'update the area for the text'a
	-- this may cause severe slowdowns, comment it out of needed
	completeredraw()
	
			
)

fn wTextOff s e =
(
	unregisterRedrawViewsCallback wTextFN ---- TURNOFF TEXT
	completeredraw() 
-- 	clearlistener()
	Print "wTextOff"
-- 	s = tm
-- 			format "time: %\n\tsender: %\n"  /*local*/Time s
			-- Stop on first TICK
			s.Stop()
	
		-- Remove Event Handler
		dotnet.removeAllEventHandlers s
		-- Dispose Timer
		s.Dispose()
	
		global wTxt1 = ""
		global wTxt2 = ""
		global wTxt3 = ""
		global wTxt4 = ""

	
		if wTC1 != White then global wTC1 = Yellow

		if wTC2 != Yellow then global wTC2 = Yellow

		if wTC3 != Yellow then global wTC3 = Yellow
		if wTC4 != Yellow then global wTC4 = Yellow
	
)

fn wTextTimer  =
(

		ftm = dotnetobject "System.Windows.Forms.Timer"
		ftm.Interval = 	(1.61803398875*1.61803398875)*	1000 -- every two seconds

		-- Add Event Handler And Start
		dotnet.addEventHandler ftm "Tick" wTextOff
		ftm.Start()

)

fn stopTextTimer =
(
-- 		ftm = dotnetobject "System.Windows.Forms.Timer"

		/***************** STOP *************/
		-- Stop Timer
		ftm.Stop()
		-- Remove Event Handler
		dotnet.removeAllEventHandlers ftm
		-- Dispose Timer
		ftm.Dispose()
)
/*

 wText "YES BABY" "" "" true

*/
-- global wTxt1 = "test225"


fn wText  wTxt1in  wTxt2in  wTxt3in  wTxt4in = 
(
-- 	global wTxt1 
-- 	global wTxt2 
-- 	global wTxt3 
-- 	
/*	
	
wTxt1 = "undefined'"
wT5 = "undefined"
wTxt3 = "undefined"
*/	
-- 	if wTxt1 == undefined then 
-- 		(
-- 			global wTxt1 = ""
-- 			global wTxt2 = ""
-- 			global wTxt3 = ""
-- 			global wTxt4 = ""

-- 			global wTC1 = Yellow

-- 			global wTC2 = Yellow
-- 	 
-- 			global wTC3 = Yellow
-- 		
-- 			global wTC4 = Yellow
-- 		
-- 		)

	
		wTextTimer()

		if wTxt1in == undefined then global wTxt1 = "undefined" else global wTxt1 = wTxt1in
		if wTxt2in == undefined then global wTxt2 = "undefined" else global wTxt2 = wTxt2in
		if wTxt3in == undefined then global wTxt3 = "undefined" else global wTxt3 = wTxt3in
		if wTxt4in == undefined then global wTxt4 = "undefined" else global wTxt4 = wTxt4in
-- 		if wTimerClose == undefined then global wTimerClose = true else global wTimerClose = wTimerClose
	
	
		registerRedrawViewsCallback wTextFN
		completeredraw()
		
	

	
)


fn wTextUI TextVar =	
(
	
	case TextVar of 
	(
	
-- 		"CopyUV": wText ("          Copy UV: " + fromUV as string)  ("          To     UV: " + toUV as string) ("Source Object: " + srcObj.name) ""
-- 		"CopyUV": TextVar ("          Copy UV: " + rollUnwrap.btnUvCopyFrom.text )  ("          To     UV: " + rollUnwrap.btnUvCopyTo.text) ("Source Object: " + srcObj.name) ""

	)
	
)



/* 


if wTextVal == undefined or wTextVal == false then  
		( 
			wTextFN
			registerRedrawViewsCallback wText
			completeredraw()
			global wTextVal = true
		) 
		else
		(
			unregisterRedrawViewsCallback wText
			completeredraw() 
			global wTextVal = false
		)


 */


