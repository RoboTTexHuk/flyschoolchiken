import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';



class WebGameScreen extends StatefulWidget {
  @override
  _WebGameScreenState createState() => _WebGameScreenState();
}

class _WebGameScreenState extends State<WebGameScreen> with SingleTickerProviderStateMixin {
  InAppWebViewController? webController; // Контроллер WebView
  double pageLoadProgress = 0.0; // Прогресс загрузки страницы

  final List<String> adFiltersList = [
    ".*.doubleclick.net/.*",
    ".*.ads.pubmatic.com/.*",
    ".*.googlesyndication.com/.*",
    ".*.google-analytics.com/.*",
    ".*.adservice.google.*/.*",
    ".*.adbrite.com/.*",
    ".*.exponential.com/.*",
    ".*.quantserve.com/.*",
    ".*.scorecardresearch.com/.*",
    ".*.zedo.com/.*",
    ".*.adsafeprotected.com/.*",
    ".*.teads.tv/.*",
    ".*.outbrain.com/.*",
  ];

  final List<ContentBlocker> webContentBlockers = [];
  late AnimationController loadingAnimationController;

  @override
  void initState() {
    super.initState();

    // Инициализация контент-блокеров
    for (final filter in adFiltersList) {
      webContentBlockers.add(ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: filter,
        ),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.BLOCK,
        ),
      ));
    }

    webContentBlockers.add(ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: ".cookie", resourceType: [
        ContentBlockerTriggerResourceType.RAW
      ]),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.BLOCK,
        selector: ".notification",
      ),
    ));

    webContentBlockers.add(ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: ".cookie", resourceType: [
        ContentBlockerTriggerResourceType.RAW
      ]),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.CSS_DISPLAY_NONE,
        selector: ".privacy-info",
      ),
    ));

    webContentBlockers.add(ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.CSS_DISPLAY_NONE,
        selector: ".banner, .banners, .ads, .ad, .advert",
      ),
    ));

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          // InAppWebView с контент-блокерами
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://application.birdsgohome.cfd/Ss7Kkm"), // Замените на нужный URL
            ),
            initialSettings: InAppWebViewSettings(
              contentBlockers: webContentBlockers, // Добавляем контент-блокеры
              javaScriptEnabled: true,
              javaScriptCanOpenWindowsAutomatically: true,
            ),
            onWebViewCreated: (controller) {
              webController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                pageLoadProgress = 0.0; // Сбрасываем прогресс при загрузке новой страницы
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                pageLoadProgress = 1.0; // Загрузка завершена
              });
            },
            onProgressChanged: (controller, newProgress) {
              setState(() {
                pageLoadProgress = newProgress / 100.0; // Обновляем прогресс
              });
            },
          ),
          // Индикатор загрузки
          if (pageLoadProgress < 1.0)
            Center(
              child: DashedCircularProgressBar.aspectRatio(
                aspectRatio: 1,
                progress: pageLoadProgress * 100, // Прогресс в процентах
                startAngle: 0,
                sweepAngle: 360,
                foregroundColor: Colors.blue,
                backgroundColor: Colors.grey.shade300,
                foregroundStrokeWidth: 8,
                backgroundStrokeWidth: 8,
                animation: true,
                child: Center(
                  child: Text(
                    "${(pageLoadProgress * 100).toInt()}%", // Показываем проценты
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}