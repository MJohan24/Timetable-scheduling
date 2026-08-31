# Handoff OpenCode — Assistant Natural Route Chat

## Tujuan

Perbaiki chat asisten KAI Metro Access agar memahami cara bicara pengguna secara natural, tetap memakai rute dari backend, dan tidak menghabiskan kuota Gemini dengan request classifier tambahan.

## Bug yang terlihat

Pengguna mengetik:

> Halo, aku mau ke Jakarta kota dari bintaro

Asisten membalas:

> Aku belum menemukan rute itu. Coba tulis nama stasiun asal dan tujuan lengkap...

Ini terasa kaku dan berbeda dari perilaku chat sebelumnya yang lebih hangat.

## Akar masalah terverifikasi

- Parser sudah berhasil membaca pola tujuan-dulu: `mau ke Jakarta Kota dari Bintaro`.
- `Bintaro` bukan entitas stasiun boarding di database/network KRL saat ini.
- `RouteService.planRoute('Bintaro', 'Jakarta Kota')` menghasilkan `ApiError` dengan kode `STATION_NOT_FOUND`.
- `RouteService.planRoute('Pondok Ranji', 'Jakarta Kota')` berhasil.
- Jadi masalah utama bukan Gemini atau format chat, melainkan area `Bintaro` diperlakukan sebagai nama stasiun lalu error dikembalikan sebagai template kaku.

## Perilaku yang diinginkan

### 1. Rute dengan dua stasiun valid

Contoh:

```text
Aku mau ke Jakarta Kota dari Pondok Ranji, naik apa ya?
```

Backend harus:

1. Ekstrak asal dan tujuan secara lokal.
2. Validasi keduanya lewat `RouteService`.
3. Hitung rute lewat backend.
4. Kirim satu request Gemini dengan fakta rute backend.
5. Tampilkan jawaban hangat, ringkas, dan tidak mengubah stasiun, transit, durasi, atau tarif.

### 2. Area atau lokasi bukan stasiun

Contoh:

```text
Aku mau ke Jakarta Kota dari Bintaro
```

Jangan tampilkan `STATION_NOT_FOUND` atau meminta format baku. Tampilkan klarifikasi natural, misalnya:

```text
Kalau dari kawasan Bintaro, kamu berangkat dari stasiun KRL mana? Misalnya Pondok Ranji atau Jurangmangu 🚆 Setelah pilih stasiunnya, aku carikan rute ke Jakarta Kota.
```

Catatan: jangan mengklaim Bintaro sebagai stasiun. Pilihan stasiun harus berasal dari data aplikasi atau daftar stasiun terdekat yang memang tersedia.

### 3. Hanya menyebut lokasi

Contoh:

```text
Aku lagi di Bintaro nih
```

Jawab natural dan tanyakan tujuan atau stasiun keberangkatan yang diperlukan. Jangan membuat rute, menyebut jalur, atau menampilkan daftar langkah sebelum tujuan jelas.

### 4. Follow-up dalam sesi yang sama

Contoh:

```text
Pengguna: Aku lagi di Pondok Ranji
Asisten: Mau menuju stasiun mana?
Pengguna: Jakarta Kota
```

Backend harus memakai `Pondok Ranji` sebagai asal dari riwayat user terakhir, lalu menghitung rute ke `Jakarta Kota`.

## Batasan kuota Gemini

- Satu request Gemini maksimal untuk setiap pesan pengguna.
- Jangan memakai Gemini sebagai intent classifier kedua.
- Ekstraksi konteks, pembersihan filler, dan validasi rute dilakukan lokal/backend.
- Riwayat chat sementara dibatasi 6 giliran terakhir.
- Jangan menyimpan isi chat atau gambar ke Neon.

## Implementasi yang sudah ada

Commit terakhir terkait asisten: `352ef5f feat: understand natural assistant route phrasing`.

File utama:

- `timetable_backend/src/domain/services/assistantService.ts`
  - Ekstraksi pola `dari A ke B`.
  - Ekstraksi pola `mau ke B dari A`.
  - Dukungan asal dari frase `di`, `lagi di`, dan `berangkat dari` pada riwayat.
  - Pembersihan filler percakapan.
  - Prompt hangat dan aturan KRL-only.
  - Fakta rute tetap berasal dari `RouteService`.
- `timetable_backend/src/presentation/controllers/assistantController.ts`
  - Validasi riwayat maksimal 6 giliran.
- `lib/features/assistant/presentation/controllers/assistant_conversation_controller.dart`
  - Mengirim maksimal 6 giliran sebelum pesan aktif.
- `test/assistant_conversation_controller_test.dart`
  - Tes urutan riwayat dan batas 6 giliran.
- `timetable_backend/tests/assistantService.test.ts`
  - Tes parser natural, filler, follow-up, prompt, dan validasi payload.

## Perubahan yang perlu dilanjutkan

1. Pisahkan error `STATION_NOT_FOUND` yang terjadi karena area/lokasi dari error rute lain.
2. Untuk lokasi yang bukan stasiun, kembalikan klarifikasi natural yang menyebut bahwa pengguna perlu memilih stasiun KRL.
3. Jika tersedia data koordinat/lokasi pengguna, gunakan daftar stasiun terdekat dari data aplikasi; jangan menebak stasiun.
4. Jangan jalankan `GoogleGenAI` lagi setelah route lookup gagal karena lokasi belum menjadi stasiun. Klarifikasi dapat dibuat deterministik agar hemat kuota.
5. Tambahkan regression test untuk:
   - `Bintaro` menghasilkan klarifikasi natural, bukan template error.
   - `Pondok Ranji → Jakarta Kota` tetap menghasilkan route context backend.
   - `mau ke Jakarta Kota dari Bintaro, kira-kira naiknya apa ya` tidak meminta format baku.
   - lokasi-only tidak membuat rute.
6. Jalankan:

```text
cd timetable_backend
npm test
npm run build
cd ..
flutter test
flutter analyze
```

## Catatan kerja aman

- Jangan menimpa perubahan UI/map/performance lain yang sedang dirty di worktree.
- Jangan mencetak isi `.env` atau API key.
- Jangan mengubah layout map untuk memperbaiki chat ini.
- Setelah perubahan Flutter, lakukan hot restart emulator agar bundle terbaru terbaca.
- Verifikasi endpoint emulator memakai base URL `http://10.0.2.2:3000/api/v1` jika backend berjalan lokal.
