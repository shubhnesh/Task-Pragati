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
    _sliderController = PageController(initialPage: 0, viewportFraction: 0.75);
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
          // Image slider in a stack
          Container(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image slider with curved animation
                Positioned(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: _sliderController,
                    onPageChanged: (int page) {
                      setState(() {
                        // keep track of current image index using modulo
                        _activeSlideIndex = page % widget.imageList.length;

                        // jump if we get too close to either end to prevent unwanted changes
                        if (page < widget.imageList.length * 5) {
                          // jump forward, after reaching to the begining
                          _sliderController.jumpToPage(
                            page + widget.imageList.length * 10,
                          );
                        } else if (page > widget.imageList.length * 15) {
                          // If getting close to the end, jump backward
                          _sliderController.jumpToPage(
                            page - widget.imageList.length * 10,
                          );
                        }
                      });
                    },
                    // infinite number of pages
                    itemCount: null,
                    itemBuilder: (context, index) {
                      // Use modulo to repeat images for infinite scrolling
                      final imageIndex = index % widget.imageList.length;

                      return AnimatedBuilder(
                        animation: _sliderController,
                        builder: (context, child) {
                          double value = 0;
                          if (_sliderController.position.haveDimensions) {
                            value =
                                index.toDouble() -
                                (_sliderController.page ?? 0);
                            value = (value * 0.5).clamp(-1.0, 1.0);
                          }

                          double verticalOffset = 120 * value * value;

                          double scaleFactor =
                              0.85 + (0.15 * (1 - value.abs()));

                          return Transform.translate(
                            offset: Offset(0, verticalOffset),
                            child: Transform.scale(
                              scale: scaleFactor,
                              child: Align(
                                alignment: Alignment.center,
                                child: child,
                              ),
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
                              widget.imageList[imageIndex],
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
              ],
            ),
          ),

          // Project name should be below the images
          Text(
            widget.titleList[_activeSlideIndex],
            style: context.sliderItemText,
          ),

          SizedBox(height: 12),

          // Dots indicator
          DotIndicator(
            count: widget.imageList.length,
            currentIndex: _activeSlideIndex,
          ),
        ],
      ),
    );
  }
}
