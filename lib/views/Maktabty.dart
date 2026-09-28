import 'package:flutter/material.dart';
import '../services/books_service.dart';
import 'book_details_view.dart';

class MaktabtyView extends StatefulWidget {
  @override
  State<MaktabtyView> createState() => _MaktabtyViewState();
}

class _MaktabtyViewState extends State<MaktabtyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EDE4),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4),
        title: Text(tr('مكتبتي', 'My library')),
        centerTitle: true,
      ),
      body: libraryBooks.isEmpty
          ? Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            tr(
              'مكتبتك فارغة\nاضغط "أضف إلى مكتبتي" في صفحة أي كتاب لإضافته هنا',
              'Your library is empty\nPress "Add to my library" on any book page to add it here',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF8A8A8A)),
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: libraryBooks.length,
        itemBuilder: (context, index) {
          var book = libraryBooks[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookDetailsView(book)),
              ).then((value) {
                setState(() {});
              });
            },
            leading: bookCover(book, 50, 75),
            title: Text(
              book['title'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(getAuthor(book)),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Color(0xFFA8434B)),
              onPressed: () {
                setState(() {
                  libraryBooks.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}