﻿CREATE VIEW vwMeterMeasurement
AS
SELECT	PostalCode,
		DATETIMEFROMPARTS(
			YEAR(MeasurementDate), 
			MONTH(MeasurementDate), 
			DAY(MeasurementDate), 
			DATEPART(HOUR,MeasurementDate), 
			DATEPART(MINUTE,MeasurementDate), 
			DATEPART(ss,MeasurementDate)/1,
			0
		) AS MeasurementDate,
		count(*) AS MeterCount,
		AVG(MeasurementInkWh) AS AvgMeasurementInkWh
FROM	[dbo].[MeterMeasurement] FOR SYSTEM_TIME ALL WITH (NOLOCK)
GROUP BY
		PostalCode,
		DATETIMEFROMPARTS(
		YEAR(MeasurementDate), 
		MONTH(MeasurementDate), 
		DAY(MeasurementDate), 
		DATEPART(HOUR,MeasurementDate), 
		DATEPART(MINUTE,MeasurementDate), 
		DATEPART(ss,MeasurementDate)/1,0) 
		
		-- NOTE TEST
