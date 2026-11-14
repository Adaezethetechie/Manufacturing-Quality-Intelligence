USE manufacturing_quality;
-- Reusable aggregated views
CREATE OR REPLACE VIEW vw_monthly_quality AS
SELECT DATE_FORMAT(defect_date,'%Y-%m') AS defect_month,
 COUNT(*) AS defect_count, ROUND(SUM(repair_cost),2) AS total_repair_cost
FROM manufacturing_defects GROUP BY DATE_FORMAT(defect_date,'%Y-%m');
CREATE OR REPLACE VIEW vw_product_costs AS
SELECT product_id, COUNT(*) AS defect_count, ROUND(SUM(repair_cost),2) AS total_repair_cost
FROM manufacturing_defects GROUP BY product_id;
SELECT * FROM vw_monthly_quality ORDER BY defect_month;
-- Derived product lookup for JOIN demonstration. No invented product attributes.
CREATE TABLE IF NOT EXISTS product_reference (product_id INT PRIMARY KEY);
INSERT IGNORE INTO product_reference(product_id)
SELECT DISTINCT product_id FROM manufacturing_defects;
SELECT p.product_id, COUNT(d.defect_id) AS recorded_defects,
 COALESCE(ROUND(SUM(d.repair_cost),2),0) AS total_repair_cost
FROM product_reference p LEFT JOIN manufacturing_defects d ON d.product_id=p.product_id
GROUP BY p.product_id ORDER BY total_repair_cost DESC;
-- Review execution plans BEFORE deciding whether an index is useful.
EXPLAIN ANALYZE SELECT * FROM manufacturing_defects
WHERE defect_date >= '2024-04-01' AND defect_date < '2024-05-01';
-- Optional experiment; small datasets may not benefit.
CREATE INDEX idx_defect_date ON manufacturing_defects(defect_date);
EXPLAIN ANALYZE SELECT * FROM manufacturing_defects
WHERE defect_date >= '2024-04-01' AND defect_date < '2024-05-01';
