import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'example_pop.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'TFLiteCameraPage.dart';
/*
Author: Christian Forest M. Raguini
Description: I made this app experimentally it may have some bugs and may not be stable on other devices and is also hardware dependent.
*/
class VoiceCommandMap extends StatefulWidget {
  const VoiceCommandMap({Key? key}) : super(key: key);

  @override
  VoiceCommandMapState createState() => VoiceCommandMapState();
}

class VoiceCommandMapState extends State<VoiceCommandMap> {
  late MapController _mapController;
  late List<Marker> _markers;
  late LatLng _currentLocation;
  stt.SpeechToText? speechToText;
  final PopupController _popupLayerController = PopupController();
  List<Marker> markers = [];

  final Map<String, dynamic> locationMap = {
    'none': {
      'coordinates': LatLng(15.812894713203333, 120.4523797350682),
      'description': 'No specific location',
    },
    'main gate entry': {
      'coordinates': LatLng(15.812662598686877, 120.45471624936943),
      'description':
          'the nearest place from Main gate entry is the guard house and university grounds',
    },
    'main gate exit': {
      'coordinates': LatLng(15.813987159268946, 120.45426067323251),
      'description':
          'the nearest place from Main gate exit is the LIS Elementary and university grounds',
    },
    'academic building': {
      'coordinates': LatLng(15.812648956239334, 120.45318506810816),
      'description':
          'the nearest place from Academic building is the erasmus building and main building',
    },
    'administrative building': {
      'coordinates': LatLng(15.811985416187762, 120.45328549120426),
      'description':
          'the nearest place from Administrative building is the registrar',
    },
    'benigno aldana gymnasium': {
      'coordinates': LatLng(15.812302007144252, 120.4526109946936),
      'description':
          'the nearest place from Benigno Aldana Gymnasium is recto building and parking lot',
    },
    'alumni building': {
      'coordinates': LatLng(15.813674452484483, 120.4528155253152),
      'description':
          'the nearest place from Alumni building is learning resource center and main building',
    },
    'school canteen': {
      'coordinates': LatLng(15.813137752424453, 120.45209361171737),
      'description': 'the nearest place from School canteen is supply office',
    },
    'culture and arts building': {
      'coordinates': LatLng(15.81242176781884, 120.45409007927233),
      'description':
          'the nearest place from Culture and Arts building is the guard house and university grounds',
    },
    'dormitory': {
      'coordinates': LatLng(15.81182701428459, 120.4522855026445),
      'description': 'the nearest place from Dormitory is old ssc building',
    },
    'erasmus building': {
      'coordinates': LatLng(15.812488791159147, 120.45321893437965),
      'description':
          'the nearest place from Erasmus building is academic building',
    },
    'fic building': {
      'coordinates': LatLng(15.812937814170148, 120.45037467390387),
      'description':
          'the nearest place from FIC building is the nursing buildings',
    },
    'guard house': {
      'coordinates': LatLng(15.812653073739892, 120.4545307330464),
      'description': 'the nearest place from Guard house is main gate entry',
    },
    'lis high school': {
      'coordinates': LatLng(15.81325429606795, 120.45129069877727),
      'description':
          'the nearest place from LIS High School is language building 2',
    },
    'lis elementary': {
      'coordinates': LatLng(15.813832946520844, 120.45316656120232),
      'description':
          'the nearest place from LIS Elementary is university grounds and main gate exit',
    },
    'language department': {
      'coordinates': LatLng(15.812752621245979, 120.4509126129517),
      'description':
          'the nearest place from Language Building is nursing building and LIS High school',
    },
    'language department two': {
      'coordinates': LatLng(15.812827461738415, 120.45127068785668),
      'description':
          'the nearest place from Language Building Two is language building one ',
    },
    'learning resource center': {
      'coordinates': LatLng(15.81365277760885, 120.45227915889683),
      'description':
          'the nearest place from Learning Resource Center is alumni building and main building',
    },
    'main building': {
      'coordinates': LatLng(15.813146077633071, 120.45291462331485),
      'description':
          'the nearest place from Main Building is alumni building, learning resource center and academic building',
    },
    'mrf building': {
      'coordinates': LatLng(15.811701121326855, 120.45065822798145),
      'description': 'the nearest place from MRF Building is rsdc building',
    },
    'nursing building': {
      'coordinates': LatLng(15.812959673666562, 120.45061957609323),
      'description':
          'the nearest place from Nursing Building is FIC building and Cast bulding',
    },
    'old ssc building': {
      'coordinates': LatLng(15.811983530162513, 120.45191225245036),
      'description': 'the nearest place from Old SSC Building ROTC building',
    },
    'parking lot': {
      'coordinates': LatLng(15.812390062757133, 120.45232448868494),
      'description':
          'the nearest place from Parking Lot is benigno aldana gymnasium',
    },
    'recto building': {
      'coordinates': LatLng(15.812093115968064, 120.45277619656356),
      'description':
          'the nearest place from Recto Building is benigno aldana gymnasium',
    },
    'registrar': {
      'coordinates': LatLng(15.812032946138357, 120.45322747370152),
      'description': 'Registrar location',
    },
    'rotc building': {
      'coordinates': LatLng(15.81200357275971, 120.4513991527917),
      'description': 'the nearest place from ROTC Building is rsdc building',
    },
    'rs building': {
      'coordinates': LatLng(15.812026539119698, 120.45077424110583),
      'description':
          'the nearest place from RSDC Building ROTC Building and mrf building',
    },
    'university grounds': {
      'coordinates': LatLng(15.813085978492184, 120.45383785622107),
      'description':
          'the nearest place from University Grounds is guard house, lis elementary and culture and arts building',
    },
    'supply office': {
      'coordinates': LatLng(15.81342123430645, 120.45202300232712),
      'description':
          'the nearest place from Supply Office is learning resource center and school canteen',
    },
    'cast building': {
      'coordinates': LatLng(15.813600058409698, 120.45059974734335),
      'description': 'the nearest place from CAST Building is Nursing building',
    },
  };

