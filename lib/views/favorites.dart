import 'package:flutter/material.dart';
import '../services/books_service.dart';
import '../widgets/empty_state.dart';
import 'book_details_view.dart';

class favoritesView extends StatefulWidget {
  final VoidCallback? onDiscover;

  const favoritesView({super.key, this.onDiscover});

  @override
  State<favoritesView> createState() => _favoritesViewState();
}

class _favoritesViewState extends State<favoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        title: Text(tr('المفضلة', 'My favorites')),
        centerTitle: true,
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
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: libraryBooks.length,
        itemBuilder: (context, index) {
          var book = libraryBooks[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDetailsView(book)),
              ).then((value) {
                setState(() {});
              });
            },
            leading: bookCover(book, 50, 75),
            title: Text(
              book['title'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(getAuthor(book)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Color(0xFFA8434B)),
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