import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/books_information.dart';
import 'book_details_view.dart';

class SearchView extends StatefulWidget {
  final String query;
  final VoidCallback? onHome;
  SearchView(this.query, {this.onHome});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  static const Color _rose = Color(0xFFA8434B);

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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List tabNames = [tr('الكل', 'All'), tr('كتب', 'Books'), tr('مؤلفون', 'Authors')];

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          tr('نتائج البحث', 'Search results'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: _rose),
            onPressed: () {
              if (widget.onHome != null) {
                widget.onHome!();
              } else {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Column(
          children: [
            // خانة البحث
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (text) {
                  search();
                },
                decoration: InputDecoration(
                  hintText: tr('ابحث عن كتاب أو مؤلف...',
                      'Search for a book or author...'),
                  hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search, color: _rose),
                    onPressed: search,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // التابات كأزرار
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: GestureDetector(
                        onTap: () {
                          selectedTab = i;
                          search();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedTab == i ? _rose : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tabNames[i],
                            style: TextStyle(
                              color: selectedTab == i
                                  ? Colors.white
                                  : const Color(0xFF8A8A8A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: loading
                  ? const Center(
                  child: CircularProgressIndicator(color: _rose))
                  : books.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 64, color: _rose.withOpacity(0.4)),
                    const SizedBox(height: 12),
                    Text(
                      tr('لا توجد نتائج', 'No results'),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  var book = books[index];
                  var year =
                  (book['first_publish_year'] ?? '').toString();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailsView(book),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(8),
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
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      year == ''
                                          ? getAuthor(book)
                                          : getAuthor(book) +
                                          '  •  ' +
                                          year,
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF8A8A8A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isInLibrary(book)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _rose,
                                ),
                                onPressed: () {
                                  if (isInLibrary(book)) {
                                    removeFromLibrary(book);
                                  } else {
                                    addToLibrary(book);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(tr(
                                            'تمت الإضافة إلى المفضلة',
                                            'Added to my favorites')),
                                      ),
                                    );
                                  }
                                  setState(() {});
                                },
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
      ),
    );
  }
}