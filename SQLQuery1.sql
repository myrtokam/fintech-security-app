USE RISK_MANAGEMENT
INSERT INTO risk_assessments (
    application_id,
    customer_id,
    risk_score,
    risk_level,
    decision,
    model_version,
    comments
)
SELECT 
    application_id,
    customer_id,
    ABS(CHECKSUM(NEWID())) % 100,
    CASE WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 THEN 'GREEN'
         WHEN ABS(CHECKSUM(NEWID())) % 3 = 1 THEN 'YELLOW'
         ELSE 'RED' END,
    CASE WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 THEN 'APPROVED'
         WHEN ABS(CHECKSUM(NEWID())) % 3 = 1 THEN 'REJECTED'
         ELSE 'MANUAL_REVIEW' END,
    'v1',
    'AUTO GENERATED RISK'
FROM applications;