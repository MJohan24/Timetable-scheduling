# Laporan Import Timetable Commuter Line 2026-02

Tanggal pelaksanaan: 1 September 2026  
Backend: Render Web Service `timetable-scheduling-api-mjohan`  
Database: PostgreSQL Neon yang dikonfigurasi melalui `DATABASE_URL` Render

## Ruang Lingkup

Dataset hanya mencakup KRL Commuter Line Jabodetabek:

- Bogor, termasuk cabang Nambo
- Cikarang
- Rangkasbitung
- Tangerang
- Tanjung Priok

Tidak ada jadwal MRT, LRT, kereta bandara, atau jadwal dummy yang dimasukkan.

## Pemeriksaan Sebelum Import

- File lampiran dan `prisma/data/commuter-2026-02.json` memiliki SHA-256 yang sama.
- Importer, pemetaan kode stasiun, dan schema lampiran semantik-identik dengan repo.
- Enam migration Prisma sudah diterapkan; tidak ada migration tertunda.
- Dataset `2026-02` sebelumnya sudah aktif dengan sumber dan jumlah yang sama.
- Seluruh 85 stasiun dan tujuh geometry line yang dibutuhkan tersedia.
- Backup dataset aktif dibuat di luar repository sebelum import ulang.
- Seed penuh tidak dijalankan.

Hitungan tabel yang harus dipertahankan sebelum import:

| Tabel | Jumlah |
|---|---:|
| User | 0 |
| Ticket | 4 |
| Payment | 4 |
| AuthSession | 0 |
| Reminder | 0 |
| Report | 0 |
| RouteConnection | 292 |

## Perintah

```powershell
npx prisma migrate deploy
npm run timetable:import
```

Hasil importer:

```text
Imported 2026-02: 1145 services, 19328 stops (active).
```

Importer mengganti dataset versi `2026-02` dan data turunannya dalam satu
transaksi. Tabel akun, tiket, pembayaran, reminder, laporan, dan koneksi rute
tidak menjadi bagian operasi tersebut.

## Hasil Verifikasi Database

| Pemeriksaan | Hasil |
|---|---:|
| Dataset aktif | `2026-02` |
| Zona waktu | `Asia/Jakarta` |
| TrainService | 1.145 |
| TrainStopTime | 19.328 |
| Catatan melintas | 343 |
| ServiceCalendar | 2 |
| Referensi stasiun valid | 19.328 dari 19.328 |
| Nomor KA duplikat | 0 |
| Dataset aktif bersamaan | 1 |

Jumlah layanan per kelompok:

| Kelompok | Jumlah |
|---|---:|
| Bogor | 392 |
| Cikarang | 365 |
| Rangkasbitung | 204 |
| Tangerang | 120 |
| Tanjung Priok | 64 |

Tabel yang tidak boleh disentuh tetap berjumlah sama setelah import: empat
tiket, empat pembayaran, dan 292 koneksi rute.

## Pencocokan Sampel

- KA `1151`: metadata, 21 stop, urutan, waktu, dan penanda melintas cocok.
- KA `1153F`: akhiran huruf tersimpan dan seluruh 21 stop cocok.
- KA `1469`: waktu lewat tengah malam tersimpan sampai menit 1.477.
- KA `2265`: urutan Tanjung Priok sampai Jakarta Kota dan seluruh waktu cocok.

## Pengujian API

Request:

```text
GET /api/v1/schedules?station=Manggarai&limit=10
```

Hasil:

- HTTP `200`
- `success: true`
- 10 jadwal dikembalikan
- `meta.total: 634`
- `meta.datasetVersion: 2026-02`
- Nomor KA dengan akhiran huruf, seperti `1153F`, tampil melalui API

Endpoint `/ready` juga mengembalikan HTTP `200` dengan database berstatus
`connected`.

## Biaya Render

`render.yaml` tetap menggunakan `plan: free`. Proses ini tidak membuat service,
database, disk, worker, atau cron job Render tambahan.
