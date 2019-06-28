-- This comment was added fօr merge
/*
Run this script on:

        SIS2S082.DEV_USA_COHR-Initial_Kb    -  This database will be modified

to synchronize it with:

        SIS2S082.DEV-RWA_IECMS-KB

You are recommended to back up your database before running this script

Script created by SQL Compare version 11.3.0 from Red Gate Software Ltd at 10/19/2017 12:24:37 PM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering extended properties'
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Merges information in DE_Control by given id:
                 when flag = 0 then JsfFormSectionID by given id;
                 when flag = 1 then DataTableColumnID by given id.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_DE_I_Control', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Merges information in DE_FieldInfo by given id:
                  when flag = 0 then categoryInfoId , displayNameId , fieldType , name , isIdField 
                  when flag = 1 then subCategoryId
                  when flag = 2 then lookupCategoryId , lookupCategoryPath
                  when flag = 3 then javaTypeId
                  when flag = 4 then dbColumnId', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_DE_I_FieldInfo', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Merges information in DE_NumberControls by given id:
                  when flag - 0 then all fields
                  when flag = 1 then NumberFormatID
                  when flag = 2 then IsPositiveOnly , NumberControlMaxLength , NumberControlMaxValue , NumberControlMinValue , NumberControlWidth.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_DE_I_NumberControl', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes Fields:
                when flag = 0 then by FieldID and WorkingCopyID;
                when flag = 1 then by WorkingCopyID;
                when flag = 2 then by WorkingCopy and Functional;
                when flag = 3 then by WorkingCopy and Category.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_Categories', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes CategoryName by CategoryID, WorkingCopyID and LanguageId.
                Flag = 0 - delete Name in all languages,
                Flag = 1 - delete by specific language.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_CategoryNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes KB_Currencies  by CurrencyID and WorkingCopyID.
-- when 0 then delete by @WorkingCopyID and  @CurrencyId 
-- when 1 then delete by @WorkingCopyID
', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_Currencies', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes DatasetNames by DatasetID and WorkingCopyID:
                  when flag = 0 then by DataSetID and WorkingCopyID;
                  when flag = 1 then by WorkingCopyID,
                  when flag = 2 then by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_DatasetNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes Dataset and all related data.
When @Flag = 0, then  delete All Dataset by Working Copy ID and Dataset ID, when @Flag =1 , then  deleteDataset all relationals by Working Copy and Dataset ID,when @Flag = 2 , then  delete All dataset by Working CopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_Datasets', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes KB_ExpressionItems.
               When @Flag = 0, then delete by WorkingCopyID,ExpressionID
               When @Flag = 1, then delete by WorkingCopyID,ExpressionID, ItemID', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_ExpressionItems', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes ExpressionNames.
                When Flag = 0, when deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_ExpressionNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes Expressions:
                  when flag = 1, then deletes KB Expressions by DataSetID and WorkingCopyID and ExpressionID;
                  when flag = 2, then deletes UD Expressions by DataSetID and WorkingCopyID;
                  when flag = 3, then deletes UD Expressions by ExpressionID,
                  when flag = 4, then deletes Expressions hierarchy by ExpressionID and WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_Expressions', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes Field Formatting Patterns.
                When @Flag = 0, then deletes by FieldID and WorkingCopyID,
                When @Flag = 1, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_FieldDateTimeNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes FieldIntervalNames.
                When @Flag = 0, then deletes by FieldID and WorkingCopy,
                When @Flag = 1, then deletes by LanguageID. ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_FieldIntervalNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes FieldIntervals. When  @Flag = 0, then delete  by WorkingCopyId and FieldID.
                ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_FieldIntervals', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes FieldMappings by FieldID and WorkingCopyID.
                When @Flag = 0, then delete by Id and @WorkingCopyID
                When @Flag =1, then delete by ItemID and @workingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_FieldMapping', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes FieldNames.
                Flag = 0 - delete names in all languages by FieldID and WorkingCopyID 
                Flag = 1 - delete name in specific language by FieldID,WorkingCopyID,LanguageID ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_FieldNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes Fields:
                when flag = 0 then by FieldID and WorkingCopyID;
                when flag = 1 then by WorkingCopyID;
                when flag = 2 then by WorkingCopy and Functional;
                when flag = 3 then by WorkingCopy and Category;
                When flag = 4, then by WorkingCopy and Performance.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_Fields', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes KB_C_FormattingPatternNames.
 When @Flag = 0, then delete by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_FormattingPatternNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'  Deletes FunctionalNames.
                Flag = 0 - deletes names in all languages by  FunctionalID,WorkingCopyId .
                Flag = 1 - deletes name in specific language by FunctionalID,WorkingCopyId,LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_FunctionalNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes Functionals.
                Deletes from KB_Fields and KB_Functionals all children of the FunctionalID:
                when flag = 0 then by Working Copy and Functional;
                when flag = 1 then by Working Copy;
                when flag = 2 then by Working Copy and Category.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_Functionals', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes GroupNames.
                When @Flag = 0, then deletes by GroupId and WorkingCopyId,
                When @Flag = 1, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_GroupNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes Groups: 
                when flag = 0 then by WorkingCopyID and GroupID;
                when flag = 1 then by WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_Groups', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'  Deletes from  KB_ItemDeleteds table.
                When @Flag = 1 then delete Paths by WorkingCopyID and DatasetID
                when 2 then delete Measures by WorkingCopyID and DatasetID
                when 3 then delete Expressions by WorkingCopyID and DatasetID
                when 4 then delete Paths by PathID, WorkingCopyID, DatasetID
                when 5 then delete Measures by MeasureID, WorkingCopyID, DatasetID
                when 6 then delete Expressions by Expression, WorkingCopyID, DatasetID
                when 7 then delete by WorkingCopyID
                when 8 then delete by LanguageID
                when 9 then delete  ExpressionPaths by WorkingCopyID and DatasetID
                when 10 then delete ExpressionPaths by WorkingCopyID and DatasetID and WorkingCopyID,
                when 11 then delete UD Expressions by DatasetID,
                when 12 tehn delete UD Expressions by  UD ExpressionID, DatasetID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_ItemDeleteds', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes ItemMappings by ItemId(CategoryID or FunctionalID) and WorkingCopyID.
                Deletes from KB_FieldMappings and KB_ItemMappings all children of ItemId.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_ItemMapping', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes MeasureNames.
                When @Flag = 0, then deletes by MeasureID and WorkingCopyID,
                When @Flag = 1, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_MeasureNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes from KB_MeasurePathNodes.
             When @Flag = 0, then delete by WorkingCopyID,MeasureID;
             when @Flag = 1, then by Working Copy.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_MeasurePathNodes', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes KB_C_MessageValues.
                When @Flag = 0, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_MessageValues', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes Narrative Names.
                When @Flag = 0, then deletes by NarrativeID and WorkingCopyID,
                When @Flag = 1, then deletes by LangaugeID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_NarrativeNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes PathNames.
                When @Flag = 0, the deletes by PathID and WorkingCopyID.
                When @Flag = 1, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_PathNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes  from KB_PathPathNodes
               When @Flag = 0, then delete by PathID,WorkingCopyID;
               When @Flag = 1, then by WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_PathPathNodes', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes Paths:
                when flag = 0 then by DataSetID and WorkingCopyID and pathID,
                when flag = 1 then by WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_Paths', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes Performance Names.
                When @Flag = 0, then deletes  by PerformanceID and WorkingCopyID,
                When @Flag = 1, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_PerformanceNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes WorkingCopy Names.
                When @Flag = 0, then deletes by WorkingCopyID,
                When @Flag = 1, the delete by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_WorkingCopyNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes WorkingCopy.
                When @Flag = 0, then deletes from  tables related to WorkingCopy
                When @Flag = 1, then deletes from  tables related to WorkingCopy, except KB_WorkingCopies.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_D_WorkingCopy', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'      Modifies all Category''s fields.
                When @Flag = 0, then by WorkingCopyID,CategoryID,
                When @Flag = 1, then update IsActive,
                When @Flag = 2, then update OwnerCategoryID,
                When @Flag = 3, then update DocumentID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_Category', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies ExpressionNames.
                When @Flag = 0, then modifies by ExpressionID, WorkingCopyID, LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_ExpressionNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Modifies ExpressionPathNames.
                When @Flag = 1, then inserts and updates by ExpressionPathID, WorkingCopyID, LanguageID.
                When @Flag = 2, then inserts and updates ExpressionPathDescription  by ExpressionPathID, WorkingCopyID, LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_ExpressionPathNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies ExpressionUserDefinedNames.
                When @Flag = 0, then modifies by ExpressionUserDefinedID, WorkingCopyID, LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_ExpressionUserDefinedNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies all ExpressionUserDefined''s fields.
                When @Flag = 0, then modifies by KB ExpressionUserDefineds by  ExpressionUserDefinedID,WorkingCopyID 
                When @Flag = 1, then modifies by UD ExpressionUserDefineds by ExpressionUserDefinedID,WorkingCopyID ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_ExpressionUserDefined', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies all Expression''s fields.
                When @Flag = 0, then modifies by KB Expressions by  ExpressionID,WorkingCopyID 
                When @Flag = 1, then modifies by UD Expressions by ExpressionID,WorkingCopyID ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_Expression', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Merge FieldReferences.
                Flag = 0, merge FieldReferences by FielID and WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_FieldReferences', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies all Field''s columns.
                Flag = 0, modifies ApiName, OwnerCategoryID, OriginID, OwnerFuntionalID, IsDefault,
      IsInUniquenessSet, IsOrderField, OrderTypeID, KindVariationID, IsActive,
      WorkingCopyID,  ID, OrderNumber fields.
                Flag = 1, modifies LookupCategoryID, IsUnique, Expression, IsRemovable fields.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_Field', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Inserts into KB_ItemDeleteds table.
                 when 1 then insert Paths
                 when 2 then insert Measures
                 when 3 then insert Expressions
                 when 4 then insert All
                 when 5 then insert UD Expressions,
                 when @Flag = 6 insert ExpressionPaths.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_ItemDeleteds', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'  Modifies KB_C_Languages.
                When @Flag = 0, then modifies by Order and Default Language;
                When @Flag = 1, then update LanguageSuffixID;
                When @Flag = 2, then update LanguageName_MessageID,
                When @Flag = 3, then update OrderNumber,
				When @Flag = 4, then copies item names,
				When @Flag = 5, then modifies item names by language suffix.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_Language', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Modifies MessageValues. 
               When @Flag = 0, then modifies by LanguageName_MessageID and LanguageID, 
               when @Flag = 1, then modifies by LanguageSuffix_MessageID and LanguageID, 
               when @Flag = 2, then  modifies by MessageNameID and LanguageId, 
               when @Flag = 3, then modifies by MessageSuffixID and languageID, 
               when @Flag = 4, then modifies by MessageID and LanguageID,
               when @Flag = 5, then copies from SourceLangID to DestLangID,
			   when @Flag = 6, then modifies by SourceLangID and MessageKey.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_MessageValues', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies Messages by MessageID:
                when flag = 0 then merge message select Identity;
                when flag = 1 then merge message return Identity.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_Messages', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies all WorkingCopy fields.
                 When  @Flag = 0 then by all information,
                 when @Flag = 1 then by WorkingCopyDataPointCount,
                 when @Flag = 2 then by LockerUserID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_I_WorkingCopy', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns arguments and their relevant information.
  When @Flag = 0 then load all Arguments,
           when @Flag = 1 then load by MethodID', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Arguments', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns Categories.
When flag = 0, returns all categories with their fields, system type and document information under specified working copy
               When flag = 1, returns specified category''s  fields, system type and document information under specified working copy 
               When flag = 2, returns specified category''s sub categories'' fields, system type and document information under specified working copy 
               When flag = 3, returns specified category''s sub categories'' fields, system type and document information under specified working copy and origin', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Categories', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns CategoryFields.
When flag = 1, returns fields information under specified owner category and working copy.
When flag = 2, returns fields information under specified owner functional and working copy.
When flag = 3, returns fields information under specified working copy.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_CategoryFields', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns KB_C_Messages. when @Flag = 0, then returns by ComponentID and LanguageID,
    when @Flag = 1, then returns by MessageTypeID and LanguageID
    when @Flag = 2, then returns by MessageID and LanguageID
     when @Flag = 3, then returns by MessageKey and LanguageID
     when @Flag = 4,, then returns by LanguageID', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_ComponentMessages', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns all currencies.
 When  @Flag = 0 then load all,
  when @Flag = 1 then load by WorkingCopyId ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Currencies', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns dataset names with their relevant information. 
 When @Flag = 0 then load tab names by DatasetID and WorkingCopyID', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_DatasetNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns all information about Dataset.
When @Flag = 0, then returns Dataset  and its names by a WorkingCopyID,
when @Flag = 1, then returns minimum DatasetId for WorkingCopyID,
when @Flag = 2, then returns Dataset  by a WorkingCopyID.
', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Datasets', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns DateFormats 
           When @Flag = 0, then by DateFormatId.
           When @Flag = 1, then in all languages.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_DateFormats', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns Documents.
When flag = 0, returns documents'' IDs and full paths by given document type
When flag = 1, returns detailed document information by given Document ID', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Documents', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns all ExpressionItems information.
               When @Flag = 0, then returns by WorkingCopyID,ExpressionID.
               When @Flag = 1, then returns by related measures information by WorkingCopyID,ExpressionID,
               When @Flag = 2, then returns parametric ExpressionItems information  by WorkingCopyID,ExpressionID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_ExpressionItems', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Loads Expression Names:
when flag = 0 , then UD Expression Names by ExpressionID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_ExpressionNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns FieldDateTimeNames.
When flag = 0, returns all FieldDateTime Names by DateTimeID, FieldID, WorkingCopyID. 
When flag = 1, returns all FieldDateTime Names by  FieldID, WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_FieldDateTimeNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns Functionals.
When flag = 1, returns functionals information, their name and mapping information by given Working Copy ID and Owner Category ID.
When flag = 2, returns functionals information, their name and mapping information by given Working Copy ID, Owner Category ID and Owner Functional ID.
When flag = 3, returns all functional information, their name and mapping information by given Working Copy ID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Functionals', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Loads KB_IndicatorDisaggregations.
                When @Flag = 1, then by  IndicatorGUID and WorkingCopy,
                When @Flag = 2, then by IndicatorDataPointID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_IndicatorDisaggregations', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns   KB_ItemDeleteds table.
When @Flag = 1 load Paths,  when @Flag = 2 load Measures and Expressions,  when  @Flag =3 then load by DatasetID,', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_ItemDeleteds', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns IWCID. 
                When @Flag = 0, then returns by given Working Copy ID and Item ID.
                When @Flag = 1, then then  IWCIDs Forms,
                When @Flag = 2, then IWCIDs Controls.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_ItemWCs', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns all information about KB_Measures.
                When @Flag = 1, then by WorkingCopyID.
                When @Flag = 2, then Indicator Measures by WorkingCopyID,
				When @Flag = 3, then measures which have filters.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Measures', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns multilingual text for Language by  @LanguageID.
 When  @Flag = 0, then returns Multilingual Text For Language,
    when @Flag = 1, then returns Language Aliases', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_MessageValues', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns information  from KB_Messages tables
 when @Falg = 0,  then returns by @ComponentID and @LanguageID
     when @Falg = 1, then returns by @MessageTypeID and @LanguageID
     when @Falg = 2, then returns by @MessageID and @LanguageID
     when @Falg = 3, then returns by @MessageKey and @LanguageID
     when @Falg = 4, then returns by @LanguageID
     when @Falg = 5, then returns by paging
     when @Falg = 6, then returns by paging and @MessageTypeID
     when @Falg = 7, then returns by paging and @ComponentID
     when @Falg = 8, then returns count of messages
     when @Falg = 9, then returns paging and MessageTypeID', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Messages', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns methodes and their relevant information. 
When @Flag =  0, then returns all Methodes,
            when @Flag = 1 then returns by MethodID,
           when @Flag = 2 then returns by MethodName.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_Methods', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns WFProcessItem.
               When @Flag = 1, then WFProcessItem by WorkingCopyID, ItemID,
               When @Flag = 2, then WFProcessItem by WorkingCopyID, DatasetID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_WFProcessItems', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns all working copies(except default working copy) with their relevant information.
			When @Flag = 0, then load all information,  
			when @Flag = 1, then load  by WorkingCopyDataPointCount, 
			when @Flag = 2, then load by workingcopyid and userid,
			when @Flag = 3, load all WC, 
			when @Flag = 4, then load LockerUserID by workingcopyid, 
			when @Flag = 5, then load deleted items by dataset, 
			when @Flag = 6, the load db name of  last deployed working copy.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_WorkingCopies', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns all working copy histories.
			When @Flag = 0, then load UserID,  
			when @Flag = 1, then load Date.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_S_WorkingCopyHistories', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies KB_ItemMappings.
When @Flag = 0, then modifies by given working copy and item.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_KB_U_ItemMapping', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'
                Deletes  UI_Filters fields.
                When @Flag = 1, then by SubTabID and WorkingCopyID
                when @Flag = 2, then by MemorizedViewID,
				when @Flag = 3, then by WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_Filters', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes group names, when @Flag = 0, then deletes by LanguageID,  
', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_GroupNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes memorizedview names.  
 When @Flag = 0, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_MemorizedViewNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes views from UI_MemorizedViews table. 
           When @Flag = 1, then deletes by MemorizedViewID, 
           when @Flag = 2, then deletes by CreatedBy,
           when @Flag = 3, then deletes by  DatasetID not under the  WorkingCopyID.
           when @Flag = 4, then deletes by  DatasetID.
           when @Flag = 5, then deletes DatasetID under the  WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_MemorizedViews', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes  from UI_SubTabFilters.
           When @Flag = 1, then by DatasetID,
           When @Flag = 2, then by DatasetID under the WorkingCopyID,
           When @Flag = 3, then by SubTabID and WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_SubTabFilters', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns subtab names.  
 When @Flag = 0, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_SubTabNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes UI_SubTabWFProcessItems fields 
                When @Flag = 1, then by SubTabID,WorkingCopyID,DatasetID,WFProcessID,
                When @Flag = 2, then by CategoryID,WorkingCopyID,WFProcessID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_SubTabWFProcessItems', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes tab names.  
 When  @Flag = 0, then deletes by LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_TabNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Delete Tabs from UI_Tabs table:
                when flag = 0 then by TabID and WorkingCopyID;
                when flag = 1 then by WorkingCopyID,
                when flag = 2 then by deleted sub tabs.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_Tab', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes view names. 
When @Flag = 0 then deletes by  LanguageID. ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_D_ViewNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Adds View and Filter Categories and Measures. 
           When @Flag = 0, then by  CategoryPathHolder, MeasurePathHolders , FilterCategoryPathHolders, FilterMeasurePathHolders.
           When @Flag = 1, then copies Memorized Views by MemorizedViewID. ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_I_MemorizedViewItems', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns group names with their relevant information. 
               When @Flag = 0, then returns by GroupID and LanguageID.
               When @Flag = 1, then returns by TabID, SubTabID ,ViewID,UserID,ExcludeGroupID,LanguageID,GroupName.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_S_GroupNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns groups with their relevant information. 
               When @Flag = 1 then returns by TabID, SubTabID,ViewId,UserID, LanguageID and also returns public groups, 
               when @Flag = 2 then returns by TabID, SubTabID,ViewId,UserID, LanguageID. 
               when @Flag = 3 then returns by GroupIDs,LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_S_Groups', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns field from UI_MemorizedViews table.
			 When @Flag = 0, then returns valid MemorizedViews, 
			 when @Flag = 1, then returns by UI_MemorizedViews.TabID,SubTabID, ViewID ,WorkingCopyID, 
			 when 2, then returns valid MemorizedViews  by   SubTabID, ViewID,MemorizedViewID,LanguageID, 
			 when @Flag = 3, then returns by UserID, 
			 when @Flag = 4, then returns by GroupID and LanguageID, 
			 when @Flag = 5, then returns by TabID,SubTabID,ViewID, LanguageID, 
			 when @Flag = 6, then returns by UserID and LanguageID,
			 when @Flag = 7, then returns IsPublic by MemorizedViewID,
			 when @Flag = 8, then returns by GroupIDs,MemorizedViewIDs, LanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_S_MemorizedViews', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns tab names with their relevant information. 
When @Flag = 0, then returns by SubTabID and WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_S_SubTabNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns SubTabViews with their relevant information. 
                When @Flag = 0, then returns by SubTabID and WorkingCopyID,
                when @Flag = 1, then returns Returns SubTabViews and Views  with their relevant information by  SubTabID and WorkingCopyID.  ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_S_SubTabViews', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns tabs with their relevant information.
           When @Flag = 0, then returns tabs by TabID and WorkingCopyID, 
           when @Flag = 1, then load tabs by WorkingCopyID,
           when @Flag = 2, then generate SortID,
           when @Flag = 3, then generate max SortID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UI_S_Tabs', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes Data related to Working Copy.
               @When @Flag = 0, then delete by WorkingCopyID and LogicalGroupIDs,
               @When @Flag = 1, then delete by WorkingCopyID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_D_WorkingCopy', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes dbo.um_CriteriaItems. 
                When @Flag = 0, then deletes by CriteriaID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_D_um_CriteriaItems', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes dbo.um_Criterias. 
                When @Flag = 0, then deletes by CriteriaID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_D_um_Criterias', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'  Deletes um_GroupsRoles:
     When flag = 2 then all relations by given GroupIDs.
                 when flag = 3 then by GroupID and RoleIDs.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_D_um_GroupsRoles', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Deletes um_GroupsUsers: 
                when Flag = 0 then all for given UserID;
                when Flag = 1 then all for given GroupID;
                when Flag = 2 then by given UserIDs and GroupID', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_D_um_GroupsUsers', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes Roles. 
First sets the parents of the children of the Role to be deleted to that Role''s Parent, 
then deletes from um_Roles by ID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_D_um_Roles', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'  Deletes User Roles. 
                when flag = 1, then deletes from um_UsersRoles by RoleID.
                when flag = 2, then deletes from um_UsersRoles by UserIDs
                when flag = 3, then deletes from um_UsersRoles by default role', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_D_um_UsersRoles', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies  dbo.um_CriteriaItems. 
                When @Flag = 0, then modifies by CriteriaID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_CriteriaItems', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies um_Criterias.
                When @Flag = 0, then modifies by CriteriaID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_Criterias', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'
Adds new Event Log.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_EventLog', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Inserts into um_GroupsRoles.
                when Flag = 0 Adds Groups for Role,
                when Flag = 1 Adds Roles for  Group. ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_GroupsRoles', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Inserts information into um_GroupsUsers.
  when Flag = 0 Delete all GroupUsers under given Group, add new Users under given Group
  when Flag = 1 Delete all GroupUsers under given User, add new Groups under given User', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_GroupsUsers', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'
Adds new PermissionValue.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_PermissionValues', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'
Adds new Permission.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_Permissions', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'
Adds new Role.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_Roles', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Add User Role:
               when flag = 0 then adds Roles to given User;
               when flag = 1 then  adds Users to a special given Role,
               when flag = 2, then  then assigns all Users to default Role.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_UsersRoles', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Add User:
when flag = 0 adds new User.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_Users', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'
Modifies all  um_kb_LogicalGroups fields by GroupID LogicalGroupID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_I_um_kb_LogicalGroups', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns list of types of application messages: 
                When @Flag = 0, then load base information; 
                When @Flag = 1 then load all information.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_ItemMessageTypes', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about Configuration:
when flag = 1 then returns information about Maintenance;
when flag = 2 then returns information about SMTP;
when flag = 3 then returns information about Back Up.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_Configurations', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about um_Criterias.
                When @Flag = 0, then returns by GroupID and WorkingCopyID
                When @Flag = 1, then returns by ItemID
                When @Flag = 2, then returns by ItemID and PermissionID,
                When @Flag = 3, then returns all information,
                When @Flag = 4, then returns last modified date by ItemID and PermissionID,
				When @Flah = 5, then returns the main information about um_Criterias by RoleID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_Criterias', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Loads new UM_Document.
                When @Flag = 0, then loads by DocumentTypeID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_Documents', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about um_GroupsUsers:
                  when flag = 0 then by GroupID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_GroupsUsers', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about Permission: 
                when flag = 0 then returns Menu''s children Permissions.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_MenusPermissions', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns the main information about Menu:
					when flag = 0 then menus and permissions.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_Menus', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about Policy:
when flag = 0 then by PolicyID;
when flag = 1 then by PolicyTypeID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_Policies', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about Policy Data Values:					
					when flag = 1 then by PolicyID and Current level;
					when flag = 2 then all.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_PolicyDataValues', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns the main information about Session
					when flag = 2 then by SessionStateID and searchtex using paging;
					when flag = 3 then count of States.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_Sessions', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Loads um_SharingDirectories.
                When @Flag = 1, then loads own share data of the user by UserId, TabId, SubTabId, ViewId,
                When @Flag = 2, then foreign share data of the user by UserId, TabId, SubTabId, ViewId,
                When @Flag = 3, then foreign share data of the user by UserID, SubTabIDs,
				When @Flag = 4, then by MemorizedViewID and LanguageID,
				When @Flag = 5, then by Loads um_SharingDirectories by  TabId, SubTabId,ViewId,IsPublicShared.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_SharingDirectories', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns the main information about User Network.
                when flag = 1 then by Email;
                when flag = 2 then by NetworkID;
                when flag = 3 then by UserID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_UserNetworks', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'  Returns the main information about User''s Profile:
				when flag = 0 then all;
				when flag = 1 then by UserID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_UserProfile', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns the main information about User:
				when flag = 0 then all by searchtext using paging;
				when flag = 1 then by Email;
				when flag = 2 then by UserID;
				when flag = 3 then by Login;
				when flag = 4 then by RoleID;
				when flag = 5 then count of users;
				when flag = 6 then by GroupID;
				when flag = 7 then by UserID and NetworkID,
				when flag = 8 then by User Activation GUID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_Users', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about Event:
when flag = 0 then about all Events;
when flag = 1 then by EventID;
when flag = 2 then by EventKey.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_kb_EventNames', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Returns the main information about Logical Group:
                when flag = 0 then by all; 
                when flag = 1 then by ParentID;
                when flag = 2 then by LogicalGroupID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_kb_LogicalGroups', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information from up_UM_S_um_kb_Parameters : 
                  when flag = 0 then returns Parameters, their Values and Types;
                  when flag = 1 then possible values for Parameter by ParameterID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_kb_Parameters', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about Policy Data Expressions:
when flag = 0 then by PolicyDataID;
when flag = 1 then by PolicyExpressionID.
', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_kb_PolicyExpressions', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about Policy Levels by ID:
                  When flag = 1 then all.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_kb_PolicyLevels', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Returns the main information about Session State:
when flag = 0 then by SessionStateID;
when flag = 1 then by SessionStateName.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_S_um_kb_SessionStates', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Updates um_Groups.
				When @Flag = 1 then by GroupID,
				When #Flag = 2 then by UserID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_U_Groups', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Updates Configuration:
when flag = 1 then updates Maintenance Configurations;
when flag = 2 then updates SMTP Configurations;
when flag = 3 then updates Back Up Configurations.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_U_um_Configurations', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Updates um_Parameters:
                when flag = 0ParameterValueID by ParameterID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_U_um_Parameters', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Updates Role Fields:
				when flag = 0 then by given ID;
				when flag = 1 then DeletedBy,DeletedOn by given ID.
				when flag = 2 then updates ParentRoles. ', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_U_um_Roles', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Updates Session Information:
                When flag = 0 then all;
                When flag = 1 then specified Session''s  State,
                Whwen flag = 2 then Session''s  State.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_U_um_Sessions', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Updates the specified User''s profile fields.
                When @Flag = 0, then updates all information by UserID,
                when @Flag = 1, then updates DefaultLanguageID by NewDefaultLanguageID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_U_um_UsersProfile', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Updates User''s information:
                When flag = 0, then Status  by UserID,
                When flag = 1, then DeletedBy,DeletedOn by UserID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_UM_U_um_Users', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Modifies ns_Notifications.
				When @Flag = 1, then by NotificationID,
				When @Flag = 2, then by NotificationIDs.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_ns_I_Notifications', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Loads ns_Notifications.
				When @Flag = 1, then by NotificationID, OffsetRows, FetchRows,
				When @Flag = 2, then count by UserID and IsRead.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_ns_S_Notifications', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Deletes um_WFRules 
			   When @Flag = 1, then by WFRuleID and WorkingCopyID,
			   When @Flag = 2, then by WFProcessID,WFStateID,
			   When @Flag = 3, then by RoleID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_um_D_WFRules', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_updateextendedproperty N'MS_Description', N' Loads um_WFRules.
			   When @Flag = 1, then by WorkingCopyID
			   When @Flag = 2, then validations.', 'SCHEMA', N'dbo', 'PROCEDURE', N'up_um_S_WFRules', NULL, NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
