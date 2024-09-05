SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_insert_comments]
    @input_data NVARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON
    INSERT INTO [dbo].[callcentre_comments] (comments, modified_date, api_modified_date)
    VALUES (@input_data, GETDATE(),NULL);
END
