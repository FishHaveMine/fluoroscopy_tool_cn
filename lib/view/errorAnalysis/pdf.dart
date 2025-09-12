import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String pdfTitle;

  const PdfViewerScreen({
    Key? key,
    required this.pdfUrl,
    required this.pdfTitle,
  }) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String remotePDFpath = "";
  double downloadProgress = 0.0;
  bool isDownloading = false;

  bool fileExists = false;
  String downloadStatus = tr("downloadStatus");

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("开始从网络下载文件!");

    try {
      final url = widget.pdfUrl;
      final filename = widget.pdfTitle + ".pdf";
      print("filename: $filename");

      setState(() {
        isDownloading = true;
        downloadStatus = tr("downloadStatus1");
      });

      // 使用http包替代HttpClient以获取下载进度
      final response = await http.Client().get(Uri.parse(url));
      final totalBytes = response.contentLength ?? 0;

      // 再次请求以获取流式响应
      final streamResponse = await http.Client().send(
        http.Request('GET', Uri.parse(url)),
      );

      final bytesReceived = Completer<int>();
      final List<int> bytes = [];

      streamResponse.stream.listen(
        (List<int> newBytes) {
          bytes.addAll(newBytes);
          bytesReceived.complete(bytes.length);

          // 更新下载进度
          if (totalBytes > 0) {
            final progress = bytes.length / totalBytes;
            setState(() {
              downloadProgress = progress;
              downloadStatus =
                  "${tr('downloadStatus2')} ${(progress * 100).toStringAsFixed(1)}%";
            });
          }
        },
        onDone: () async {
          setState(() {
            downloadStatus = tr("downloadStatus3");
          });

          final dir = await getApplicationDocumentsDirectory();
          File file = File("${dir.path}/$filename");
          await file.writeAsBytes(bytes, flush: true);

          setState(() {
            isDownloading = false;
            downloadStatus = tr("downloadStatus4");
          });

          completer.complete(file);
        },
        onError: (e) {
          print('下载错误: $e');
          setState(() {
            isDownloading = false;
            downloadStatus = "${tr('downloadStatus5')}: $e";
          });
          completer.completeError(Exception('${tr('downloadStatus5')}: $e'));
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('获取文件错误: $e');
      setState(() {
        isDownloading = false;
        downloadStatus = "${tr("downloadStatuserror")}: $e";
      });
      completer.completeError(Exception('${tr("downloadStatus6")}: $e'));
    }

    return completer.future;
  }

// 检查文件是否存在
  Future<bool> checkFileExists() async {
    try {
      final filename = widget.pdfTitle + ".pdf";
      final dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      bool isex = await file.exists();
      if (isex) {
        // 获取文件状态
        final fileStat = await file.stat();

        // 获取创建日期
        final creationDate = fileStat.changed;

        // 格式化日期显示
        final formattedDate =
            DateFormat('yyyy-MM-dd HH:mm').format(creationDate);
        print("formattedDate:  $formattedDate");

        final differenceWithoutTime =
            DateTime.now().difference(creationDate).inDays;
        print("formattedDate differenceWithoutTime :  $differenceWithoutTime");
        if (differenceWithoutTime > 2) {
          isex = false;
        }
      }

      return isex;
    } catch (e) {
      print('检查文件存在性错误: $e');
      return false;
    }
  }

  // 获取文件路径
  Future<String> getFilePath() async {
    final filename = widget.pdfTitle + ".pdf";
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }

  @override
  void initState() {
    super.initState();
    checkFileExists().then((exists) {
      setState(() {
        fileExists = exists;
      });

      if (exists) {
        // 文件已存在，直接获取路径
        getFilePath().then((path) {
          setState(() {
            remotePDFpath = path;
            isDownloading = false;
            downloadStatus = tr('downloadStatus4');
          });
        });
      } else {
        // 文件不存在，开始下载
        createFileOfPdfUrl().then((f) {
          setState(() {
            remotePDFpath = f.path;
          });
        }).catchError((error) {
          print('下载PDF出错: $error');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDownloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: downloadProgress,
                    strokeWidth: 6.0,
                  ),
                  SizedBox(height: 20),
                  Text(
                    downloadStatus,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${(downloadProgress * 100).toStringAsFixed(1)}%",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                PDFScreen(
                  key: ValueKey(remotePDFpath),
                  isback: false,
                  path: remotePDFpath,
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        print("PDFScreen: click");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PDFScreen(isback: true, path: remotePDFpath),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;
  bool isback;

  PDFScreen({Key? key, this.path, required this.isback}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isback
          ? AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: Text(
                '',
                style: const TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              actions: [],
            )
          : null,
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            backgroundColor: Colors.white,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },

            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: ${page ?? 0 + 1}/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: SizedBox(
                    width: 320.w,
                    height: 320.w,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                      child: EmptyWidget(
                        image: null,
                        packageImage: PackageImage.Image_1,
                        title: tr('device.empty'),
                        titleTextStyle: const TextStyle(
                          fontSize: 22,
                          color: Color(0xff9da9c7),
                          fontWeight: FontWeight.w500,
                        ),
                        subtitleTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xffabb8d6),
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
