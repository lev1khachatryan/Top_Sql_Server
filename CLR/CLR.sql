-- This comment was added fօr merge
--sp_configure 'clr enabled'
ALTER DATABASE [ddxk]
SET TRUSTWORTHY ON

--nax directoryov sarqeci ,
--heto

--SELECT 
-- af.name,
-- af.content 
--FROM sys.assemblies a
--INNER JOIN sys.assembly_files af ON a.assembly_id = af.assembly_id 

--dra contenty  henc hex akan codena


CREATE ASSEMBLY Point
--AUTHORIZATION dbo
--FROM '\\sis2s082\BACKUP_E\Point.dll'
FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C010300FC1E785A0000000000000000E00022200B013000000E000000060000000000004A2D0000002000000040000000000010002000000002000004000000000000000600000000000000008000000002000000000000030060850000100000100000000010000010000000000000100000000000000000000000F82C00004F000000004000005803000000000000000000000000000000000000006000000C000000C02B00001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E74657874000000500D000000200000000E000000020000000000000000000000000000200000602E7273726300000058030000004000000004000000100000000000000000000000000000400000402E72656C6F6300000C00000000600000000200000014000000000000000000000000000040000042000000000000000000000000000000002C2D0000000000004800000002000500442200007C0900000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000133001000C0000000100001100027B010000040A2B00062A133002001700000002000011001200FE15020000021200177D01000004060B2B00072A00133002004B00000003000011000228010000060A062C0872010000700B2B3600731000000A0C08027B020000046F1100000A2608720B0000706F1200000A2608027B030000046F1100000A26086F1300000A0B2B00072A00133003007400000004000011000F00281400000A0C082C0828020000060D2B5E1200FE15020000020F00281500000A720B000070281600000A6F1700000A0B120007169A281800000A280600000600120007179A281800000A2808000006001200280900000616FE01130411042C0B720F000070731900000A7A060D2B00092A133001000C0000000500001100027B020000040A2B00062A13300200300000000600001100027B020000040A02037D0200000402280900000616FE010B072C130002067D02000004724B000070731900000A7A2A133001000C0000000500001100027B030000040A2B00062A13300200300000000600001100027B030000040A02037D0300000402280900000616FE010B072C130002067D030000047283000070731900000A7A2A13300200290000000700001100027B0200000416320E027B0300000416FE0416FE012B01160A062C0500170B2B0500160B2B00072A00000042534A4201000100000000000C00000076342E302E33303331390000000005006C00000034030000237E0000A00300005403000023537472696E677300000000F4060000BC00000023555300B0070000100000002347554944000000C0070000BC01000023426C6F6200000000000000020000015717A2010900000000FA01330016000001000000190000000200000003000000090000000300000001000000190000000F00000007000000010000000400000006000000010000000200000000001C0201000000000006005401CE020600C101CE0206006C009C020F00EE0200000600940049020600370149020600180149020600A801490206007401490206008D0149020600C700490206008000AF0206005E00AF020600FB0049020600E200EF010A0012037B020A00AB007B0206004E0042020A004400FD0206006D0234030A000902FD0206001903420206001502420206000100420206005B0242020000000007000000000001000100092110002E030000490001000100010026027900010040037C00010043037C00502000000000E60937024D00010068200000000096082E027F0001008C2000000000C60013023E000100E420000000009600580084000100642100000000860810008B0002007C21000000008608160001000200B8210000000086081C008B000300D0210000000086082200010003000C2200000000810026034D00040000000100100300000100E90100000100E90102004D00090096020100110096020600190096020A00290096021000310096021000390096021000410096021000490096021000510096021000590096021000610096021500690096021000710096021000790096021000890096021A00A10096020600A1003D003200A1003D003800B10013023E00A90037024D00A900DF013E00B90046035100B90020035600C10058005D00C900960210002E000B009C002E001300A5002E001B00C4002E002300CD002E002B00D8002E003300D8002E003B00D8002E004300CD002E004B00DE002E005300D8002E005B00D8002E006300F6002E006B0020012E0073002D0143007B007B01200024002B004200620066006B000200010000003B028F0000003D02930000001A0098000000260098000200010003000200020005000200050007000100060007000200070009000100080009000480000001000000000000000000000000002E03000004000000000000000000000070003400000000000400000000000000000000007000280000000000000000496E743332003C4D6F64756C653E006765745F58007365745F58006765745F59007365745F590053797374656D2E44617461006D73636F726C696200417070656E6400494E756C6C61626C650056616C75655479706500506172736500477569644174747269627574650044656275676761626C6541747472696275746500436F6D56697369626C6541747472696275746500417373656D626C795469746C654174747269627574650053716C55736572446566696E65645479706541747472696275746500417373656D626C7954726164656D61726B417474726962757465005461726765744672616D65776F726B41747472696275746500417373656D626C7946696C6556657273696F6E41747472696275746500417373656D626C79436F6E66696775726174696F6E41747472696275746500417373656D626C794465736372697074696F6E41747472696275746500436F6D70696C6174696F6E52656C61786174696F6E7341747472696275746500417373656D626C7950726F6475637441747472696275746500417373656D626C79436F7079726967687441747472696275746500417373656D626C79436F6D70616E794174747269627574650052756E74696D65436F6D7061746962696C697479417474726962757465006765745F56616C75650076616C75650053797374656D2E52756E74696D652E56657273696F6E696E670053716C537472696E6700546F537472696E6700506F696E742E646C6C0069735F4E756C6C006765745F4E756C6C006765745F49734E756C6C0053797374656D0053797374656D2E5265666C656374696F6E00417267756D656E74457863657074696F6E00537472696E674275696C646572004D6963726F736F66742E53716C5365727665722E536572766572002E63746F720053797374656D2E446961676E6F73746963730053797374656D2E52756E74696D652E496E7465726F7053657276696365730053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300446562756767696E674D6F6465730053797374656D2E446174612E53716C547970657300466F726D6174004F626A6563740053706C69740056616C6964617465506F696E740053797374656D2E54657874005F78005F7900546F43686172417272617900000000094E0055004C004C0000032C00003B49006E00760061006C0069006400200058005900200063006F006F007200640069006E006100740065002000760061006C007500650073002E00003749006E00760061006C006900640020005800200063006F006F007200640069006E006100740065002000760061006C00750065002E00003749006E00760061006C006900640020005900200063006F006F007200640069006E006100740065002000760061006C00750065002E0000000F5C5DA40A4AE94EB7128C4DC071BA0100042001010803200001052001011111042001010E04200101020520010111410307010206070211081108060703020E125105200112510805200112510E0320000E0A070511081D0E02110802032000020420001D030620011D0E1D03040001080E030701080407020802040702020208B77A5C561934E08902060202060804000011080600011108115503200008032800020408001108032800080801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F7773010801000701000000000A010005506F696E74000005010000000017010012436F7079726967687420C2A920203230313800002901002435626139373765612D326136372D343333632D383439342D62396363616231376239343000000C010007312E302E302E3000004D01001C2E4E45544672616D65776F726B2C56657273696F6E3D76342E362E310100540E144672616D65776F726B446973706C61794E616D65142E4E4554204672616D65776F726B20342E362E313E010001000000020054020D4973427974654F72646572656401540E1456616C69646174696F6E4D6574686F644E616D650D56616C6964617465506F696E74000000000000FC1E785A00000000020000001C010000DC2B0000DC0D000052534453B50100599F29C1459B10EBF805C20D6501000000433A5C4D7950726F6A656374735C506F696E745C506F696E745C6F626A5C44656275675C506F696E742E7064620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000202D000000000000000000003A2D00000020000000000000000000000000000000000000000000002C2D0000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF2500200010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100000000004800000058400000FC0200000000000000000000FC0234000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100000001000000000000000100000000003F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B0045C020000010053007400720069006E006700460069006C00650049006E0066006F0000003802000001003000300030003000300034006200300000001A000100010043006F006D006D0065006E007400730000000000000022000100010043006F006D00700061006E0079004E0061006D0065000000000000000000340006000100460069006C0065004400650073006300720069007000740069006F006E000000000050006F0069006E0074000000300008000100460069006C006500560065007200730069006F006E000000000031002E0030002E0030002E003000000034000A00010049006E007400650072006E0061006C004E0061006D006500000050006F0069006E0074002E0064006C006C0000004800120001004C006500670061006C0043006F007000790072006900670068007400000043006F0070007900720069006700680074002000A90020002000320030003100380000002A00010001004C006500670061006C00540072006100640065006D00610072006B00730000000000000000003C000A0001004F0072006900670069006E0061006C00460069006C0065006E0061006D006500000050006F0069006E0074002E0064006C006C0000002C0006000100500072006F0064007500630074004E0061006D0065000000000050006F0069006E0074000000340008000100500072006F006400750063007400560065007200730069006F006E00000031002E0030002E0030002E003000000038000800010041007300730065006D0062006C0079002000560065007200730069006F006E00000031002E0030002E0030002E003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000C0000004C3D00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
WITH PERMISSION_SET =UNSAFE;

CREATE TYPE Point
EXTERNAL NAME Point.Point;

--
--
CREATE TABLE dbo.Points   
(ID int IDENTITY(1,1) PRIMARY KEY, PointValue Point)
GO

--sp_configure @configname=clr_enabled, 
--@configvalue=1
--GO
--RECONFIGURE
--GO


INSERT  INTO dbo.Points
        ( PointValue )
VALUES  ( CONVERT(Point, '3,4') );  
INSERT  INTO dbo.Points
        ( PointValue )
VALUES  ( CONVERT(Point, '1,5') );  
INSERT  INTO dbo.Points
        ( PointValue )
VALUES  ( CAST ('1,99' AS Point) ); 
INSERT  INTO dbo.Points
        ( PointValue )
VALUES  ( CAST ('2,3' AS Point) ); 


SELECT  ID ,
        PointValue.ToString()
FROM    dbo.Points 

SELECT ID, PointValue.ToString() AS Points   
FROM dbo.Points  
WHERE PointValue > CONVERT(Point, '2,2'); 


--DROP TABLE dbo.Points
--DROP TYPE Point
--DROP ASSEMBLY point