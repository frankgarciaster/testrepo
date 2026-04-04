/* ============================================================ */

/* Individual DMO */

select ssot__Id__c,
	   ssot__FirstName__c,
	   ssot__LastName__c,
	   Date_of_Birth__c,
	   ssot__DataSourceObjectId__c
	   
from   ssot__Individual__dlm

order by ssot__FirstName__c

/* ============================================================ */

/* Relate third party identifier to indiviuals */

select 	concat(ssot__Individual__dlm.ssot__FirstName__c, ' ', ssot__Individual__dlm.ssot__LastName__c) as IndividualName,
		ssot__Individual__dlm.ssot__Id__c as IndividualId,
		ssot__PartyIdentification__dlm.ssot__IdentificationNumber__c as PartyIdentifier,
		ssot__PartyIdentification__dlm.ssot__Name__c as PartyName
		
from 	ssot__Individual__dlm

join	ssot__PartyIdentification__dlm ON ssot__PartyIdentification__dlm.ssot__PartyId__c = ssot__Individual__dlm.ssot__Id__c

where 	ssot__PartyIdentification__dlm.ssot__IdentificationNumber__c <> ''

order by PartyName, PartyIdentifier
/*order by ssot__Individual__dlm.ssot__FirstName__c */

/* ============================================================ */

/* Query Individual and email records  */

select 	ssot__Individual__dlm.ssot__Id__c as IndividualId,
		concat(ssot__Individual__dlm.ssot__FirstName__c, ' ', ssot__Individual__dlm.ssot__LastName__c) as IndividualName,
		ssot__Individual__dlm.Date_of_Birth__c as DOB,
		ssot__ContactPointEmail__dlm.ssot__EmailAddress__c as EmailAddress,
		ssot__Individual__dlm.ssot__DataSourceId__c as DataSource
		
from 	ssot__Individual__dlm

join	ssot__ContactPointEmail__dlm on ssot__ContactPointEmail__dlm.ssot__PartyId__c = ssot__Individual__dlm.ssot__Id__c

/* where   ssot__Individual__dlm.ssot__LastName__c = 'Johnson' */
/* where   ssot__Individual__dlm.ssot__LastName__c = 'Davis' */

order by IndividualName

/* ============================================================ */

/* Query Individual and phone records  */

select 	ssot__Individual__dlm.ssot__Id__c as IndividualId,
		concat(ssot__Individual__dlm.ssot__FirstName__c, ' ', ssot__Individual__dlm.ssot__LastName__c) as IndividualName,
		ssot__Individual__dlm.Date_of_Birth__c as DOB,
		ssot__ContactPointPhone__dlm.ssot__FormattedE164PhoneNumber__c as Phone,
		ssot__Individual__dlm.ssot__DataSourceId__c as DataSource
		
from 	ssot__Individual__dlm

join	ssot__ContactPointPhone__dlm on ssot__ContactPointPhone__dlm.ssot__PartyId__c = ssot__Individual__dlm.ssot__Id__c

/* where   ssot__Individual__dlm.ssot__LastName__c = 'Johnson' */
/* where   ssot__Individual__dlm.ssot__LastName__c = 'Davis' */

order by IndividualName

/* ============================================================ */

/* Query provides a detailed look at individual profiles that are associated with the same third party identification number */

SELECT party_id."ssot__identificationnumber__c" AS "Identification Number",
	   party_id."ssot__name__c" AS "Identification Name",
       individual."ssot__id__c" AS "Individual Id",
       individual."ssot__firstname__c" AS "First Name",
       individual."ssot__lastname__c" AS "Last Name",
       contact_email."ssot__emailaddress__c" AS "Email",
       contact_phone."ssot__formattede164phonenumber__c" AS "Phone"
	   
FROM "ssot__partyidentification__dlm" party_id
LEFT JOIN "ssot__individual__dlm" individual ON party_id."ssot__partyid__c" = individual."ssot__id__c"
LEFT JOIN "ssot__contactpointemail__dlm" contact_email ON contact_email."ssot__partyid__c" = individual."ssot__id__c"
LEFT JOIN "ssot__contactpointphone__dlm" contact_phone ON contact_phone."ssot__partyid__c" = individual."ssot__id__c"

WHERE party_id."ssot__identificationnumber__c" IN
    (SELECT sub_party_id."ssot__identificationnumber__c"
     FROM "ssot__partyidentification__dlm" sub_party_id
     LEFT JOIN "ssot__individual__dlm" sub_individual ON sub_party_id."ssot__partyid__c" = sub_individual."ssot__id__c"
     WHERE sub_party_id."ssot__identificationnumber__c" LIKE '%-%' GROUP  BY sub_party_id."ssot__identificationnumber__c"
     HAVING Count(DISTINCT sub_individual."ssot__id__c") > 1)
	 
ORDER BY "Identification Number"

/* ============================================================ */

/* Query Content Point Consent per Individual */

