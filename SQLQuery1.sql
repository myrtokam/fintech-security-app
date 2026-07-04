USE RISK_MANAGEMENT;

BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO risk_assessments (
        application_id,
        customer_id,
        risk_score,
        risk_level,
        decision,
        model_version,
        assessed_at,
        assessed_by,
        comments
    )
    SELECT 
        a.application_id,
        a.customer_id,
        a.calculated_risk_score,
        CASE 
            WHEN a.calculated_risk_score < 30 THEN 'GREEN'
            WHEN a.calculated_risk_score < 70 THEN 'YELLOW'
            ELSE 'RED'
        END,
        CASE 
            WHEN a.calculated_risk_score < 30 THEN 'APPROVED'
            WHEN a.calculated_risk_score >= 70 THEN 'REJECTED'
            ELSE 'MANUAL_REVIEW'
        END,
        'v1',
        GETUTCDATE(),
        SYSTEM_USER,
        'Risk assessment generated from application risk score'
    FROM applications a
    WHERE NOT EXISTS (
        SELECT 1 FROM risk_assessments r
        WHERE r.application_id = a.application_id
          AND r.model_version = 'v1'
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
