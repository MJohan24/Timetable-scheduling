# Pengujian performa 200 ms

Target pengujian: setiap respons sukses **kurang dari 200 ms**. Respons error,
data kosong, dan jadwal yang tidak memakai dataset Commuter Line Februari 2026
tidak dianggap lolos. Rata-rata atau p95 di bawah batas saja tidak cukup.

## Menjalankan

Dari folder `timetable_backend`, jalankan backend hasil build pada terminal pertama:

```powershell
npm run build
$env:PERFORMANCE_METRICS = "true"
npm start
```

Jika port 3000 sedang dipakai, tetapkan `$env:PORT = "3011"` sebelum `npm start`,
lalu sesuaikan `--base` di terminal kedua. Tidak perlu mengubah `.env`.

```powershell
npm run benchmark -- --base http://127.0.0.1:3000/api/v1 --rounds 5
```

Enam skenario diuji berurutan: daftar stasiun (limit 200), pencarian stasiun,
rute langsung Bogor-Jakarta Kota, pindah jalur Cikini-BNI City, berjalan kaki
Cikoko-Tebet, dan jadwal KRL Manggarai (limit 100, hari kerja).
Tidak ada pemesanan, perubahan database, panggilan AI, atau pembayaran.
Pemeriksaan membutuhkan katalog dan dataset yang sudah diimpor; benchmark
tidak menjalankan seed/migration.

Mode berulang sampai dihentikan:

```powershell
npm run benchmark -- --base http://127.0.0.1:3000/api/v1 --continuous
```

Mode ini memberi jeda minimal 10 detik antar-request, menyimpan laporan setiap
batch 5 putaran, lalu mengosongkan sampel di memori. Ctrl+C menyimpan batch parsial.
Rate limit backend tetap 100 request per 15 menit; HTTP 429 menghentikan benchmark
tanpa retry atau bypass. Request lain dari IP sama masih dapat menghabiskan kuota.
Pengujian juga berhenti pada masalah koneksi/timeout agar tidak terus membebani
layanan bermasalah. Jangan menjalankan mode berulang tanpa pengawasan.

Opsi: `--rounds`, `--threshold` (ms), `--interval` (ms), `--timeout` (ms), `--out`.
Default: 5 putaran, batas 200 ms, jeda 1 detik (10 detik untuk mode berulang),
timeout 15 detik, dan satu request aktif. Mode terbatas default menghasilkan
30 request. Exit code 0 berarti seluruh sampel dalam batch lengkap lolos;
1 berarti lambat, gagal, atau tidak selesai; 2 berarti masalah konfigurasi/script.
Dalam mode berulang, kegagalan batch sebelumnya tetap membuat exit code 1.

## Arti pengukuran

- `elapsedMs`: waktu klien Node dari sebelum fetch sampai body diterima dan JSON
  dibaca. Termasuk jaringan, backend, database, dan pengiriman respons. Tidak
  termasuk render Flutter atau waktu perangkat Android.
- `handler`: waktu server dari middleware hingga pemanggilan `res.json`, termasuk
  menunggu database. Tidak termasuk serialisasi JSON dan pengiriman body. Ini
  wall time, bukan pengukuran CPU per-request.
- `station_query`: query katalog stasiun dan relasi beserta hitungan total.
- `station_lookup` / `graph_load`: resolusi kedua stasiun / pembacaan graf rute.
- `dijkstra`: membentuk adjacency, pencarian shortest path, rekonstruksi path.
  Tidak termasuk query database, penyusunan timeline, dan serialisasi respons.
- `schedule_catalog`: lookup stasiun dan dataset aktif.
- `schedule_query`: query jadwal, relasi, dan hitungan total.
- `schedule_format`: pembuatan DTO jadwal, termasuk query aturan peron existing.

Rincian server dikirim melalui `Server-Timing` hanya ketika
`PERFORMANCE_METRICS=true`; payload mobile tetap sama. Fase berada di dalam waktu
handler, jadi **jangan menjumlahkan handler dengan fase-fasenya**. Matikan flag
setelah pengujian jika rincian internal tidak perlu diekspos.

CSV berisi setiap sampel dan fase waktunya. JSON berisi konfigurasi, setiap
sampel, rata-rata, maksimum, p95 nearest-rank, jumlah error, serta jumlah durasi
yang mencapai/melebihi batas. Statistik durasi ringkas menggunakan sampel sukses;
error tetap dihitung dan menggagalkan hasil. Sampel pertama tetap disertakan.
`firstMs` bukan bukti cold start: database mungkin sudah aktif.
P95 pada hanya 5 sampel sama dengan maksimum; gunakan pengujian lebih panjang
yang menghormati rate limit untuk kesimpulan yang lebih kuat.

Laporan tersimpan di `reports/performance/` (diabaikan Git). Setiap batch punya
nama unik, tidak menimpa laporan lama. Mode berulang tetap menambah file di disk;
pantau ruang penyimpanan. Laporan menyertakan alamat API, tanpa kredensial atau body
respons. Jangan memasukkan kredensial ke `--base`.

## Hasil awal: 1 September 2026 WIB

Backend hasil build berjalan lokal pada port 3011, database **Neon**, Node
v24.13.1 di Windows. Satu klien, lima putaran, jeda satu detik antar-request.
Tidak ada perubahan data, cache tambahan, atau bypass rate limit.
Identitas batch UTC: `2026-08-31T20-08-40-391Z-2d34faa8`.

| Skenario | Sampel | Rata-rata HTTP (ms) | Maksimum / p95 (ms) | >= 200 ms |
|---|---:|---:|---:|---:|
| Daftar stasiun | 5 | 2048.771 | 4413.268 | 5 |
| Cari stasiun | 5 | 1313.740 | 1658.644 | 5 |
| Rute langsung | 5 | 2312.272 | 3268.739 | 5 |
| Rute pindah jalur | 5 | 1422.400 | 1748.569 | 5 |
| Rute berjalan kaki | 5 | 1668.641 | 2258.528 | 5 |
| Jadwal KRL | 5 | 3085.676 | 4413.703 | 5 |

Seluruh 30 respons berhasil dan memuat data, seluruh 30 melampaui target.
Header pengukuran server tersedia pada seluruh sampel. **Target respons lengkap
200 ms belum terpenuhi.** Hasil ini bukan pengujian seluruh fitur aplikasi,
bukan pengukuran Render, dan bukan pengujian beban banyak pengguna.

Pada 15 pencarian rute, Dijkstra terukur **0.083-1.091 ms**, sementara pembacaan
graf **822.872-2044.570 ms**. Pada jadwal, rata-rata query jadwal/relasi
**1873.067 ms**, dan format/aturan peron **837.012 ms**. Katalog/search hampir
seluruh durasinya berada dalam fase query. Ini menunjukkan waktu dominan berada
di jalur pengambilan data, bukan algoritma Dijkstra. Fase query mencakup jaringan,
antrean koneksi, query SQL, dan pemrosesan Prisma; pengukuran ini belum memisahkan
kontribusi masing-masing, sehingga tidak membuktikan bahwa SQL saja lambat.

Langkah optimasi berdasarkan hasil ini: kurangi query peron per jadwal menjadi
batch, evaluasi pembacaan graf berulang beserta strategi pembaruan cache yang
benar, dan bandingkan deployment backend/database dalam lokasi yang berdekatan.
Setelah setiap perubahan, ulangi skenario/payload yang sama dan simpan hasil
sebelum-sesudah. Jangan mengganti data dengan dummy atau hanya melaporkan waktu
Dijkstra untuk mengklaim respons keseluruhan memenuhi 200 ms.
