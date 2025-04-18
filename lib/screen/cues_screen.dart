import 'dart:typed_data';
import 'package:billiard_club_frontend/model/cue_response.dart';
import 'package:billiard_club_frontend/service/cue_service.dart'; // Assume you have a service for cues
import 'package:flutter/material.dart';

class CueScreen extends StatefulWidget {
  const CueScreen({Key? key}) : super(key: key);

  @override
  _CueScreenState createState() => _CueScreenState();
}

class _CueScreenState extends State<CueScreen> {
  final CueService _service = CueService(); // Assume you have a CueService
  late Future<List<CueResponse>> _cues;
  List<CueResponse> _filteredCues = [];
  List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    _cues = _service.getAllCues().then((cues) {
      _filteredCues = cues;
      return cues;
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
          _filteredCues = cues.where((cue) =>
            _selectedTypes.contains(cue.cueType.name)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cues', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                        _buildFilterButton('Кий 1'),
                        _buildFilterButton('Кий 2'),
                        _buildFilterButton('Кий 3'),
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
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No cues found.'));
                }

                final cues = _filteredCues;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: cues.length,
                  itemBuilder: (context, index) {
                    return CueCard(cue: cues[index]);
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
        child: Text(type, style: TextStyle(fontSize: 12)), // Adjusted font size
      ),
    );
  }
}

class CueCard extends StatelessWidget {
  final CueResponse cue;

  const CueCard({Key? key, required this.cue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<Uint8List?>(
            future: CueService().getCueImage(cue.id), // Assume this method exists
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 150,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (imageSnapshot.hasError || !imageSnapshot.hasData) {
                return Container(
                  height: 150,
                  child: const Center(child: Text('Error loading image')),
                );
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.memory(
                  imageSnapshot.data!,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${cue.price} BYN/час',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16, // Adjusted font size
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              cue.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              cue.cueType.name,
              style: const TextStyle(fontSize: 14), // Adjusted font size
            ),
          ),
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Свободно киев - ${cue.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Adjusted font size
                  ),
                ),
              ),
          const SizedBox(height: 8),
          ElevatedButton(
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
      )],
      ),
    );
  }
}