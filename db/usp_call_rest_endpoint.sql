SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_call_rest_endpoint]
    @input_data NVARCHAR(MAX),
    @response NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @url NVARCHAR(MAX) = 'https://presidiopii.azurewebsites.net/analyze';
    DECLARE @headers NVARCHAR(MAX) = '{"Content-Type": "application/json"}';
    DECLARE @payload NVARCHAR(MAX) = '{"text": "' + @input_data + '"}';

    EXEC sp_invoke_external_rest_endpoint
        @url = @url,
        @method = 'POST',
        @headers = @headers,
        @payload = @payload,
        @response = @response OUTPUT;
END
