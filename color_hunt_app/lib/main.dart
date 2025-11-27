import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
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
  static const String kDefineBaseUrl = String.fromEnvironment('BASE_URL');
  List<Map<String, dynamic>> levels = [];
  int currentLevelIndex = 0;
  String targetColor = 'red';
  late BannerAd _bannerAd;
  bool _isBannerLoaded = false;
  InterstitialAd? _interstitialAd;
  int _correctCount = 0;
  List<String> currentPalette = [];

  String get baseUrl {
    if (kDefineBaseUrl.isNotEmpty) return kDefineBaseUrl;
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      _loadBanner();
      _loadInterstitial();
    }
    _fetchLevels();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerLoaded = true),
        onAdFailedToLoad: (_, __) => setState(() => _isBannerLoaded = false),
      ),
      request: const AdRequest(),
    )..load();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (_) => _interstitialAd = null,
      ),
    );
  }

  Future<void> _fetchLevels() async {
    final uri = Uri.parse('$baseUrl/api/color-hunt/levels');
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        levels = data.map((e) => Map<String, dynamic>.from(e)).toList();
        if (levels.isNotEmpty) {
          _setupLevel(0);
        }
        setState(() {});
        return;
      }
    } catch (_) {
      // ignore
    }
    // Fallback seviyeler
    levels = [
      {
        'id': 1,
        'speed': 1,
        'colorsCount': 3,
        'paletteJson': jsonEncode(['red', 'green', 'blue'])
      },
      {
        'id': 2,
        'speed': 2,
        'colorsCount': 4,
        'paletteJson': jsonEncode(['red', 'yellow', 'green', 'blue'])
      },
    ];
    _setupLevel(0);
    setState(() {});
  }

  void _setupLevel(int index) {
    currentLevelIndex = index;
    final level = levels[index];
    final palette = List<String>.from(jsonDecode(level['paletteJson']));
    targetColor = (palette..shuffle()).first;
    currentPalette = List<String>.from(palette)..shuffle();
    debugPrint(
        '[ColorHunt] setupLevel index=$index target=$targetColor palette=$palette');
    setState(() {});
  }

  Future<void> _postEvent(bool correct) async {
    final uri = Uri.parse('$baseUrl/api/color-hunt/events');
    final body = {
      'sessionId': 'local',
      'anonymousId': 'anon',
      'eventType': 'tap',
      'payload': {
        'correct': correct,
      },
    };
    await http.post(uri,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
  }

  void _onTap(String color) async {
    debugPrint('[ColorHunt] tap color=$color target=$targetColor');
    final correct = color == targetColor;
    await _postEvent(correct);
    final snack = SnackBar(
        content: Text(correct ? 'Doğru!' : 'Tekrar dene'),
        duration: const Duration(milliseconds: 600));
    ScaffoldMessenger.of(context).showSnackBar(snack);
    if (correct) {
      debugPrint('[ColorHunt] correct tap');
      _correctCount++;
      if (_interstitialAd != null && _correctCount % 3 == 0) {
        _interstitialAd!.show();
        _interstitialAd = null;
        _loadInterstitial();
      }
      // Konumu garanti değiştir: bir adım sağa döndür
      if (currentPalette.isNotEmpty) {
        currentPalette = [
          ...currentPalette.sublist(1),
          currentPalette.first,
        ];
      }
      debugPrint('[ColorHunt] palette rotated: $currentPalette');
      setState(() {});
    }
  }

  List<Widget> _shapeGrid() {
    if (levels.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Yükleniyor...'),
        ),
        TextButton(onPressed: _fetchLevels, child: const Text('Tekrar Dene')),
      ];
    }
    final level = levels[currentLevelIndex];
    debugPrint('[ColorHunt] shapeGrid palette=$currentPalette');
    return List.generate(currentPalette.length, (i) {
      final name = currentPalette[i];
      final color = _parseColor(name);
      return GestureDetector(
        key: ValueKey('$name-$i-$currentLevelIndex-$_correctCount'),
        onTap: () => _onTap(name),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200 + (level['speed'] as int) * 50),
          margin: const EdgeInsets.all(8),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(blurRadius: 6, color: Colors.black26)
              ]),
        ),
      );
    });
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

  String _colorName(Color c) {
    if (c == Colors.red) return 'red';
    if (c == Colors.green) return 'green';
    if (c == Colors.blue) return 'blue';
    if (c == Colors.yellow) return 'yellow';
    if (c == Colors.purple) return 'purple';
    return 'grey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_instructionText().toUpperCase())),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: _shapeGrid(),
              ),
            ),
          ),
          if (_isBannerLoaded && (Platform.isAndroid || Platform.isIOS))
            SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
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
}
