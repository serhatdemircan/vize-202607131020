-- Ödev 2, Bölüm 1: Filo soruları
-- Ad Soyad: Serhat Demircan
-- Veritabanı: robot_fleet
-- Her sorgunun altına sonucu açıklayan tek cümlelik yorum yaz.

-- Soru 1: Her robotun adı, operatör adı ve operatör telefonu (INNER JOIN)
SELECT
    r.name AS robot_name,
    o.operator_name,
    o.phone
FROM robots r
INNER JOIN operators o ON r.operator_name = o.operator_name;

-- Yorum: Operatörü tanımlı 9 robot listelendi, operatör bilgisi NULL olan Mars-03 ise INNER JOIN koşulu sağlanmadığı için sonuçta yer almadı.

-- Soru 2: Aynı liste, bütün robotlar görünsün (LEFT JOIN). 1. sorguyla karşılaştır, kim kayboldu?
SELECT
    r.name AS robot_name,
    o.operator_name,
    o.phone
FROM robots r
LEFT JOIN operators o ON r.operator_name = o.operator_name;

-- Yorum: Filodaki 10 robotun tamamı listelendi ve 1. sorguda operatörü NULL olduğu için kaybolan Mars-03 bu sorguda operatör bilgileri boş olarak geri geldi.

-- Soru 3: Hiç görev almamış robotların adı ve modeli
SELECT
    r.name AS robot_name,
    r.model
FROM robots r
LEFT JOIN missions m ON r.id = m.robot_id
WHERE m.id IS NULL;

-- Yorum: Görev kaydı bulunmayan 4 robot (Kartal-02, Atlas-03, Mars-03 ve Kartal-04) LEFT JOIN ve IS NULL filtresiyle listelendi.

-- Soru 4a: JOIN ile hesaplanan toplam batarya (görevi olan robotlar)
SELECT
    SUM(r.battery_level) AS total_battery_join
FROM robots r
INNER JOIN missions m ON r.id = m.robot_id;

-- Soru 4b: JOIN kullanmadan doğru toplam
SELECT
    SUM(r.battery_level) AS total_battery_correct
FROM robots r
WHERE EXISTS (
    SELECT 1
    FROM missions m
    WHERE m.robot_id = r.id
);

-- Yorum (iki sonuç ve fark): JOIN ile toplam batarya 743 çıkarken doğru toplam 242'dir çünkü birden fazla görevi olan robotların batarya değerleri görev sayısı kadar tekrar toplanarak şişmiştir.

-- Soru 5: Robot başına görev sayısı; count(*) ve count(m.id) yan yana
SELECT
    r.id,
    r.name AS robot_name,
    COUNT(*) AS count_all,
    COUNT(m.id) AS count_mission_id
FROM robots r
LEFT JOIN missions m ON r.id = m.robot_id
GROUP BY r.id, r.name
ORDER BY r.id;

-- Yorum (hangi robotlarda ikisi farklı?): Hiç görevi olmayan 4 robotta (Kartal-02, Atlas-03, Mars-03 ve Kartal-04) LEFT JOIN sonucu oluşan NULL satır sayıldığı için COUNT(*) 1 dönerken COUNT(m.id) doğru olarak 0 döndü.