-- This comment was added fօr merge
IF OBJECT_ID('DE_AfterFullSync') IS NOT NULL
    BEGIN
        DROP PROC dbo.DE_AfterFullSync;
    END;
GO
-- ======================================================
-- Author:		<LKH>
-- Create date: <20170804>
-- Description:	<Procedure is being run after full sync>
-- ======================================================
CREATE PROCEDURE dbo.DE_AfterFullSync
AS
    BEGIN
        UPDATE  [dbo].[CourtCase]
        SET     [CourtCase].[WFActionDateInDay] = CONVERT(DECIMAL(18, 2), [CourtCase].[WFActionDate])
                - 42368.00 --= '2016-01-01 00:00'
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     [FillingFee] = CASE [CourtCase].CategoryID
                                 WHEN 4 THEN 0
                                 ELSE C_Group.FillingFee
                               END
        FROM    [dbo].[CourtCase]
                INNER JOIN dbo.C_Group ON C_Group.GroupID = CourtCase.CourtID;

        TRUNCATE TABLE dbo.CourtCaseWFState;

        INSERT  INTO dbo.CourtCaseWFState
                ( CourtCaseID ,
                  WFStateID
                )
                SELECT  CourtCaseID ,
                        WFStateID
                FROM    dbo.CourtCase;

        UPDATE  [dbo].[CourtCase]
        SET     CaseRegisteredDateDayID = CAST(DATEPART(yy,
                                                        [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCase].[CaseRegisteredDate])
                                              + 1 AS VARCHAR), 3) ,
                CaseRegisteredDateWeekID = CAST(DATEPART(yy,
                                                         [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR),
                                   2) ,
                CaseRegisteredDateMonthID = CAST(DATEPART(yy,
                                                          [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR),
                        2) ,
                CaseRegisteredDateQuarterID = CAST(DATEPART(yy,
                                                            [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR) ,
                CaseRegisteredDateYearID = CAST(DATEPART(yy,
                                                         [dbo].[CourtCase].[CaseRegisteredDate]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     CaseSubmittedDateDayID = CAST(DATEPART(yy,
                                                       [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCase].[CaseSubmittedDate])
                                              + 1 AS VARCHAR), 3) ,
                CaseSubmittedDateWeekID = CAST(DATEPART(yy,
                                                        [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR),
                                   2) ,
                CaseSubmittedDateMonthID = CAST(DATEPART(yy,
                                                         [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR),
                        2) ,
                CaseSubmittedDateQuarterID = CAST(DATEPART(yy,
                                                           [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR) ,
                CaseSubmittedDateYearID = CAST(DATEPART(yy,
                                                        [dbo].[CourtCase].[CaseSubmittedDate]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     DateCreatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[CourtCase].[DateCreated]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[CourtCase].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     DecisionDateDayID = CAST(DATEPART(yy,
                                                  [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCase].[DecisionDate])
                                              + 1 AS VARCHAR), 3) ,
                DecisionDateWeekID = CAST(DATEPART(yy,
                                                   [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                                   2) ,
                DecisionDateMonthID = CAST(DATEPART(yy,
                                                    [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                        2) ,
                DecisionDateQuarterID = CAST(DATEPART(yy,
                                                      [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR) ,
                DecisionDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     DecisionDateDayID = CAST(DATEPART(yy,
                                                  [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCase].[DecisionDate])
                                              + 1 AS VARCHAR), 3) ,
                DecisionDateWeekID = CAST(DATEPART(yy,
                                                   [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                                   2) ,
                DecisionDateMonthID = CAST(DATEPART(yy,
                                                    [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR),
                        2) ,
                DecisionDateQuarterID = CAST(DATEPART(yy,
                                                      [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[DecisionDate]) AS VARCHAR) ,
                DecisionDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[CourtCase].[DecisionDate]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     DecisionPronouncementDateYearID = CAST(DATEPART(yy,
                                                              [dbo].[CourtCase].[DecisionPronouncementDate]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     FirstScheduleDateYearID = CAST(DATEPART(yy,
                                                        [dbo].[CourtCase].[FirstScheduleDate]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     LastScheduleDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[CourtCase].[LastScheduleDate]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCase]
        SET     WFActionDateDayID = CAST(DATEPART(yy,
                                                  [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[WFActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[WFActionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCase].[WFActionDate])
                                              + 1 AS VARCHAR), 3) ,
                WFActionDateWeekID = CAST(DATEPART(yy,
                                                   [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[WFActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCase].[WFActionDate]) AS VARCHAR),
                                   2) ,
                WFActionDateMonthID = CAST(DATEPART(yy,
                                                    [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[CourtCase].[WFActionDate]) AS VARCHAR),
                        2) ,
                WFActionDateQuarterID = CAST(DATEPART(yy,
                                                      [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCase].[WFActionDate]) AS VARCHAR) ,
                WFActionDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[CourtCase].[WFActionDate]) AS VARCHAR)
        FROM    [dbo].[CourtCase];

        UPDATE  [dbo].[CourtCaseDecisionDetails]
        SET     SentenceEndDateYearID = CAST(DATEPART(yy,
                                                      [dbo].[CourtCaseDecisionDetails].[SentenceEndDate]) AS VARCHAR)
        FROM    [dbo].[CourtCaseDecisionDetails];

        UPDATE  [dbo].[CourtCaseDecisionDetails]
        SET     SentenceStartDateYearID = CAST(DATEPART(yy,
                                                        [dbo].[CourtCaseDecisionDetails].[SentenceStartDate]) AS VARCHAR)
        FROM    [dbo].[CourtCaseDecisionDetails];

        UPDATE  CourtCaseDecisionDetailsSubject
        SET     DurationInYear = DATEDIFF(DAY, StartDate, EndDate) / 360.0
        FROM    [dbo].CourtCaseDecisionDetailsSubject;

        UPDATE  [dbo].[CourtCaseDecisionDetailsSubject]
        SET     EndDateDayID = CAST(DATEPART(yy,
                                             [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCaseDecisionDetailsSubject].[EndDate])
                                              + 1 AS VARCHAR), 3) ,
                EndDateWeekID = CAST(DATEPART(yy,
                                              [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR),
                                   2) ,
                EndDateMonthID = CAST(DATEPART(yy,
                                               [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR),
                        2) ,
                EndDateQuarterID = CAST(DATEPART(yy,
                                                 [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR) ,
                EndDateYearID = CAST(DATEPART(yy,
                                              [dbo].[CourtCaseDecisionDetailsSubject].[EndDate]) AS VARCHAR)
        FROM    [dbo].[CourtCaseDecisionDetailsSubject];

        UPDATE  [dbo].[CourtCaseDecisionDetailsSubject]
        SET     StartDateDayID = CAST(DATEPART(yy,
                                               [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCaseDecisionDetailsSubject].[StartDate])
                                              + 1 AS VARCHAR), 3) ,
                StartDateWeekID = CAST(DATEPART(yy,
                                                [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR),
                                   2) ,
                StartDateMonthID = CAST(DATEPART(yy,
                                                 [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR),
                        2) ,
                StartDateQuarterID = CAST(DATEPART(yy,
                                                   [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR) ,
                StartDateYearID = CAST(DATEPART(yy,
                                                [dbo].[CourtCaseDecisionDetailsSubject].[StartDate]) AS VARCHAR)
        FROM    [dbo].[CourtCaseDecisionDetailsSubject];

        UPDATE  [dbo].[CourtCaseIntervention]
        SET     InterventionDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[CourtCaseIntervention].[InterventionDate]) AS VARCHAR)
        FROM    [dbo].[CourtCaseIntervention];

        UPDATE  [dbo].[CourtCaseProceeding]
        SET     ProceedingDateDayID = CAST(DATEPART(yy,
                                                    [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCaseProceeding].[ProceedingDate])
                                              + 1 AS VARCHAR), 3) ,
                ProceedingDateWeekID = CAST(DATEPART(yy,
                                                     [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR),
                                   2) ,
                ProceedingDateMonthID = CAST(DATEPART(yy,
                                                      [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR),
                        2) ,
                ProceedingDateQuarterID = CAST(DATEPART(yy,
                                                        [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR) ,
                ProceedingDateYearID = CAST(DATEPART(yy,
                                                     [dbo].[CourtCaseProceeding].[ProceedingDate]) AS VARCHAR)
        FROM    [dbo].[CourtCaseProceeding];

        UPDATE  [dbo].[CourtCaseSchedule]
        SET     HearingDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCaseSchedule].[HearingDate])
                                              + 1 AS VARCHAR), 3) ,
                HearingDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR),
                                   2) ,
                HearingDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR),
                        2) ,
                HearingDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR) ,
                HearingDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[CourtCaseSchedule].[HearingDate]) AS VARCHAR)
        FROM    [dbo].[CourtCaseSchedule];

        UPDATE  CourtCaseScheduleHearingParty
        SET     HearingTypeID = CourtCaseSchedule.HearingTypeID ,
                HearingDate = CourtCaseSchedule.HearingDate ,
                HearingDateDayID = CourtCaseSchedule.HearingDateDayID ,
                HearingDateWeekID = CourtCaseSchedule.HearingDateWeekID ,
                HearingDateMonthID = CourtCaseSchedule.HearingDateMonthID ,
                HearingDateQuarterID = CourtCaseSchedule.HearingDateQuarterID ,
                HearingDateYearID = CourtCaseSchedule.HearingDateYearID ,
                CourtCaseNumber = CourtCase.CaseNumber ,
                CourtID = CourtCase.CourtID
        FROM    CourtCaseScheduleHearingParty
                INNER JOIN CourtCaseSchedule ON CourtCaseSchedule.CourtCaseScheduleID = CourtCaseScheduleHearingParty.CourtCaseScheduleID
                INNER JOIN CourtCase ON CourtCaseSchedule.CourtCaseID = CourtCase.CourtCaseID;

        UPDATE  [dbo].[CourtCaseWFAction]
        SET     [CourtCaseWFAction].[ActionDateInDay] = CONVERT(DECIMAL(18, 2), [CourtCaseWFAction].[ActionDate])
                - 42368.00 --= '2016-01-01 00:00'
        FROM    [dbo].[CourtCaseWFAction]; 

        UPDATE  [dbo].[CourtCaseWFAction]
        SET     ActionDateDayID = CAST(DATEPART(yy,
                                                [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[CourtCaseWFAction].[ActionDate])
                                              + 1 AS VARCHAR), 3) ,
                ActionDateWeekID = CAST(DATEPART(yy,
                                                 [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) ,
                ActionDateMonthID = CAST(DATEPART(yy,
                                                  [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) ,
                ActionDateQuarterID = CAST(DATEPART(yy,
                                                    [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR) ,
                ActionDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[CourtCaseWFAction].[ActionDate]) AS VARCHAR)
        FROM    [dbo].[CourtCaseWFAction];
	
        TRUNCATE TABLE dbo.RCSCaseWFState;
        INSERT  INTO dbo.RCSCaseWFState
                ( RCSCaseID ,
                  WFStateID
                )
                SELECT  RCSCaseID ,
                        WFStateID
                FROM    dbo.RCSCase;

        UPDATE  [dbo].[RCSCase]
        SET     ArrestDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCase].[ArrestDate]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     ArrivingDateDayID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCase].[ArrivingDate])
                                              + 1 AS VARCHAR), 3) ,
                ArrivingDateWeekID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR),
                                   2) ,
                ArrivingDateMonthID = CAST(DATEPART(yy,
                                                    [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR),
                        2) ,
                ArrivingDateQuarterID = CAST(DATEPART(yy,
                                                      [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR) ,
                ArrivingDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCase].[ArrivingDate]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     DateCreatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[DateCreated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCase].[DateCreated])
                                              + 1 AS VARCHAR), 3) ,
                DateCreatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[DateCreated]) AS VARCHAR),
                                   2) ,
                DateCreatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[DateCreated]) AS VARCHAR),
                        2) ,
                DateCreatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[DateCreated]) AS VARCHAR) ,
                DateCreatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCase].[DateCreated]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     DateUpdatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[DateUpdated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCase].[DateUpdated])
                                              + 1 AS VARCHAR), 3) ,
                DateUpdatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[DateUpdated]) AS VARCHAR),
                                   2) ,
                DateUpdatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[DateUpdated]) AS VARCHAR),
                        2) ,
                DateUpdatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[DateUpdated]) AS VARCHAR) ,
                DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCase].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     DeathDateYearID = CAST(DATEPART(yy,
                                                [dbo].[RCSCase].[DeathDate]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     ExitDateYearID = CAST(DATEPART(yy, [dbo].[RCSCase].[ExitDate]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     FinalDecisionDateYearID = CAST(DATEPART(yy,
                                                        [dbo].[RCSCase].[FinalDecisionDate]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     ReleaseDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCase].[ReleaseDate])
                                              + 1 AS VARCHAR), 3) ,
                ReleaseDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR),
                                   2) ,
                ReleaseDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR),
                        2) ,
                ReleaseDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR) ,
                ReleaseDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCase].[ReleaseDate]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     ReleaseDetailsDateUpdatedYearID = CAST(DATEPART(yy,
                                                              [dbo].[RCSCase].[ReleaseDetailsDateUpdated]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     SentenceEndDateDayID = CAST(DATEPART(yy,
                                                     [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCase].[SentenceEndDate])
                                              + 1 AS VARCHAR), 3) ,
                SentenceEndDateWeekID = CAST(DATEPART(yy,
                                                      [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR),
                                   2) ,
                SentenceEndDateMonthID = CAST(DATEPART(yy,
                                                       [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR),
                        2) ,
                SentenceEndDateQuarterID = CAST(DATEPART(yy,
                                                         [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR) ,
                SentenceEndDateYearID = CAST(DATEPART(yy,
                                                      [dbo].[RCSCase].[SentenceEndDate]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCase]
        SET     SentenceStartDateDayID = CAST(DATEPART(yy,
                                                       [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCase].[SentenceStartDate])
                                              + 1 AS VARCHAR), 3) ,
                SentenceStartDateWeekID = CAST(DATEPART(yy,
                                                        [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR),
                                   2) ,
                SentenceStartDateMonthID = CAST(DATEPART(yy,
                                                         [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR),
                        2) ,
                SentenceStartDateQuarterID = CAST(DATEPART(yy,
                                                           [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR) ,
                SentenceStartDateYearID = CAST(DATEPART(yy,
                                                        [dbo].[RCSCase].[SentenceStartDate]) AS VARCHAR)
        FROM    [dbo].[RCSCase];

        UPDATE  [dbo].[RCSCaseArrestStatement]
        SET     ArrestStatementDateDayID = CAST(DATEPART(yy,
                                                         [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCaseArrestStatement].[ArrestStatementDate])
                                              + 1 AS VARCHAR), 3) ,
                ArrestStatementDateWeekID = CAST(DATEPART(yy,
                                                          [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR),
                                   2) ,
                ArrestStatementDateMonthID = CAST(DATEPART(yy,
                                                           [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR),
                        2) ,
                ArrestStatementDateQuarterID = CAST(DATEPART(yy,
                                                             [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR) ,
                ArrestStatementDateYearID = CAST(DATEPART(yy,
                                                          [dbo].[RCSCaseArrestStatement].[ArrestStatementDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseArrestStatement];

        UPDATE  [dbo].[RCSCaseArrestWarrant]
        SET     WarrantDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCaseArrestWarrant].[WarrantDate])
                                              + 1 AS VARCHAR), 3) ,
                WarrantDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR),
                                   2) ,
                WarrantDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR),
                        2) ,
                WarrantDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR) ,
                WarrantDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCaseArrestWarrant].[WarrantDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseArrestWarrant];

        UPDATE  [dbo].[RCSCaseCourtDecision]
        SET     DecisionDateDayID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCaseCourtDecision].[DecisionDate])
                                              + 1 AS VARCHAR), 3) ,
                DecisionDateWeekID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR),
                                   2) ,
                DecisionDateMonthID = CAST(DATEPART(yy,
                                                    [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR),
                        2) ,
                DecisionDateQuarterID = CAST(DATEPART(yy,
                                                      [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR) ,
                DecisionDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCaseCourtDecision].[DecisionDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseCourtDecision];

	;
        WITH    CTE
                  AS ( SELECT   RCSCase.RCSCaseID ,
                                MIN(RCSCaseCourtDecisionSubject.StartDate) AS StartDate ,
                                MAX(RCSCaseCourtDecisionSubject.EndDate) AS EndDate
                       FROM     dbo.RCSCaseCourtDecisionSubject
                                JOIN dbo.RCSCaseCourtDecision ON RCSCaseCourtDecision.RCSCaseCourtDecisionID = RCSCaseCourtDecisionSubject.RCSCaseCourtDecisionID
                                JOIN dbo.RCSCase ON RCSCase.RCSCaseID = RCSCaseCourtDecision.RCSCaseID
                       GROUP BY RCSCase.RCSCaseID
                     )
            UPDATE  RCSSubject
            SET     DecisionDuration = ( CAST(DATEDIFF(DAY, CTE.StartDate,
                                                       CTE.EndDate) AS DECIMAL)
                                         / 360 )
            FROM    dbo.RCSCaseCourtDecisionSubject AS RCSSubject
                    JOIN dbo.RCSCaseCourtDecision ON RCSCaseCourtDecision.RCSCaseCourtDecisionID = RCSSubject.RCSCaseCourtDecisionID
                    JOIN CTE ON CTE.RCSCaseID = RCSCaseCourtDecision.RCSCaseID;

        UPDATE  [dbo].[RCSCaseCourtDecisionSubject]
        SET     EndDateYearID = CAST(DATEPART(yy,
                                              [dbo].[RCSCaseCourtDecisionSubject].[EndDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseCourtDecisionSubject];
	
        UPDATE  [dbo].[RCSCaseCourtDecisionSubject]
        SET     StartDateYearID = CAST(DATEPART(yy,
                                                [dbo].[RCSCaseCourtDecisionSubject].[StartDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseCourtDecisionSubject];
	
        UPDATE  RCSCaseCrimeType
        SET     PartyCrimeID = RCSCaseCrimeTypeID;	

        UPDATE  [dbo].[RCSCaseDetaineesAppointment]
        SET     HearingDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCaseDetaineesAppointment].[HearingDate])
                                              + 1 AS VARCHAR), 3) ,
                HearingDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR),
                                   2) ,
                HearingDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR),
                        2) ,
                HearingDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR) ,
                HearingDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCaseDetaineesAppointment].[HearingDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseDetaineesAppointment];

        UPDATE  [dbo].[RCSCaseDiscipline]
        SET     DateDayID = CAST(DATEPART(yy, [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCaseDiscipline].[Date])
                                              + 1 AS VARCHAR), 3) ,
                DateWeekID = CAST(DATEPART(yy,
                                           [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR),
                                   2) ,
                DateMonthID = CAST(DATEPART(yy,
                                            [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR),
                        2) ,
                DateQuarterID = CAST(DATEPART(yy,
                                              [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR) ,
                DateYearID = CAST(DATEPART(yy,
                                           [dbo].[RCSCaseDiscipline].[Date]) AS VARCHAR)
        FROM    [dbo].[RCSCaseDiscipline];

        UPDATE  [dbo].[RCSCaseEvasion]
        SET     EscapeDateDayID = CAST(DATEPART(yy,
                                                [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCaseEvasion].[EscapeDate])
                                              + 1 AS VARCHAR), 3) ,
                EscapeDateWeekID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR),
                                   2) ,
                EscapeDateMonthID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR),
                        2) ,
                EscapeDateQuarterID = CAST(DATEPART(yy,
                                                    [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR) ,
                EscapeDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCaseEvasion].[EscapeDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseEvasion];

        UPDATE  [dbo].[RCSCaseMedicalCheckUp]
        SET     ConsultationDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[RCSCaseMedicalCheckUp].[ConsultationDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseMedicalCheckUp];

        UPDATE  [dbo].[RCSCaseMedicalCheckUp]
        SET     StartDateYearID = CAST(DATEPART(yy,
                                                [dbo].[RCSCaseMedicalCheckUp].[StartDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseMedicalCheckUp];

        UPDATE  [dbo].[RCSCaseMedicalCheckUp]
        SET     TestDateYearID = CAST(DATEPART(yy,
                                               [dbo].[RCSCaseMedicalCheckUp].[TestDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseMedicalCheckUp];

        UPDATE  [dbo].[RCSCaseMoney]
        SET     DateYearID = CAST(DATEPART(yy, [dbo].[RCSCaseMoney].[Date]) AS VARCHAR)
        FROM    [dbo].[RCSCaseMoney];

        UPDATE  [dbo].[RCSCaseReturnItem]
        SET     ReturnDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCaseReturnItem].[ReturnDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseReturnItem];

        UPDATE  [dbo].[RCSCaseSeizedItem]
        SET     SeizedDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCaseSeizedItem].[SeizedDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseSeizedItem];

        UPDATE  [dbo].[RCSCaseTransfer]
        SET     DateDayID = CAST(DATEPART(yy, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCaseTransfer].[Date])
                                              + 1 AS VARCHAR), 3) ,
                DateWeekID = CAST(DATEPART(yy, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR),
                                   2) ,
                DateMonthID = CAST(DATEPART(yy, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR),
                        2) ,
                DateQuarterID = CAST(DATEPART(yy,
                                              [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR) ,
                DateYearID = CAST(DATEPART(yy, [dbo].[RCSCaseTransfer].[Date]) AS VARCHAR)
        FROM    [dbo].[RCSCaseTransfer];

        UPDATE  [dbo].[RCSCaseWFAction]
        SET     [RCSCaseWFAction].[ActionDateInDay] = CONVERT(DECIMAL(18, 2), [RCSCaseWFAction].[ActionDate])
                - 42368.00 --= '2016-01-01 00:00'
        FROM    [dbo].[RCSCaseWFAction];

        UPDATE  [dbo].[RCSCaseWFAction]
        SET     ActionDateDayID = CAST(DATEPART(yy,
                                                [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[RCSCaseWFAction].[ActionDate])
                                              + 1 AS VARCHAR), 3) ,
                ActionDateWeekID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) ,
                ActionDateMonthID = CAST(DATEPART(yy,
                                                  [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) ,
                ActionDateQuarterID = CAST(DATEPART(yy,
                                                    [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR) ,
                ActionDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[RCSCaseWFAction].[ActionDate]) AS VARCHAR)
        FROM    [dbo].[RCSCaseWFAction];

        TRUNCATE TABLE dbo.ProsecutionCaseWFState;

        INSERT  INTO dbo.ProsecutionCaseWFState
                ( ProsecutionCaseID ,
                  WFStateID
                )
                SELECT  ProsecutionCaseID ,
                        WFStateID
                FROM    dbo.ProsecutionCase;

        UPDATE  [dbo].[ProsecutionCase]
        SET     CaseFieldDateDayID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCase].[CaseFieldDate])
                                              + 1 AS VARCHAR), 3) ,
                CaseFieldDateWeekID = CAST(DATEPART(yy,
                                                    [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR),
                                   2) ,
                CaseFieldDateMonthID = CAST(DATEPART(yy,
                                                     [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR),
                        2) ,
                CaseFieldDateQuarterID = CAST(DATEPART(yy,
                                                       [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR) ,
                CaseFieldDateYearID = CAST(DATEPART(yy,
                                                    [dbo].[ProsecutionCase].[CaseFieldDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCase];

        UPDATE  [dbo].[ProsecutionCase]
        SET     CaseReceivedDateDayID = CAST(DATEPART(yy,
                                                      [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCase].[CaseReceivedDate])
                                              + 1 AS VARCHAR), 3) ,
                CaseReceivedDateWeekID = CAST(DATEPART(yy,
                                                       [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR),
                                   2) ,
                CaseReceivedDateMonthID = CAST(DATEPART(yy,
                                                        [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR),
                        2) ,
                CaseReceivedDateQuarterID = CAST(DATEPART(yy,
                                                          [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR) ,
                CaseReceivedDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[ProsecutionCase].[CaseReceivedDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCase];

        UPDATE  [dbo].[ProsecutionCase]
        SET     DateCreatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCase].[DateCreated])
                                              + 1 AS VARCHAR), 3) ,
                DateCreatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR),
                                   2) ,
                DateCreatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR),
                        2) ,
                DateCreatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR) ,
                DateCreatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCase].[DateCreated]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCase];

        UPDATE  [dbo].[ProsecutionCase]
        SET     DateUpdatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCase].[DateUpdated])
                                              + 1 AS VARCHAR), 3) ,
                DateUpdatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR),
                                   2) ,
                DateUpdatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR),
                        2) ,
                DateUpdatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR) ,
                DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCase].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCase];

        UPDATE  [dbo].[ProsecutionCase]
        SET     IndictmentDateDayID = CAST(DATEPART(yy,
                                                    [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCase].[IndictmentDate])
                                              + 1 AS VARCHAR), 3) ,
                IndictmentDateWeekID = CAST(DATEPART(yy,
                                                     [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR),
                                   2) ,
                IndictmentDateMonthID = CAST(DATEPART(yy,
                                                      [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR),
                        2) ,
                IndictmentDateQuarterID = CAST(DATEPART(yy,
                                                        [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR) ,
                IndictmentDateYearID = CAST(DATEPART(yy,
                                                     [dbo].[ProsecutionCase].[IndictmentDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCase];

        UPDATE  [dbo].[ProsecutionCaseArrestWarrant]
        SET     ArrestDateDayID = CAST(DATEPART(yy,
                                                [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate])
                                              + 1 AS VARCHAR), 3) ,
                ArrestDateWeekID = CAST(DATEPART(yy,
                                                 [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR),
                                   2) ,
                ArrestDateMonthID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR),
                        2) ,
                ArrestDateQuarterID = CAST(DATEPART(yy,
                                                    [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR) ,
                ArrestDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[ProsecutionCaseArrestWarrant].[ArrestDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseArrestWarrant];

        UPDATE  [dbo].[ProsecutionCaseArrestWarrant]
        SET     IssueDateDayID = CAST(DATEPART(yy,
                                               [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseArrestWarrant].[IssueDate])
                                              + 1 AS VARCHAR), 3) ,
                IssueDateWeekID = CAST(DATEPART(yy,
                                                [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR),
                                   2) ,
                IssueDateMonthID = CAST(DATEPART(yy,
                                                 [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR),
                        2) ,
                IssueDateQuarterID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR) ,
                IssueDateYearID = CAST(DATEPART(yy,
                                                [dbo].[ProsecutionCaseArrestWarrant].[IssueDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseArrestWarrant];

        UPDATE  [dbo].[ProsecutionCaseCaseClosure]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCaseCaseClosure].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseCaseClosure];

        UPDATE  [dbo].[ProsecutionCaseCaseClosure]
        SET     DateDayID = CAST(DATEPART(yy,
                                          [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseCaseClosure].[Date])
                                              + 1 AS VARCHAR), 3) ,
                DateWeekID = CAST(DATEPART(yy,
                                           [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR),
                                   2) ,
                DateMonthID = CAST(DATEPART(yy,
                                            [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR),
                        2) ,
                DateQuarterID = CAST(DATEPART(yy,
                                              [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR) ,
                DateYearID = CAST(DATEPART(yy,
                                           [dbo].[ProsecutionCaseCaseClosure].[Date]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseCaseClosure];

        UPDATE  ProsecutionCaseCrimeType
        SET     PartyCrimeID = ProsecutionCaseCrimeTypeID;

        UPDATE  ProsecutionCaseDiagram
        SET     CountryID = ( SELECT    CountryID
                              FROM      dbo.C_Country
                              WHERE     Name = 'Rwanda'
                            )
        FROM    [dbo].[ProsecutionCaseDiagram];
	
	--UPDATE ProsecutionCaseEvidence
	--SET CountryID = (SELECT CountryID FROM dbo.C_Country WHERE Name = 'Rwanda')
	--FROM  [dbo].[ProsecutionCaseEvidence]
	
        UPDATE  [dbo].[ProsecutionCaseEvidence]
        SET     RecoveryDateDayID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseEvidence].[RecoveryDate])
                                              + 1 AS VARCHAR), 3) ,
                RecoveryDateWeekID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR),
                                   2) ,
                RecoveryDateMonthID = CAST(DATEPART(yy,
                                                    [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR),
                        2) ,
                RecoveryDateQuarterID = CAST(DATEPART(yy,
                                                      [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR) ,
                RecoveryDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCaseEvidence].[RecoveryDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseEvidence];
	
        UPDATE  [dbo].[ProsecutionCaseExpertRequest]
        SET     CopyDocumentAttachedDateYearID = CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseExpertRequest].[CopyDocumentAttachedDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseExpertRequest];
	
        UPDATE  [dbo].[ProsecutionCaseExpertRequest]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseExpertRequest].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseExpertRequest];
	
        UPDATE  [dbo].[ProsecutionCaseExpertRequest]
        SET     DocumentAttachedDateYearID = CAST(DATEPART(yy,
                                                           [dbo].[ProsecutionCaseExpertRequest].[DocumentAttachedDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseExpertRequest];
	
        UPDATE  [dbo].[ProsecutionCaseExpertRequest]
        SET     RequestDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseExpertRequest].[RequestDate])
                                              + 1 AS VARCHAR), 3) ,
                RequestDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR),
                                   2) ,
                RequestDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR),
                        2) ,
                RequestDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR) ,
                RequestDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseExpertRequest].[RequestDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseExpertRequest];
	
        UPDATE  [dbo].[ProsecutionCaseHandingStatement]
        SET     DateDayID = CAST(DATEPART(yy,
                                          [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseHandingStatement].[Date])
                                              + 1 AS VARCHAR), 3) ,
                DateWeekID = CAST(DATEPART(yy,
                                           [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR),
                                   2) ,
                DateMonthID = CAST(DATEPART(yy,
                                            [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR),
                        2) ,
                DateQuarterID = CAST(DATEPART(yy,
                                              [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR) ,
                DateYearID = CAST(DATEPART(yy,
                                           [dbo].[ProsecutionCaseHandingStatement].[Date]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseHandingStatement];
	
        UPDATE  [dbo].[ProsecutionCaseInternationalArrestWarrant]
        SET     IssueDateYearID = CAST(DATEPART(yy,
                                                [dbo].[ProsecutionCaseInternationalArrestWarrant].[IssueDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseInternationalArrestWarrant];
	
        UPDATE  [dbo].[ProsecutionCaseJustitiaStatement]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCaseJustitiaStatement].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseJustitiaStatement];
	
        UPDATE  [dbo].[ProsecutionCaseJustitiaStatement]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseJustitiaStatement].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseJustitiaStatement];
	
        UPDATE  [dbo].[ProsecutionCaseJustitiaStatement]
        SET     InterviewDateYearID = CAST(DATEPART(yy,
                                                    [dbo].[ProsecutionCaseJustitiaStatement].[InterviewDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseJustitiaStatement]; 
	
        UPDATE  [dbo].[ProsecutionCaseOffence]
        SET     DateDayID = CAST(DATEPART(yy,
                                          [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseOffence].[Date])
                                              + 1 AS VARCHAR), 3) ,
                DateWeekID = CAST(DATEPART(yy,
                                           [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR),
                                   2) ,
                DateMonthID = CAST(DATEPART(yy,
                                            [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR),
                        2) ,
                DateQuarterID = CAST(DATEPART(yy,
                                              [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR) ,
                DateYearID = CAST(DATEPART(yy,
                                           [dbo].[ProsecutionCaseOffence].[Date]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseOffence];
	
        UPDATE  [dbo].[ProsecutionCaseRelease]
        SET     DecisionDateDayID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseRelease].[DecisionDate])
                                              + 1 AS VARCHAR), 3) ,
                DecisionDateWeekID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR),
                                   2) ,
                DecisionDateMonthID = CAST(DATEPART(yy,
                                                    [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR),
                        2) ,
                DecisionDateQuarterID = CAST(DATEPART(yy,
                                                      [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR) ,
                DecisionDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[ProsecutionCaseRelease].[DecisionDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseRelease];
	
        UPDATE  [dbo].[ProsecutionCaseSearchWarrant]
        SET     IssueDateYearID = CAST(DATEPART(yy,
                                                [dbo].[ProsecutionCaseSearchWarrant].[IssueDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseSearchWarrant];
	
        UPDATE  [dbo].[ProsecutionCaseSeizedItemsRegister]
        SET     SellDateDayID = CAST(DATEPART(yy,
                                              [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate])
                                              + 1 AS VARCHAR), 3) ,
                SellDateWeekID = CAST(DATEPART(yy,
                                               [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR),
                                   2) ,
                SellDateMonthID = CAST(DATEPART(yy,
                                                [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR),
                        2) ,
                SellDateQuarterID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR) ,
                SellDateYearID = CAST(DATEPART(yy,
                                               [dbo].[ProsecutionCaseSeizedItemsRegister].[SellDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseSeizedItemsRegister];
	
        UPDATE  [dbo].[ProsecutionCaseSeizure]
        SET     DateDayID = CAST(DATEPART(yy,
                                          [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseSeizure].[Date])
                                              + 1 AS VARCHAR), 3) ,
                DateWeekID = CAST(DATEPART(yy,
                                           [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR),
                                   2) ,
                DateMonthID = CAST(DATEPART(yy,
                                            [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR),
                        2) ,
                DateQuarterID = CAST(DATEPART(yy,
                                              [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR) ,
                DateYearID = CAST(DATEPART(yy,
                                           [dbo].[ProsecutionCaseSeizure].[Date]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseSeizure];
	
        UPDATE  [dbo].[ProsecutionCaseWarrantToBring]
        SET     IssueDateYearID = CAST(DATEPART(yy,
                                                [dbo].[ProsecutionCaseWarrantToBring].[IssueDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseWarrantToBring];
	
        UPDATE  [dbo].[ProsecutionCaseWFAction]
        SET     [ProsecutionCaseWFAction].[ActionDateInDay] = CONVERT(DECIMAL(18,
                                                              2), [ProsecutionCaseWFAction].[ActionDate])
                - 42368.00 --= '2016-01-01 00:00'
        FROM    [dbo].[ProsecutionCaseWFAction]; 
	
        UPDATE  [dbo].[ProsecutionCaseWFAction]
        SET     ActionDateDayID = CAST(DATEPART(yy,
                                                [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[ProsecutionCaseWFAction].[ActionDate])
                                              + 1 AS VARCHAR), 3) ,
                ActionDateWeekID = CAST(DATEPART(yy,
                                                 [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) ,
                ActionDateMonthID = CAST(DATEPART(yy,
                                                  [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) ,
                ActionDateQuarterID = CAST(DATEPART(yy,
                                                    [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR) ,
                ActionDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[ProsecutionCaseWFAction].[ActionDate]) AS VARCHAR)
        FROM    [dbo].[ProsecutionCaseWFAction];
	
        UPDATE  [dbo].[C_Child]
        SET     BirthDateDayID = CAST(DATEPART(yy, [dbo].[C_Child].[BirthDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[C_Child].[BirthDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[C_Child].[BirthDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[C_Child].[BirthDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[C_Child].[BirthDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[C_Child].[BirthDate])
                                              + 1 AS VARCHAR), 3) ,
                BirthDateWeekID = CAST(DATEPART(yy,
                                                [dbo].[C_Child].[BirthDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[C_Child].[BirthDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[C_Child].[BirthDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[C_Child].[BirthDate]) AS VARCHAR),
                                   2) ,
                BirthDateMonthID = CAST(DATEPART(yy,
                                                 [dbo].[C_Child].[BirthDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[C_Child].[BirthDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[C_Child].[BirthDate]) AS VARCHAR),
                        2) ,
                BirthDateQuarterID = CAST(DATEPART(yy,
                                                   [dbo].[C_Child].[BirthDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[C_Child].[BirthDate]) AS VARCHAR) ,
                BirthDateYearID = CAST(DATEPART(yy,
                                                [dbo].[C_Child].[BirthDate]) AS VARCHAR)
        FROM    [dbo].[C_Child];   

        UPDATE  [dbo].[C_Land]
        SET     RegistrationDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[C_Land].[RegistrationDate]) AS VARCHAR)
        FROM    [dbo].[C_Land];

        UPDATE  [dbo].[C_Land]
        SET     RegistrationEndDateYearID = CAST(DATEPART(yy,
                                                          [dbo].[C_Land].[RegistrationEndDate]) AS VARCHAR)
        FROM    [dbo].[C_Land];

        UPDATE  [dbo].[C_Vehicle]
        SET     AcquisitionDateYearID = CAST(DATEPART(yy,
                                                      [dbo].[C_Vehicle].[AcquisitionDate]) AS VARCHAR)
        FROM    [dbo].[C_Vehicle];

        UPDATE  [dbo].[C_Vehicle]
        SET     ConsumptionDateYearID = CAST(DATEPART(yy,
                                                      [dbo].[C_Vehicle].[ConsumptionDate]) AS VARCHAR)
        FROM    [dbo].[C_Vehicle];

        UPDATE  [dbo].[C_Vehicle]
        SET     RegistrationDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[C_Vehicle].[RegistrationDate]) AS VARCHAR)
        FROM    [dbo].[C_Vehicle];

        UPDATE  [dbo].[Document]
        SET     UploadDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[Document].[UploadDate]) AS VARCHAR)
        FROM    [dbo].[Document];

        TRUNCATE TABLE dbo.LitigationCaseWFState;
        INSERT  INTO dbo.LitigationCaseWFState
                ( LitigationCaseID ,
                  WFStateID
                )
                SELECT  LitigationCaseID ,
                        WFStateID
                FROM    dbo.LitigationCase;

        UPDATE  [dbo].[LitigationCase]
        SET     CaseFiledDateDayID = CAST(DATEPART(yy,
                                                   [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[LitigationCase].[CaseFiledDate])
                                              + 1 AS VARCHAR), 3) ,
                CaseFiledDateWeekID = CAST(DATEPART(yy,
                                                    [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR),
                                   2) ,
                CaseFiledDateMonthID = CAST(DATEPART(yy,
                                                     [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR),
                        2) ,
                CaseFiledDateQuarterID = CAST(DATEPART(yy,
                                                       [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR) ,
                CaseFiledDateYearID = CAST(DATEPART(yy,
                                                    [dbo].[LitigationCase].[CaseFiledDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCase];

        UPDATE  [dbo].[LitigationCase]
        SET     CaseSubmittedDateYearID = CAST(DATEPART(yy,
                                                        [dbo].[LitigationCase].[CaseSubmittedDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCase];

        UPDATE  [dbo].[LitigationCase]
        SET     DateCreatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCase].[DateCreated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[LitigationCase].[DateCreated])
                                              + 1 AS VARCHAR), 3) ,
                DateCreatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCase].[DateCreated]) AS VARCHAR),
                                   2) ,
                DateCreatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[DateCreated]) AS VARCHAR),
                        2) ,
                DateCreatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[DateCreated]) AS VARCHAR) ,
                DateCreatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCase].[DateCreated]) AS VARCHAR)
        FROM    [dbo].[LitigationCase];

        UPDATE  [dbo].[LitigationCase]
        SET     DateUpdatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[LitigationCase].[DateUpdated])
                                              + 1 AS VARCHAR), 3) ,
                DateUpdatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR),
                                   2) ,
                DateUpdatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR),
                        2) ,
                DateUpdatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR) ,
                DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCase].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[LitigationCase];

        UPDATE  [dbo].[LitigationCase]
        SET     RequestAttachedDateYearID = CAST(DATEPART(yy,
                                                          [dbo].[LitigationCase].[RequestAttachedDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCase];

        UPDATE  [dbo].[LitigationCase]
        SET     RequestIssueDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[LitigationCase].[RequestIssueDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCase];

        UPDATE  [dbo].[LitigationCaseAmount]
        SET     CreatedDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[LitigationCaseAmount].[CreatedDate])
                                              + 1 AS VARCHAR), 3) ,
                CreatedDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR),
                                   2) ,
                CreatedDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR),
                        2) ,
                CreatedDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR) ,
                CreatedDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseAmount].[CreatedDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCaseAmount];

        UPDATE  [dbo].[LitigationCaseMeetingMinute]
        SET     MeetingDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[LitigationCaseMeetingMinute].[MeetingDate])
                                              + 1 AS VARCHAR), 3) ,
                MeetingDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR),
                                   2) ,
                MeetingDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR),
                        2) ,
                MeetingDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR) ,
                MeetingDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseMeetingMinute].[MeetingDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCaseMeetingMinute];

        UPDATE  [dbo].[LitigationCaseRecommendation]
        SET     CreatedDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[LitigationCaseRecommendation].[CreatedDate])
                                              + 1 AS VARCHAR), 3) ,
                CreatedDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR),
                                   2) ,
                CreatedDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR),
                        2) ,
                CreatedDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR) ,
                CreatedDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseRecommendation].[CreatedDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCaseRecommendation];

        UPDATE  [dbo].[LitigationCaseSchedule]
        SET     HearingDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[LitigationCaseSchedule].[HearingDate])
                                              + 1 AS VARCHAR), 3) ,
                HearingDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR),
                                   2) ,
                HearingDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR),
                        2) ,
                HearingDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR) ,
                HearingDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseSchedule].[HearingDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCaseSchedule];

        UPDATE  [dbo].[LitigationCaseWFAction]
        SET     [LitigationCaseWFAction].[ActionDateInDay] = CONVERT(DECIMAL(18,
                                                              2), [LitigationCaseWFAction].[ActionDate])
                - 42368.00 --= '2016-01-01 00:00'
        FROM    [dbo].[LitigationCaseWFAction]; 

        UPDATE  [dbo].[LitigationCaseWFAction]
        SET     ActionDateDayID = CAST(DATEPART(yy,
                                                [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[LitigationCaseWFAction].[ActionDate])
                                              + 1 AS VARCHAR), 3) ,
                ActionDateWeekID = CAST(DATEPART(yy,
                                                 [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) ,
                ActionDateMonthID = CAST(DATEPART(yy,
                                                  [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) ,
                ActionDateQuarterID = CAST(DATEPART(yy,
                                                    [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR) ,
                ActionDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[LitigationCaseWFAction].[ActionDate]) AS VARCHAR)
        FROM    [dbo].[LitigationCaseWFAction];

        UPDATE  [dbo].[Party]
        SET     BirthDateDayID = CAST(DATEPART(yy, [dbo].[Party].[BirthDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[BirthDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[BirthDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[Party].[BirthDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[Party].[BirthDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[Party].[BirthDate])
                                              + 1 AS VARCHAR), 3) ,
                BirthDateWeekID = CAST(DATEPART(yy, [dbo].[Party].[BirthDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[BirthDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[BirthDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[Party].[BirthDate]) AS VARCHAR),
                                   2) ,
                BirthDateMonthID = CAST(DATEPART(yy, [dbo].[Party].[BirthDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[BirthDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[BirthDate]) AS VARCHAR),
                        2) ,
                BirthDateQuarterID = CAST(DATEPART(yy,
                                                   [dbo].[Party].[BirthDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[BirthDate]) AS VARCHAR) ,
                BirthDateYearID = CAST(DATEPART(yy, [dbo].[Party].[BirthDate]) AS VARCHAR)
        FROM    [dbo].[Party];

        UPDATE  [dbo].[Party]
        SET     BusinessStartDateYearID = CAST(DATEPART(yy,
                                                        [dbo].[Party].[BusinessStartDate]) AS VARCHAR)
        FROM    [dbo].[Party];

        UPDATE  [dbo].[Party]
        SET     DateCreatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[Party].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[Party].[DateCreated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[Party].[DateCreated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[Party].[DateCreated])
                                              + 1 AS VARCHAR), 3) ,
                DateCreatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[Party].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[Party].[DateCreated]) AS VARCHAR),
                                   2) ,
                DateCreatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[Party].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[DateCreated]) AS VARCHAR),
                        2) ,
                DateCreatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[Party].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[DateCreated]) AS VARCHAR) ,
                DateCreatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[Party].[DateCreated]) AS VARCHAR)
        FROM    [dbo].[Party];

        UPDATE  [dbo].[Party]
        SET     DateUpdatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[Party].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[Party].[DateUpdated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[Party].[DateUpdated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[Party].[DateUpdated])
                                              + 1 AS VARCHAR), 3) ,
                DateUpdatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[Party].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[Party].[DateUpdated]) AS VARCHAR),
                                   2) ,
                DateUpdatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[Party].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[Party].[DateUpdated]) AS VARCHAR),
                        2) ,
                DateUpdatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[Party].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[Party].[DateUpdated]) AS VARCHAR) ,
                DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[Party].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[Party];

        UPDATE  [dbo].[Party]
        SET     EmploymentDateYearID = CAST(DATEPART(yy,
                                                     [dbo].[Party].[EmploymentDate]) AS VARCHAR)
        FROM    [dbo].[Party];

        UPDATE  [dbo].[PartyComment]
        SET     CreatedDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PartyComment].[CreatedDate]) AS VARCHAR)
        FROM    [dbo].[PartyComment];

        UPDATE  [dbo].[PartyEmployment]
        SET     EmploymentEndDateYearID = CAST(DATEPART(yy,
                                                        [dbo].[PartyEmployment].[EmploymentEndDate]) AS VARCHAR)
        FROM    [dbo].[PartyEmployment];

        UPDATE  [dbo].[PartyEmployment]
        SET     EmploymentStartDateYearID = CAST(DATEPART(yy,
                                                          [dbo].[PartyEmployment].[EmploymentStartDate]) AS VARCHAR)
        FROM    [dbo].[PartyEmployment];

        TRUNCATE TABLE dbo.PoliceCaseWFState;
        INSERT  INTO dbo.PoliceCaseWFState
                ( PoliceCaseID ,
                  WFStateID
                )
                SELECT  PoliceCaseID ,
                        WFStateID
                FROM    dbo.PoliceCase;
	
        UPDATE  [dbo].[PoliceCase]
        SET     CaseOpenedDateDayID = CAST(DATEPART(yy,
                                                    [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCase].[CaseOpenedDate])
                                              + 1 AS VARCHAR), 3) ,
                CaseOpenedDateWeekID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR),
                                   2) ,
                CaseOpenedDateMonthID = CAST(DATEPART(yy,
                                                      [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR),
                        2) ,
                CaseOpenedDateQuarterID = CAST(DATEPART(yy,
                                                        [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR) ,
                CaseOpenedDateYearID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCase].[CaseOpenedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCase];

        UPDATE  [dbo].[PoliceCase]
        SET     ComplaintFiledDateDayID = CAST(DATEPART(yy,
                                                        [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCase].[ComplaintFiledDate])
                                              + 1 AS VARCHAR), 3) ,
                ComplaintFiledDateWeekID = CAST(DATEPART(yy,
                                                         [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR),
                                   2) ,
                ComplaintFiledDateMonthID = CAST(DATEPART(yy,
                                                          [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR),
                        2) ,
                ComplaintFiledDateQuarterID = CAST(DATEPART(yy,
                                                            [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR) ,
                ComplaintFiledDateYearID = CAST(DATEPART(yy,
                                                         [dbo].[PoliceCase].[ComplaintFiledDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCase];

        UPDATE  [dbo].[PoliceCase]
        SET     ComplaintReceivedDateDayID = CAST(DATEPART(yy,
                                                           [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCase].[ComplaintReceivedDate])
                                              + 1 AS VARCHAR), 3) ,
                ComplaintReceivedDateWeekID = CAST(DATEPART(yy,
                                                            [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR),
                                   2) ,
                ComplaintReceivedDateMonthID = CAST(DATEPART(yy,
                                                             [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR),
                        2) ,
                ComplaintReceivedDateQuarterID = CAST(DATEPART(yy,
                                                              [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR) ,
                ComplaintReceivedDateYearID = CAST(DATEPART(yy,
                                                            [dbo].[PoliceCase].[ComplaintReceivedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCase];

        UPDATE  [dbo].[PoliceCase]
        SET     DateCreatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCase].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[DateCreated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCase].[DateCreated])
                                              + 1 AS VARCHAR), 3) ,
                DateCreatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCase].[DateCreated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[DateCreated]) AS VARCHAR),
                                   2) ,
                DateCreatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCase].[DateCreated]) AS VARCHAR),
                        2) ,
                DateCreatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[DateCreated]) AS VARCHAR) ,
                DateCreatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCase].[DateCreated]) AS VARCHAR)
        FROM    [dbo].[PoliceCase];

        UPDATE  [dbo].[PoliceCase]
        SET     DateUpdatedDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCase].[DateUpdated])
                                              + 1 AS VARCHAR), 3) ,
                DateUpdatedWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR),
                                   2) ,
                DateUpdatedMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR),
                        2) ,
                DateUpdatedQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR) ,
                DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCase].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCase];

        UPDATE  [dbo].[PoliceCaseArrest]
        SET     ArrestDateDayID = CAST(DATEPART(yy,
                                                [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseArrest].[ArrestDate])
                                              + 1 AS VARCHAR), 3) ,
                ArrestDateWeekID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR),
                                   2) ,
                ArrestDateMonthID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR),
                        2) ,
                ArrestDateQuarterID = CAST(DATEPART(yy,
                                                    [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR) ,
                ArrestDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseArrest].[ArrestDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseArrest];

        UPDATE  [dbo].[PoliceCaseArrest]
        SET     ArrestStatementDateYearID = CAST(DATEPART(yy,
                                                          [dbo].[PoliceCaseArrest].[ArrestStatementDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseArrest];

        UPDATE  [dbo].[PoliceCaseArrest]
        SET     ArrestWarrantAttachedDateYearID = CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseArrest].[ArrestWarrantAttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseArrest];

        UPDATE  [dbo].[PoliceCaseArrest]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseArrest].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseArrest];

        UPDATE  [dbo].[PoliceCaseArrest]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseArrest].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseArrest];

        UPDATE  [dbo].[PoliceCaseComment]
        SET     CreatedDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseComment].[CreatedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseComment];

    --UPDATE  PoliceCaseConstatation
    --SET     CountryID = ( SELECT    CountryID
    --                      FROM      dbo.C_Country
    --                      WHERE     Name = 'Rwanda'
    --                    )
    --FROM    [dbo].[PoliceCaseConstatation];

        UPDATE  [dbo].[PoliceCaseConstatation]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseConstatation].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseConstatation];

        UPDATE  [dbo].[PoliceCaseConstatation]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseConstatation].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseConstatation];

        UPDATE  [dbo].[PoliceCaseConstatation]
        SET     SubmissionDateYearID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseConstatation].[SubmissionDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseConstatation];

        UPDATE  PoliceCaseCrimeType
        SET     PartyCrimeID = PoliceCaseCrimeTypeID;

        UPDATE  PoliceCaseDiagram
        SET     CountryID = ( SELECT    CountryID
                              FROM      dbo.C_Country
                              WHERE     Name = 'Rwanda'
                            )
        FROM    [dbo].[PoliceCaseDiagram];

        UPDATE  [dbo].[PoliceCaseDiagram]
        SET     DiagramDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseDiagram].[DiagramDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseDiagram];
	
        UPDATE  [dbo].[PoliceCaseEquipmentIssued]
        SET     CreatedDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseEquipmentIssued].[CreatedDate])
                                              + 1 AS VARCHAR), 3) ,
                CreatedDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR),
                                   2) ,
                CreatedDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR),
                        2) ,
                CreatedDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR) ,
                CreatedDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseEquipmentIssued].[CreatedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseEquipmentIssued];

        UPDATE  [dbo].[PoliceCaseEquipmentUsed]
        SET     CreatedDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseEquipmentUsed].[CreatedDate])
                                              + 1 AS VARCHAR), 3) ,
                CreatedDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR),
                                   2) ,
                CreatedDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR),
                        2) ,
                CreatedDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR) ,
                CreatedDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseEquipmentUsed].[CreatedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseEquipmentUsed];

    --UPDATE  PoliceCaseEvidence
    --SET     CountryID = ( SELECT    CountryID
    --                      FROM      dbo.C_Country
    --                      WHERE     Name = 'Rwanda'
    --                    )
    --FROM    [dbo].[PoliceCaseEvidence]

        UPDATE  [dbo].[PoliceCaseEvidence]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseEvidence].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseEvidence];

        UPDATE  [dbo].[PoliceCaseEvidence]
        SET     RecoveryDateDayID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseEvidence].[RecoveryDate])
                                              + 1 AS VARCHAR), 3) ,
                RecoveryDateWeekID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR),
                                   2) ,
                RecoveryDateMonthID = CAST(DATEPART(yy,
                                                    [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR),
                        2) ,
                RecoveryDateQuarterID = CAST(DATEPART(yy,
                                                      [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR) ,
                RecoveryDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseEvidence].[RecoveryDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseEvidence];

        UPDATE  [dbo].[PoliceCaseExpertRequest]
        SET     CopyDocumentAttachedDateYearID = CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseExpertRequest].[CopyDocumentAttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseExpertRequest];

        UPDATE  [dbo].[PoliceCaseExpertRequest]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseExpertRequest].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseExpertRequest];

        UPDATE  [dbo].[PoliceCaseExpertRequest]
        SET     DocumentAttachedDateYearID = CAST(DATEPART(yy,
                                                           [dbo].[PoliceCaseExpertRequest].[DocumentAttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseExpertRequest];

        UPDATE  [dbo].[PoliceCaseExpertRequest]
        SET     RequestDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseExpertRequest].[RequestDate])
                                              + 1 AS VARCHAR), 3) ,
                RequestDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR),
                                   2) ,
                RequestDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR),
                        2) ,
                RequestDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR) ,
                RequestDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseExpertRequest].[RequestDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseExpertRequest];

        UPDATE  [dbo].[PoliceCaseFileInformation]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseFileInformation].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseFileInformation];

        UPDATE  [dbo].[PoliceCaseFileInformation]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseFileInformation].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseFileInformation];

        UPDATE  [dbo].[PoliceCaseFileInformation]
        SET     StatementDateYearID = CAST(DATEPART(yy,
                                                    [dbo].[PoliceCaseFileInformation].[StatementDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseFileInformation];

        UPDATE  [dbo].[PoliceCaseFileInformation]
        SET     SubmissionDateYearID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseFileInformation].[SubmissionDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseFileInformation];

        UPDATE  [dbo].[PoliceCaseJustitiaStatement]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseJustitiaStatement].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseJustitiaStatement];

        UPDATE  [dbo].[PoliceCaseJustitiaStatement]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseJustitiaStatement].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseJustitiaStatement];

        UPDATE  [dbo].[PoliceCaseJustitiaStatement]
        SET     InterviewDateYearID = CAST(DATEPART(yy,
                                                    [dbo].[PoliceCaseJustitiaStatement].[InterviewDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseJustitiaStatement];

        UPDATE  [dbo].[PoliceCaseOffence]
        SET     DateDayID = CAST(DATEPART(yy, [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseOffence].[Date])
                                              + 1 AS VARCHAR), 3) ,
                DateWeekID = CAST(DATEPART(yy,
                                           [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR),
                                   2) ,
                DateMonthID = CAST(DATEPART(yy,
                                            [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR),
                        2) ,
                DateQuarterID = CAST(DATEPART(yy,
                                              [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR) ,
                DateYearID = CAST(DATEPART(yy,
                                           [dbo].[PoliceCaseOffence].[Date]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseOffence];

        UPDATE  [dbo].[PoliceCasePersonalEffect]
        SET     PersonalItemDateDayID = CAST(DATEPART(yy,
                                                      [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCasePersonalEffect].[PersonalItemDate])
                                              + 1 AS VARCHAR), 3) ,
                PersonalItemDateWeekID = CAST(DATEPART(yy,
                                                       [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR),
                                   2) ,
                PersonalItemDateMonthID = CAST(DATEPART(yy,
                                                        [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR),
                        2) ,
                PersonalItemDateQuarterID = CAST(DATEPART(yy,
                                                          [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR) ,
                PersonalItemDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[PoliceCasePersonalEffect].[PersonalItemDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCasePersonalEffect];

        UPDATE  [dbo].[PoliceCaseRelease]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseRelease].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseRelease];

        UPDATE  [dbo].[PoliceCaseRelease]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseRelease].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseRelease];

        UPDATE  [dbo].[PoliceCaseRelease]
        SET     DetainedFromYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseRelease].[DetainedFrom]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseRelease];

        UPDATE  [dbo].[PoliceCaseRelease]
        SET     DetainedToYearID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseRelease].[DetainedTo]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseRelease];

        UPDATE  [dbo].[PoliceCaseRelease]
        SET     ReleaseDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseRelease].[ReleaseDate])
                                              + 1 AS VARCHAR), 3) ,
                ReleaseDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                                   2) ,
                ReleaseDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                        2) ,
                ReleaseDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR) ,
                ReleaseDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseRelease];

        UPDATE  [dbo].[PoliceCaseRelease]
        SET     ReleaseDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseRelease].[ReleaseDate])
                                              + 1 AS VARCHAR), 3) ,
                ReleaseDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                                   2) ,
                ReleaseDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR),
                        2) ,
                ReleaseDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR) ,
                ReleaseDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseRelease].[ReleaseDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseRelease];

        UPDATE  [dbo].[PoliceCaseRelease]
        SET     StatementDateYearID = CAST(DATEPART(yy,
                                                    [dbo].[PoliceCaseRelease].[StatementDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseRelease];

        UPDATE  [dbo].[PoliceCaseReturnEffect]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseReturnEffect].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseReturnEffect];

        UPDATE  [dbo].[PoliceCaseReturnEffect]
        SET     ReturnDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseReturnEffect].[ReturnDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseReturnEffect];

        UPDATE  [dbo].[PoliceCaseReturnEffect]
        SET     StatementSigningDateYearID = CAST(DATEPART(yy,
                                                           [dbo].[PoliceCaseReturnEffect].[StatementSigningDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseReturnEffect];

        UPDATE  [dbo].[PoliceCaseSeizure]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseSeizure].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseSeizure];

        UPDATE  [dbo].[PoliceCaseSeizure]
        SET     DateDayID = CAST(DATEPART(yy, [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseSeizure].[Date])
                                              + 1 AS VARCHAR), 3) ,
                DateWeekID = CAST(DATEPART(yy,
                                           [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR),
                                   2) ,
                DateMonthID = CAST(DATEPART(yy,
                                            [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm, [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR),
                        2) ,
                DateQuarterID = CAST(DATEPART(yy,
                                              [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR) ,
                DateYearID = CAST(DATEPART(yy,
                                           [dbo].[PoliceCaseSeizure].[Date]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseSeizure];

        UPDATE  [dbo].[PoliceCaseSeizure]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseSeizure].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseSeizure];

        UPDATE  [dbo].[PoliceCaseSummon]
        SET     AppearDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseSummon].[AppearDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseSummon];

        UPDATE  [dbo].[PoliceCaseSummon]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseSummon].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseSummon];

        UPDATE  [dbo].[PoliceCaseSummon]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseSummon].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseSummon];

        UPDATE  [dbo].[PoliceCaseSummon]
        SET     SummonIssueDateYearID = CAST(DATEPART(yy,
                                                      [dbo].[PoliceCaseSummon].[SummonIssueDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseSummon];

        UPDATE  [dbo].[PoliceCaseTeamMember]
        SET     CreatedDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseTeamMember].[CreatedDate])
                                              + 1 AS VARCHAR), 3) ,
                CreatedDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR),
                                   2) ,
                CreatedDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR),
                        2) ,
                CreatedDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR) ,
                CreatedDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseTeamMember].[CreatedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseTeamMember];

        UPDATE  [dbo].[PoliceCaseVehicleUsed]
        SET     CreatedDateDayID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseVehicleUsed].[CreatedDate])
                                              + 1 AS VARCHAR), 3) ,
                CreatedDateWeekID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR),
                                   2) ,
                CreatedDateMonthID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR),
                        2) ,
                CreatedDateQuarterID = CAST(DATEPART(yy,
                                                     [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR) ,
                CreatedDateYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseVehicleUsed].[CreatedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseVehicleUsed];

        UPDATE  [dbo].[PoliceCaseWarrant]
        SET     AttachedDateYearID = CAST(DATEPART(yy,
                                                   [dbo].[PoliceCaseWarrant].[AttachedDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseWarrant];

        UPDATE  [dbo].[PoliceCaseWarrant]
        SET     DateUpdatedYearID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseWarrant].[DateUpdated]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseWarrant];

        UPDATE  [dbo].[PoliceCaseWarrant]
        SET     WarrantIssueDateDayID = CAST(DATEPART(yy,
                                                      [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseWarrant].[WarrantIssueDate])
                                              + 1 AS VARCHAR), 3) ,
                WarrantIssueDateWeekID = CAST(DATEPART(yy,
                                                       [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR),
                                   2) ,
                WarrantIssueDateMonthID = CAST(DATEPART(yy,
                                                        [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR),
                        2) ,
                WarrantIssueDateQuarterID = CAST(DATEPART(yy,
                                                          [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
                + CAST(DATEPART(qq,
                                [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR) ,
                WarrantIssueDateYearID = CAST(DATEPART(yy,
                                                       [dbo].[PoliceCaseWarrant].[WarrantIssueDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseWarrant];

        UPDATE  [dbo].[PoliceCaseWFAction]
        SET     [PoliceCaseWFAction].[ActionDateInDay] = CONVERT(DECIMAL(18, 2), [PoliceCaseWFAction].[ActionDate])
                - 42368.00 --= '2016-01-01 00:00'
        FROM    [dbo].[PoliceCaseWFAction];

        UPDATE  [dbo].[PoliceCaseWFAction]
        SET     ActionDateDayID = CAST(DATEPART(yy,
                                                [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) + RIGHT('000'
                                              + CAST(DATEDIFF(dd,
                                                              CAST(DATEPART(yy,
                                                              [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
                                                              + '-01-01',
                                                              [dbo].[PoliceCaseWFAction].[ActionDate])
                                              + 1 AS VARCHAR), 3) ,
                ActionDateWeekID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) + RIGHT('0'
                                   + CAST(DATEPART(wk,
                                                   [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR),
                                   2) ,
                ActionDateMonthID = CAST(DATEPART(yy,
                                                  [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
                + RIGHT('0'
                        + CAST(DATEPART(mm,
                                        [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR),
                        2) ,
                ActionDateQuarterID = CAST(DATEPART(yy,
                                                    [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
                + CAST(DATEPART(qq, [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR) ,
                ActionDateYearID = CAST(DATEPART(yy,
                                                 [dbo].[PoliceCaseWFAction].[ActionDate]) AS VARCHAR)
        FROM    [dbo].[PoliceCaseWFAction];

        TRUNCATE TABLE dbo.TaskWFState;
        INSERT  INTO dbo.TaskWFState
                ( TaskID ,
                  WFStateID
                )
                SELECT  TaskID ,
                        WFStateID
                FROM    dbo.Task;
    END;
GO
