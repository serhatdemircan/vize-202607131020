-- ==========================================
-- Hafta 5: Analitik Sorgular (sql/hafta-05.sql).
-- Öğrenci No: 202607131020 | Kura #21
-- Senaryo: Tarım x Öneri Motoru x Model Performans Karşılaştırması
-- ==========================================

-- 1. Sorgu: Bu sorgu, Model A ve Model B tarafından yapılan toplam ürün önerisi sayısını ve bu önerilerin ne kadarının gerçek satın almaya dönüştüğünü sorar. Beklenen sonuç, her iki model için toplam öneri adedi, satın alınan ürün sayısı ve yüzdelik satın alma oranını gösteren 2 satırlık (2 rows) bir özet tablodur. Bu sonuç, hangi yapay zeka modelinin çiftçilerin gerçek ihtiyaçlarına daha uygun öneriler üreterek satış dönüşümünü artırdığını anlamamızı sağlar.
SELECT 
    r.model_name,
    COUNT(r.id) AS total_recommendations,
    SUM(CASE WHEN s.was_purchased IS TRUE THEN 1 ELSE 0 END) AS purchased_count,
    ROUND(SUM(CASE WHEN s.was_purchased IS TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(r.id), 2) AS purchase_rate_pct
FROM recommendations r
LEFT JOIN sales s ON r.id = s.recommendation_id
GROUP BY r.model_name;
-- Çıktı: (2 rows) - Model A ve Model B için toplam öneri, satın alınan adet ve yüzdelik oran listelendi.


-- 2. Sorgu: Bu sorgu, öneri motoru tarafından üretildiği halde satış tablosunda henüz hiçbir işlem kaydı bulunmayan önerilerin sayısını sorar. Beklenen sonuç, tüm öneri satırları (COUNT(*)) ile satış tablosunda karşılığı olan kayıtların (COUNT(s.id)) arasındaki farkı 1 satırlık (1 row) tek bir özet tabloda görmektir. Bu sonuç, sistemdeki 2200 öneriden 168 tanesinin henüz satış aşamasına hiç geçmediğini veya işlem kaydının oluşmadığını ortaya koyar.
SELECT 
    COUNT(*) AS total_recommendation_rows,
    COUNT(s.id) AS rows_with_sales_record,
    COUNT(*) - COUNT(s.id) AS missing_sales_record_count
FROM recommendations r
LEFT JOIN sales s ON r.id = s.recommendation_id;
-- Çıktı: (1 row) - total_recommendation_rows: 2200 | rows_with_sales_record: 2032 | missing_sales_record_count: 168


-- 3. Sorgu: Bu sorgu, her iki öneri modelinde de en az 50 adet gerçekleşmiş satış barajını aşan tarımsal bölgelerin hangileri olduğunu sorar. Beklenen sonuç, model adı ve bölge kırılımında yalnızca aktif satış hacmi 50 ve üzerinde olan satırların çoktan aza doğru listelenmesidir. Bu sonuç, modellerin hangi coğrafi bölgelerde yüksek talep ve ticari başarı yakaladığını tespit etmemizi sağlar.
SELECT 
    r.model_name,
    r.region,
    COUNT(s.id) AS total_sales
FROM recommendations r
JOIN sales s ON r.id = s.recommendation_id
WHERE s.was_purchased IS TRUE
GROUP BY r.model_name, r.region
HAVING COUNT(s.id) >= 50
ORDER BY r.model_name, total_sales DESC;
-- Çıktı: (14 rows) - Model A ve Model B için 7'şer tarımsal bölgenin tamamı 50 satış barajını geçtiği için listelendi.


-- 4. Sorgu: Bu sorgu, satın alınan tarım ürünlerinin satış tutarlarına göre düşük (low), orta (medium) ve yüksek (high) fiyat segmentlerinde nasıl dağıldığını sorar. Beklenen sonuç, üç fiyat kategorisinin her birinde kaç adet satış yapıldığını, ortalama sepet tutarını ve toplam ciroyu gösteren 3 satırlık (3 rows) bir tablodur. Bu sonuç, çiftçilerin önerilen ürünlerde daha çok hangi bütçe aralığındaki tohum ve gübreleri tercih ettiğini gösterir.
SELECT 
    CASE 
        WHEN amount_try < 300 THEN 'low'
        WHEN amount_try BETWEEN 300 AND 700 THEN 'medium'
        ELSE 'high'
    END AS amount_category,
    COUNT(id) AS sales_count,
    ROUND(AVG(amount_try), 2) AS avg_amount_try,
    SUM(amount_try) AS total_revenue_try
FROM sales
WHERE was_purchased IS TRUE
GROUP BY 
    CASE 
        WHEN amount_try < 300 THEN 'low'
        WHEN amount_try BETWEEN 300 AND 700 THEN 'medium'
        ELSE 'high'
    END
ORDER BY sales_count DESC;
-- Çıktı: (3 rows) - medium, high ve low kategorilerinin satış adetleri, ortalama tutarları ve toplam ciroları özetlendi.


-- 5. Sorgu: Bu sorgu, zaman içinde haftalık periyotlara göre her iki modelin önerdiği ürünlerdeki iade oranlarının nasıl değiştiğini sorar. Beklenen sonuç, hafta başlangıç tarihlerine göre Model A ve Model B'nin toplam satışlarını, toplam iade sayılarını ve yüzdelik iade oranlarını alt alta karşılaştırmalı olarak listelemektir. Bu sonuç, modellerin öneri kalitesinin ve iade oranlarının haftalık periyotlarda (~%11 ile %27 aralığında) nasıl dalgalandığını karşılaştırmalı olarak görmemizi sağlar.
SELECT 
    date_trunc('week', r.recommended_at)::date AS week_start,
    r.model_name,
    COUNT(s.id) AS total_sales,
    COUNT(i.id) AS total_returns,
    ROUND(COUNT(i.id) * 100.0 / NULLIF(COUNT(s.id), 0), 2) AS return_rate_pct
FROM recommendations r
JOIN sales s ON r.id = s.recommendation_id
LEFT JOIN product_returns i ON s.id = i.sale_id
WHERE s.was_purchased IS TRUE
GROUP BY date_trunc('week', r.recommended_at)::date, r.model_name
ORDER BY week_start, r.model_name;
-- Çıktı: (20 rows) - Haftalık tarih kırılımında Model A ve Model B'nin satış adetleri, iade sayıları ve yüzdelik iade oranları (~%11-27 aralığında) karşılaştırmalı olarak listelendi.