/*
This script extracts the variables which are relevant for the later computation from
the Test.db
*/


/*
Create a temporary table to select the employee who worked on lastly on the bug.
*/
WITH TBL1 AS (SELECT ID AS ID, MAX(UPDATE_TIME) FROM ASSIGNED_TO GROUP BY ID),
TBL3 AS (SELECT TBL2.ID, TBL2.CURRENT_EMPLOYEE FROM ASSIGNED_TO TBL2 INNER JOIN TBL1 ON TBL2.ID = TBL1.ID)


SELECT REPORTS.ID AS ID,
       REPORTS.CURRENT_RESOLUTION AS CURRENT_RESOLUTION,
       REPORTS.CURRENT_STATUS AS CURRENT_STATUS,
       VERSION, 
       SEVERITY, 
       PRODUCT.REPORTER AS REPORTER,
       VERSION.VERSION AS VERSION,
       PRIORITY.PRIORITY AS PRIORITY,
       COMPONENT.SUBSYSTEM AS SUBSYSTEM,
       OP_SYS,
       TBL3.CURRENT_EMPLOYEE AS CURRENT_EMPLOYEE,	
       RESOLUTION.RESOLUTION AS RESOLUTION,
       CC_CLEAN.WHO AS CC_WHO,
       BUG_STATUS.STATUS AS BUG_STATUS

FROM REPORTS 

LEFT OUTER JOIN VERSION VERSION
ON REPORTS.ID = VERSION.ID
LEFT OUTER JOIN SEVERITY SEVERITY
ON REPORTS.ID = SEVERITY.ID
LEFT OUTER JOIN PRODUCT PRODUCT
ON REPORTS.ID = PRODUCT.ID
LEFT OUTER JOIN COMPONENT COMPONENT
ON REPORTS.ID = COMPONENT.ID
LEFT OUTER JOIN PRIORITY PRIORITY
ON REPORTS.ID = PRIORITY.ID
LEFT OUTER JOIN CC_CLEAN CC_CLEAN
ON REPORTS.ID = CC_CLEAN.ID
LEFT OUTER JOIN OP_SYS OP_SYS
ON REPORTS.ID = OP_SYS.ID
LEFT OUTER JOIN RESOLUTION RESOLUTION
ON REPORTS.ID = RESOLUTION.ID
LEFT OUTER JOIN TBL3 TBL3
ON REPORTS.ID = TBL3.ID
LEFT OUTER JOIN BUG_STATUS BUG_STATUS
ON REPORTS.ID = BUG_STATUS.ID

/*
With the where close we select only the bugs which are "FIXED" or "WONTFIX".
Here we assume that the bugs are closed and Fixed indicates sucess and wontfix no success.
*/

WHERE REPORTS.CURRENT_RESOLUTION ="FIXED" OR REPORTS.CURRENT_RESOLUTION = "WONTFIX"

GROUP BY REPORTS.ID;


