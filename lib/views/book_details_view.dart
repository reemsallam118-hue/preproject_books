import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/books_information.dart';

class BookDetailsView extends StatefulWidget {
  final Map book;
  BookDetailsView(this.book);

  @override
  State<BookDetailsView> createState() => _BookDetailsViewState();
}

class _BookDetailsViewState extends State<BookDetailsView> {
  static const Color _rose = Color(0xFFA8434B);

  bool added = false;

  @override
  void initState() {
    super.initState();
    added = isInLibrary(widget.book);
  }

  Widget infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: _rose),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A5A5A)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var book = widget.book;
    var year = (book['first_publish_year'] ?? '').toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          tr('تفاصيل الكتاب', 'Book details'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: _rose),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: bookCover(book, 130, 190),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      getAuthor(book),
                      style: const TextStyle(
                        color: Color(0xFF8A8A8A),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text(
                          '4.6',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        for (int i = 0; i < 5; i++)
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFD4A24C), size: 20),
                      ],
                    ),
                    if (year != '') ...[
                      const SizedBox(height: 14),
                      infoChip(Icons.calendar_today_outlined, year),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: added
                  ? []
                  : [
                BoxShadow(
                  color: _rose.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _rose,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF8A8A8A),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: added
                    ? null
                    : () {
                  addToLibrary(book);
                  setState(() {
                    added = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(tr('تمت الإضافة إلى المفضلة',
                            'Added to my favorites'))),
                  );
                },
                icon: Icon(added ? Icons.favorite : Icons.favorite_border),
                label: Text(
                  added
                      ? tr('تمت الإضافة إلى المفضلة', 'Added to my favorites')
                      : tr('أضف إلى المفضلة', 'Add to my favorites'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _rose,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tr('نبذة عن الكتاب', 'About the book'),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  tr(
                    'هذا الكتاب من تأليف ${getAuthor(book)}. نُشر لأول مرة عام ${book['first_publish_year'] ?? '-'}.',
                    'This book was written by ${getAuthor(book)}. First published in ${book['first_publish_year'] ?? '-'}.',
                  ),
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    height: 1.7,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}