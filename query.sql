CREATE TABLE kimia_farma.kf_analysis AS
SELECT tr.transaction_id, 
  tr.date, 
  tr.branch_id, 
  kc.branch_name, 
  kc.kota, 
  kc.provinsi, 
  kc.rating AS rating_cabang, 
  tr.customer_name, 
  tr.product_id, 
  pd.product_name, 
  pd.price AS actual_price, 
  tr.discount_percentage,
  CASE
    WHEN pd.price <= 50000 then 0.1
    WHEN pd.price > 50000 AND pd.price <= 100000 then 0.15
    WHEN pd.price > 100000 AND pd.price <= 300000 then 0.2
    WHEN pd.price > 300000 AND pd.price <= 500000 then 0.25
    ELSE 0.3      --pd.price >500000 
    END AS persentase_gross_laba,
  (pd.price * (1-tr.discount_percentage)) AS nett_sales,
  (pd.price * (1 - tr.discount_percentage)) * CASE
                                                WHEN pd.price <= 50000 THEN 0.1
                                                WHEN pd.price <= 100000 THEN 0.15
                                                WHEN pd.price <= 300000 THEN 0.2
                                                WHEN pd.price <= 500000 THEN 0.25
                                                ELSE 0.3
                                              END AS nett_profit,
  tr.rating AS rating_transaksi
FROM kimia_farma.kf_final_transaction AS tr 
  LEFT JOIN kimia_farma.kf_kantor_cabang AS kc 
  ON (tr.branch_id = kc.branch_id)
  LEFT JOIN kimia_farma.kf_product AS pd
  ON (tr.product_id = pd.product_id)
;

CREATE TABLE kimia_farma.kf_branch_analysis AS
SELECT kc.branch_id, 
  kc.branch_name, 
  AVG(tr.rating) AS rating_transaction,
  kc.rating AS rating_branch
FROM kimia_farma.kf_kantor_cabang AS kc
  LEFT JOIN kimia_farma.kf_final_transaction AS tr
  ON (kc.branch_id = tr.branch_id)
GROUP BY kc.branch_id, kc.branch_name, kc.rating
ORDER BY AVG(tr.rating) ASC, kc.rating DESC
;

CREATE TABLE kimia_farma.kf_branch_analysis_lim AS
SELECT kc.branch_id, 
  kc.branch_name, 
  AVG(tr.rating) AS rating_transaction,
  kc.rating AS rating_branch
FROM kimia_farma.kf_kantor_cabang AS kc
  LEFT JOIN kimia_farma.kf_final_transaction AS tr
  ON (kc.branch_id = tr.branch_id)
GROUP BY kc.branch_id, kc.branch_name, kc.rating
ORDER BY AVG(tr.rating) ASC, kc.rating DESC
LIMIT 5
;