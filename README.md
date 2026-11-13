# Marketing Analysis
### Dari SQL sampai Dashboard: SQL, Python, Excel, Power BI, dan Tableau

> Menganalisis performa 11 campaign iklan digital selama Februari 2021: kanal mana yang paling efisien, di tahap mana funnel bocor, dan ke mana anggaran sebaiknya dialihkan.

---

## Ringkasan Proyek

| | |
|---|---|
| **Peran analis** | Marketing Analyst |
| **Dataset** | Digital Marketing Metrics & KPIs (Kaggle) |
| **Periode** | 1-28 Februari 2021 (28 hari) |
| **Ukuran data** | 308 baris, 11 kolom (11 campaign × 28 hari) |
| **Tools** | SQL (SQLite), Python (pandas), Excel, Power BI, Tableau Public |

---

## 1. Pertanyaan Bisnis

1. Kategori kanal dan campaign mana yang punya ROAS (revenue ÷ biaya) tertinggi, dan mana yang rugi?
2. Seberapa efisien biaya tiap kanal: CPC, CPL, CPA?
3. Di tahap mana funnel paling bocor: impressions → clicks → leads → orders?
4. Bagaimana tren harian dan mingguan biaya dan revenue selama Februari?
5. Apakah perbedaan ROAS antar kanal nyata atau hanya kebetulan?
6. Kalau biaya ditambah, apakah hasilnya masih seefisien rata-ratanya (Marginal ROAS)?
7. Campaign mana yang sebaiknya di-scale, test, maintain, fix, atau cut?
8. Berapa potensi dampak realokasi anggaran, dengan rentang perkiraan yang jujur?

---

## 2. Data

- **Sumber:** https://www.kaggle.com/datasets/sinderpreet/analyze-the-marketing-spending
- **Kolom utama:** c_date, campaign_name, category (social, search, influencer, media), impressions, mark_spent (biaya marketing), clicks, leads, orders, revenue
- **Pembersihan:** nama campaign `facebOOK_tier2` diseragamkan, tanggal diubah ke tipe tanggal, dan 19 baris dengan revenue = 0 **ditandai, tidak dihapus**.

**Metrik utama**
- **ROAS** = revenue ÷ biaya
- **CPA** = biaya ÷ orders
- **CTR** = clicks ÷ impressions
- **Click to Lead** = leads ÷ clicks; **Lead to Order** = orders ÷ leads
- **Marginal ROAS** = perkiraan tambahan revenue per tambahan 1 biaya (dari kemiringan regresi per campaign)

---

## 3. Tools

| Tool | Dipakai untuk | Output |
|---|---|---|
| **SQL (SQLite)** | Agregasi metrik per kategori, campaign, dan minggu | `queries.sql` |
| **Python (pandas, numpy)** | Pipeline dengan validasi, EDA, Marginal ROAS, uji bootstrap, segmentasi campaign, simulasi realokasi anggaran | `analysis.ipynb`, `campaign_summary.csv` |
| **Excel** | PivotTable dengan Calculated Field (ROAS, CPA, CTR), slicer, dan sheet ringkasan untuk validasi angka | `marketing_analysis.xlsx` |
| **Power BI** | Dashboard interaktif: KPI, tren harian, ROAS per campaign berwarna sesuai aksi, funnel | `dashboard.pbix` |
| **Tableau Public** | Visualisasi ROAS, funnel, dan tren yang dipublikasikan | Link Tableau Public |

---

## 4. Insight

### Insight 1: Social boros, influencer unggul
Total biaya **30.590.880** menghasilkan revenue **42.889.366** (ROAS **1,40**, CPA **3.803**).

