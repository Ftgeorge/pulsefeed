import 'package:flutter/material.dart';

class DesciptionScreen extends StatefulWidget {
  final Map<String, dynamic>
      article; // Define a field to store the article details

  const DesciptionScreen({Key? key, required this.article}) : super(key: key);

  @override
  State<DesciptionScreen> createState() => _DesciptionScreenState();
}

class _DesciptionScreenState extends State<DesciptionScreen> {
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
      return '$hoursDifference ${hoursDifference == 1 ? 'h' : 'h'} ';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the article details using widget.article
    final title = widget.article['title'];
    final description = widget.article['description'];
    final imageUrl = widget.article['urlToImage'];
    final author = widget.article['author'];
    final publishedAt = widget.article['publishedAt'];
    final url = widget.article['url'];
    // Assuming you want to limit the author text to a certain number of characters
    String truncatedAuthor =
        author.substring(0, 10); // Limit to the first 10 characters

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Container(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                          context); //Navigate back when icon is pressed
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          title: Center(
            child: Text(
              "PulseFeed",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Icon(
                Icons.share_outlined,
                size: 24,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Text(
              title ?? 'No Title',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
                clipBehavior: Clip.hardEdge,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Text(
                      'by ' + truncatedAuthor,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    // color: Color(0xFFF0F0F0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Color(0xFFB3B3B3),
                          size: 21,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          _calculateTimeDifference(publishedAt),
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              description ?? 'No Description',
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
          ),
          if (url != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 0, 20, 0),
              child: TextButton(
                onPressed: () {
                  // Open URL when "Read More" button is clicked
                  // launch(url);
                },
                child: Text(
                  'Read More',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
