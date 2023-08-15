create PROCEDURE [Data].[uspPopulateDimIssue]
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON

	BEGIN TRY
		PRINT 'Populating data into [Report].DimIssue';

		IF OBJECT_ID('tempdb.dbo.#DimIssue') IS NOT NULL
			DROP TABLE #DimIssue;

		SELECT *
		INTO #DimIssue
		FROM [Report].[DimIssue]
		WHERE 0 = 1;

		INSERT INTO #DimIssue (IssueId, IssueName, LastUpdatedDateTimestamp)
		VALUES (1,'Model Lateness',GETDATE()),
				(2, 'Model Issue', GETDATE()),
				(3, 'Tech Issue', GETDATE()),
				(4, ' H & M Issue', GETDATE()),
				(5, 'ShootTeamLateness',GETDATE()),
				(6, 'Fure Alarm', GETDATE()),
				(7,'Other',GETDATE());

		WITH cte_data
		AS (
			SELECT IssueId, IssueName
			FROM #DimIssue
			)
		MERGE [Report].[DimIssue] AS t
		USING cte_data AS s
			ON t.IssueId = s.IssueId
		WHEN NOT MATCHED BY TARGET
			THEN
				INSERT (IssueId, IssueName, LastUpdatedDateTimestamp)
				VALUES (s.IssueId, s.IssueName, GETDATE())
		WHEN MATCHED
			THEN
				UPDATE
				SET t.IssueName = s.IssueName, t.LastUpdatedDateTimestamp = GETDATE();

		DROP TABLE #DimIssue;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH

	SET NOCOUNT OFF
END
GO


EXEC [Data].[uspPopulateDimIssue]

SELECT * FROM Report.dimissue