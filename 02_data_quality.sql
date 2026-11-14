USE manufacturing_quality;
-- Completeness and uniqueness
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT defect_id) AS unique_ids,
 SUM(defect_id IS NULL) AS missing_id, SUM(product_id IS NULL) AS missing_product,
 SUM(defect_type IS NULL) AS missing_type, SUM(defect_date IS NULL) AS missing_date,
 SUM(defect_location IS NULL) AS missing_location, SUM(severity IS NULL) AS missing_severity,
 SUM(inspection_method IS NULL) AS missing_method, SUM(repair_cost IS NULL) AS missing_cost
FROM manufacturing_defects;
-- Duplicates, unexpected cost, and category profiles
SELECT defect_id, COUNT(*) AS copies FROM manufacturing_defects GROUP BY defect_id HAVING COUNT(*)>1;
SELECT COUNT(*) AS invalid_cost_count FROM manufacturing_defects WHERE repair_cost < 0;
SELECT defect_type, COUNT(*) AS n FROM manufacturing_defects GROUP BY defect_type ORDER BY n DESC;
SELECT severity, COUNT(*) AS n FROM manufacturing_defects GROUP BY severity ORDER BY n DESC;
SELECT inspection_method, COUNT(*) AS n FROM manufacturing_defects GROUP BY inspection_method ORDER BY n DESC;
SELECT MIN(defect_date) AS first_date, MAX(defect_date) AS last_date FROM manufacturing_defects;
