CREATE TABLE rakamin-kf-analytics-998.kimia_farma.kf_analytics_table AS
  SELECT
    x.transaction_id, x.date, x.branch_id, x.branch_name,
    x.kota, x.provinsi, x.rating_cabang, x.customer_name,
    x.product_id, x.actual_price, x.discount_percentage,
    x.persentase_gross_laba, x.nett_sales,
    (x.actual_price * x.persentase_gross_laba) - (x.actual_price - x.nett_sales) nett_profit,
    x.rating_transaction
  FROM (
    SELECT
    t.transaction_id, t.date, b.branch_id,
    b.branch_name, b.kota, b.provinsi,
    b.rating AS rating_cabang,
    t.customer_name, p.product_id,
    p.product_name, p.price AS actual_price,
    t.discount_percentage,
    CASE
      WHEN p.price <= 50000 THEN 0.1
      WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
      WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
      WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS persentase_gross_laba,
    p.price * (1 - t.discount_percentage) AS nett_sales,
    t.rating AS rating_transaction
    FROM rakamin-kf-analytics-998.kimia_farma.kf_final_transaction AS t
    JOIN rakamin-kf-analytics-998.kimia_farma.kf_kantor_cabang AS b ON t.branch_id = b.branch_id
    JOIN rakamin-kf-analytics-998.kimia_farma.kf_product AS p ON t.product_id = p.product_id
    ) x
