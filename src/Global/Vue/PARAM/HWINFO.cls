Class Global.Vue.PARAM.HWINFO [ ClassType = view, DdlAllowed, Owner = {_SYSTEM}, Not ProcedureBlock, ViewQuery = {
SELECT 
	*
FROM 
(
	SELECT ID, N1, null as N2, null as N3, null as N4, null as N5, VALEUR
    FROM Global_Components_PARAM.HWINFO1
    UNION
    SELECT ID, N1, N2, null as N3, null as N4, null as N5, VALEUR
    FROM Global_Components_PARAM.HWINFO2
    UNION
    SELECT ID, N1, N2, N3, null as N4, null as N5, VALEUR
    FROM Global_Components_PARAM.HWINFO3
    UNION
    SELECT ID, N1, N2, N3, N4, null as N5, VALEUR
    FROM Global_Components_PARAM.HWINFO4
    UNION
    SELECT ID, N1, N2, N3, N4, N5, VALEUR
    FROM Global_Components_PARAM.HWINFO5
)

} ]
{

}
