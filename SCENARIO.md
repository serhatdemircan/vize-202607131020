# Kura #21: Tarım x Öneri Motoru x Model Performans Karşılaştırması

## 1. Problem Tanımı ve Hikâye
Bir gübre ve tohum tedarikçisi, çiftçilerin tarla koşullarına ve mahsul türlerine göre en uygun tarımsal girdileri seçebilmesi için yapay zekâ destekli bir öneri motoru kullanmaktadır[cite: 31, 58]. Sistem bünyesinde önerileri üreten iki farklı makine öğrenmesi modeli (Model A ve Model B) test edilmektedir[cite: 31, 58]. Şirket yönetimi, hangi modelin önerdiği ürünlerin gerçekte daha yüksek oranda satın alındığını ve hangi modelin iade oranlarının daha düşük olduğunu ölçerek daha verimli olan modeli belirlemek istemektedir[cite: 31, 58].

## 2. Ana Soru
İki modelin önerdiği ürünlerde satın alma oranı ve iade oranı arasında anlamlı bir fark var mı?[cite: 31, 58]

## 3. Hedef Kullanıcı ve Sistem Bileşenleri
* **Hedef Kullanıcılar:** Tarımsal girdi (tohum, gübre, ilaç) tedarik eden çiftçiler ve sistemin operasyonel verimliliğini izleyen tedarikçi veri analiz ekibi[cite: 31, 58].
* **Sistem:** Çiftçinin bölge ve tarımsal ihtiyaçlarına göre ürün listesi oluşturan öneri motoru[cite: 31, 58].
* **YZ Bileşeni (Model Performans Karşılaştırması):** İki farklı öneri algoritmasının (Model A ve Model B) satın alma dönüşümü ve iade metrikleri üzerinden kıyaslanması[cite: 31, 58]. Dönem sonunda modelin önerdiği ürünle gerçek satın alma arasındaki ilişkiyi izleyen bir geri bildirim döngüsü kurulacaktır[cite: 32].

## 4. Karıştırıcı Değişkenler (Confounding Variables) ve Riskler
* **Satın Alınmama Durumu ≠ Kötü Öneri:** Bir önerinin satın alınmamış olması, o önerinin teknik olarak başarısız veya hatalı olduğu anlamına gelmez[cite: 32, 58]. Ürünün o anki stok durumu, piyasa fiyat artışları, nakit akışı, çiftçinin bütçesi veya mevsimsel hava şartları gibi dışsal faktörler de satın alma kararını doğrudan etkiler[cite: 31, 32, 58].
* **İade Kayıtlarının Yorumlanması:** İade tablosunda (`iadeler`) bir satışa ait satır bulunmaması, o ürünün iade edilmediği anlamına gelir; bu durum veri eksikliği (`NULL`) ile karıştırılmamalıdır[cite: 31].

## 5. Tablo Adayları ve Kolonları
* **`recommendations`** `(id, model_name, product_id, recommended_at, region)` — Öneri motorundaki modellerin ürettiği ürün tavsiyeleri, öneri zamanı ve tarımsal bölge kayıtları[cite: 31].
* **`sales`** `(id, recommendation_id, was_purchased, amount_try)` — Önerilerin satın almaya dönüşüp dönüşmediği ve Türk Lirası cinsinden satış tutarı bilgileri[cite: 31].
* **`iadeler`** `(id, sale_id, return_reason, returned_at)` — Gerçekleşen satışlar arasından iade edilen ürünlerin iade nedeni ve iade tarihi kayıtları[cite: 31].

## 6. Veri Kaynağı Adayları ve Veri Gereksinimleri
* **Kaggle Datasets:** `"agricultural products"`, `"fertilizer sales"` ve `"crop recommendation"` aramaları ile tarımsal ürün ve satış verileri[cite: 8, 31].
* **Hugging Face Datasets:** `"recommendation"` araması ile öneri sistemi etkileşim ve değerlendirme kayıtları[cite: 8, 31].
* **Open-Meteo:** Öneri zamanlarıyla mevsimsel hava koşullarını karşılaştırmak için il bazlı tarihsel meteoroloji verileri[cite: 8, 31].
* **Asgari Veri Kuralı:** Veri seti en az 500 öneri satırı, en az 4 sayısal sütun ve en az 1 tarih/zaman sütunu içerecek şekilde yapılandırılmıştır[cite: 7, 31].