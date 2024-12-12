Class Global.Vues.RETRO.CMD.EnTete [ ClassType = view, DdlAllowed, Owner = {_SYSTEM}, Not ProcedureBlock, ViewQuery = {
SELECT 
	*
FROM 
(
	SELECT 
		* , 'INTERSITE' as TYPAGE
	FROM 
		Global_Components_RETRO_CMD.INTERSITE 
	UNION ALL
	SELECT 
		*  , 'COUPE' as TYPAGE
	FROM 
		Global_Components_RETRO_CMD.COUPE 
	UNION ALL
	SELECT 
		* , 'CONFECTION' as TYPAGE
	FROM 
		Global_Components_RETRO_CMD.CONFECTION 
)
} ]
{

}
