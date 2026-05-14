import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../theme.dart';

class AddProductSheet extends StatefulWidget {
  final VoidCallback onSuccess;

  const AddProductSheet({super.key, required this.onSuccess});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final price = int.tryParse(
          _priceCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

    final ok = await ApiService.createProduct(
      name: _nameCtrl.text.trim(),
      price: price,
      description: _descCtrl.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambah produk.',
              style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tambah Produk',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
            Text(
              'Simpan produk ke draft katalog kamu.',
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.grey),
            ),
            const SizedBox(height: 22),
            _label('Nama Produk'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameCtrl,
              style: GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
              decoration:
                  const InputDecoration(hintText: 'Contoh: Macbook Pro M5 2026'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 14),
            _label('Harga (Rp)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
              decoration: const InputDecoration(hintText: 'Contoh: 32450000'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Harga wajib diisi';
                final parsed = int.tryParse(v.trim().replaceAll(RegExp(r'[^0-9]'), ''));
                if (parsed == null || parsed <= 0) return 'Harga tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _label('Deskripsi'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              style: GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
              decoration:
                  const InputDecoration(hintText: 'Deskripsikan produk kamu...'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Deskripsi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : Text(
                        'Simpan Produk',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.greyLight,
      ),
    );
  }
}
