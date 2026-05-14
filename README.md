# Tugas PBM 2026 - Katalog Produk Flutter

Aplikasi Flutter untuk tugas Praktikum Pemrograman Berbasis Mobile 2026.

## Screenshot Aplikasi

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
