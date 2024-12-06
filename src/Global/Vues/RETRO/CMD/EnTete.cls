Class Global.Vues.RETRO.CMD.EnTete [ ClassType = view, DdlAllowed, Owner = {_SYSTEM}, Not ProcedureBlock, ViewQuery = {
SELECT 
	*
FROM 
(
	SELECT 
		* 
	FROM 
		Global_Components_RETRO_CMD.INTERSITE 
	UNION ALL
	SELECT 
		* 
	FROM 
		Global_Components_RETRO_CMD.COUPE 
	UNION ALL
	SELECT 
		* 
	FROM 
		Global_Components_RETRO_CMD.CONFECTION 
)
} ]
{

}
