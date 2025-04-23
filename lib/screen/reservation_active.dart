import 'dart:typed_data';
import 'package:billiard_club_frontend/model/reservation_cue_response.dart';
import 'package:billiard_club_frontend/model/reservation_table_response.dart';
import 'package:billiard_club_frontend/service/billiard_table_service.dart';
import 'package:billiard_club_frontend/service/cue_service.dart';
import 'package:billiard_club_frontend/service/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:billiard_club_frontend/model/reservation_response.dart';
import 'package:intl/intl.dart' as intl; // Import for date formatting

class ReservationsActivePage extends StatefulWidget {
  @override
  _ReservationsActivePageState createState() => _ReservationsActivePageState();
}

class _ReservationsActivePageState extends State<ReservationsActivePage> {
  late Future<List<ReservationResponse>>? reservations;

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  void loadReservations() {
    Future<List<ReservationResponse>> reservationsGet =
        ReservationService().findAllActiveReservations();
    setState(() {
      reservations = reservationsGet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 228, 114),
        title: Text('Активные брони'),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 175, 239, 169),
      body: FutureBuilder<List<ReservationResponse>>(
        future: reservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text(
                      'Активные брони отсутствуют',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),);
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              return ReservationCard(
                reservation: reservations[index],
                onReservationCancelled: loadReservations, // передаём метод
              );
            },
          );
        },
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final ReservationResponse reservation;
  final VoidCallback onReservationCancelled;

  ReservationCard(
      {required this.reservation, required this.onReservationCancelled});

  String monthToRussian(int month) {
    switch (month) {
      case 1:
        return 'Января';
      case 2:
        return 'Февраля';
      case 3:
        return 'Марта';
      case 4:
        return 'Апреля';
      case 5:
        return 'Мая';
      case 6:
        return 'Июня';
      case 7:
        return 'Июля';
      case 8:
        return 'Августа';
      case 9:
        return 'Сентября';
      case 10:
        return 'Октября';
      case 11:
        return 'Ноября';
      case 12:
        return 'Декабря';
      default:
        return '';
    }
  }

  String formatDate(DateTime start, DateTime end) {
    String startMonth = monthToRussian(start.month);
    String endMonth = monthToRussian(end.month);

    String startFormatted =
        '${start.day} $startMonth ${start.hour}:${start.minute.toString().padLeft(2, '0')}';
    String endFormatted =
        '${end.day} $endMonth ${end.hour}:${end.minute.toString().padLeft(2, '0')}';

    if (start.day == end.day) {
      return '$startFormatted - ${endFormatted.split(' ')[2]}'; // Сохраняем только время
    } else {
      return '$startFormatted - $endFormatted';
    }
  }

  void cancelReservation(int id) {
    ReservationService().cancelReservation(id);
  }

  void _showConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Отмена брони'),
          content: Text(
            'Вы уверены, что хотите отменить бронь №$id?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Нет',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await ReservationService()
                    .cancelReservation(id); // <--- Ждём завершения!
                onReservationCancelled(); // После отмены
              },
              child: Text(
                'Да',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final startDate = DateTime.parse(reservation.startReservationDate);
    final endDate = DateTime.parse(reservation.endReservationDate);

    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Бронь №${reservation.id}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton.icon(
                  onPressed: () =>
                      _showConfirmationDialog(context, reservation.id),
                  icon: Icon(Icons.cancel, color: Colors.red),
                  label: Text(
                    'Отменить',
                    style:
                        TextStyle(color: Colors.red, fontFamily: "Courier new"),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14.0), // Уменьшите радиус здесь
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '${formatDate(startDate, endDate)}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              '${reservation.totalPrice.toStringAsFixed(2)} BYN',
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(height: 5),
            Column(
              children: reservation.reservedCues.map((cue) {
                return CueCard(cue: cue);
              }).toList(),
            ),
            SizedBox(height: 5),
            Column(
              children: reservation.reservedBilliardTables.map((table) {
                return TableCard(table: table);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CueCard extends StatelessWidget {
  final ReservationCueResponse cue;

  CueCard({required this.cue});

  Future<Uint8List?> _fetchCueImage(int id) async {
    return await CueService().getCueImage(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _fetchCueImage(cue.cue.id),
      builder: (context, snapshot) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          color: Color.fromARGB(255, 211, 237, 212),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : snapshot.hasData
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Text('Failed to load image'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${cue.cue.price.toStringAsFixed(2)} BYN',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Количество: ${cue.amount}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  '${cue.cue.name}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TableCard extends StatelessWidget {
  final ReservationTableResponse table;

  TableCard({required this.table});

  Future<Uint8List?> _fetchTableImage(int id) async {
    return await BilliardTableService().getBilliardTableImage(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _fetchTableImage(table.billiardTable.id),
      builder: (context, snapshot) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          color: Color.fromARGB(255, 211, 237, 212), // Green background
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : snapshot.hasData
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Text('Failed to load image'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${table.billiardTable.price * 4} BYN/час',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Количество: ${table.amount}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  '${table.billiardTable.billiardTableType.name} ${table.billiardTable.size}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
