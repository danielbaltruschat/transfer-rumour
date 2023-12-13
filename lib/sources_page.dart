import 'package:flutter/material.dart';
import 'transfer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'queries.dart';

class TwitterEmbed extends StatefulWidget {
  final int tweetID;
  const TwitterEmbed({required this.tweetID});

  @override
  State<TwitterEmbed> createState() => _TwitterEmbedState();
}

class _TwitterEmbedState extends State<TwitterEmbed> {
  late bool isLoaded = false;
  late double height = 300;

  late WebViewController controller = WebViewController()
    ..loadHtmlString(getHtmlString(widget.tweetID))
    //..loadHtmlString(getHtmlString2())
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..addJavaScriptChannel("Twitter", onMessageReceived: (message) {
      if (this.mounted) {
        setState(() {
          isLoaded = true;
          height = double.parse(message.message);
        });
      }
    })
    ..setNavigationDelegate(
        NavigationDelegate(onNavigationRequest: (navigation) {
      if (!(navigation.url == "about:blank" ||
          navigation.url.startsWith("https://platform.twitter."))) {
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    }));

  String getHtmlString(int tweetId) {
    return """
        <html>
        
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
          </head>
          <body>
              <div id="container"></div>
                  
          </body>
          <script id="twitter-wjs" type="text/javascript" async defer src="https://platform.twitter.com/widgets.js" onload="createMyTweet()"></script>
          <script>
          
        
        function  createMyTweet() {  
          var twtter = window.twttr;
    
          twttr.widgets.createTweet(
            '$tweetId',
            document.getElementById('container'),
          ).then(function (el) {
            Twitter.postMessage(container.offsetHeight.toString());
          })
        }
          </script>
          
        </html>
      """;
  }

  String getHtmlString2() {
    return "\u003Cblockquote class=\"twitter-tweet\"\u003E\u003Cp lang=\"en\" dir=\"ltr\"\u003ESunsets don&#39;t get much better than this one over \u003Ca href=\"https:\/\/twitter.com\/GrandTetonNPS?ref_src=twsrc%5Etfw\"\u003E@GrandTetonNPS\u003C\/a\u003E. \u003Ca href=\"https:\/\/twitter.com\/hashtag\/nature?src=hash&amp;ref_src=twsrc%5Etfw\"\u003E#nature\u003C\/a\u003E \u003Ca href=\"https:\/\/twitter.com\/hashtag\/sunset?src=hash&amp;ref_src=twsrc%5Etfw\"\u003E#sunset\u003C\/a\u003E \u003Ca href=\"http:\/\/t.co\/YuKy2rcjyU\"\u003Epic.twitter.com\/YuKy2rcjyU\u003C\/a\u003E\u003C\/p\u003E&mdash; US Department of the Interior (@Interior) \u003Ca href=\"https:\/\/twitter.com\/Interior\/status\/463440424141459456?ref_src=twsrc%5Etfw\"\u003EMay 5, 2014\u003C\/a\u003E\u003C\/blockquote\u003E\n\u003Cscript async src=\"https:\/\/platform.twitter.com\/widgets.js\" charset=\"utf-8\"\u003E\u003C\/script\u003E\n";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(children: [
        WebViewWidget(controller: controller),
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLoaded
                ? const SizedBox.shrink()
                : const Center(child: CircularProgressIndicator.adaptive()),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            })
      ]),
    );
  }
}

class PopUpSource<T> extends PopupRoute<T> {
  final String source;
  final String sourceLink;
  late final Widget popUp;

  PopUpSource({required this.source, required this.sourceLink}) {
    if (source.toLowerCase() == "twitter") {
      popUp = TwitterEmbed(tweetID: int.parse(sourceLink));
    } else {
      popUp = WebViewWidget(
          controller: WebViewController()
            ..loadRequest(Uri.parse(sourceLink))
            ..setJavaScriptMode(JavaScriptMode.unrestricted));
    }
  }

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "Dismissible";

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    //return Center(child: popUp);
    // List<String> sourceDataArgs =
    //     ModalRoute.of(context)!.settings.arguments as List<String>;

    // late final sourceType = sourceDataArgs[0];
    // late final sourceLink = sourceDataArgs[1];

    // late final Widget popUp;
    // if (sourceType.toLowerCase() == "twitter") {
    //   popUp = TwitterEmbed(tweetID: int.parse(sourceLink));
    // } else {
    //   popUp = WebViewWidget(
    //       controller: WebViewController()
    //         ..loadRequest(Uri.parse(sourceLink))
    //         ..setJavaScriptMode(JavaScriptMode.unrestricted));
    // }

    return Center(
        child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: popUp)));
  }
}

class Source {
  final String sourceText;
  final int sourceID;
  final String sourceType;
  final String sourceLink;
  final String sourceAuthor;

