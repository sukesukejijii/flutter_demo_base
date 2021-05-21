import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel();

  final int numOfPhotos = 5;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  PageController pageController;
  int currentPage = 0;
  List<String> photos = [];

  Future<void> getPhoto() async {
    final dio = Dio();
    final Response response = await dio.get(
        'https://api.unsplash.com/photos/random?client_id=IBqP1F6EqiNJZlf1Op_6LeUrIo2TVbSQ-6gRHSBdgRg&orientation=portrait&count=${widget.numOfPhotos}&collections=485707');

    if (response.statusCode != 200) {
      throw Exception('Something went wrong');
    }
    final data = response.data as List;
    setState(() {
      photos = data.map((photo) => photo['urls']['regular'] as String).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: currentPage,
      viewportFraction: 0.75,
    );
    Future.wait([getPhoto()]);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  AnimatedBuilder buildItem(int index) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double value = 1;
        double rate;
        if (pageController.position.haveDimensions) {
          rate = pageController.page - index;
          value = (1 - rate.abs() * 0.5).clamp(0, 1);
        }
        return Center(
          child: Container(
            child: SizedBox(
              height: Curves.easeIn.transform(value) * 800,
              width: Curves.easeIn.transform(value) * 600,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        child: Center(
          child: Image.network(
            photos[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return photos.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 800,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: widget.numOfPhotos,
                  itemBuilder: (context, index) => buildItem(index),
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  SizedBox(width: 24),
                  IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                ],
              )
            ],
          );
  }
}
