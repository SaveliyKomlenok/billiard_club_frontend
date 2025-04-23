import 'dart:typed_data';
import 'package:billiard_club_frontend/model/billiard_table_response.dart';
import 'package:billiard_club_frontend/model/request/selected_table_request.dart';
import 'package:billiard_club_frontend/screen/login_screen.dart';
import 'package:billiard_club_frontend/screen/selected_items_screen.dart';
import 'package:billiard_club_frontend/service/billiard_table_service.dart';
import 'package:billiard_club_frontend/service/selected_table_service.dart';
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
  String? token;
  String? role;
  String? username;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _billiardTables = _service.getAllBilliardTables().then((tables) {
      _filteredTables = tables;
      return tables;
    });
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      role = prefs.getString('role');
      username = prefs.getString('username');
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
          _filteredTables = tables
              .where((table) =>
                  _selectedTypes.contains(table.billiardTableType.name))
              .toList();
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
        backgroundColor: const Color.fromARGB(255, 110, 228, 114),
        title: Text('Столы'),
        centerTitle: true,
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
                  return const Center(child: Text(
                      'Столы данного типа отсутствуют. \nВыберите другие!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),);
                }

                final tables = _filteredTables;
                return ListView.builder(
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    return BilliardTableCard(
                      table: tables[index],
                      role: role,
                    );
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
          foregroundColor: isSelected ? Colors.white : Colors.green,
          backgroundColor: isSelected ? Colors.green : Colors.white,
          side: BorderSide(color: Colors.green),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          type,
          style: TextStyle(fontFamily: 'Courier New'),
        ),
      ),
    );
  }
}

class BilliardTableCard extends StatelessWidget {
  final BilliardTableResponse table;
  final String? role;

  const BilliardTableCard({Key? key, required this.table, this.role})
      : super(key: key);

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAvailable = table.amount > 0;

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            imageUrl:
                "$baseURL/api/v1/carambol/billiard-tables/${table.id}/image",
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
                  onPressed: isAvailable
                      ? () async {
                          try {
                            if (role != null) {
                              SelectedTableRequest request = SelectedTableRequest(
                                amount: 1,
                                billiardTable: table.id,
                              );
                              await SelectedTableService.save(request);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SelectedScreen(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            _showErrorSnackbar(context,
                                'Превышен лимит бронирования данного стола');
                          }
                        }
                      : null, // Disable button if not available
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                    backgroundColor:
                        isAvailable ? Colors.white : Colors.grey.shade300,
                    side: BorderSide(
                      color: isAvailable ? Colors.green : Colors.grey,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Courier New',
                    ),
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

