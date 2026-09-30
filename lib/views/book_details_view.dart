import 'package:flutter/material.dart';
import '../services/books_service.dart';

class BookDetailsView extends StatefulWidget {
  final Map book;
  BookDetailsView(this.book);

  @override
  State<BookDetailsView> createState() => _BookDetailsViewState();
}

class _BookDetailsViewState extends State<BookDetailsView> {
  bool added = false;

  @override
  void initState() {
    super.initState();
    added = isInLibrary(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    var book = widget.book;

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE4),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4),
        title: Text(tr('تفاصيل الكتاب', 'Book details')),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bookCover(book, 130, 190),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['title'] ?? '',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      getAuthor(book),
                      style: TextStyle(color: Color(0xFF8A8A8A)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '4.6',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.star, color: Color(0xFFD4A24C), size: 18),
                        Icon(Icons.star, color: Color(0xFFD4A24C), size: 18),
                        Icon(Icons.star, color: Color(0xFFD4A24C), size: 18),
                        Icon(Icons.star, color: Color(0xFFD4A24C), size: 18),
                        Icon(Icons.star, color: Color(0xFFD4A24C), size: 18),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA8434B),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Color(0xFF8A8A8A),
                disabledForegroundColor: Colors.white,
              ),
              onPressed: added
                  ? null
                  : () {
                addToLibrary(book);
                setState(() {
                  added = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(tr('تمت الإضافة إلى المفضلة', 'Added to my favorites'))),
                );
              },
              child: Text(added ? tr('تمت الإضافة إلى المفضلة', 'Added to my favorites') : tr('أضف إلى المفضلة', 'Add to my favorites')),
            ),
          ),
          SizedBox(height: 20),

          Text(
            tr('نبذة عن الكتاب', 'About the book'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            tr(
              'هذا الكتاب من تأليف ${getAuthor(book)}. نُشر لأول مرة عام ${book['first_publish_year'] ?? '-'}.',
              'This book was written by ${getAuthor(book)}. First published in ${book['first_publish_year'] ?? '-'}.',
            ),
            style: TextStyle(color: Color(0xFF8A8A8A), height: 1.6),
          ),
        ],
      ),
    );
  }
}