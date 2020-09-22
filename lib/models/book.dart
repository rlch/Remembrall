import 'package:googleapis/books/v1.dart';

class Book {
  final String id;
  final String title;
  final String description;
  final String cover;

  Book(
    this.id,
    this.title,
    this.description,
    this.cover,
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

    return Book(
      volume.id,
      info.title,
      info.description,
      cover,
    );
  }
}
