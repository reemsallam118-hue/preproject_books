import 'package:flutter/material.dart';
import '../services/books_service.dart';
import 'book_details_view.dart';

class SearchView extends StatefulWidget {
  final String query;
  SearchView(this.query);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List books = [];
  bool loading = true;
  TextEditingController controller = TextEditingController();

  int selectedTab = 0;
  List tabTypes = ['all', 'books', 'authors'];

  @override
  void initState() {
    super.initState();
    controller.text = widget.query;
    search();
  }

  void search() async {
    String text = controller.text;
    if (text == '') {
      text = 'bestseller';
    }

    setState(() {
      loading = true;
    });
    try {
      books = await searchBooks(text, tabTypes[selectedTab]);
    } catch (e) {
      books = [];
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List tabNames = [tr('الكل', 'All'), tr('كتب', 'Books'), tr('مؤلفون', 'Authors')];

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE4),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4),
        title: Text(tr('نتائج البحث', 'Search results')),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onSubmitted: (text) {
                search();
              },
              decoration: InputDecoration(
                hintText: tr('ابحث عن كتاب أو مؤلف...', 'Search for a book or author...'),
                suffixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),

            Row(
              children: [
                for (int i = 0; i < 3; i++)
                  GestureDetector(
                    onTap: () {
                      selectedTab = i;
                      search();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedTab == i
                                ? Color(0xFFA8434B)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        tabNames[i],
                        style: TextStyle(
                          color: selectedTab == i
                              ? Color(0xFFA8434B)
                              : Color(0xFF8A8A8A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Divider(),

            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : books.isEmpty
                  ? Center(child: Text(tr('لا توجد نتائج', 'No results')))
                  : ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  var book = books[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsView(book),
                        ),
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
                    subtitle: Text(
                      getAuthor(book) +
                          '  •  ' +
                          (book['first_publish_year'] ?? '').toString(),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isInLibrary(book)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Color(0xFFA8434B),
                      ),
                      onPressed: () {
                        if (isInLibrary(book)) {
                          removeFromLibrary(book);
                        } else {
                          addToLibrary(book);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(tr('تمت الإضافة إلى المفضلة', 'Added to my favorites'))),
                          );
                        }
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}