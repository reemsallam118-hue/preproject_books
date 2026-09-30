import 'package:flutter/material.dart';
import '../services/books_service.dart';
import 'search_view.dart';
import 'book_details_view.dart';
import 'favorites.dart';

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
      SearchView(''),
      favoritesView(onDiscover: () => setState(() => currentIndex = 0)),    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE4),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFF5EDE4),
        selectedItemColor: Color(0xFFA8434B),
        unselectedItemColor: Color(0xFF8A8A8A),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: tr('الرئيسية', 'Home')),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: tr('بحث', 'Search')),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: tr('المفضلة', ' my favorites')),
        ],
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
    setState(() {
      loading = false;
    });
  }

  Widget categoryBox(String name, IconData icon, Color color, String query) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showCategoryBooks(name, query);
        },
        child: Container(
          height: 80,
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Color(0xFFA8434B)),
              SizedBox(height: 4),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }

  void showCategoryBooks(String title, String query) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFFF5EDE4),
      builder: (context) {
        return SizedBox(
          height: 450,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  tr('كتب مقترحة: $title', 'Recommended books: $title'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder(
                    future: getBooks(query),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text(tr('حدث خطأ، تأكد من الإنترنت', 'Something went wrong, check your internet')));
                      }
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      List list = snapshot.data as List;
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          var book = list[index];
                          return ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsView(book),
                                ),
                              );
                            },
                            leading: bookCover(book, 50, 75),
                            title: Text(
                              book['title'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(getAuthor(book)),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: languageSwitch(),
              ),
              Text(
                tr('كُتُب', 'Kotob'),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA8434B),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          TextField(
            onSubmitted: (text) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchView(text)),
              );
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
          SizedBox(height: 20),

          Text(
            tr('التصنيفات', 'Categories'),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          Row(
            children: [
              categoryBox(tr('روايات', 'Novels'), Icons.menu_book, Color(0xFFEDE0D0), 'novel'),
              categoryBox(tr('شعر', 'Poetry'), Icons.edit, Color(0xFFEDE0D0), 'poetry'),
              categoryBox(tr('تاريخ', 'History'), Icons.account_balance, Color(0xFFEDE0D0), 'history'),
            ],
          ),
          Row(
            children: [
              categoryBox(tr('علم نفس', 'Psychology'), Icons.psychology, Color(0xFFEDE0D0), 'psychology'),
              categoryBox(tr('قصص', 'Stories'), Icons.auto_stories, Color(0xFFEDE0D0), 'stories'),
              categoryBox(tr('مقالات', 'Essays'), Icons.article, Color(0xFFEDE0D0), 'essays'),
            ],
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr('كتب مميزة', 'Featured books'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchView('bestseller')),
                  );
                },
                child: Text(tr('عرض الكل', 'View all'), style: TextStyle(color: Color(0xFFA8434B))),
              ),
            ],
          ),
          SizedBox(height: 10),

          loading
              ? Center(child: CircularProgressIndicator())
              : books.isEmpty
              ? Center(child: Text(tr('لا توجد كتب، تأكد من الإنترنت', 'No books found, check your internet')))
              : SizedBox(
            height: 230,
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
                    width: 110,
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bookCover(book, 110, 150),
                        SizedBox(height: 5),
                        Text(
                          book['title'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          getAuthor(book),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Color(0xFFD4A24C), size: 16),
                            Text('4.5'),
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