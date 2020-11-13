import 'package:googleapis/books/v1.dart';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String cover;
  final int pages;

  Book(
    this.id,
    this.title,
    this.authors,
    this.description,
    this.cover,
    this.pages,
  );

  factory Book.fromVolume(Volume volume) {
    final info = volume.volumeInfo;

    String cover;
    final covers = info.imageLinks;
    cover = covers != null
        ? covers.extraLarge ??
            covers.large ??
            covers.medium ??
            covers.small ??
            covers.thumbnail ??
            covers.smallThumbnail ??
            ""
        : "";
    cover = cover.replaceAll("http", "https");

    return Book(
      volume.id,
      info.title,
      info.authors,
      info.description,
      cover,
      info.pageCount,
    );
  }
}
