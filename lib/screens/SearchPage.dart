import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'DescriptionScreen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false; // Flag to track loading state

  void _searchNews(String query) async {
    // Lowercase the query
    query = query.toLowerCase();

    // Show circular progress indicator
    setState(() {
      _isLoading = true;
    });

    String url =
        'https://newsapi.org/v2/everything?q=$query&from=2024-04-14&sortBy=publishedAt&apiKey=34a431b2ae0b4fb9aab7eef6d991a97f';

    final response = await http.get(Uri.parse(url));

    // Hide circular progress indicator
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body)['articles'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.1;
    double cardWidth = MediaQuery.of(context).size.width * 0.6;
    double titleHeight = MediaQuery.of(context).size.height * 0.07;
    double imgHeight = MediaQuery.of(context).size.height * 0.1;
    double imgWidth = MediaQuery.of(context).size.width * 0.2;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Center(
              child: Text(
                "Search News",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      // Enable or disable search icon based on query
                      setState(() {
                        _isLoading = value.isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      hintText: 'Search',
                      suffixIcon: _isLoading
                          ? null // Disable search icon if loading or query is empty
                          : IconButton(
                              onPressed: () {
                                String query = _searchController.text;
                                _searchNews(query);
                              },
                              icon: const Icon(Icons.search),
                            ),
                      hintStyle: const TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            var article = _searchResults[index];
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
                                margin: const EdgeInsets.only(bottom: 20),
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
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.network(
                                        article['urlToImage'] ??
                                            '', // Provide an empty string as the fallback value
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // If there's an error loading the image, return a placeholder image
                                          return Image.asset(
                                            'images/breaking.png', // Provide the path to your placeholder image
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Container(
                                        height: cardHeight,
                                        width: cardWidth,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              height: titleHeight,
                                              child: Text(
                                                article['title'] ?? '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  color: Colors.grey,
                                                  size: 19,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  _calculateTimeDifference(
                                                      article['publishedAt']),
                                                  style: const TextStyle(
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
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

String _truncateTitle(String title, int maxLines) {
  const ellipsis = '...';
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