  Source(
      {required this.sourceText,
      required this.sourceID,
      required this.sourceType,
      required this.sourceLink,
      required this.sourceAuthor});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
        sourceText: json["text"],
        sourceID: json["source_id"],
        sourceType: json["source_type"],
        sourceLink: json["source_link"],
        sourceAuthor: json["author_name"]);
  }
}

class SourceWidget extends StatelessWidget {
  final Source source;
  late final Widget image;
  late final String sourceURL;
  late final String sourceAuthorDisplay;

  SourceWidget({required this.source}) {
    if (source.sourceType.toLowerCase() == "twitter") {
      image = Image.asset("assets/X_white.png");
      sourceURL =
          "https://twitter.com/${source.sourceAuthor}/status/${source.sourceLink}";
      sourceAuthorDisplay = "@${source.sourceAuthor}";
    } else {
      image = const Icon(Icons.newspaper, color: Colors.black);
      sourceURL = source.sourceLink;
      sourceAuthorDisplay = source.sourceAuthor;
    }
  }

  factory SourceWidget.fromJson(Map<String, dynamic> json) {
    return SourceWidget(source: Source.fromJson(json));
  }

  _openLinkInBrowser() async {
    final Uri url = Uri.parse(sourceURL);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //Navigator.push(context, DismissibleDialog(testArg: "test"));
          Navigator.of(context).push(PopUpSource(
              source: source.sourceType, sourceLink: source.sourceLink));
          // Navigator.of(context).pushNamed('sources/popup',
          //     arguments: [source.sourceType, source.sourceLink]);
        },
        child:
            // ConstrainedBox(
            //     constraints: BoxConstraints(maxHeight: 200),
            //     child:
            Padding(
                padding: const EdgeInsets.only(top: 5, left: 3, right: 3),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 4)
                        ]),
                    child: Row(children: [
                      Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: image))),
                      const SizedBox(width: 18),
                      Expanded(
                          flex: 4,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(children: [
                                Text(sourceAuthorDisplay,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 3),
                                Text(source.sourceText,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500))
                              ]))),
                      Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: IconButton(
                                  icon: const Icon(Icons.open_in_new),
                                  onPressed: _openLinkInBrowser)))
                    ]))));
  }
}

class SourcesList extends StatelessWidget {
  final Transfer transfer;
  late Future<List<SourceWidget>> futureSources = getSources(transfer);
  // late Future<List<TwitterEmbed>> futureTweets = Future.value([
  //   const TwitterEmbed(tweetID: 1685649487539122177),
  //   const TwitterEmbed(tweetID: 1686114646984445952)
  // ]);
  // final Future<List<SourceWidget>> futureSources = Future.value([
  //   SourceWidget.fromJson({
  //     "text":
  //         "This is a test tweetggggajwfoijaopgjwpogjsopagjop[es jgpoeshjgposejophjeposyjaioerjhgiohrdiohiordhgiozhdsrioghriod`ghiordhiozgjdroijhgiodrjhzgiuh`uildghiudhzliughduizghiudhigkh`oirhg;iordzhiohiod`hoig;oi]",
  //     "source_id": 1,
  //     "source_type": "twitter",
  //     "source_link": "1685649487539122177",
  //     "author": "elonmusk"
  //   }),
  //   SourceWidget.fromJson({
  //     "text": "This is a test tweet",
  //     "source_id": 2,
  //     "source_type": "twitter",
  //     "source_link": "1686114646984445952",
  //     "author": "elonmusk"
  //   }),
  //   SourceWidget.fromJson({
  //     "text": "This is a test tweet",
  //     "source_id": 3,
  //     "source_type": "twitter",
  //     "source_link": "1685649487539122177",
  //     "author": "elonmusk"
  //   }),
  // ]);

  SourcesList({required this.transfer});

  static Future<List<SourceWidget>> getSources(Transfer transfer) async {
    List<Map<String, dynamic>> json =
        await QueryServer.getSources(transfer.transferID);
    final List<SourceWidget> sources = [];

    for (Map<String, dynamic> transfer in json) {
      Source source = Source.fromJson(transfer);
      sources.add(SourceWidget(source: source));
    }
    return sources;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SourceWidget>>(
        future: futureSources,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  //JavaScript get element height?
                  return snapshot.data![index];
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator.adaptive();
        });
  }
}

class SourcesPage extends StatelessWidget {
  const SourcesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Transfer transfer =
        ModalRoute.of(context)!.settings.arguments as Transfer;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.width * 0.25,
          flexibleSpace: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Row(children: [
                    const SizedBox(width: 50),
                    Expanded(
                        child: TransferWidgetUnboxed(
                            transfer: transfer,
                            onPlayerTap: () {
                              print("Player tapped");
                            }))
                  ]))),
        ),

        //body: TwitterEmbed(tweetID: 1685649487539122177));
        body: SourcesList(transfer: transfer));
  }
}
