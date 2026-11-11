-- Lihat 10 baris pertama
SELECT * FROM marketing LIMIT 10;

-- Ringkasan total
SELECT COUNT(*) AS total_baris,
       MIN(c_date) AS tanggal_awal,
       MAX(c_date) AS tanggal_akhir,
       ROUND(SUM(mark_spent), 0) AS total_biaya,
       ROUND(SUM(revenue), 0)    AS total_revenue,
       ROUND(SUM(revenue) / SUM(mark_spent), 2) AS roas_total
FROM marketing;

-- Cek ejaan nama campaign (cari yang tidak konsisten)
SELECT campaign_name, COUNT(*) AS jumlah
FROM marketing
GROUP BY campaign_name
ORDER BY campaign_name;

-- Performa per kategori kanal
SELECT category,
       ROUND(SUM(mark_spent), 0) AS biaya,
       ROUND(SUM(revenue), 0)    AS revenue,
       SUM(orders)               AS orders,
       ROUND(SUM(revenue) / SUM(mark_spent), 2) AS roas,
       ROUND((SUM(revenue) - SUM(mark_spent)) * 100.0 / SUM(mark_spent), 1) AS roi_persen
FROM marketing
GROUP BY category
ORDER BY roas DESC;

-- Performa per campaign (standarkan nama dengan LOWER)
SELECT LOWER(campaign_name) AS campaign,
       category,
       ROUND(SUM(mark_spent), 0) AS biaya,
       ROUND(SUM(revenue), 0)    AS revenue,
       ROUND(SUM(revenue) / SUM(mark_spent), 2) AS roas
FROM marketing
GROUP BY LOWER(campaign_name), category
ORDER BY roas DESC;

-- Efisiensi biaya per kategori (CTR, CPC, CPL, CPA)
SELECT category,
       ROUND(SUM(clicks) * 100.0 / SUM(impressions), 3) AS ctr_persen,
       ROUND(SUM(mark_spent) / SUM(clicks), 2)          AS cpc,
       ROUND(SUM(mark_spent) / NULLIF(SUM(leads), 0), 2)  AS cpl,
       ROUND(SUM(mark_spent) / NULLIF(SUM(orders), 0), 2) AS cpa
FROM marketing
GROUP BY category
ORDER BY cpa;

-- Funnel per kategori
SELECT category,
       SUM(impressions) AS impressions,
       SUM(clicks)      AS clicks,
       SUM(leads)       AS leads,
       SUM(orders)      AS orders,
       ROUND(SUM(leads)  * 100.0 / SUM(clicks), 2) AS click_to_lead_persen,
       ROUND(SUM(orders) * 100.0 / NULLIF(SUM(leads), 0), 2) AS lead_to_order_persen
FROM marketing
GROUP BY category;

-- Tren mingguan
SELECT strftime('%W', c_date) AS minggu_ke,
       ROUND(SUM(mark_spent), 0) AS biaya,
       ROUND(SUM(revenue), 0)    AS revenue,
       ROUND(SUM(revenue) / SUM(mark_spent), 2) AS roas
FROM marketing
GROUP BY minggu_ke
ORDER BY minggu_ke;

-- Hari-hari tanpa revenue (campaign boros tanpa hasil)
SELECT c_date, LOWER(campaign_name) AS campaign, mark_spent
FROM marketing
WHERE revenue = 0
ORDER BY mark_spent DESC;