import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/trips_get_res.dart';
import 'package:my_first_app/pages/profile.dart';
import 'package:my_first_app/pages/trip.dart';

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> tripGetResponses = [];
  List<TripGetResponse> filterTrips = [];

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      getTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //not show leading icon
        title: Text('Show Trip'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                child: Text('ข้อมูลส่วนตัว'),
                value: 'profile',
              ),
              PopupMenuItem<String>(child: Text('ออกจากระบบ'), value: 'logout'),
            ],
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [Text('ปลายทาง')]),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 2,
                    children: [
                      FilledButton(onPressed: getTrips, child: Text('ทั้งหมด')),
                      FilledButton(
                        onPressed: () => getZoneTrips('เอเชีย'),
                        child: Text('เอเชีย'),
                      ),
                      FilledButton(
                        onPressed: () => getZoneTrips('ยุโรป'),
                        child: Text('ยุโรป'),
                      ),
                      FilledButton(
                        onPressed: () => getZoneTrips('อาเซียน'),
                        child: Text('อาเซียน'),
                      ),
                      FilledButton(
                        onPressed: () => getZoneTrips('ประเทศไทย'),
                        child: Text('ไทยแลนด์'),
                      ),
                      FilledButton(
                        onPressed: () => getZoneTrips('เอเชียตะวันออกเฉียงใต้'),
                        child: Text('เอเชียตะวันออกเฉียงใต้'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: filterTrips
                      .map(
                        (trip) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      trip.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 150,
                                        child: Image.network(
                                          trip.coverimage,
                                          width: 150,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(trip.country),
                                          Text('ระยะเวลา ${trip.duration} วัน'),
                                          Text('ราคา ${trip.price} บาท'),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TripPage(idx: trip.idx),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'รายละเอียดเพิ่มเติม',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getZoneTrips(String destinationZone) {
    List<TripGetResponse> Trips = [];
    for (var trip in tripGetResponses) {
      if (trip.destinationZone == destinationZone) {
        Trips.add(trip);
      }
    }
    setState(() {
      filterTrips = Trips;
    });
  }

  Future<void> getTrips() async {
    var res = await http.get(Uri.parse('$url/trips'));
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
      filterTrips = tripGetResponses;
    });
    log(tripGetResponses.length.toString());
  }
}
