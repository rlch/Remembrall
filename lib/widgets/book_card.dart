import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:remembrall/models/book.dart';
import 'package:remembrall/widgets/book_detail.dart';

class BookCard extends StatefulWidget {
  final Book book;

  BookCard(this.book, {Key key}) : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  Book book;

  bool _isHovering = false;
  final int _animationDuration = 200;

  @override
  void initState() {
    book = widget.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BookDetail(book),
      )),
      onHover: (isHovering) {
        setState(() {
          _isHovering = isHovering;
        });
      },
      child: Hero(
        tag: book.id,
        child: CachedNetworkImage(
          imageUrl: book.cover,
          imageBuilder: (context, imageProvider) => AnimatedContainer(
            duration: Duration(milliseconds: _animationDuration),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                _isHovering
                    ? BoxShadow(
                        color: Theme.of(context).primaryColor,
                        spreadRadius: 3,
                        blurRadius: 5,
                      )
                    : BoxShadow(
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
          errorWidget: (context, _, __) {
            return AnimatedContainer(
              duration: Duration(milliseconds: _animationDuration),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  _isHovering
                      ? BoxShadow(
                          color: Theme.of(context).primaryColor,
                          spreadRadius: 3,
                          blurRadius: 5,
                        )
                      : BoxShadow(
                          color: Theme.of(context).shadowColor,
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  )
                ],
              ),
            );
          },
          placeholder: (context, _) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
