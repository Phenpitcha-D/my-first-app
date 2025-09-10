import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/trip_idx_get_res.dart';
import 'package:my_first_app/model/response/trips_get_res.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  late TripIdxGetResponse tripIdxGetResponse;
  late Future<void> loaddata;

  @override
  void initState() {
    super.initState();
    loaddata = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: loaddata,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tripIdxGetResponse.name),
                    Text(tripIdxGetResponse.country),
                    SizedBox(
                      child: Image.network(tripIdxGetResponse.coverimage),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'ราคา ${tripIdxGetResponse.price.toString()} บาท',
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('โซน${tripIdxGetResponse.destinationZone}'),
                          ],
                        ),
                      ],
                    ),
                    Text(tripIdxGetResponse.detail),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(onPressed: () {}, child: Text('จองเลย')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
  }
}
