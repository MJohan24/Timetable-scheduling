# Desain Wake Word Asisten

## Tujuan

Mengaktifkan percakapan suara nyata pada halaman Asisten. Saat mode wake word
aktif dan pengguna mengucapkan "Halo Asisten", aplikasi membalas melalui TTS:
"Halo, kamu mau melakukan perjalanan ke mana?", lalu mendengarkan jawaban dan
mengirim transkripnya ke alur assistant backend yang sudah ada.

## Batasan

- Wake word hanya aktif ketika halaman Asisten terbuka dan aplikasi berada di
  foreground.
- Tidak ada perekaman atau pengenalan suara di background.
- Tombol mikrofon tetap dapat memulai percakapan tanpa wake word.
- Bahasa awal mengikuti locale aplikasi, dengan fokus verifikasi `id-ID`.
- TTS harus berhenti sebelum speech recognition dimulai agar suara aplikasi tidak
  memicu wake word sendiri.

## Arsitektur

Tambahkan abstraksi voice service yang menyediakan inisialisasi, mendengarkan,
berhenti mendengarkan, membacakan teks, menghentikan TTS, dan status ketersediaan.
Implementasi produksi memakai `speech_to_text` untuk input dan `flutter_tts`
untuk output. `AssistantController` mengatur state percakapan, sedangkan
`AssistantPage` meneruskan transkrip akhir ke `AssistantConversationController`.

## Alur

1. Switch wake word menginisialisasi mikrofon dan mulai mendengarkan.
2. Hasil parsial dinormalisasi dan diperiksa terhadap frasa "halo asisten".
3. Setelah terdeteksi, recognizer berhenti dan TTS membacakan pertanyaan tujuan.
4. Sesudah TTS selesai, recognizer mendengarkan jawaban tujuan.
5. Transkrip final dikirim melalui callback ke conversation controller.
6. Jawaban backend ditampilkan dan dibacakan melalui TTS.
7. Setelah jawaban selesai, mode kembali mendengarkan wake word jika switch masih
   aktif dan halaman masih foreground.

## Error dan Lifecycle

Izin mikrofon ditambahkan pada Android. Izin ditolak, recognizer tidak tersedia,
timeout tanpa ucapan, dan kegagalan TTS menghasilkan state error yang dapat dicoba
ulang. Saat aplikasi inactive/paused atau halaman ditutup, recognizer dan TTS
dihentikan. Saat resumed, wake word hanya dilanjutkan bila switch masih aktif.

## Pengujian

- Unit test deteksi wake word yang tidak sensitif kapitalisasi/tanda baca.
- Unit test urutan listen wake word, prompt TTS, listen tujuan, dan callback.
- Unit test TTS berhenti sebelum recognizer aktif.
- Widget test lifecycle dan switch wake word.
- Test izin/ketidaktersediaan yang menghasilkan error recoverable.
- Uji perangkat Android fisik untuk permission, pengenalan `id-ID`, TTS, respons
  backend, serta penghentian mikrofon saat aplikasi masuk background.
