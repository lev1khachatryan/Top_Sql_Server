-- change data and KB db names befor executing


USE [DEV-RWA_IECMS-DATA_Live_20180801]
DECLARE @CopyuserID INT, @RoleID INT , @RoleName NVARCHAR(500), @FirstName NVARCHAR(500), @LastName NVARCHAR(500), @userLoginName NVARCHAR(500)

CREATE TABLE #groupUserRoles (UserID INT, roleID INT, groupid INT)
; WITH  groupUserRoles AS (
SELECT MAX(C_User.UserID) AS UserID, RoleID, GroupID
FROM dbo.C_User
JOIN dbo.UserRole ON UserRole.UserID = C_User.UserID
JOIN dbo.C_UserGroup ON C_UserGroup.UserID = C_User.UserID
GROUP BY RoleID, GroupID
)
INSERT INTO #groupUserRoles
        ( UserID, roleID, groupid )
SELECT *
FROM groupUserRoles
--DECLARE v_curs CURSOR FOR 


--SELECT #groupUserRoles.UserID, #groupUserRoles.roleID, C_Role.Name, u.FirstName, u.LastName, u.Username
--FROM ARTASH.dbo._Users u
--JOIN dbo.C_Role ON u.Role = C_Role.Name
--JOIN dbo.C_Group ON u.[Group] = C_Group.Name
--LEFT JOIN #groupUserRoles ON #groupUserRoles.GroupID = C_Group.GroupID AND #groupUserRoles.RoleID = C_Role.RoleID

SELECT  @CopyuserID = sub.UserID ,
        @RoleID = sub.roleID ,
        @RoleName = sub.Name ,
        @FirstName = 'Babken' ,
        @LastName = 'All' ,
        @userLoginName = 'BabkenAll'
FROM    ( SELECT  TOP(1)  #groupUserRoles.UserID ,
                    #groupUserRoles.roleID ,
                    C_Role.Name ,
                    u.FirstName ,
                    u.LastName ,
                    u.Username
          FROM      ARTASH.dbo._Users u
                    JOIN dbo.C_Role ON u.Role = C_Role.Name
                    JOIN dbo.C_Group ON u.[Group] = C_Group.Name
                    LEFT JOIN #groupUserRoles ON #groupUserRoles.groupid = C_Group.GroupID
                                                 AND #groupUserRoles.roleID = C_Role.RoleID
		WHERE C_Group.GroupID = 1000084
        ) as sub

--OPEN v_curs
--FETCH NEXT FROM v_curs INTO @CopyuserID, @RoleID, @RoleName, @FirstName, @LastName, @userLoginName
--WHILE @@FETCH_STATUS = 0
--BEGIN
	USE [DEV-RWA_IECMS-KB_Live_20180801]

SET XACT_ABORT ON 
DECLARE @UserCount INT 
--DECLARE @UserStartIndexID INT
DECLARE @CopyFromUserID INT  = @CopyuserID
--DECLARE @prefix VARCHAR(20)
/* HOW MANY USERS YOU WANT TO CREATE? */
--SET @UserStartIndexID = 4101
 --The index from which will start the users (e.g. if user index = 6 and user count = 10 the 10 users will be created, user6, user7... user16)
SET @UserCount = 1
--SET @prefix = 'Public'--'' --'Public' --'Police' -- 'Court' --


/**
* Desc:   This procedure is intended for dynamically creating users.
		  Created users will be used for performance automatic tests.
		  The ['user + $user-index$] as clogin name and '1' as password are used for creating the users (e.g. user1 | 1, user2 | 1) .
		  Procedure uses the transaction and in any fail rolling back the changes.
		  
*/


DECLARE @UserID INT
DECLARE @UserLogin VARCHAR(50)
DECLARE @Password VARCHAR(255)
DECLARE @Salt VARCHAR(255)
DECLARE @UserTopIndex INT
--DECLARE @UserGUID UNIQUEIDENTIFIER
SET @UserTopIndex = @UserCount

SET @Password = N'b0b5deb00d5e9bc6d62333cf1ed45911bfbd73db'
SET @Salt = N'394c8bb8-01c4-48e1-ab5b-545bfa9d8b55' 


