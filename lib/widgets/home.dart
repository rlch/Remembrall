import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remembrall/models/book.dart';
import 'package:remembrall/services/book_service.dart';
import 'package:remembrall/widgets/book_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final BookService _bs = BookService();
  final TextEditingController searchController = TextEditingController();

  String query = "harry potter";
  Timer _debounce;
  static const int _debounceDuration = 200;

  int crossAxisCount = 4;

  @override
  void initState() {
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: _debounceDuration), () {
        if (searchController.text.isEmpty) return;
        setState(() {
          query = searchController.text;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Remembrall',
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: CupertinoTextField(
                  placeholder: "Search for a book:",
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  placeholderStyle:
                      Theme.of(context).inputDecorationTheme.hintStyle,
                  style: Theme.of(context).textTheme.subtitle1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: FutureBuilder<List<Book>>(
                  future: _bs.searchBooks(query),
                  initialData: [],
                  builder: (context, snapshot) {
                    final books = snapshot.hasData
                        ? snapshot.data
                        : snapshot.requireData ?? [];
                    print(books.length);
                    return AnimationLimiter(
                      key: ValueKey(books.isNotEmpty ? books[0]?.id : 0),
                      child: GridView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio:
                              0.625, // Standard aspect ratio for eBooks
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, i) =>
                            AnimationConfiguration.staggeredGrid(
                          duration: Duration(milliseconds: 300),
                          delay: Duration(milliseconds: 150),
                          columnCount: crossAxisCount,
                          position: i,
                          child: SlideAnimation(
                            child: ScaleAnimation(
                              scale: 0.7,
                              child: FadeInAnimation(
                                child: BookCard(
                                  books[i],
                                  key: ValueKey(books[i].id),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
