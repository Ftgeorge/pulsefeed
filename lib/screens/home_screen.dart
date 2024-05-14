import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulsefeed/screens/DescriptionScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  String selectedCategory = 'Politics';
  List<String> categories = [
    'Politics',
    'Business',
    'Technology',
    'Sports',
    'Entertainment',
    'Science',
    'Health',
  ];
  List<dynamic> newsData = []; // Stores the fetched news data
  final int _currentCarouselIndex = 0;
  final int _currentIndex = 0; // Index for bottom navigation bar
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget initializes
    // Set up timer to fetch data every 10 minutes
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true; // Set isLoading to true when fetching data
    });
    String category = selectedCategory.toLowerCase();
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=34a431b2ae0b4fb9aab7eef6d991a97f';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          newsData = json.decode(response.body)['articles'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle errors
    } finally {
      setState(() {
        _isLoading = false; // Set isLoading to false when data fetching is done
      });
    }
  }

  String _calculateTimeDifference(String publishedAt) {
    // Parse the publishedAt string to DateTime object
    DateTime publishedDateTime = DateTime.parse(publishedAt);
    // Calculate the difference between published time and current time
    Duration difference = DateTime.now().difference(publishedDateTime);
    // Convert the difference to hours
    int hoursDifference = difference.inHours;
    if (hoursDifference < 24) {
      if (hoursDifference == 0) {
        return 'just now';
      } else {
        return '$hoursDifference ${hoursDifference == 1 ? 'hour' : 'hours'} ago';
      }
    } else {
      // Calculate the difference in days
      int daysDifference = difference.inDays;
      // Calculate the remaining hours
      int remainingHours = hoursDifference % 24;
      // Construct the string to display
      String timeString =
          '$daysDifference ${daysDifference == 1 ? 'day' : 'days'}';
      if (remainingHours > 0) {
        timeString +=
            ' $remainingHours ${remainingHours == 1 ? 'hour' : 'hours'}';
      }
      timeString += ' ago';
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double responsiveHeight = screenHeight * 0.45;
    double BNHeight = MediaQuery.of(context).size.height * 0.15;
    double BNMainHeight = MediaQuery.of(context).size.height * 0.3;
    double BNWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  // Top News Section
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: responsiveHeight,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            // Use the top news image if available, else use a placeholder
                            newsData.isNotEmpty
                                ? newsData[0]['urlToImage'] ?? ''
                                : '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Align(
                            child: Column(
                              children: [
                                // News category label
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 100, 0, 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.transparent,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 15, sigmaY: 15),
                                          child: Container(
                                            color: Colors.transparent,
                                            child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0),
                                                child: Text(
                                                  'News of the day',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Top news title
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      // Use the top news title if available, else use a placeholder
                                      newsData[0]['title'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Breaking News Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Breaking News",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SeeMorePage(newsData: newsData),
                              ),
                            );
                          },
                          child: const Text(
                            'More',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Horizontal List of Breaking News
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FutureBuilder(
                      future: fetchMoreData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Container(
                            height: BNMainHeight, // Set the height of the horizontal list
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DesciptionScreen(
                                          article: snapshot.data![index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: BNWidth,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10), // Add margin between items
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Image
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 10),
                                          child: Container(
                                            height: BNHeight,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.network(
                                              snapshot.data![index]
                                                      ['urlToImage'] ??
                                                  '',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // Title
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            snapshot.data![index]['title'] ??
                                                '',
                                            maxLines: 2, // Limit to 2 lines
                                            overflow: TextOverflow
                                                .ellipsis, // Add ellipsis if exceeds
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // Time ago
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            _calculateTimeDifference(snapshot
                                                .data![index]['publishedAt']),
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        // Author
                                        Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          'by ' +
                                              (snapshot.data![index]
                                                      ['author'] ??
                                                  ''),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<List<dynamic>> fetchMoreData() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=34a431b2ae0b4fb9aab7eef6d991a97f';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to load more data');
    }
  }
}

class SeeMorePage extends StatelessWidget {
  final List<dynamic> newsData;

  const SeeMorePage({Key? key, required this.newsData}) : super(key: key);

  String _calculateTimeDifference(String publishedAt) {
    // Parse the publishedAt string to DateTime object
    DateTime publishedDateTime = DateTime.parse(publishedAt);

    // Calculate the difference between published time and current time
    Duration difference = DateTime.now().difference(publishedDateTime);

    // Convert the difference to hours
    int hoursDifference = difference.inHours;

    if (hoursDifference < 24) {
      if (hoursDifference == 0) {
        return 'just now';
      } else {
        return '$hoursDifference ${hoursDifference == 1 ? 'hour' : 'hours'} ago';
      }
    } else {
      // Calculate the difference in days
      int daysDifference = difference.inDays;

      // Calculate the remaining hours
      int remainingHours = hoursDifference % 24;

      // Construct the string to display
      String timeString =
          '$daysDifference ${daysDifference == 1 ? 'day' : 'days'}';
      if (remainingHours > 0) {
        timeString +=
            ' $remainingHours ${remainingHours == 1 ? 'hour' : 'hours'}';
      }
      timeString += ' ago';

      return timeString;
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          width: 300,
          color: Colors.white,
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'See More',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back when icon is pressed
                },
                icon: const Icon(
                  Icons.chevron_left,
                  size: 32,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: newsData.map((article) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the description screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DesciptionScreen(article: article),
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
                          errorBuilder: (context, error, stackTrace) {
                            // If there's an error loading the image, return a placeholder image
                            return Image.asset(
                              'images/breaking.png', // Provide the path to your placeholder image
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: cardHeight,
                          width: cardWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        fontSize: 16, color: Colors.grey),
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
    );
  }
}
