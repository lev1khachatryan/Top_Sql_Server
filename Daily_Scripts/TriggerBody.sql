-- This comment was added fօr merge
SELECT      Tables.Name TableName,
      Triggers.name TriggerName,
      Triggers.crdate TriggerCreatedDate,
      Comments.Text TriggerText
FROM      sysobjects Triggers
      Inner Join sysobjects Tables On Triggers.parent_obj = Tables.id
      Inner Join syscomments Comments On Triggers.id = Comments.id
WHERE      Triggers.xtype = 'TR'
      And Tables.xtype = 'U'
	  --AND  Triggers.name not LIKE 'triu%'
	  --AND  Comments.Text not LIKE '%Inserted%'
ORDER BY Tables.Name, Triggers.name
