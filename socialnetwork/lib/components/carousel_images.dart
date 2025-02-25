import 'package:flutter/material.dart';

class CarouselImages extends StatefulWidget {
  final List<Map<String, dynamic>> images;

  const CarouselImages({super.key, required this.images});

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  final PageController _pageController = PageController();
  double currentHeight = 300;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadAndSetHeight(0);
    });
  }

  void _preloadAndSetHeight(int index) {
    final Image image = Image.network(widget.images[index]['url']);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        if (mounted) {
          setState(() {
            currentHeight = info.image.height /
                (info.image.width / MediaQuery.of(context).size.width);
          });
        }
      }),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    _preloadAndSetHeight(index);
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: currentHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.network(
                images[index]['url'],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),
        SizedBox(height: 5),
        images.length == 1
            //Nếu chỉ có 1 ảnh thì không cần
            ? SizedBox(height: 5)
            //Nếu có nhiều ảnh thì cần các chấm dot
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: currentIndex == index ? 8 : 6,
                    height: currentIndex == index ? 8 : 6,
                    decoration: BoxDecoration(
                      color: currentIndex == index ? Colors.blue : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
