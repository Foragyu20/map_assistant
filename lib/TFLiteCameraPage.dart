import 'package:flutter/material.dart';
import 'widgettf.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'example_pop.dart';
import 'package:flutter_tts/flutter_tts.dart';
/*
Author: Christian Forest M. Raguini
Description: I made this app experimentally it may have some bugs and may not be stable on other devices and is also hardware dependent.
*/
class TFLiteCameraPage extends StatefulWidget {
  const TFLiteCameraPage({Key? key}) : super(key: key);

  @override
  TFLiteCameraPageState createState() => TFLiteCameraPageState();
}

class TFLiteCameraPageState extends State<TFLiteCameraPage> {
  String _output = '';
  bool isPanelOpen = false;
  late LatLng _center = LatLng(15.812894713203333, 120.4523797350682);
  LatLng get center => _center;
  final PopupController _popupLayerController = PopupController();
  late final List<Marker> markers;
  final FlutterTts flutterTts = FlutterTts();
  bool isMuted = true;

  set center(LatLng value) {
    setState(() {
      _center = value;
    });
  }

  void updateOutput(String output) {
    setState(() {
      _output = output;
      updateMarkers();

      if (_output.isNotEmpty) {
        if (!isMuted) {
          speak('You are at $_output');
        }
      }
    });
  }

  void updateMarkers() {
    markers.clear();

    if (_output.isNotEmpty && locationMap.containsKey(_output)) {
      LatLng newCenter = locationMap[_output]!;
      markers.add(
        Marker(
          point: newCenter,
          width: 40,
          height: 40,
          builder: (_) => const Icon(Icons.location_on, size: 40),
          anchorPos: AnchorPos.align(AnchorAlign.top),
          rotateAlignment: AnchorAlign.top.rotationAlignment,
        ),
      );

      _center = newCenter;
    }
  }

  void togglePanelState() {
    setState(() {
      isPanelOpen = !isPanelOpen;
    });
  }

  void mute() {
    setState(() {
      isMuted = false;
    });
  }

  void unmute() {
    setState(() {
      isMuted = true;
    });
  }

  Future<void> speak(String text) async {
    if (!isMuted) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(text);
      await flutterTts.setPitch(1.0);
    }
  }

  final Map<String, LatLng> locationMap = {
    'None': LatLng(15.812894713203333, 120.4523797350682),
    'Main Gate: Entry': LatLng(15.812662598686877, 120.45471624936943),
    'Main Gate: Exit': LatLng(15.813987159268946, 120.45426067323251),
    'Academic Building': LatLng(15.812648956239334, 120.45318506810816),
    'Administrative Building': LatLng(15.811985416187762, 120.45328549120426),
    'Benigno Aldana Gymnasium': LatLng(15.812302007144252, 120.4526109946936),
    'Alumni Building': LatLng(15.813674452484483, 120.4528155253152),
    'School Canteen': LatLng(15.813137752424453, 120.45209361171737),
    'Culture And Arts Building': LatLng(15.81242176781884, 120.45409007927233),
    'Dormitory': LatLng(15.81182701428459, 120.4522855026445),
    'Erasmus Building': LatLng(15.812488791159147, 120.45321893437965),
    'FIC Building': LatLng(15.812937814170148, 120.45037467390387),
    'Guard House': LatLng(15.812653073739892, 120.4545307330464),
    'LIS-High School': LatLng(15.81325429606795, 120.45129069877727),
    'LIS-Elementary': LatLng(15.813832946520844, 120.45316656120232),
    'Language Building: 1': LatLng(15.812752621245979, 120.4509126129517),
    'Language Building: 2': LatLng(15.812827461738415, 120.45127068785668),
    'Learning Resource Center': LatLng(15.81365277760885, 120.45227915889683),
    'Main Building': LatLng(15.813146077633071, 120.45291462331485),
    'MRF Building': LatLng(15.811701121326855, 120.45065822798145),
    'Nursing Building': LatLng(15.812959673666562, 120.45061957609323),
    'Old SSC Building': LatLng(15.811983530162513, 120.45191225245036),
    'Parking Lot': LatLng(15.812390062757133, 120.45232448868494),
    'Recto Building': LatLng(15.812093115968064, 120.45277619656356),
    'Registrar': LatLng(15.812032946138357, 120.45322747370152),
    'ROTC Building': LatLng(15.81200357275971, 120.4513991527917),
    'RSDC Building': LatLng(15.812026539119698, 120.45077424110583),
    'University Grounds': LatLng(15.813085978492184, 120.45383785622107),
    'Supply Office': LatLng(15.81342123430645, 120.45202300232712),
    'Near Erasmus And Academic Building':
        LatLng(15.812608576630597, 120.45324256764111),
    'Near Registrar, Cashier and Admin Building':
        LatLng(15.812037651342814, 120.45333974192104),
    'Near Parking Lot and Gymnasium':
        LatLng(15.812238094527501, 120.45240389692415),
    'Near Recto building and Gymnasium':
        LatLng(15.812173576674931, 120.45260103928652),
    'CAST Building': LatLng(15.813600058409698, 120.45059974734335),
  };
  @override
  void initState() {
    super.initState();

    markers = [
      Marker(
        point: _center,
        width: 40,
        height: 40,
        builder: (_) => const Icon(Icons.location_on, size: 40),
        anchorPos: AnchorPos.align(AnchorAlign.top),
        rotateAlignment: AnchorAlign.top.rotationAlignment,
      ),
    ];
  }

  @override
  void dispose() {
    _popupLayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        toolbarOpacity: 0.3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors.purpleAccent,
              child: Text(
                _output.isNotEmpty
                    ? _output
                    : "please cover the camera before use",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            Switch(
              value: isMuted,
              onChanged: (value) {
                setState(() {
                  isMuted = value;
                });
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: togglePanelState,
        child: SlidingUpPanel(
          renderPanelSheet: false,
          panel: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 253, 253, 253),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                ),
              ],
            ),
            margin: const EdgeInsets.all(31.0),
            child: FlutterMap(
              options: MapOptions(
                  center: LatLng(15.81290354004793, 120.45251481435734),
                  zoom: 16.7,
                  rotation: 98,
                  interactiveFlags: InteractiveFlag.none),
              nonRotatedChildren: [
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    popupController: _popupLayerController,
                    markers: markers,
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) =>
                          ExamplePopup(marker),
                    ),
                  ),
                ),
              ],
            ),
          ),
          collapsed: Container(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0)),
          body: TFLiteCameraWidget(
            onOutputChanged: updateOutput,
          ),
        ),
      ),
    );
  }
}
