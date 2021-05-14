IF EXISTS
  (SELECT 1
   FROM sys.objects
   WHERE TYPE = 'P'
     AND name = 'IMEX_GetJobSchedule' )
DROP PROCEDURE IMEX_GetJobSchedule;

GO
CREATE PROCEDURE [dbo].[IMEX_GetJobSchedule] @Interval int = 5 AS BEGIN DECLARE @CurrentDayOfWeek int = DATEPART(dw, GETDATE())
SELECT job.Job,
       step.Step,
       'N',
       GETDATE(),
       NULL,
       NULL
FROM IMEX_Schedules sd
INNER JOIN IMEX_JobSchedules js ON sd.ID = js.Schedule
INNER JOIN IMEX_Job job ON js.Job = job.Job
INNER JOIN IMEX_Step step ON step.Job = job.Job
WHERE job.Inactive = 0
  AND step.Inactive = 0
  AND 1 = CASE
              WHEN sd.RecurringType = 'D'
                   AND DATEDIFF (dd, sd.StartDate, GETDATE())%sd.RecursEvery = 0 THEN 1
              WHEN sd.RecurringType = 'W'
                   AND DATEDIFF (WEEK, sd.StartDate, GETDATE())%sd.RecursEvery = 0
                   AND SUBSTRING([DayOfWeek], @CurrentDayOfWeek, 1) = 1 THEN 1
              WHEN sd.RecurringType = 'M'
                   AND DATEDIFF (MONTH, sd.StartDate, GETDATE())%sd.RecursEvery = 0
                   AND DAY(GETDATE()) = DayOfMonth THEN 1
              ELSE 0
          END
  AND GETDATE() BETWEEN sd.StartDate AND ISNULL(sd.EndDate, GETDATE()+1)
  AND CONVERT(varchar, GETDATE(), 108) BETWEEN sd.StartingAt AND ISNULL(sd.EndingAt, GETDATE())
  AND sd.OccursEvery - DATEDIFF (MINUTE, sd.StartingAt, GETDATE()) % sd.OccursEvery < @Interval END;

GO