  FlutterTts flutterTts = FlutterTts();

  bool isListening = false;
  String recognizedCommand = '';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _markers = [];
    _currentLocation = LatLng(15.81290354004793, 120.45251481435734);
    _popupLayerController.dispose();
    _updateMarkers();
    initializeSpeechToText();
  }

  Future<void> initializeSpeechToText() async {
    speechToText = stt.SpeechToText();
    final isAvailable = await speechToText!.initialize();
    if (!isAvailable) {
      // Speech recognition is not available on the device
      // Handle the error condition accordingly
    }
  }

  void _updateMarkers() {
    _markers.clear();

    _markers.add(
      Marker(
        point: _currentLocation,
        width: 40,
        height: 40,
        builder: (_) => const Icon(Icons.location_on, size: 40),
        anchorPos: AnchorPos.align(AnchorAlign.top),
        rotateAlignment: AnchorAlign.top.rotationAlignment,
      ),
    );
  }

  void _markLocation(String locationName) {
    if (locationMap.containsKey(locationName)) {
      final dynamic location = locationMap[locationName];
      if (location is Map<String, dynamic> &&
          location.containsKey('coordinates')) {
        final LatLng? coordinates = location['coordinates'] as LatLng?;
        setState(() {
          _currentLocation = coordinates!;
        });
        _mapController.move(coordinates!, 16.7);
        _updateMarkers();
        _speakBuildingAndLocation(locationName);
      } else {
        // Invalid location data
        _speakErrorMessage();
      }
    } else {
      // Command is not a specific building
      _speakErrorMessage();
    }
  }

  Future<void> _speakBuildingAndLocation(String command) async {
    final dynamic location = locationMap[command];
    if (location is Map<String, dynamic> &&
        location.containsKey('description') &&
        location.containsKey('coordinates')) {
      final String description = location['description'] as String;
      final LatLng coordinates = location['coordinates'] as LatLng;

      final text =
          'Where: $command\nLocation: $description\nCoordinates: Latitude ${coordinates.latitude}, Longitude ${coordinates.longitude}';
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(text);
    } else {
      // Invalid location data
      _speakErrorMessage();
    }
  }

  Future<void> _speakErrorMessage() async {
    const errorMessage =
        "Sorry, I only understand specific building names from PSU Bayambang Campus.";
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(errorMessage);
  }

  void _startListening() {
    if (speechToText != null && speechToText!.isAvailable) {
      isListening = true;
      speechToText!.listen(
        onResult: (result) {
          setState(() {
            recognizedCommand = result.recognizedWords;
          });
          if (result.finalResult) {
            _markLocation(recognizedCommand);
            isListening = false;
          }
        },
      );
    }
  }

  void _stopListening() {
    if (isListening && speechToText != null) {
      speechToText!.stop();
      setState(() {
        isListening = false;
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    if (speechToText != null) {
      speechToText!.cancel();
      speechToText!.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Command Map'),
        leading: IconButton(
          onPressed: () => Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => const TFLiteCameraPage()),
          ),
          icon: const Icon(Icons.camera_enhance_outlined),
          iconSize: 20,
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentLocation,
          zoom: 17.7,
          rotation: 98,
          interactiveFlags: InteractiveFlag.none,
        ),
        nonRotatedChildren: [
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(
                  Uri.parse('https://openstreetmap.org/copyright'),
                ),
              ),
            ],
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: _markers),
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
      floatingActionButton: FloatingActionButton(
        onPressed: isListening ? _stopListening : _startListening,
        child: Icon(isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
