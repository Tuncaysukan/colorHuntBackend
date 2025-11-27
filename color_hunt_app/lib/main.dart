import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    final config = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
    );
    MobileAds.instance.updateRequestConfiguration(config);
    await MobileAds.instance.initialize();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renk Avı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ColorHuntPage(),
    );
  }
}

class ColorHuntPage extends StatefulWidget {
  const ColorHuntPage({super.key});

  @override
  State<ColorHuntPage> createState() => _ColorHuntPageState();
}

class _ColorHuntPageState extends State<ColorHuntPage> {
  List<String> currentPalette = ['red', 'green', 'blue'];
  String targetColor = 'blue';
  Key gridKey = UniqueKey();
  late BannerAd _bannerAd;
  bool _bannerLoaded = false;
  InterstitialAd? _interstitialAd;
  int _correctCount = 0;

  String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _bannerLoaded = true),
          onAdFailedToLoad: (_, __) => setState(() => _bannerLoaded = false),
        ),
        request: const AdRequest(),
      )..load();
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (_) => _interstitialAd = null,
        ),
      );
    }
    _fetchLevels();
  }

  Future<void> _fetchLevels() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/color-hunt/levels'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        if (list.isNotEmpty) {
          final level = Map<String, dynamic>.from(list.first);
          final palette = List<String>.from(jsonDecode(level['paletteJson']));
          currentPalette = List<String>.from(palette)..shuffle();
          targetColor = (List<String>.from(palette)..shuffle()).first;
          setState(() {});
        }
      }
    } catch (_) {
      // sessiz geç
    }
  }

  void _onTapName(String name, int index) {
    final correct = name == targetColor;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(correct ? 'Doğru!' : 'Tekrar dene'),
        duration: const Duration(milliseconds: 800),
      ),
    );
    _postEvent(correct);
    if (!correct) return;
    currentPalette = [...currentPalette.sublist(1), currentPalette.first];
    gridKey = UniqueKey();
    _correctCount++;
    if (_interstitialAd != null && _correctCount % 3 == 0) {
      _interstitialAd!.show();
      _interstitialAd = null;
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (_) => _interstitialAd = null,
        ),
      );
    }
    setState(() {});
  }

  Future<void> _postEvent(bool correct) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/color-hunt/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sessionId': 'local',
          'anonymousId': 'anon',
          'eventType': 'tap',
          'payload': {'correct': correct},
        }),
      );
    } catch (_) {}
  }

  Color _parseColor(String name) {
    switch (name) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _instructionText() {
    switch (targetColor) {
      case 'red':
        return 'KIRMIZIYI BUL!';
      case 'green':
        return 'YEŞİLİ BUL!';
      case 'blue':
        return 'MAVİYİ BUL!';
      case 'yellow':
        return 'SARIYI BUL!';
      case 'purple':
        return 'MORU BUL!';
      default:
        return 'Rengi Bul!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_instructionText())),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Row(
                key: gridKey,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(currentPalette.length, (i) {
                  final name = currentPalette[i];
                  final color = _parseColor(name);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTapName(name, i),
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(blurRadius: 6, color: Colors.black26),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          if (_bannerLoaded && (Platform.isAndroid || Platform.isIOS))
            SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
  }
}
