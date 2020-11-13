import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:remembrall/models/book.dart';
import 'package:remembrall/theme.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:remembrall/widgets/snackbar.dart';

class BookDetail extends StatefulWidget {
  final Book book;

  BookDetail(this.book);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  GlobalKey scaffoldKey = GlobalKey();
  Book book;
  bool shouldStack;

  @override
  void initState() {
    book = widget.book;
    super.initState();
  }

  void uploadPDF() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files.first;
        if (file.type == 'application/pdf') {
          final int timestamp = DateTime.now().millisecondsSinceEpoch;
          fb.StorageReference ref = fb
              .app()
              .storage()
              .refFromURL('gs://remembrallpdf.appspot.com')
              .child('pdf')
              .child(book.id)
              .child('$timestamp.pdf');
          fb.UploadTask uploadTask = ref.put(file);
          await uploadTask.future;

          CloudFunctions(region: 'australia-southeast1')
              .getHttpsCallable(functionName: 'recogniseTextFromPdf')
              .call({'name': '${book.id}/$timestamp.pdf'});
        } else {
          (scaffoldKey.currentState as ScaffoldState).showSnackBar(
              getSnackBar("Please upload a .pdf file.", Colors.red));
        }
      } else {
        (scaffoldKey.currentState as ScaffoldState).showSnackBar(
            getSnackBar("Please upload a single file.", Colors.red));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    shouldStack =
        AppTheme.determineBreakpoint(width, true, false, false, false);

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        child: Hero(
          tag: 'appBar',
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Remembrall',
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).highlightColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 300,
        child: FloatingActionButton.extended(
          onPressed: uploadPDF,
          label: Text(
            'Upload PDF',
            style: TextStyle(
              color: Theme.of(context).textTheme.button.color,
            ),
          ),
          icon: Icon(
            Icons.upload_file,
            color: Theme.of(context).textTheme.button.color,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                child: SizedBox(
                  width: width < AppTheme.tabletBoundary
                      ? null
                      : AppTheme.tabletBoundary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: book.id,
                        child: SizedBox(
                          height: 350,
                          width: 0.625 * 350,
                          child: CachedNetworkImage(
                            imageUrl: book.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 5),
                                  )
                                ],
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!shouldStack) SizedBox(width: 40),
                      if (!shouldStack)
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: BookDescription(book),
                        )),
                    ],
                  ),
                ),
              ),
            ),
            if (shouldStack)
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 90),
                  child: BookDescription(book),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BookDescription extends StatelessWidget {
  final Book book;
  BookDescription(this.book);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          overflow: TextOverflow.fade,
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          book.authors.reduce((s1, s2) => '$s1, $s2') +
              " · ${book.pages.toString()} pages",
          overflow: TextOverflow.fade,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(height: 20),
        ExpandableNotifier(
          child: Expandable(
            collapsed: Column(
              children: [
                Text(
                  book.description ?? "",
                  maxLines: 10,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ExpandableButton(
                    child: IconButton(
                      onPressed: null,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        Icons.expand_more,
                        color: Theme.of(context).textTheme.button.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            expanded: Column(
              children: [
                Text(
                  book.description ?? "",
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ExpandableButton(
                    child: IconButton(
                      onPressed: null,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        Icons.expand_less,
                        color: Theme.of(context).textTheme.button.color,
                      ),
                    ),
                  ),
                )
              ],
            ),
            theme: ExpandableThemeData(
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
              useInkWell: false,
              inkWellBorderRadius: BorderRadius.circular(100),
            ),
          ),
        )
      ],
    );
  }
}
