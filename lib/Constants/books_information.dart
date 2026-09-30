import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
ValueNotifier<bool> isArabic = ValueNotifier(true);
String tr(String ar, String en) {
  if (isArabic.value) {
    return ar;
  }
  return en;
}
List libraryBooks = [];
Future<List> getBooks(String q) async {
  var url = Uri.parse(
      'https://openlibrary.org/search.json?q=${Uri.encodeComponent(q)}&limit=15');
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  return data['docs'];
}
Future<List> searchBooks(String text, String type) async {
  String param = 'q';
  if (type == 'books') {
    param = 'title';
  }
  if (type == 'authors') {
    param = 'author';
  }
  var url = Uri.parse(
      'https://openlibrary.org/search.json?$param=${Uri.encodeComponent(text)}&limit=15');
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  return data['docs'];
}
Widget bookCover(Map book, double w, double h) {
  if (book['cover_i'] == null) {
    return Container(
      width: w,
      height: h,
      color: Color(0xFF4A3528),
      child: Center(
        child: Text(
          book['title'] ?? '',
          style: TextStyle(color: Colors.white, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  return Image.network(
    'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg',
    width: w,
    height: h,
    fit: BoxFit.cover,
  );
}
String getAuthor(Map book) {
  if (book['author_name'] == null) {
    return tr('غير معروف', 'Unknown');
  }
  return book['author_name'][0];
}
bool isInLibrary(Map book) {
  for (var b in libraryBooks) {
    if (b['key'] == book['key']) {
      return true;
    }
  }
  return false;
}
void addToLibrary(Map book) {
  if (isInLibrary(book) == false) {
    libraryBooks.add(book);
  }
}
void removeFromLibrary(Map book) {
  libraryBooks.removeWhere((b) => b['key'] == book['key']);
}
Widget languageSwitch() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            isArabic.value = true;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isArabic.value ? Color(0xFFA8434B) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'AR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isArabic.value ? Colors.white : Color(0xFF8A8A8A),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            isArabic.value = false;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isArabic.value ? Colors.transparent : Color(0xFFA8434B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'EN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isArabic.value ? Color(0xFF8A8A8A) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}