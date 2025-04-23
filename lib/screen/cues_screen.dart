import 'dart:convert';
import 'package:billiard_club_frontend/model/cue_response.dart';
import 'package:billiard_club_frontend/screen/login_screen.dart';
import 'package:billiard_club_frontend/screen/selected_items_screen.dart';
import 'package:billiard_club_frontend/service/cue_service.dart';
import 'package:billiard_club_frontend/service/selected_cue_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/request/selected_cue_request.dart';
import '../util/constants.dart';

class CueScreen extends StatefulWidget {
  const CueScreen({Key? key}) : super(key: key);

  @override
  _CueScreenState createState() => _CueScreenState();
}

class _CueScreenState extends State<CueScreen> {
  final CueService _service = CueService();
  late Future<List<CueResponse>> _cues;
  List<CueResponse> _filteredCues = [];
  List<String> _selectedTypes = [];
  String? token;
  String? role;
  String? username;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _cues = _service.getAllCues().then((cues) {
      _filteredCues = cues;
      return cues;
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
      _updateFilteredCues();
    });
  }

  void _updateFilteredCues() {
    setState(() {
      _cues = _service.getAllCues().then((cues) {
        if (_selectedTypes.isEmpty) {
          _filteredCues = cues;
        } else {
          _filteredCues = cues
              .where((cue) => _selectedTypes.contains(cue.cueType.name))
              .toList();
        }
        return _filteredCues;
      });
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedTypes.clear();
      _updateFilteredCues();
    });
  }

  Future<void> _bookCue(CueResponse cue) async {
    final request = SelectedCueRequest(amount: 1, cue: cue.id);
    try {
      await SelectedCueService.save(request);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Кий забронирован')),
      );
    } catch (e) {
      String errorMessage = 'Ошибка бронирования';
      if (e.toString().contains("лимит") || e.toString().contains("стол")) {
        errorMessage =
            'Превышен лимит по бронированию киев или не был выбран стол';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Кии', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 110, 228, 114),
      ),
      backgroundColor: const Color.fromARGB(255, 175, 239, 169),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                if (_selectedTypes.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: _clearFilters,
                    tooltip: 'Clear Filters',
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton('Русский бильярд'),
                        _buildFilterButton('Пул'),
                        _buildFilterButton('Снукер'),
                        _buildFilterButton('Карамболь'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CueResponse>>(
              future: _cues,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Кии данного типа отсутствуют. \nВыберите другие!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                final cues = _filteredCues;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: cues.length,
                  itemBuilder: (context, index) {
                    return CueCard(
                      cue: cues[index],
                      onBook: () => _bookCue(cues[index]),
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
          side: const BorderSide(color: Colors.green),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          type,
          style: const TextStyle(fontFamily: 'Courier New'),
        ),
      ),
    );
  }
}

class CueCard extends StatelessWidget {
  final CueResponse cue;
  final VoidCallback onBook;
  final String? role;

  const CueCard({Key? key, required this.cue, required this.onBook, this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            CachedNetworkImage(
              imageUrl: "$baseURL/api/v1/carambol/cues/${cue.id}/image",
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Text('No image available')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${cue.price} BYN/час',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                cue.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                cue.cueType.name,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Свободно киев - ${cue.amount}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ElevatedButton(
                onPressed: (cue.amount == 0)
                    ? null
                    : () async {
                        if (role != null) {
                          try {
                            await SelectedCueService.save(
                              SelectedCueRequest(amount: 1, cue: cue.id),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SelectedScreen()),
                            );
                          } catch (e) {
                            String errorMessage =
                                'Превышен лимит по бронированию киев или не был выбран стол';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  foregroundColor: cue.amount == 0 ? Colors.grey : Colors.green,
                  backgroundColor:
                      Colors.white.withOpacity(cue.amount == 0 ? 0.5 : 1),
                  side: BorderSide(
                    color: cue.amount == 0 ? Colors.grey : Colors.green,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text(
                  "Забронировать",
                  style: TextStyle(fontFamily: 'Courier New'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
