import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../theme.dart';

class SubmitTaskSheet extends StatefulWidget {
  const SubmitTaskSheet({super.key});

  @override
  State<SubmitTaskSheet> createState() => _SubmitTaskSheetState();
}

class _SubmitTaskSheetState extends State<SubmitTaskSheet> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _githubCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _githubCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final price = int.tryParse(
          _priceCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

    final ok = await ApiService.submitTask(
      name: _nameCtrl.text.trim(),
      price: price,
      description: _descCtrl.text.trim(),
      githubUrl: _githubCtrl.text.trim(),
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.card,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.pink, size: 26),
              const SizedBox(width: 10),
              Text('Berhasil!',
                  style: GoogleFonts.poppins(
                      color: AppColors.white, fontWeight: FontWeight.w700)),
            ],
          ),
          content: Text(
            'Tugas kamu berhasil disubmit. Waktu submit telah tercatat otomatis oleh sistem.',
            style: GoogleFonts.poppins(
                color: AppColors.greyLight, fontSize: 13, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup',
                  style: GoogleFonts.poppins(
                      color: AppColors.pink, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submit gagal. Coba lagi.',
              style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      child: SingleChildScrollView(
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.upload_rounded,
                        color: AppColors.pink, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Submit Tugas',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'Data ini akan dicatat oleh asisten.',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.pink.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.pink.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.pink, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pastikan data sudah benar. Submit tidak dapat diubah!',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.pinkLight,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _label('Nama Produk'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameCtrl,
                style:
                    GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
                decoration: const InputDecoration(hintText: 'Nama produk'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 14),
              _label('Harga (Rp)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                style:
                    GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
                decoration: const InputDecoration(hintText: 'Harga produk'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                  final p = int.tryParse(v.trim().replaceAll(RegExp(r'[^0-9]'), ''));
                  if (p == null || p <= 0) return 'Harga tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _label('Deskripsi'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descCtrl,
                maxLines: 2,
                style:
                    GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
                decoration:
                    const InputDecoration(hintText: 'Deskripsi produk'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 14),
              _label('GitHub Repository URL'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _githubCtrl,
                keyboardType: TextInputType.url,
                style:
                    GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'https://github.com/username/repo',
                  prefixIcon: Icon(Icons.link_rounded),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'URL GitHub wajib diisi';
                  if (!v.trim().startsWith('https://github.com/')) {
                    return 'URL harus dimulai dengan https://github.com/';
                  }
                  return null;
                },
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
                          'Submit Tugas',
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