SELECT "ssot__ContactPointConsent__dlm"."ssot__Id__c",
	   "ssot__ConsentStatusId__c",
	   "ssot__ContactPointId__c",
	   CONCAT("ssot__Individual__dlm"."ssot__FirstName__c", ' ', "ssot__Individual__dlm"."ssot__LastName__c") AS Name
FROM "ssot__ContactPointConsent__dlm" 
JOIN "ssot__Individual__dlm" ON "ssot__Individual__dlm"."ssot__Id__c" = "ssot__ContactPointConsent__dlm"."ssot__PartyId__c"
ORDER BY Name

/* ============================================================ */

/* Query Individual and email and phone records  */

select 	ssot__Individual__dlm.ssot__Id__c as IndividualId,
		concat(ssot__Individual__dlm.ssot__FirstName__c, ' ', ssot__Individual__dlm.ssot__LastName__c) as IndividualName,
		ssot__Individual__dlm.Date_of_Birth__c as DOB,
		ssot__ContactPointEmail__dlm.ssot__EmailAddress__c as EmailAddress,
		ssot__ContactPointPhone__dlm.ssot__TelephoneNumber__c as Phone,
		ssot__Individual__dlm.ssot__DataSourceId__c as DataSource
		
from 	ssot__Individual__dlm

join	ssot__ContactPointEmail__dlm on ssot__ContactPointEmail__dlm.ssot__PartyId__c = ssot__Individual__dlm.ssot__Id__c
join	ssot__ContactPointPhone__dlm on ssot__ContactPointPhone__dlm.ssot__PartyId__c = ssot__Individual__dlm.ssot__Id__c

where   ssot__Individual__dlm.ssot__LastName__c = 'Keller'

/*where   ssot__Individual__dlm.ssot__FirstName__c = 'Lisa'*/

/* order by IndividualName */

/* ============================================================ */

/* Query Unified and Individual names for Rulset 01*/

select ui.ssot__Id__c AS unifiedid,
	   ui.ssot__FirstName__c AS UnifiedFirstName,
	   ui.ssot__LastName__c AS UnifiedLastName,
	   i.ssot__Id__c AS individualid, 
	   i.ssot__FirstName__c AS FirstName,
	   i.ssot__LastName__c AS LastName,
   	   i.ssot__DataSourceObjectId__c AS Datasource

from ssot__Individual__dlm i
 join UnifiedLinkssotIndividualRs01__dlm on (i.ssot__Id__c = UnifiedLinkssotIndividualRs01__dlm.SourceRecordId__c) 
 join UnifiedssotIndividualRs01__dlm ui on (UnifiedLinkssotIndividualRs01__dlm.UnifiedRecordId__c = ui.ssot__Id__c) 
 
order by UnifiedFirstName

/* ============================================================ */

/* Query Unified and Individual names for Rulset 02*/

select ui.ssot__Id__c AS unifiedid,
	   ui.ssot__FirstName__c AS UnifiedFirstName,
	   ui.ssot__LastName__c AS UnifiedLastName,
	   i.ssot__Id__c AS individualid, 
	   i.ssot__FirstName__c AS FirstName,
	   i.ssot__LastName__c AS LastName,
   	   i.ssot__DataSourceObjectId__c AS Datasource

from ssot__Individual__dlm i
 join UnifiedLinkssotIndividualRs02__dlm on (i.ssot__Id__c = UnifiedLinkssotIndividualRs02__dlm.SourceRecordId__c) 
 join UnifiedssotIndividualRs02__dlm ui on (UnifiedLinkssotIndividualRs02__dlm.UnifiedRecordId__c = ui.ssot__Id__c) 
 
order by UnifiedFirstName

/* ============================================================ */

/* Loyalty Points Transactions */

SELECT "transaction_id__c",
	  "transaction_date__c",
	  "guest_id__c",
	  "points__c",	   
	  "transaction_type__c" 
FROM "Loyalty_Points_Transactions__dlm" 
ORDER BY "guest_id__c"

/* ============================================================ */

/* Calculated Insight */

SELECT 
 SUM(((Loyalty_Points_Transactions__dlm.points__c * CASE WHEN Loyalty_Points_Transactions__dlm.transaction_type__c = 'earn' THEN 1 ELSE 0 END) - (Loyalty_Points_Transactions__dlm.points__c * CASE WHEN Loyalty_Points_Transactions__dlm.transaction_type__c = 'redeem' THEN 1 ELSE 0 END))) AS points_balance__c,
 
  CASE WHEN SUM((Loyalty_Points_Transactions__dlm.points__c * CASE WHEN Loyalty_Points_Transactions__dlm.transaction_type__c = 'earn' THEN 1 ELSE 0 END)) >= 2000 THEN 'Titanium' 
  
       WHEN (SUM((Loyalty_Points_Transactions__dlm.points__c * CASE WHEN Loyalty_Points_Transactions__dlm.transaction_type__c = 'earn' THEN 1 ELSE 0 END)) >= 1200 and SUM((Loyalty_Points_Transactions__dlm.points__c * CASE WHEN Loyalty_Points_Transactions__dlm.transaction_type__c = 'earn' THEN 1 ELSE 0 END)) <= 1999 ) THEN 'Diamond'
	   
	   WHEN (SUM((Loyalty_Points_Transactions__dlm.points__c * CASE WHEN Loyalty_Points_Transactions__dlm.transaction_type__c = 'earn' THEN 1 ELSE 0 END)) >= 600 and SUM((Loyalty_Points_Transactions__dlm.points__c * CASE WHEN Loyalty_Points_Transactions__dlm.transaction_type__c = 'earn' THEN 1 ELSE 0 END)) <= 1199 ) THEN 'Emerald'
	   
	   ELSE 'Gold' END AS tier__c,

 UnifiedssotIndividualRs02__dlm.ssot__Id__c AS unifiedprofileid__c

