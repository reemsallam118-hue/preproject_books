import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/app_colors.dart';
import 'package:preproject_books/Constants/books_information.dart';
import '../widgets/empty_state_widgets.dart';
import 'book_details_view.dart';

class MaktabtyView extends StatefulWidget {
  final VoidCallback? onDiscover;
  const MaktabtyView({super.key, this.onDiscover});

  @override
  State<MaktabtyView> createState() => _MaktabtyViewState();
}

class _MaktabtyViewState extends State<MaktabtyView> {
  static const Color _rose = Color(0xFFA8434B);
  static const Color _grey = Color(0xFF8A8A8A);
  int tab = 0;

  List get currentList {
    if (tab == 1) {
      return readingBooks.where((b) => getProgress(b) < 1.0).toList();
    }
    if (tab == 2) {
      return readingBooks.where((b) => getProgress(b) >= 1.0).toList();
    }
    if (tab == 3) {
      return libraryBooks;
    }
    return readingBooks;
  }

  String get emptyTitle {
    if (tab == 1) return tr('لا توجد كتب تقرأها الآن', 'Nothing being read now');
    if (tab == 2) return tr('لم تنهِ أي كتاب بعد', 'No finished books yet');
    if (tab == 3) return tr('لا توجد كتب مفضلة بعد', 'No favorites yet');
    return tr('مكتبتك فارغة', 'Your library is empty');
  }

  String get emptySubtitle {
    if (tab == 3) {
      return tr('أضف كتباً تعجبك لتظهر هنا',
          'Add books you like and they will show up here');
    }
    return tr('اضغط "قراءة الآن" على أي كتاب ليظهر هنا',
        'Tap "Read now" on any book and it will show up here');
  }

  void changeProgress(Map book) {
    double value = getProgress(book);
    showModalBottomSheet(
      context: context,
      backgroundColor: context.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr('تحديث تقدم القراءة', 'Update reading progress'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    book['title'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${(value * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: _rose,
                    ),
                  ),
                  Slider(
                    value: value,
                    divisions: 20,
                    activeColor: _rose,
                    inactiveColor: context.divider,
                    onChanged: (v) => setSheet(() => value = v),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _rose,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        setProgress(book, value);
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text(tr('حفظ', 'Save'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget tabItem(int index, String label) {
    bool selected = tab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => tab = index),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? _rose : _grey,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: selected ? _rose : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bookCard(Map book) {
    // في تاب المفضلة مفيش شريط تقدم
    bool showProgress = tab != 3;
    double progress = getProgress(book);

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
              MaterialPageRoute(builder: (context) => BookDetailsView(book)),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        getAuthor(book),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _grey),
                      ),
                      const SizedBox(height: 10),
                      if (showProgress)
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 5,
                                  color: _rose,
                                  backgroundColor: context.surface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${(progress * 100).round()}%',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _grey),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: const [
                            Icon(Icons.star,
                                color: Color(0xFFD4A24C), size: 16),
                            SizedBox(width: 4),
                            Text('4.6',
                                style:
                                TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                    ],
                  ),
                ),
                if (showProgress)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: _grey),
                    color: context.card,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    onSelected: (value) {
                      if (value == 'read') {
                        (context, book, onReturn: () {
                          if (mounted) setState(() {});
                        });
                      } else if (value == 'progress') {
                        changeProgress(book);
                      } else if (value == 'done') {
                        setProgress(book, 1.0);
                        setState(() {});
                      } else if (value == 'remove') {
                        removeFromReading(book);
                        setState(() {});
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'read',
                        child: Text(tr('متابعة القراءة', 'Continue reading')),
                      ),
                      PopupMenuItem(
                        value: 'progress',
                        child: Text(tr('تحديث التقدم', 'Update progress')),
                      ),
                      PopupMenuItem(
                        value: 'done',
                        child: Text(tr('تم قراءته', 'Mark as finished')),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: Text(tr('إزالة من مكتبتي', 'Remove from library')),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List list = currentList;

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          tr('مكتبتي', 'My library'),
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
      body: Column(
        children: [
          Row(
            children: [
              tabItem(0, tr('الكل', 'All')),
              tabItem(1, tr('أقرأ الآن', 'Reading')),
              tabItem(2, tr('تم قراءته', 'Finished')),
              tabItem(3, tr('المفضلة', 'Favorites')),
            ],
          ),
          Divider(height: 1, color: context.divider),
          Expanded(
            child: list.isEmpty
                ? EmptyState(
              title: emptyTitle,
              subtitle: emptySubtitle,
              buttonText: tr('اكتشف كتب', 'Discover books'),
              onPressed: () => widget.onDiscover?.call(),
              logo: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: context.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_stories_rounded,
                    size: 54, color: _rose),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              itemCount: list.length,
              itemBuilder: (context, index) => bookCard(list[index]),
            ),
          ),
        ],
      ),
    );
  }
}
