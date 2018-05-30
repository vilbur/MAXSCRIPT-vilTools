fn vilTools_InstanceTest Sel =
(
	finSel = #()
	Instances = #()
	unSelInstances = #()
-- 	origSel = for o in selection   where superclassof o == GeometryClass collect o			
	for o in Sel do
		(	
-- 					local addmod = #()
			obj_instance
			testInst = (InstanceMgr.GetInstances o &obj_instance)

			if testInst > 1 then 
			(
				join instances obj_instance	
			
				for inst in instances do
				(
					if (finditem unSelInstances inst == 0 ) then appendifunique finSel o
					appendifunique unSelInstances inst

-- 							if (finditem Sel inst != 0 ) then deleteitem Sel (finditem Sel inst)
				)
			)
			else
			(
				appendifunique finSel o
			)

		)
		finSel
	
-- 			select finSel
)