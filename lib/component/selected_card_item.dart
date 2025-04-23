import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/selected_cue_response.dart';
import '../model/selected_table_response.dart';
import '../util/constants.dart';

class SelectedItem extends StatelessWidget {
  final SelectedCueResponse? cue;
  final SelectedTableResponse? table;
  final ValueChanged<int> onUpdateAmount;
  final VoidCallback onDelete;
  final int cueLimit;
  final void Function(int newLimit)? onCueOverLimit;

  const SelectedItem({
    super.key,
    this.cue,
    this.table,
    required this.cueLimit,
    required this.onUpdateAmount,
    required this.onDelete,
    this.onCueOverLimit,
  });

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы уверены, что хотите удалить предмет?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Отмена', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showCueLimitDialog(BuildContext context, int limit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content:
              Text('Превышен лимит по бронированию киев. Ваш лимит: $limit'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCue = cue != null;
    final name = isCue ? cue!.cue.name : table!.billiardTable.name;
    final price = isCue ? cue!.cue.price : table!.billiardTable.price * 4;
    final amount = isCue ? cue!.amount : table!.amount;
    final stock = isCue ? cue!.cue.amount : table!.billiardTable.amount;

    final imageUrl = isCue
        ? "$baseURL/api/v1/carambol/cues/${cue!.cue.id}/image"
        : "$baseURL/api/v1/carambol/billiard-tables/${table!.billiardTable.id}/image";

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Image(
                  image: AssetImage('assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${price.toStringAsFixed(2)} BYN/час',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.green),
                  onPressed: () {
                    if (amount > 1) {
                      onUpdateAmount(amount - 1);
                      if (!isCue && onCueOverLimit != null) {
                        onCueOverLimit!((amount - 1) * 2);
                      }
                    } else {
                      showDeleteConfirmationDialog(context);
                    }
                  },
                ),
                Text(
                  '$amount',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                if (amount < stock)
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      if (isCue && amount + 1 > cueLimit) {
                        showCueLimitDialog(context, cueLimit);
                      } else {
                        onUpdateAmount(amount + 1);
                      }
                    },
                  ),
                const Spacer(),
                Text(
                  '${(price * amount).toStringAsFixed(2)} BYN',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => showDeleteConfirmationDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
