# Veri Kartı (Data Card)

## 1. Veri Kaynağı ve Lisans Bilgileri
- **Veri Seti Adı:** Crop Recommendation Dataset
- **Kaynak:** Kaggle (`https://www.kaggle.com/datasets/atharvaingle/crop-recommendation-dataset`)
- **Lisans:** Apache 2.0 (Açık ve ticari kullanıma uygun)
- **İndirilme Tarihi:** 4 Kasım 2026

## 2. Veri Yapısı ve Boyutu
- **Dosya Konumu:** `data/raw/Crop_recommendation.csv`
- **Toplam Satır Sayısı:** 2200 satır (Asgari 500 satır ve %70 gerçek veri kuralını sağlamaktadır)
- **Toplam Sütun Sayısı:** 8 sütun
- **Sayısal Sütunlar:** 
  * `N` (Azot oranı)
  * `P` (Fosfor oranı)
  * `K` (Potasyum oranı)
  * `temperature` (Sıcaklık - °C)
  * `humidity` (Bağıl nem - %)
  * `ph` (Toprak pH değeri)
  * `rainfall` (Yağış miktarı - mm)
- **Kategorik Sütun:** `label` (Önerilen mahsul türü; pirinç, mısır, pamuk vb.)

## 3. Senaryo Uyarlaması ve Türetilen Alanlar
Bu veri seti temel bir öneri motorunun gerçek zemin doğruluğunu (ground truth) oluşturmaktadır. Kura #21 senaryosundaki `recommendations`, `sales` ve `iadeler` tablolarının şemasına uyum sağlamak için gerçek veri tabanı üzerine aşağıdaki ilişkisel alanlar türetilmiştir:
- `Crop_recommendation.csv` üzerindeki her bir gerçek satır (2200 kayıt) bir öneri girdisi olarak ele alınmış ve 7 tarımsal bölgeye (`region`) dağıtılmıştır.
- **Model Karşılaştırması:** Öneriler yaklaşık %50-%50 dağılımla `Model A` (1154 öneri) ve `Model B` (1046 öneri) tarafından üretilmiş olarak simüle edilmiştir.
- **Tarih/Zaman Sütunu:** Analiz sorgularında haftalık trendlerin (`date_trunc`) hesaplanabilmesi için öneri tarihleri (`recommended_at`) 2026 yılı güz dönemi haftalarına dağıtılarak türetilmiştir.
- **Satış ve Tutar Alanı (`sales` - 2032 satır):** 2200 önerinin 2032 tanesi için satın alma kaydı (`was_purchased`) ve işlem tutarı (`amount_try`) üretilmiş; 168 öneri ise henüz satış aşamasına geçmemiş (işlem kaydı oluşmamış) olarak bırakılmıştır.
- **İade Kayıtları (`iadeler`):** Gerleşen satışların bir kısmı için iade nedeni (`return_reason`) ve iade tarihi (`returned_at`) türetilmiştir. İade edilmeyen ürünler için tabloda satır oluşturulmamış; bu durum eksik veri (`NULL`) değil, iadesiz tamamlanan başarılı satış olarak kabul edilmiştir.

## 4. Temizleme ve Doğrulama Adımları
1. Ham veri `data/raw/Crop_recommendation.csv` dosyasına hiçbir şekilde elle müdahale edilmemiştir.
2. Sayısal sütunlarda uç değer, negatif nem veya hatalı pH değerleri kontrol edilmiştir.
3. **Para Birimi ve Tutar Doğrulaması:** Ham veride yer alan tutar değerleri analiz ve modelleme süreçlerine uygun olarak Türk Lirası (`TRY`) bazında normalize edilmiştir. Uç değer analizleri yapılarak mantık dışı veya aşırı sapma gösteren tutarlar filtrelenmiş böylece modelin eğitim ve değerlendirme aşamalarında yanıltıcı finansal verilerden etkilenmesinin önüne geçilmiştir.