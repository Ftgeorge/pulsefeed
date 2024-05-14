import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulsefeed/screens/DescriptionScreen.dart';

class HeadlinesScreen extends StatefulWidget {
  const HeadlinesScreen({Key? key});

  @override
  State<HeadlinesScreen> createState() => _HeadlinesScreenState();
}

class _HeadlinesScreenState extends State<HeadlinesScreen> {
  List<String> categories = [
    'Politics',
    'Business',
    'Technology',
    'Sports',
    'Entertainment',
    'Science',
    'Health',
  ];

  String selectedCategory = 'Politics';
  List<dynamic> newsArticles = [];

  @override
  void initState() {
    super.initState();
    fetchData(selectedCategory); // Call fetchData initially with default category
  }

  Future<void> fetchData(String category) async {
    String lowerCaseCategory = category.toLowerCase();
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$lowerCaseCategory&apiKey=34a431b2ae0b4fb9aab7eef6d991a97f';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        newsArticles = json.decode(response.body)['articles'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String _calculateTimeDifference(String publishedAt) {
    // Parse the publishedAt string to DateTime object
    DateTime publishedDateTime = DateTime.parse(publishedAt);

    // Calculate the difference between published time and current time
    Duration difference = DateTime.now().difference(publishedDateTime);

    // Convert the difference to hours
    int hoursDifference = difference.inHours;

    // Format the difference string
    if (hoursDifference == 0) {
      return 'just now';
    } else {
      return '$hoursDifference ${hoursDifference == 1 ? 'hour' : 'hours'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculating dimensions based on device screen size
    double cardHeight = MediaQuery.of(context).size.height * 0.1;
    double cardWidth = MediaQuery.of(context).size.width * 0.6;
    double titleHeight = MediaQuery.of(context).size.height * 0.07;
    double imgHeight = MediaQuery.of(context).size.height * 0.1;
    double imgWidth = MediaQuery.of(context).size.width * 0.2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text("Headlines",
          style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories section
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildCategoryTexts(),
                ),
              ),
            ),
          ),
          // News Cards
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: newsArticles.map((article) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the description screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DesciptionScreen(article: article),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.only(bottom: 20),
                        elevation: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: imgWidth,
                              height: imgHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                article['urlToImage'] ??
                                    '', // Provide an empty string as the fallback value
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // If there's an error loading the image, return a placeholder image
                                  return Image.asset(
                                    'images/breaking.png', // Provide the path to your placeholder image
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height: cardHeight,
                                width: cardWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: titleHeight,
                                      child: Text(
                                        article['title'] ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                          size: 19,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          _calculateTimeDifference(
                                              article['publishedAt']),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to truncate title text if it exceeds a certain number of lines
  String _truncateTitle(String title, int maxLines) {
    final ellipsis = '...';
    final words = title.split(' ');
    final totalWords = words.length;

    // If the title already fits within the specified number of lines, return it as is
    if (totalWords <= maxLines) {
      return title;
    }

    // Calculate the maximum number of characters to fit within the specified number of lines
    final maxCharacters = title.length ~/ maxLines;

    // Concatenate words until the total characters exceed the limit
    var truncatedTitle = '';
    var charactersCount = 0;
    for (var word in words) {
      if (charactersCount + word.length + ellipsis.length <= maxCharacters) {
        truncatedTitle += ' ' + word;
        charactersCount += word.length + 1; // Add 1 for the space
      } else {
        break;
      }
    }

    // Add ellipsis to the truncated title
    truncatedTitle += ellipsis;

    return truncatedTitle.trim();
  }

  // Method to build category texts for the categories section
  List<Widget> _buildCategoryTexts() {
    return categories.map((category) {
      bool isSelected = category == selectedCategory;
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = category;
            fetchData(selectedCategory); // Call fetchData with the new category
          });
        },
        child: Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.only(
            bottom: 5,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.black : Colors.transparent,
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      );
    }).toList();
  }
}
