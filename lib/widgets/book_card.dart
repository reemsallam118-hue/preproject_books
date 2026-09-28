import 'package:flutter/material.dart';
import 'package:preproject_books/app_colors.dart';
import '../theme/app_colors.dart';

/// كارت الكتاب المتكرر في كل الشاشات (هوم، بحث، مفضلة...).
/// الغلاف + التقييم + العنوان + المؤلف + زرار القلب.
class BookCard extends StatelessWidget {
  final Book book;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;
  final double width;

  const BookCard({
    super.key,
    required this.book,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الغلاف
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 0.78,
                child: book.coverUrl != null
                    ? Image.network(
                  book.coverUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _coverPlaceholder(),
                )
                    : _coverPlaceholder(),
              ),
            ),
            const SizedBox(height: 8),

            // التقييم
            if (book.averageRating != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    book.averageRating!.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star_rounded, size: 14, color: AppColors.rating),
                ],
              ),
            const SizedBox(height: 4),

            // العنوان
            Text(
              book.title,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),

            // المؤلف
            Text(
              book.authors.isNotEmpty ? book.authors.first : '',
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),

            // زرار القلب
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onFavoriteToggle,
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? AppColors.primary : AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      color: AppColors.coverBrown,
      alignment: Alignment.center,
      child: const Icon(Icons.menu_book_rounded, color: Colors.white38, size: 32),
    );
  }
}
