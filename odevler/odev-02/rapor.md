# Ödev Raporu

> Bu rapor yazdırılıp derste elden teslim edilir. Aynı dosya reponda `odevler/odev-02/rapor.md` olarak da durur. Bir sayfa yeterli, en fazla iki. Bilgisayarda doldurup yazdırabilirsin, elle de doldurabilirsin.

---

**Ödev no:** Ödev 02 **Hafta:** 06 **Tarih:** 23 / 11 / 2026

**Ad Soyad:** Serhat Demircan **Öğrenci No:** 202607131020

**Program:** [x] Yapay Zeka Operatörlüğü [ ] Robotik ve Yapay Zeka

**Kullandığım veritabanı:** [ ] `llm_ops` [x] `robot_fleet`

**PR bağlantısı:** `https://github.com/serhatdemircan/vize-202607131020/pull/4`

**Commit sayısı:** 3

---

## 1. Fan-out

4. soruda `EXISTS` ile doğru hesaplanan toplam batarya **262** iken, `robots` ve `missions` tablolarını `INNER JOIN` ile birleştirdiğimizde toplam **700**'e çıktı. Çünkü birden fazla görevi olan robotların batarya değerleri görev satırı sayısı kadar tekrar toplandı: **Atlas-01** (82) **3 kez**, **Kartal-01** (18) **3 kez**, **Kartal-03** (91) **3 kez**, **Mars-01** (47) **2 kez**, **Mars-02** (9) **2 kez** sayılırken tek görevi olan **Atlas-02** (15) **1 kez** sayıldı. Gerçek bir şirket veya operasyon raporunda bu hata, eldeki toplam stok, bütçe, ciro veya enerji kapasitesinin olduğundan katbekat yüksek görünmesine yol açar; yöneticilerin yanlış kaynak planlaması yapmasına ve gerçekte olmayan bir kapasiteye güvenerek hatalı karar almasına neden olur.

## 2. En zor karar

Kura #21 (Tarım × Öneri Motoru) ERD'sini tasarlarken en çok düşündüğüm karar, iade bilgilerini (`return_reason`, `returned_at`) `sales` tablosunun içine sütun olarak mı ekleyeceğim yoksa ayrı bir `iadeler` tablosuna mı böleceğim ve bu iki tablo arasındaki kardinaliteyi (`1:0..1` mi `1:N` mi) nasıl kuracağım oldu. İade alanlarını `sales` tablosuna eklemek tek tabloda kolay sorgu avantajı sunsa da satışların büyük kısmı iade edilmediği için binlerce satırda gereksiz `NULL` tekrarına yol açacaktı. Bu nedenle `iadeler` tablosunu ayırıp `sales` ile arasında `1 : 0..1` ilişkisi kurmayı seçtim; böylece hem 3NF normalizasyonunu korudum hem de tabloda kayıt olmamasını (iadesiz başarılı satış) eksik veri (`NULL`) ile karışmadan `LEFT JOIN` üzerinden net biçimde analiz edebildim.

---

## 5. Yapay zeka kullanım beyanı

[ ] Bu ödevde yapay zeka aracı **kullanmadım**.

[x] Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
| :--- | :--- | :--- | :--- |
| Bölüm 1 (Soru 4–5) | Gemini | `JOIN` sonrası batarya toplamının şişme nedenini ve `COUNT(*)` farkını sordum. | Sorguları `psql` üzerinde `robot_fleet` veritabanında çalıştırdım, dönen satırları tek tek kontrol ettim. |
| Bölüm 2 (ERD & SQL) | Gemini | Kura #21 tabloları için Mermaid ERD sözdizimi ve 3NF normalizasyon kontrolü aldım. | Tablo ve sütun adlarını `SCENARIO.md` ve `data/README.md` ile karşılaştırarak doğruladım. |

> "Nasıl doğruladım" sütunu en önemlisi. "Çalıştırdım, 4 satır döndü, tabloyla karşılaştırdım" gibi somut bir şey yaz.

---

## 6. Öz değerlendirme

Rubriğe (`RUBRIK.md`) göre kendine bir seviye ver. Bu puanını etkilemez.

| Ölçüt | 4 Tam | 3 İyi | 2 Gelişmeli | 1 Yetersiz |
| :--- | :---: | :---: | :---: | :---: |
| A, Doğruluk | [x] | [ ] | [ ] | [ ] |
| B, SQL kalitesi | [] | [x] | [ ] | [ ] |
| C, Yorum ve analiz | [] | [x] | [ ] | [ ] |
| D, Git ve PR disiplini | [] | [x] | [ ] | [ ] |
| E, Dürüstlük ve beyan | [x] | [ ] | [ ] | [ ] |

**Bir dahaki ödevde daha iyi yapacağım şey:**
Sorgu yazmaya başlamadan önce tablolar arasındaki bire-çok (`1:N`) ilişkileri kâğıt üzerinde kontrol ederek `JOIN` kaynaklı satır çoğalması (fan-out) hatalarını baştan öngörmek.

---

## 7. Bana sorun

**Anlamadığın, merak ettiğin ya da derste tekrar görmek istediğin bir konu:**
Çok tablolu (`3` ve daha fazla tablo) sorgularda fan-out hatasına düşmeden hem ana tablo toplamlarını hem de alt tablo sayımlarını tek sorguda en temiz hangi yöntemle (`CTE` mi yoksa alt sorgu mu) birleştirmeliyiz?

**İmza:** Serhat

*Doğruluk beyanı: Bu çalışmayı kendim yaptım. Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*