import 'package:flower_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Carousel for product images coming from the backend (imageUrls).
/// Fully driven by the list length — no hardcoded image count or colors.
class ProductImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  const ProductImageSlider({
    super.key,
    required this.imageUrls,
    this.height = 380,
  });

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return SizedBox(height: widget.height.h);
    }

    return Stack(
      children: [
        SizedBox(
          height: widget.height.h,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: context.colors.pink,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: context.colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: context.colors.grey.shade700,
                      size: 40.sp,
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: _SliderIndicator(
              itemCount: widget.imageUrls.length,
              currentIndex: _currentIndex,
            ),
          ),
      ],
    );
  }
}

class _SliderIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const _SliderIndicator({required this.itemCount, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          height: 6.h,
          width: isActive ? 18.w : 6.w,
          decoration: BoxDecoration(
            color: isActive
                ? context.colors.pink
                : context.colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