FROM UnifiedssotIndividualRs02__dlm 
 JOIN UnifiedLinkssotIndividualRs02__dlm ON (UnifiedssotIndividualRs02__dlm.ssot__Id__c = UnifiedLinkssotIndividualRs02__dlm.UnifiedRecordId__c) 
 JOIN ssot__Individual__dlm ON (UnifiedLinkssotIndividualRs02__dlm.SourceRecordId__c = ssot__Individual__dlm.ssot__Id__c) 
 JOIN Loyalty_Points_Transactions__dlm ON (ssot__Individual__dlm.ssot__Id__c = Loyalty_Points_Transactions__dlm.guest_id__c) 

GROUP BY unifiedprofileid__c

/* ============================================================ */

/* CI output showing Individual Names */

SELECT c.unifiedprofileid__c,
	   concat(u.ssot__FirstName__c, ' ', u.ssot__LastName__c) as Name,
	   c.points_balance__c,
	   c.tier__c,
	   u."ssot__DataSourceId__c"
	   
FROM Loyalty_Balance_and_Tier__cio c
 JOIN "UnifiedLinkssotIndividualRs02__dlm" ON "UnifiedLinkssotIndividualRs02__dlm"."UnifiedRecordId__c" = c.unifiedprofileid__c
 JOIN "ssot__Individual__dlm" u ON u."ssot__Id__c" = "UnifiedLinkssotIndividualRs02__dlm"."SourceRecordId__c"

ORDER BY Name

/* ============================================================ */

/* Unified Individuals related to more than 1 Individual */

SELECT ui.ssot__Id__c AS "Unified ID",
       CONCAT(ui.ssot__FirstName__c, ' ', ui.ssot__LastName__c) AS "Unified Name",
   	   COUNT(i.ssot__Id__c) AS "Individual Count"

FROM UnifiedssotIndividualRs02__dlm ui
INNER JOIN UnifiedLinkssotIndividualRs02__dlm l ON ui.ssot__Id__c = l.UnifiedRecordId__c
INNER JOIN ssot__Individual__dlm i ON i.ssot__Id__c = l.SourceRecordId__c

GROUP BY ui.ssot__Id__c,
	     ui.ssot__FirstName__c,
	     ui.ssot__LastName__c

HAVING COUNT(i.ssot__Id__c) > 1

ORDER BY ui.ssot__FirstName__c

/* ============================================================ */

/* Unified Individuals related to only 1 Individual */

SELECT ui.ssot__Id__c AS "Unified ID",
       CONCAT(ui.ssot__FirstName__c, ' ', ui.ssot__LastName__c) AS "Unified Name",
   	   COUNT(i.ssot__Id__c) AS "Individual Count"

FROM UnifiedssotIndividualRs02__dlm ui
INNER JOIN UnifiedLinkssotIndividualRs02__dlm l ON ui.ssot__Id__c = l.UnifiedRecordId__c
INNER JOIN ssot__Individual__dlm i ON i.ssot__Id__c = l.SourceRecordId__c

GROUP BY ui.ssot__Id__c,
	     ui.ssot__FirstName__c,
	     ui.ssot__LastName__c

HAVING COUNT(i.ssot__Id__c) = 1

ORDER BY ui.ssot__FirstName__c

/* ============================================================ */

/* Unified Individuals and related Individuals */

SELECT ui.ssot__Id__c AS "Unified ID",
       CONCAT(ui.ssot__FirstName__c, ' ', ui.ssot__LastName__c) AS "Unified Name",
	   CONCAT(i.ssot__FirstName__c, ' ', i.ssot__LastName__c) AS "Indiividual Name"

FROM UnifiedssotIndividualRs02__dlm ui
INNER JOIN UnifiedLinkssotIndividualRs02__dlm l ON ui.ssot__Id__c = l.UnifiedRecordId__c
INNER JOIN ssot__Individual__dlm i ON i.ssot__Id__c = l.SourceRecordId__c

/* WHERE ui.ssot__LastName__c = 'Abrehart' */
/* WHERE ui.ssot__LastName__c = 'Babst' */

ORDER BY ui.ssot__FirstName__c

/* ============================================================ */

/* Count the number of Individual records per Data Source */

SELECT i.ssot__DataSourceObjectId__c,
       COUNT(i.ssot__DataSourceObjectId__c)
	   
FROM ssot__Individual__dlm i 

GROUP BY i.ssot__DataSourceObjectId__c