| Kategori | Biaya | Revenue | Porsi biaya | Porsi revenue | ROAS | CPA |
|---|---|---|---|---|---|---|
| Influencer | 8.305.304 | 21.119.887 | 27,1% | **49,2%** | **2,54** | 2.756 |
| Media | 5.026.675 | 6.152.960 | 16,4% | 14,4% | 1,22 | 3.210 |
| Search | 3.460.400 | 3.705.065 | 11,3% | 8,6% | 1,07 | 4.179 |
| Social | 13.798.501 | 11.911.454 | **45,1%** | 27,8% | **0,86** | 5.237 |

- **Social menyerap 45,1% biaya tetapi hanya menghasilkan 27,8% revenue**, dan satu-satunya kategori dengan ROAS di bawah 1.
- **Influencer** menghasilkan hampir separuh revenue (49,2%) dengan 27,1% biaya.

### Insight 2: Satu campaign menyumbang sepertiga revenue, lima campaign merugi
| Campaign | Kategori | Porsi biaya | ROAS | CPA | Aksi |
|---|---|---|---|---|---|
| youtube_blogger | Influencer | 13,3% | **3,77** | 2.120 | Scale |
| facebook_retargeting | Social | 0,9% | 2,01 | 2.467 | Test |
| google_hot | Search | 3,9% | 1,84 | 4.270 | Test |
| instagram_tier1 | Social | 8,4% | 1,77 | 3.384 | Scale |
| instagram_blogger | Influencer | 13,9% | 1,37 | 3.861 | Maintain |
| banner_partner | Media | 16,4% | 1,22 | 3.210 | Maintain |
| facebook_tier1 | Social | 8,4% | 0,93 | 5.411 | Fix |
| facebook_tier2 | Social | 15,3% | 0,74 | 6.822 | Fix |
| google_wide | Search | 7,4% | 0,66 | 4.132 | Fix |
| instagram_tier2 | Social | 3,5% | 0,63 | 3.406 | Fix |
| facebook_lal | Social | 8,6% | **0,11** | **8.986** | Cut |

- **`youtube_blogger`** menghasilkan **35,7%** revenue dengan 13,3% biaya.
- **Lima campaign ber-ROAS di bawah 1** (`facebook_tier1`, `facebook_tier2`, `google_wide`, `instagram_tier2`, `facebook_lal`) menyerap **43,2%** biaya tetapi hanya menghasilkan **19,4%** revenue.
- **`facebook_lal`** adalah yang terburuk: ROAS 0,11 dan CPA 8.986 (sekitar 2,4× CPA rata-rata).
- Campaign dari platform yang sama bisa berbeda jauh: `facebook_retargeting` ROAS 2,01, sedangkan `facebook_lal` hanya 0,11.

### Insight 3: Funnel bocor di tahap lead-to-order, bukan di trafik
| Kategori | CTR | Click to Lead | Lead to Order |
|---|---|---|---|
| Influencer | 0,96% | 2,26% | **17,79%** |
| Media | 0,04% | 2,42% | 15,43% |
| Search | 0,46% | 2,15% | 11,65% |
| Social | 0,42% | 2,09% | **8,40%** |
| **Total** | 0,19% | 2,19% | 12,26% |

- **Click to Lead hampir seragam** di semua kategori (2,09-2,42%), tetapi **Lead to Order bervariasi lebar** (8,40-17,79%). Perbedaan efisiensi lebih banyak ditentukan oleh kemampuan menutup prospek, bukan oleh volume klik.
- **`instagram_tier2`** punya Lead to Order terendah (**3,02%**), padahal ia menghasilkan banyak leads. Tertinggi: **`facebook_retargeting` (21,34%)**, yang juga punya CTR tertinggi (3,07%).
- Korelasi biaya dengan revenue **0,76**; orders dengan revenue **0,94**.

### Insight 4: Biaya menumpuk di enam hari, tetapi ROAS harian tetap stabil
| Minggu | Biaya | Revenue | ROAS |
|---|---|---|---|
| 5 (1-7 Feb) | 4.897.446 | 7.271.655 | 1,48 |
| 6 (8-14 Feb) | 7.052.815 | 9.778.635 | 1,39 |
| 7 (15-21 Feb) | 17.298.180 | 23.886.110 | 1,38 |
| 8 (22-28 Feb) | 1.342.440 | 1.952.966 | 1,45 |

