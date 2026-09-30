import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/books_information.dart';
import 'search_view.dart';
import 'book_details_view.dart';
import 'favorites_view.dart';

const Color _rose = Color(0xFFA8434B);

List<BoxShadow> _softShadow() => [
  BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 12,
    offset: const Offset(0, 4),
  ),
];

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List pages = [
      HomeContent(),
      SearchView('', onHome: () => setState(() => currentIndex = 0)),
      favoritesView(onDiscover: () => setState(() => currentIndex = 0)),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: _rose,
            unselectedItemColor: const Color(0xFF8A8A8A),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  label: tr('الرئيسية', 'Home')),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.search_rounded),
                  label: tr('بحث', 'Search')),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_rounded),
                  label: tr('المفضلة', 'My favorites')),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List books = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  void loadBooks() async {
    try {
      books = await getBooks('bestseller');
    } catch (e) {
      books = [];
    }
    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  Widget categoryBox(String name, IconData icon, String query) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showCategoryBooks(name, query);
        },
        child: Container(
          height: 88,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _softShadow(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E4DB),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _rose, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCategoryBooks(String title, String query) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5EDE4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: 450,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A8A8A).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  tr('كتب مقترحة: $title', 'Recommended books: $title'),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder(
                    future: getBooks(query),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(tr('حدث خطأ، تأكد من الإنترنت',
                                'Something went wrong, check your internet')));
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator(color: _rose));
                      }
                      List list = snapshot.data as List;
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          var book = list[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: _softShadow(),
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetailsView(book),
                                  ),
                                );
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: bookCover(book, 50, 75),
                              ),
                              title: Text(
                                book['title'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(getAuthor(book)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget sectionTitle(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: _rose,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: languageSwitch(),
              ),
              Text(
                tr('كُتُب', 'Books'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: _rose,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: _softShadow(),
            ),
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchView(text)),
                );
              },
              decoration: InputDecoration(
                hintText: tr('ابحث عن كتاب أو مؤلف...',
                    'Search for a book or author...'),
                hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
                prefixIcon: const Icon(Icons.search, color: _rose),
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
          const SizedBox(height: 24),
          sectionTitle(tr('التصنيفات', 'Categories')),
          const SizedBox(height: 10),
          Row(
            children: [
              categoryBox(tr('روايات', 'Novels'), Icons.menu_book, 'novel'),
              categoryBox(tr('شعر', 'Poetry'), Icons.edit, 'poetry'),
              categoryBox(
                  tr('تاريخ', 'History'), Icons.account_balance, 'history'),
            ],
          ),
          Row(
            children: [
              categoryBox(tr('علم نفس', 'Psychology'), Icons.psychology,
                  'psychology'),
              categoryBox(
                  tr('قصص', 'Stories'), Icons.auto_stories, 'stories'),
              categoryBox(tr('مقالات', 'Essays'), Icons.article, 'essays'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              sectionTitle(tr('كتب مميزة', 'Featured books')),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchView('bestseller')),
                  );
                },
                child: Text(
                  tr('عرض الكل', 'View all'),
                  style: const TextStyle(
                      color: _rose, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          loading
              ? const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
                child: CircularProgressIndicator(color: _rose)),
          )
              : books.isEmpty
              ? Center(
              child: Text(tr('لا توجد كتب، تأكد من الإنترنت',
                  'No books found, check your internet')))
              : SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (context, index) {
                var book = books[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsView(book),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    margin:
                    const EdgeInsetsDirectional.only(end: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: bookCover(book, 120, 160),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book['title'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          getAuthor(book),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: const [
                            Icon(Icons.star,
                                color: Color(0xFFD4A24C), size: 16),
                            SizedBox(width: 2),
                            Text('4.5',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
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