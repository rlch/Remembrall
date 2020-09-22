import 'package:googleapis/books/v1.dart';
import 'package:googleapis_auth/auth_browser.dart' as auth;
import 'package:remembrall/models/book.dart';
import 'package:http/http.dart' as http;

class BookService {
  http.Client _client;

  final _apiKey = "AIzaSyBb6Qsw1UVXGrk1c8dcakZIuzcOxhRTBkU";

  BookService() {
    _client = auth.clientViaApiKey(_apiKey);
  }

  Future<List<Book>> searchBooks(String query) async {
    if (query.isEmpty) return [];
    final Volumes vols = await BooksApi(_client).volumes.list(
          query,
          printType: "books",
          orderBy: "relevance",
          maxResults: 20,
        );
    final List<Book> books =
        vols.items.map((vol) => Book.fromVolume(vol)).toList();
    return books;
  }
}