- Biaya naik sejak awal Februari dan **memuncak pada 15-20 Februari: 55,6% dari seluruh biaya dalam enam hari** (puncak 20 Februari: 3.499.172). Setelah 21 Februari biaya anjlok, dengan hari tertinggi hanya 583.694.
- **ROAS harian berkisar 1,11-1,95** dan ROAS mingguan stabil (1,38-1,48). Jadi perbandingan mingguan mencerminkan **jadwal anggaran**, bukan naik-turunnya performa.
- Ada **19 baris campaign-hari tanpa order**, dengan total biaya **20.299 (0,07% dari total biaya)**, jadi bukan sumber kerugian utama.

### Insight 5: Tambahan biaya di campaign terbaik cenderung kurang efisien
| Campaign | ROAS rata-rata | Marginal ROAS | Marginal ÷ rata-rata |
|---|---|---|---|
| youtube_blogger | 3,77 | 3,25 | 0,86× |
| facebook_retargeting | 2,01 | 1,60 | 0,80× |
| facebook_lal | 0,11 | 0,13 | 1,11× |

- Untuk **dua campaign terbaik**, Marginal ROAS lebih rendah dari rata-ratanya. Artinya menambah biaya di sana kemungkinan menghasilkan lebih sedikit dari performa rata-ratanya. Campaign lain berada dekat 1× (0,90-1,04×).
- Pola yang sama terlihat di seluruh data: ROAS saat biaya harian **rendah 1,67**, **sedang 1,45**, dan **tinggi 1,38** (dibagi per campaign). Ini konsisten dengan tanda *diminishing returns*.
- *Catatan: ini estimasi dari hubungan data. Biaya dan revenue sama-sama naik di pertengahan Februari, sehingga waktu atau permintaan ikut berpengaruh.*

### Insight 6: Influencer jelas lebih baik; social tidak pernah jelas di atas 1
| Kategori | Rentang ROAS 95% (bootstrap) |
|---|---|
| Influencer | 2,07-3,09 |
| Media | 1,13-1,33 |
| Search | 0,86-1,35 |
| Social | 0,73-1,01 |

- Rentang **influencer tidak tumpang tindih** dengan kategori lain, jadi keunggulannya meyakinkan.
- Rentang **social** tidak pernah jelas melewati 1, dan berada di bawah media.
- Search dan media masih **tumpang tindih** dengan social atau satu sama lain, jadi perbedaannya belum meyakinkan.

### Insight 7: Segmentasi aksi
| Aksi | Campaign | Porsi biaya | Porsi revenue | ROAS |
|---|---|---|---|---|
| Scale | youtube_blogger, instagram_tier1 | 21,7% | **46,3%** | **3,00** |
| Test | facebook_retargeting, google_hot | 4,8% | 6,4% | 1,87 |
| Maintain | instagram_blogger, banner_partner | 30,3% | 27,9% | 1,29 |
| Fix | facebook_tier1, facebook_tier2, google_wide, instagram_tier2 | **34,6%** | 18,7% | 0,76 |
| Cut | facebook_lal | 8,6% | 0,7% | 0,11 |

Batas label: ROAS < 0,5 = Cut; 0,5-1,0 = Fix; 1,0-1,5 = Maintain; ≥ 1,5 dengan porsi biaya ≥ 5% = Scale; ≥ 1,5 dengan porsi biaya < 5% = Test. Batas ini adalah pertimbangan analis dan bisa diganti.

### Insight 8: Potensi realokasi anggaran
Skenario: menggeser sebagian biaya dari campaign ber-ROAS di bawah 1 ke tiga campaign ber-ROAS tertinggi.

