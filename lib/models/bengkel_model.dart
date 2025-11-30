import 'package:cloud_firestore/cloud_firestore.dart';

class Bengkel {
  final String id;
  final String nama;
  final String alamat;
  final String deskripsi;
  final double rating;
  final bool buka;
  final String foto;
  final String telepon;
  final GeoPoint lokasi;
  final Map<String, dynamic> jamOperasional;

  Bengkel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.deskripsi,
    required this.rating,
    required this.buka,
    required this.foto,
    required this.telepon,
    required this.lokasi,
    required this.jamOperasional,
  });

  factory Bengkel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return Bengkel(
      id: doc.id,
      nama: data['nama'] ?? '-',
      alamat: data['alamat'] ?? '-',
      deskripsi: data['deskripsi'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      buka: data['buka'] ?? false,
      foto: data['foto'] ?? '',
      telepon: data['telepon'],
      lokasi: data['lokasi'] as GeoPoint? ?? const GeoPoint(0, 0),
      jamOperasional: (data['jam_operasional'] as Map<String, dynamic>?) ?? {},
    );
  }
}
