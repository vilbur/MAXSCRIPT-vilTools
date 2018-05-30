fn saveOrigMat = 	--start
(
--		o=$
	Sel = #()
	Sel = for o in selection   where superclassof o == GeometryClass collect o

	for o in sel do 
	(	
		if o.material != undefined then
		(
			if  o.material.name != "BakedMat" do
			(
				setUserProp o "origMat" ""
				setUserProp o "origMat" o.material
			)
		)
		else
		(
				setUserProp o "origMat" "undefined"
		)
	)		
)	

--end
fn revertOrigMat = 	--start
(
--		o=$
	sceneMat = #()			--		o=$
	sel = #()
	sel =  for o in selection where superclassof o == geometryclass collect o

	sceneMatStrings = #()
	for m in  scenematerials where m.name != "BakedMat" do append sceneMat m
	for m in  meditMaterials where m.name != "BakedMat"  do appendifunique sceneMat m
	sceneMatStrings =  for m in  sceneMat collect m as string

	for o in sel do
	(		
		origmat = getUserProp o "origMat"
	--	o.material = sceneMat[finditem sceneMatStrings origmat]
				--Split the properies into key value pairs
	--	setUserProp o "origMat" ""	
		index = finditem sceneMatStrings origmat
		if index !=0 do 
		(
			mat = sceneMat[index]
			o.material = mat
-- 			rollMaterials.btnChecker.text = 1 as string 
		--	showTextureMap Mat Mat.diffusemap on
		--		currentKeyValuePair=allKeyValuePairs[1]	
		)
		
		if origmat == "undefined" do
		(
			o.material = undefined
		)
	)	
)