BEGIN TRY
    BEGIN TRANSACTION 
    PRINT N'Starting transaction...'
		
    PRINT N' Create cycle'		
    --WHILE ( @UserTopIndex <= @UserCount )
    --    BEGIN
			IF NOT EXISTS(SELECT 1 FROM dbo.um_UserNetworks WHERE UserLogin = @userLoginName)
			BEGIN 
            INSERT  INTO dbo.[um_Users]
                    ( [UserStatusID] )
            VALUES  ( 1 )
            SELECT  @UserID = SCOPE_IDENTITY()


            SET @UserLogin = @userLoginName

            --SET @UserGUID = ( SELECT    UserGUID
            --                  FROM      dbo.um_Users
            --                  WHERE     UserID = @UserID
            --                )

            INSERT  INTO um_UserNetworks
                    ( UserID ,
                      NetworkID ,
                      UserLogin ,
                      IsEnabled
                    )
            VALUES  ( @UserID ,
                      1 ,
                      @UserLogin ,
                      1
                    )


            INSERT  INTO um_UserData
                    ( [UserID] ,
                      [Psw] ,
                      [PswSalt] ,
                      [PswQuestion] ,
                      [PswAnswer] ,
                      [CreateDate] ,
                      PermissionsUpdatedOn
					  ,LastPasswordChangeDate
                    )
            VALUES  ( @UserID ,
                      @Password ,
                      @Salt ,
                      N'question' ,
                      N'answer' ,
                      GETDATE() ,
                      GETDATE()
					  ,GETDATE()
                    )

            INSERT  INTO um_UserProfile
                    ( [UserID] ,
                      [FirstName] ,
                      [LastName] ,
                      [UserEmail] ,
                      [DefaultLanguageID]
                    )
            VALUES  ( @UserID ,
                      @FirstName ,
                      @LastName,
                      @UserLogin + N'@arm.synisys.com' ,
                      3
                    )
            INSERT  INTO um_UsersRoles
                    ( UserID, RoleID )
			--SELECT @UserID, RoleID
			--FROM dbo.um_UsersRoles
			--WHERE UserID = @CopyFromUserID
			--UNION
			SELECT @UserID,16
			UNION
			SELECT @UserID,17
			UNION
			SELECT @UserID,20
			UNION
			SELECT @UserID,21
			UNION
			SELECT @UserID,-3

            INSERT  INTO dbo.um_GroupsUsers
                    ( GroupID, UserID )
            SELECT GroupID, @UserID
			FROM dbo.um_GroupsUsers
			WHERE UserID = @CopyFromUserID


            INSERT  INTO dbo.um_PermissionDirectoryUsers
                    ( PermissionID ,
                      ItemID ,
                      ValueID ,
                      UserID
                    )
                    SELECT  PermissionID ,
                            ItemID ,
                            ValueID ,
                            @UserID
                    FROM    dbo.um_PermissionDirectoryUsers
                    WHERE   UserID = @CopyFromUserID

						  
            INSERT  INTO um_PasswordHistory
                    ( [UserID], [Password] )
            VALUES  ( @UserID, @Password )

            
            --SET IDENTITY_INSERT [DEV-RWA_IECMS-DATA_Live_20180801].dbo.C_User ON 
			     
            INSERT  INTO [DEV-RWA_IECMS-DATA_Live_20180801].dbo.C_User
                    ( UserID ,
                      Name_ENG ,
                      --UserGUID ,
                      UserInitials ,
                      PassportID ,
                      Email ,
                      IsDeleted ,
                      Passport
				    )
            VALUES  ( @UserID ,
                      @FirstName + ' ' + @LastName,
                      --@UserGUID ,
                      NULL ,
                      NULL ,
                      @UserLogin + N'@arm.synisys.com' ,
                      0 ,
                      NULL  
				    )
			

            --SET IDENTITY_INSERT [DEV-RWA_IECMS-DATA_Live_20180801].dbo.C_User OFF


            INSERT  [DEV-RWA_IECMS-DATA_Live_20180801].dbo.C_UserGroup
                    ( UserID, GroupID )
			SELECT @UserID , GroupID
			FROM [DEV-RWA_IECMS-DATA_Live_20180801].dbo.C_UserGroup
			WHERE UserID = @CopyFromUserID

            INSERT  [DEV-RWA_IECMS-DATA_Live_20180801].dbo.UserRole
                    ( UserID, RoleID )
			--SELECT @UserID , RoleID
			--FROM [DEV-RWA_IECMS-DATA_Live_20180801].dbo.UserRole
			--WHERE UserID = @CopyFromUserID
			SELECT @UserID,16
			UNION
			SELECT @UserID,17
			UNION
			SELECT @UserID,20
			UNION
			SELECT @UserID,21
			UNION
			SELECT @UserID,-3

			PRINT N'Finish. ' + CAST(@UserCount AS VARCHAR)
        + ' users are successfully created'
			END
			SET @UserTopIndex = @UserTopIndex + 1
        --END
    PRINT N' Commiting transaction...'
    COMMIT TRANSACTION    
END TRY 

BEGIN CATCH
    SELECT  ERROR_NUMBER() AS ErrorNum ,
            ERROR_MESSAGE() AS ErrorMessage
    PRINT N'Exception thrown, rolling back transaction.'
    ROLLBACK TRANSACTION
    PRINT N'Transaction rolled back.' 
END CATCH
--    FETCH NEXT FROM v_curs INTO @CopyuserID, @RoleID, @RoleName, @FirstName, @LastName, @userLoginName
--END
--CLOSE v_curs
--DEALLOCATE v_curs
