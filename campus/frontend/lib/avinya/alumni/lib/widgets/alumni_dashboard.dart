import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery/avinya/alumni/lib/data/organization.dart';

class AlumniDashboard extends StatefulWidget {
  const AlumniDashboard({super.key});

  @override
  State<AlumniDashboard> createState() => _AlumniDashboardState();
}

class _AlumniDashboardState extends State<AlumniDashboard> {
  late Future<List<Organization>> _fetchBatchData;
  bool _isFetching = false;
  Organization? _selectedValue;

  @override
  void initState() {
    super.initState();
    _fetchBatchData = _loadBatchData();
    // filteredStudents = _fetchedPersonData;
  }

  Future<List<Organization>> _loadBatchData() async {
    return await fetchOrganizationsByAvinyaType(86);
  }

  final Map<String, int> alumniCounts = {
    "Studying": 45,
    "Working": 30,
    "Not Working": 10,
    "Abroad": 15,
    "Inactive": 5,
  };

  final Map<String, IconData> icons = {
    "Studying": Icons.school,
    "Working": Icons.work,
    "Not Working": Icons.do_not_disturb,
    "Abroad": Icons.flight_takeoff,
    "Inactive": Icons.pause_circle_filled,
  };

  final Map<String, Color> colors = {
    "Studying": Colors.blueAccent,
    "Working": Colors.green,
    "Not Working": Colors.orange,
    "Abroad": Colors.purple,
    "Inactive": Colors.redAccent,
  };

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        primary: false,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Alumni Dashboard",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 38, 38, 38),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text('Select a Batch :'),
              SizedBox(
                width: 10,
              ),
              FutureBuilder<List<Organization>>(
                future: _fetchBatchData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      child: SpinKitCircle(
                        color: (Colors.blueGrey[400]),
                        size: 70,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong...'),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No batch found'),
                    );
                  }
                  final batchData = snapshot.data!;
                  return DropdownButton<Organization>(
                      value: _selectedValue,
                      items: batchData.map((Organization batch) {
                        return DropdownMenuItem(
                            value: batch,
                            child: Text(batch.name!.name_en ?? ''));
                      }).toList(),
                      onChanged: (Organization? newValue) async {
                        if (newValue == null) {
                          return;
                        }

                        if (newValue.organization_metadata.isEmpty) {
                          return;
                        }

                        setState(() {
                          _selectedValue = newValue;
                          this._isFetching = true;
                        });
                      });
                },
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Alumni Summary",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 38, 38, 38),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.7,
            child: Expanded(
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                children: alumniCounts.keys.map((status) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4.0,
                    color: colors[status],
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icons[status],
                              size: 80,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "${alumniCounts[status]}",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
