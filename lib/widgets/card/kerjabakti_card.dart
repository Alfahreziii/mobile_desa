import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:concept/core/models/kerjabakti_model.dart';

class KerjaBaktiCard extends StatelessWidget {
  final KerjaBakti kerjabakti;

  const KerjaBaktiCard({super.key, required this.kerjabakti});

  String formatTanggal(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal(); // ← tambahkan .toLocal()
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  kerjabakti.judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                ),
              ),
              Text(
                formatTanggal(kerjabakti.created_at_formatted),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          buildRow("Hari", kerjabakti.hari),
          buildRow(
              "Jam", "${kerjabakti.jam_mulai} - ${kerjabakti.jam_selesai}"),
          buildRow("Tempat", kerjabakti.tempat),
          buildRow("Peserta", kerjabakti.peserta),
        ],
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              ": $value",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}
