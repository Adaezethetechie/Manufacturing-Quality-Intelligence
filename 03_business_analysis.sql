USE manufacturing_quality;
-- Q0. Validate loaded records and date coverage
SELECT COUNT(*) AS records, COUNT(DISTINCT defect_id) AS unique_defects,
 COUNT(DISTINCT product_id) AS products, MIN(defect_date) AS first_date,
 MAX(defect_date) AS last_date,
 SUM(defect_type IS NULL OR severity IS NULL OR repair_cost IS NULL) AS incomplete_rows
FROM manufacturing_defects;

-- Q1. Overall volume and repair-cost summary
SELECT COUNT(*) AS defect_count, COUNT(DISTINCT product_id) AS affected_products,
 ROUND(SUM(repair_cost),2) AS total_repair_cost,
 ROUND(AVG(repair_cost),2) AS avg_repair_cost,
 MIN(repair_cost) AS min_repair_cost, MAX(repair_cost) AS max_repair_cost
FROM manufacturing_defects;

-- Q2. Defect type: frequency, share and cost
SELECT defect_type, COUNT(*) AS defect_count,
 ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM manufacturing_defects),2) AS pct_of_defects,
 ROUND(SUM(repair_cost),2) AS total_repair_cost,
 ROUND(100.0*SUM(repair_cost)/(SELECT SUM(repair_cost) FROM manufacturing_defects),2) AS pct_of_cost,
 ROUND(AVG(repair_cost),2) AS avg_repair_cost
FROM manufacturing_defects GROUP BY defect_type ORDER BY total_repair_cost DESC;

-- Q3. Severity breakdown with ordered labels and conditional aggregation
SELECT severity, COUNT(*) AS defect_count,
 SUM(CASE WHEN repair_cost >= 750 THEN 1 ELSE 0 END) AS high_cost_defects,
 ROUND(AVG(repair_cost),2) AS avg_repair_cost,
 ROUND(SUM(repair_cost),2) AS total_repair_cost
FROM manufacturing_defects GROUP BY severity
ORDER BY FIELD(severity,'Minor','Moderate','Critical');

-- Q4. Defect locations ranked by repair burden
SELECT defect_location, COUNT(*) AS defect_count,
 ROUND(SUM(repair_cost),2) AS total_repair_cost,
 ROUND(AVG(repair_cost),2) AS avg_repair_cost,
 DENSE_RANK() OVER (ORDER BY SUM(repair_cost) DESC) AS cost_rank
FROM manufacturing_defects GROUP BY defect_location ORDER BY cost_rank;

-- Q5. Inspection method comparisons (NOT inspection effectiveness)
SELECT inspection_method, COUNT(*) AS recorded_defects,
 COUNT(DISTINCT product_id) AS distinct_affected_products,
 ROUND(SUM(repair_cost),2) AS total_repair_cost,
 ROUND(AVG(repair_cost),2) AS avg_repair_cost,
 ROUND(100.0*SUM(severity='Critical')/COUNT(*),2) AS critical_pct_of_recorded_defects
FROM manufacturing_defects GROUP BY inspection_method ORDER BY recorded_defects DESC;

-- Q6. Monthly changes in defects and repair costs
WITH monthly AS (
 SELECT DATE_FORMAT(defect_date,'%Y-%m') AS month,
 COUNT(*) AS defects, ROUND(SUM(repair_cost),2) AS total_cost
 FROM manufacturing_defects GROUP BY DATE_FORMAT(defect_date,'%Y-%m')
), trend AS (
 SELECT month, defects, total_cost,
 LAG(defects) OVER (ORDER BY month) AS previous_defects,
 LAG(total_cost) OVER (ORDER BY month) AS previous_cost
 FROM monthly
)
SELECT month, defects, total_cost, previous_defects,
 defects-previous_defects AS change_in_defects,
 ROUND(100.0*(defects-previous_defects)/NULLIF(previous_defects,0),2) AS pct_change_in_defects,
 ROUND(total_cost-previous_cost,2) AS change_in_cost
FROM trend ORDER BY month;

-- Q7. Ten highest-cost products
WITH product_costs AS (
 SELECT product_id, COUNT(*) AS defect_count,
 ROUND(SUM(repair_cost),2) AS total_repair_cost,
 ROUND(AVG(repair_cost),2) AS avg_repair_cost
 FROM manufacturing_defects GROUP BY product_id
)
SELECT product_id, defect_count, total_repair_cost, avg_repair_cost,
 DENSE_RANK() OVER (ORDER BY total_repair_cost DESC) AS cost_rank
FROM product_costs ORDER BY total_repair_cost DESC,product_id LIMIT 10;

-- Q8. Type x severity contribution to repair spending
WITH combinations AS (
 SELECT defect_type,severity,COUNT(*) AS defect_count,
 ROUND(SUM(repair_cost),2) AS total_cost
 FROM manufacturing_defects GROUP BY defect_type,severity
)
SELECT defect_type,severity,defect_count,total_cost,
 ROUND(100.0*total_cost/SUM(total_cost) OVER (),2) AS pct_of_all_repair_cost,
 DENSE_RANK() OVER (ORDER BY total_cost DESC) AS cost_rank
FROM combinations ORDER BY total_cost DESC;

-- Q9. High-cost outliers: >2x average for same type AND severity
WITH benchmarks AS (
 SELECT defect_id,product_id,defect_type,severity,repair_cost,
 AVG(repair_cost) OVER (PARTITION BY defect_type,severity) AS peer_avg_cost
 FROM manufacturing_defects
)
SELECT defect_id,product_id,defect_type,severity,repair_cost,
 ROUND(peer_avg_cost,2) AS peer_avg_cost,
 ROUND(repair_cost/NULLIF(peer_avg_cost,0),2) AS cost_multiple
FROM benchmarks WHERE repair_cost > 2*peer_avg_cost
ORDER BY cost_multiple DESC,repair_cost DESC;

-- Q10. Recurring-defect products versus average product-level spending
WITH product_summary AS (
 SELECT product_id,COUNT(*) AS defect_count,SUM(repair_cost) AS total_cost
 FROM manufacturing_defects GROUP BY product_id
), benchmark AS (
 SELECT product_id,defect_count,total_cost,
 AVG(total_cost) OVER () AS avg_product_cost
 FROM product_summary
)
SELECT product_id,defect_count,ROUND(total_cost,2) AS total_repair_cost,
 ROUND(avg_product_cost,2) AS avg_product_repair_cost,
 ROUND(total_cost-avg_product_cost,2) AS difference_from_avg,
 ROUND(total_cost/NULLIF(avg_product_cost,0),2) AS cost_multiple
FROM benchmark WHERE defect_count >= 2
ORDER BY defect_count DESC,total_cost DESC;
