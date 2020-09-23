import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:remembrall/models/book.dart';

class BookDetail extends StatefulWidget {
  final Book book;

  BookDetail(this.book);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  Book book;

  @override
  void initState() {
    book = widget.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: Icon(Icons.close),
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
          onPressed: () {},
          label: Text('Upload PDF'),
          icon: Icon(
            Icons.upload_file,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 40,
              ),
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
                  SizedBox(width: 40),
                  Flexible(
                    child: Column(
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
                                  maxLines: 6,
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
                                        color: Theme.of(context)
                                            .textTheme
                                            .button
                                            .color,
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
                                        color: Theme.of(context)
                                            .textTheme
                                            .button
                                            .color,
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
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
