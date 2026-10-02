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

// ===================== مكتبتي (الكتب اللي بتقراها) =====================
// readingBooks: الكتب اللي ضفتها لمكتبتي بزرار "قراءة الآن"
// readingProgress: نسبة التقدم لكل كتاب من 0.0 لـ 1.0 (المفتاح = book['key'])
List readingBooks = [];
Map<String, double> readingProgress = {};

bool isReading(Map book) {
  for (var b in readingBooks) {
    if (b['key'] == book['key']) {
      return true;
    }
  }
  return false;
}

void startReading(Map book) {
  if (isReading(book) == false) {
    readingBooks.add(book);
    readingProgress[book['key'].toString()] = 0.0;
  }
}

double getProgress(Map book) {
  return readingProgress[book['key'].toString()] ?? 0.0;
}

void setProgress(Map book, double value) {
  readingProgress[book['key'].toString()] = value.clamp(0.0, 1.0);
}

void removeFromReading(Map book) {
  readingBooks.removeWhere((b) => b['key'] == book['key']);
  readingProgress.remove(book['key'].toString());
}

// ===================== الإعدادات =====================
// حجم الخط: 0.9 صغير / 1.0 متوسط / 1.15 كبير
ValueNotifier<double> fontScale = ValueNotifier(1.0);
ValueNotifier<bool> notificationsOn = ValueNotifier(true);

// الوضع الداكن
ValueNotifier<bool> isDark = ValueNotifier(false);

// ملف الكتاب اللي اختاره المستخدم من جهازه (PDF / TXT) وآخر صفحة وصلها في الـ PDF
Map<String, String> bookFiles = {};
Map<String, int> bookLastPage = {};
