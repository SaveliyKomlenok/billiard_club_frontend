import 'package:billiard_club_frontend/model/request/reservation_request.dart';
import 'package:billiard_club_frontend/model/request/selected_cue_request.dart';
import 'package:billiard_club_frontend/model/request/selected_table_request.dart';
import 'package:billiard_club_frontend/service/reservation_service.dart';
import 'package:billiard_club_frontend/service/selected_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/selected_card_item.dart';
import '../model/selected_response.dart';
import '../service/selected_cue_service.dart';
import '../service/selected_table_service.dart';

class SelectedScreen extends StatefulWidget {
  const SelectedScreen({super.key});

  @override
  State<SelectedScreen> createState() => _SelectedScreenState();
}

class _SelectedScreenState extends State<SelectedScreen> {
  SelectedResponse? selectedResponse;
  bool isLoading = true;
  String userRole = '';
  late final int cueLimit;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? '';
    });

    fetchSelectedItems();
  }

  Future<void> fetchSelectedItems() async {
    if (userRole != 'USER') {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final result = await SelectedService().listOfSelected();
      setState(() {
        selectedResponse = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> updateCueAmount(int selectedCueId, int cueId, int amount) async {
    if (amount < 1) return;

    try {
      SelectedCueRequest selectedCueRequest =
          SelectedCueRequest(amount: amount, cue: cueId);
      await SelectedCueService.update(selectedCueId, selectedCueRequest);
      fetchSelectedItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка обновления кия: $e'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> updateTableAmount(
      int selectedTableId, int tableId, int amount) async {
    if (amount < 1) return;

    try {
      SelectedTableRequest selectedTableRequest =
          SelectedTableRequest(amount: amount, billiardTable: tableId);
      await SelectedTableService.update(selectedTableId, selectedTableRequest);
      fetchSelectedItems(); // обновим список
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка обновления стола: $e'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  int _calculateCueLimit(SelectedResponse response) {
    // Допустим, каждый стол даёт право на 2 кия
    return response.selectedTables
        .fold(0, (sum, table) => sum + table.amount * 2);
  }

  Future<void> deleteSelectedItem(int id, bool isCue) async {
    try {
      if (isCue) {
        await SelectedCueService.delete(id);
      } else {
        await SelectedTableService.delete(id);

        // Пересчёт лимита киев после удаления стола
        final newSelectedResponse = await SelectedService().listOfSelected();
        final newLimit = _calculateCueLimit(newSelectedResponse);

        if (newLimit == 0) {
          // Удалить все кии, если лимит стал 0
          for (var cue in newSelectedResponse.selectedCues) {
            await SelectedCueService.delete(cue.id);
          }
        } else {
          // Уменьшить кии до нового лимита
          int totalCues = newSelectedResponse.selectedCues
              .fold(0, (sum, c) => sum + c.amount);
          if (totalCues > newLimit) {
            int remaining = newLimit;
            for (var cue in newSelectedResponse.selectedCues) {
              if (remaining <= 0) {
                await updateCueAmount(cue.id, cue.cue.id, 0);
                continue;
              }
              int newAmount = cue.amount > remaining ? remaining : cue.amount;
              if (newAmount != cue.amount) {
                await updateCueAmount(cue.id, cue.cue.id, newAmount);
              }
              remaining -= newAmount;
            }
          }
        }
      }

      fetchSelectedItems(); // Обновить состояние после всех изменений
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка удаления: $e'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> handleCueLimitChange(int newLimit) async {
    setState(() {
      cueLimit = newLimit;
    });

    final cues = selectedResponse?.selectedCues ?? [];

    // если общее количество киев превышает лимит, уменьшаем их
    int totalCues = cues.fold(0, (sum, item) => sum + item.amount);
    if (totalCues > newLimit) {
      int remaining = newLimit;
      for (var cue in cues) {
        if (remaining <= 0) {
          await updateCueAmount(cue.id, cue.cue.id, 0); // можно удалить
          continue;
        }

        int newAmount = cue.amount > remaining ? remaining : cue.amount;
        if (newAmount != cue.amount) {
          await updateCueAmount(cue.id, cue.cue.id, newAmount);
        }

        remaining -= newAmount;
      }

      // после всех обновлений — перезагрузим список
      await fetchSelectedItems();
    }
  }

  void _showReservationDialog(BuildContext context) {
    final addressController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    int durationHours = 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('Бронирование'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Адрес'),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text(selectedDate == null
                          ? 'Выбрать дату'
                          : 'Дата: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        selectedTime == null
                            ? 'Выбрать время'
                            : 'Время: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: selectedDate == null
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.access_time,
                        color: selectedDate == null
                            ? Colors.grey.withOpacity(0.5)
                            : Colors.black,
                      ),
                      onTap: selectedDate == null
                          ? null
                          : () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                final now = DateTime.now();
                                final selectedDateTime = DateTime(
                                  selectedDate!.year,
                                  selectedDate!.month,
                                  selectedDate!.day,
                                  picked.hour,
                                  picked.minute,
                                );

                                final nowPlus15 =
                                    now.add(const Duration(minutes: 15));

                                if (selectedDateTime.isBefore(nowPlus15) &&
                                    selectedDateTime.day == now.day &&
                                    selectedDateTime.month == now.month &&
                                    selectedDateTime.year == now.year) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Выберите время минимум через 15 минут от текущего',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  selectedTime = picked;
                                });
                              }
                            },
                    ),
                    Row(
                      children: [
                        const Text('Часы:'),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: durationHours > 1
                              ? () => setState(() => durationHours--)
                              : null,
                        ),
                        Text('$durationHours'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: durationHours < 8
                              ? () => setState(() => durationHours++)
                              : null,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child:
                      const Text('Отмена', style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text(
                    'Подтвердить',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    if (addressController.text.isEmpty ||
                        selectedDate == null ||
                        selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Заполните все поля')),
                      );
                      return;
                    }

                    final reservationDate = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                    );

                    final reservationTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );

                    final request = ReservationRequest(
                      address: addressController.text,
                      reservationDate: reservationDate,
                      reservationTime: reservationTime,
                      durationHours: durationHours,
                    );

                    _createReservation(request);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _createReservation(ReservationRequest request) async {
    try {
      await ReservationService().createReservation(request);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Бронь успешно создана')),
      );
      fetchSelectedItems(); // очистим выбранные
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка бронирования: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int cueLimit = (selectedResponse?.selectedTables ?? [])
            .map((t) => t.amount)
            .fold(0, (prev, next) => prev + next) *
        2;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 175, 239, 169),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 228, 114),
        title: const Text(
          'Выбранные кии и столы',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : userRole != 'USER'
              ? const Center(
                  child: Text(
                    'Авторизируйтесь, чтобы просматривать выбранные предметы',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )
              : (selectedResponse?.selectedCues.isEmpty ?? true) &&
                      (selectedResponse?.selectedTables.isEmpty ?? true)
                  ? const Center(
                      child: Text(
                        'Ничего не выбрано',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView(
                      children: [
                        ...selectedResponse!.selectedCues.map((cue) =>
                            SelectedItem(
                              cue: cue,
                              cueLimit: cueLimit,
                              onUpdateAmount: (amount) =>
                                  updateCueAmount(cue.id, cue.cue.id, amount),
                              onDelete: () => deleteSelectedItem(cue.id, true),
                            )),
                        ...selectedResponse!.selectedTables
                            .map((table) => SelectedItem(
                                  table: table,
                                  cueLimit: cueLimit,
                                  onUpdateAmount: (amount) => updateTableAmount(
                                      table.id, table.billiardTable.id, amount),
                                  onDelete: () =>
                                      deleteSelectedItem(table.id, false),
                                  onCueOverLimit: handleCueLimitChange,
                                )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () => _showReservationDialog(context),
                              child: const Text(
                                'Подтвердить бронь',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