| Biaya digeser | Perkiraan konservatif (Marginal ROAS) | Perkiraan optimistis (ROAS rata-rata) |
|---|---|---|
| 10% | +7,0% revenue | +8,1% |
| 20% | +14,0% | +16,3% |
| 30% | +21,0% | +24,4% |

Persentase dihitung terhadap total revenue (42.889.366).

> **Catatan dan keterbatasan**
> - Data hanya **28 hari (Februari 2021)**, jadi pola musiman dan tren jangka panjang tidak bisa dilihat.
> - `revenue` adalah pendapatan, **bukan profit**. ROAS di bawah 1 pasti merugi, tetapi ROAS di atas 1 belum tentu untung.
> - Marginal ROAS dan skenario realokasi adalah **perkiraan dari hubungan data**, bukan hasil eksperimen. Skenario mengasumsikan hubungan biaya-revenue stabil, sehingga hasil nyata bisa lebih rendah.
> - Bootstrap memperlakukan tiap baris sebagai pengamatan bebas, padahal hari-hari berdekatan saling berkaitan, sehingga rentangnya kemungkinan terlalu sempit.
> - Tidak ada atribusi antar kanal, data demografi, atau satuan mata uang yang jelas (angka ditampilkan tanpa simbol mata uang).
> - Data terlalu kecil (308 baris) untuk model prediksi, sehingga tidak dibuat. Dataset ini adalah dataset latihan, bukan data bisnis nyata.

---

## 5. Rekomendasi

1. **Scale bertahap `youtube_blogger` dan `instagram_tier1`.** Keduanya menghasilkan 46,3% revenue dengan 21,7% biaya (ROAS 3,00). Naikkan anggaran sedikit demi sedikit dan pantau, karena Marginal ROAS `youtube_blogger` (3,25) lebih rendah dari rata-ratanya (3,77).
2. **Hentikan `facebook_lal`.** ROAS 0,11 dan CPA 8.986 dengan 8,6% biaya, tetapi hanya 0,7% revenue.
3. **Perbaiki atau kurangi empat campaign berlabel Fix** (`facebook_tier2`, `facebook_tier1`, `google_wide`, `instagram_tier2`). Mereka menyerap 34,6% biaya dan hanya menghasilkan 18,7% revenue. Mulailah dari `facebook_tier2` (15,3% biaya, ROAS 0,74), dan tinjau seluruh kategori **social** yang menyerap 45,1% biaya dengan ROAS 0,86.
4. **Perbaiki tahap lead-to-order.** Click to Lead relatif seragam, jadi masalahnya ada di menutup prospek. Prioritaskan `instagram_tier2` (3,02% vs rata-rata 12,26%) dan social secara umum (8,40%): perbaiki follow-up prospek, kualitas landing page, dan penawaran.
5. **Uji tambah anggaran kecil pada `facebook_retargeting` dan `google_hot`.** ROAS 2,01 dan 1,84 dengan hanya 4,8% biaya. Naikkan bertahap karena Marginal ROAS `facebook_retargeting` (1,60) lebih rendah dari rata-ratanya.
6. **Geser anggaran secara bertahap, mulai 10%** dari campaign Fix dan Cut ke campaign Scale dan Test, lalu ukur ulang. Perkiraannya +7,0% sampai +8,1% revenue per 10% biaya yang digeser.
7. **Tinjau pola jadwal anggaran.** 55,6% biaya terkonsentrasi dalam enam hari lalu anjlok. ROAS harian tetap stabil, tetapi data ini belum cukup untuk menyimpulkan apakah penyebaran yang lebih merata akan lebih efisien, jadi uji dulu sebelum mengubah pola.

---

## 6. Hasil & Link

| Tool | Link / File |
|---|---|
| Query SQL | `queries.sql` |
| Notebook Python | `analysis.ipynb` |
| Excel | `marketing_analysis.xlsx` |
| Power BI | `dashboard.pbix` + screenshot di `images/` |
| Tableau Public | [Marketing Dashboard](tempel-link-tableau-di-sini) |

---
