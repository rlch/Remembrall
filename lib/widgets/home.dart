import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:remembrall/models/book.dart';
import 'package:remembrall/services/book_service.dart';
import 'package:remembrall/theme.dart';
import 'package:remembrall/widgets/book_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int crossAxisCount;
  String query = "Harry Potter";
  final TextEditingController searchController = TextEditingController();

  AppTheme appTheme;

  final BookService _bs = BookService();
  Timer _debounce;
  static const int _debounceDuration = 200;
  Future<List<Book>> searchBooks;

  @override
  void initState() {
    searchBooks = _bs.searchBooks(query);

    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: _debounceDuration), () {
        if (searchController.text.isEmpty) return;
        setState(() {
          query = searchController.text;
          searchBooks = _bs.searchBooks(query);
        });
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    appTheme = Provider.of<AppTheme>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    crossAxisCount = AppTheme.determineBreakpoint(width, 2, 3, 5, 6);
    return Scaffold(
      appBar: PreferredSize(
        child: Hero(
          tag: 'appBar',
          child: AppBar(
            title: Text(
              'Remembrall',
            ),
            actions: [
              IconButton(
                color: Theme.of(context).highlightColor,
                icon: Icon(
                  appTheme.isDark ? Icons.wb_sunny : Icons.nights_stay,
                ),
                onPressed: () => appTheme.switchTheme(),
              )
            ],
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
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
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  style: Theme.of(context).textTheme.subtitle1,
                  placeholderStyle:
                      Theme.of(context).inputDecorationTheme.hintStyle,
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
                  future: searchBooks,
                  initialData: [],
                  builder: (context, snapshot) {
                    final books = snapshot.hasData
                        ? snapshot.data
                        : snapshot.requireData ?? [];
                    return AnimationLimiter(
                      key: ValueKey(books.isNotEmpty ? books[0]?.id : 0),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
