# Tugas PBM 2026 - Katalog Produk Flutter

Aplikasi Flutter untuk tugas Praktikum Pemrograman Berbasis Mobile 2026.

## Screenshot Aplikasi
<img width="552" height="835" alt="Login" src="https://github.com/user-attachments/assets/26d08e6e-a78e-4657-9c2d-8f632a1abb74" />
<img width="600" height="828" alt="Tambah produk" src="https://github.com/user-attachments/assets/926f08ea-cb35-4231-b872-972784046b5e" />
<img width="535" height="817" alt="Tampilan Awal" src="https://github.com/user-attachments/assets/3a2a6997-4a3d-4dbc-9988-f94d59dbfe45" />
<img width="549" height="826" alt="Tampilan produk yg ditambahkan" src="https://github.com/user-attachments/assets/b76ef8c9-bf3c-4d95-a4dc-8d0b37ed00fe" />


> Letakkan screenshot tampilan aplikasi di folder ini (root project).

| Login Screen | Home / Katalog | Tambah Produk | Submit Tugas |
|---|---|---|---|
| *(screenshot_login.png)* | *(screenshot_home.png)* | *(screenshot_add.png)* | *(screenshot_submit.png)* |

## Fitur

- Login menggunakan NIM dan password
- Melihat daftar draft produk milik sendiri
- Menambah produk baru (nama, harga, deskripsi)
- Menghapus produk (soft delete)
- Submit tugas beserta link GitHub repository

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

## Tech Stack

- Flutter 3.x
- Dart
- HTTP package untuk request API
- Flutter Secure Storage untuk menyimpan token
- Google Fonts (Poppins)

## API

Base URL: `https://task.itprojects.web.id`

| Method | Endpoint | Keterangan |
|---|---|---|
| POST | `/api/auth/login` | Login & ambil token |
| GET | `/api/products` | Lihat daftar produk |
| POST | `/api/products` | Tambah produk baru |
| DELETE | `/api/products/:id` | Hapus produk |
| POST | `/api/products/submit` | Submit tugas |
