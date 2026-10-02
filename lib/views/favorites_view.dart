import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/app_colors.dart';
import 'package:preproject_books/Constants/books_information.dart';
import '../widgets/empty_state_widgets.dart';
import 'book_details_view.dart';

class favoritesView extends StatefulWidget {
  final VoidCallback? onDiscover;
  const favoritesView({super.key, this.onDiscover});

  @override
  State<favoritesView> createState() => _favoritesViewState();
}

class _favoritesViewState extends State<favoritesView> {
  static const Color _rose = Color(0xFFA8434B);

  void removeBook(int index) {
    var removed = libraryBooks[index];
    setState(() {
      libraryBooks.removeAt(index);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('تمت الإزالة من المفضلة', 'Removed from favorites')),
        action: SnackBarAction(
          label: tr('تراجع', 'Undo'),
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              libraryBooks.insert(index, removed);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          tr('المفضلة', 'My favorites'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: _rose),
            onPressed: () => widget.onDiscover?.call(),
          ),
        ],
      ),
      body: libraryBooks.isEmpty
          ? EmptyState(
        title: tr('لا توجد كتب مفضلة بعد', 'No favorites yet'),
        subtitle: tr(
          'أضف كتباً تعجبك لتظهر هنا',
          'Add books you like and they will show up here',
        ),
        buttonText: tr('اكتشف كتب', 'Discover books'),
        onPressed: () => widget.onDiscover?.call(),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: _rose, size: 18),
                const SizedBox(width: 8),
                Text(
                  tr('${libraryBooks.length} كتاب',
                      '${libraryBooks.length} books'),
                  style: const TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: libraryBooks.length,
              itemBuilder: (context, index) {
                var book = libraryBooks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: context.card,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailsView(book)),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: bookCover(book, 60, 90),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book['title'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    getAuthor(book),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF8A8A8A),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: const [
                                      Icon(Icons.star,
                                          color: Color(0xFFD4A24C),
                                          size: 16),
                                      SizedBox(width: 4),
                                      Text('4.6',
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: _rose),
                              onPressed: () => removeBook(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
