ALTER PROCEDURE spGetQuestionAnswer
	@idForm INT,
	@idAnswerGroup INT
AS
	CREATE TABLE #tblQuestions (
		idQuestion INT,
		dataType CHAR,
		question VARCHAR(256)
	)

	CREATE TABLE #tblAnswers (
		fkQuestion INT,
		answer VARCHAR(256)
	)

	INSERT INTO #tblQuestions
		SELECT
			idQuestion,
			dataType,
			question
		FROM
			Questions
		WHERE
			fkForm=@idForm AND isAlive = 1

	INSERT INTO #tblAnswers
		SELECT
			fkQuestion,
			answer
		FROM
			AnswerItemText
		WHERE
			fkAnswerGroup=@idAnswerGroup AND isLatest = 1

	INSERT INTO #tblAnswers
		SELECT
			fkQuestion,
			answer
		FROM
			AnswerItemDate
		WHERE
			fkAnswerGroup=@idAnswerGroup AND isLatest = 1

	INSERT INTO #tblAnswers
		SELECT
			fkQuestion,
			answer
		FROM
			AnswerItemNumeric
		WHERE
			fkAnswerGroup=@idAnswerGroup AND isLatest = 1

	SELECT
		dataType,
		question,
		answer
	FROM
		#tblQuestions LEFT JOIN #tblAnswers
			ON #tblQuestions.idQuestion=#tblAnswers.fkQuestion

-- EXEC spGetQuestionAnswer 1, 1