import 'package:flutter/material.dart';
import 'dot_indicator.dart';
import '../theme/app_colors.dart';
import '../theme/custom_typography.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageList;
  final List<String> titleList;
  final double sliderHeight;

  const ImageSlider({
    Key? key,
    required this.imageList,
    required this.titleList,
    this.sliderHeight = 300,
  }) : super(key: key);

  @override
  State<ImageSlider> createState() => _ProjectSliderState();
}

class _ProjectSliderState extends State<ImageSlider> {
  late PageController _sliderController;
  int _activeSlideIndex = 0;

  @override
  void initState() {
    super.initState();
    _sliderController = PageController();
    // _activeSlideIndex = widget.imageList.length * 1000;
  }

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.sliderHeight,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _sliderController,
              onPageChanged: (int page) {
                setState(() {
                  // Update the active slide index
                  _activeSlideIndex = page;
                });
              },
              // infinite number of pages
              itemCount:
                  widget.imageList.length, // Limited to the number of images
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _sliderController,
                  builder: (context, child) {
                    double value = 0;
                    if (_sliderController.position.haveDimensions) {
                      value = index.toDouble() - (_sliderController.page ?? 0);
                      value = (value * 0.5).clamp(-1.0, 1.0);
                    }

                    double verticalOffset = 120 * value * value;

                    double scaleFactor = 0.85 + (0.15 * (1 - value.abs()));

                    return Transform.translate(
                      offset: Offset(0, verticalOffset),
                      child: Transform.scale(
                        scale: scaleFactor,
                        child: Align(alignment: Alignment.center, child: child),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        widget.imageList[index],
                        height: 204, // Updated size
                        width: 275, // Updated size
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 204, // Updated size
                            width: 275, // Updated size
                            color: AppColors.darkPurpleBackground,
                            child: Center(
                              child: Icon(
                                Icons.construction,
                                size: 48,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          //Title of active index
          Text(
            widget.titleList[_activeSlideIndex],
            style: context.sliderItemText,
          ),

          const SizedBox(height: 12),

          // Dot indicator
          DotIndicator(
            count: widget.imageList.length,
            currentIndex: _activeSlideIndex,
          ),
        ],
      ),
    );
  }
}
