import 'dart:typed_data';
import 'package:billiard_club_frontend/model/billiard_table_response.dart';
import 'package:billiard_club_frontend/service/billiard_table_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BilliardTableScreen extends StatefulWidget {
  const BilliardTableScreen({Key? key}) : super(key: key);
  
  @override
  _BilliardTableScreenState createState() => _BilliardTableScreenState();
}

class _BilliardTableScreenState extends State<BilliardTableScreen> {
  final BilliardTableService _service = BilliardTableService();
  late Future<List<BilliardTableResponse>> _billiardTables;
  List<BilliardTableResponse> _filteredTables = [];
  List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    _billiardTables = _service.getAllBilliardTables().then((tables) {
      _filteredTables = tables;
      return tables;
    });
  }

  void _toggleFilter(String type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
      _updateFilteredTables();
    });
  }

  void _updateFilteredTables() {
    setState(() {
      _billiardTables = _service.getAllBilliardTables().then((tables) {
        if (_selectedTypes.isEmpty) {
          _filteredTables = tables;
        } else {
          _filteredTables = tables.where((table) =>
            _selectedTypes.contains(table.billiardTableType.name)).toList();
        }
        return _filteredTables;
      });
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedTypes.clear();
      _updateFilteredTables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billiard Tables'),
      ),
      backgroundColor: Color.fromARGB(255, 175, 239, 169),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                if (_selectedTypes.isNotEmpty) 
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: _clearFilters,
                    tooltip: 'Clear Filters',
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton('Пул'),
                        _buildFilterButton('Пирамида'),
                        _buildFilterButton('Снукер'),
                        _buildFilterButton('Карамболь'),
                        _buildFilterButton('Маленькая пирамида'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<BilliardTableResponse>>(
              future: _billiardTables,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No billiard tables found.'));
                }

                final tables = _filteredTables;
                return ListView.builder(
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    return BilliardTableCard(table: tables[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String type) {
    bool isSelected = _selectedTypes.contains(type);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () => _toggleFilter(type),
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.green, backgroundColor: isSelected ? Colors.green : Colors.white,
          side: BorderSide(color: Colors.green),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(type),
      ),
    );
  }
}

class BilliardTableCard extends StatelessWidget {
  final BilliardTableResponse table;

  const BilliardTableCard({Key? key, required this.table}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            imageUrl: "$baseURL/api/v1/carambol/billiard-tables/${table.id}/image", // Assuming you have this property
            height: 200,
            fit: BoxFit.contain,
            placeholder: (context, url) => Container(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              child: Center(child: Text('No image available')),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${table.price * 4} BYN/час',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Свободных столов - ${table.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${table.billiardTableType.name}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.green, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Забронировать"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}