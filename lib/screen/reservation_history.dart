import 'dart:typed_data';
import 'package:billiard_club_frontend/model/reservation_cue_response.dart';
import 'package:billiard_club_frontend/model/reservation_table_response.dart';
import 'package:billiard_club_frontend/service/billiard_table_service.dart';
import 'package:billiard_club_frontend/service/cue_service.dart';
import 'package:billiard_club_frontend/service/reservation_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:billiard_club_frontend/model/reservation_response.dart';
import 'package:intl/intl.dart' as intl;

import '../util/constants.dart'; // Import for date formatting

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  late Future<List<ReservationResponse>> reservations;

  @override
  void initState() {
    super.initState();
    reservations = ReservationService().findAllReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 228, 114),
        title: Text('Бронирования'),
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
            return Center(child: Text('No reservations found.'));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              return ReservationCard(reservation: reservations[index]);
            },
          );
        },
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final ReservationResponse reservation;

  ReservationCard({required this.reservation});

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
                Text(
                  '${reservation.totalPrice.toStringAsFixed(2)} BYN',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
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
              reservation.status == 'COMPLETED'
                  ? 'ЗАВЕРШЕН'
                  : reservation.status == 'CANCELED'
                      ? 'ОТМЕНЕН'
                      : reservation.status, // Для других статусов
              style: TextStyle(
                color: reservation.status == 'COMPLETED'
                    ? Colors.blue
                    : reservation.status == 'CANCELED'
                        ? Colors.red
                        : Colors.black, // Цвет для других статусов
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Color.fromARGB(255, 211, 237, 212),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: "$baseURL/api/v1/carambol/cues/${cue.cue.id}/image", // Use the URL directly
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Text('Failed to load image')),
                fit: BoxFit.cover,
                
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cue.cue.price.toStringAsFixed(2)} BYN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
  }
}

class TableCard extends StatelessWidget {
  final ReservationTableResponse table;

  TableCard({required this.table});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Color.fromARGB(255, 211, 237, 212),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: "$baseURL/api/v1/carambol/billiard-tables/${table.billiardTable.id}/image", // Use the URL directly
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Text('Failed to load image')),
                fit: BoxFit.cover,
                
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${table.billiardTable.price * 4} BYN/час',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
  }
}