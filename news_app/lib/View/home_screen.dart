import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model/categories_new_model.dart';
import 'package:news_app/Model/news_channels_headline_model.dart';
import 'package:news_app/View%20Model/news_view_model.dart';
import 'package:news_app/View/category_screen.dart';
import 'package:news_app/View/news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, alJazeeraNews, cnn, foxNews, abcNews}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedList;

  final format = DateFormat('MMMM, dd, yyyy');

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryScreen()),
            );
          },
          icon: Image.asset('images/category_icon.png', height: 25, width: 25),
        ),
        title: Text(
          "News",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedList,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.aryNews.name == item.name) {
                name = 'ary-news';
              }
              if (FilterList.alJazeeraNews.name == item.name) {
                name = 'al-jazeera-english';
              }
              if (FilterList.cnn.name == item.name) {
                name = 'CNN';
              }
              if (FilterList.foxNews.name == item.name) {
                name = 'fox-news';
              }
              if (FilterList.abcNews.name == item.name) {
                name = 'abc-news';
              }

              setState(() {
                selectedList = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem(value: FilterList.bbcNews, child: Text('BBC News')),
              PopupMenuItem(value: FilterList.aryNews, child: Text('Ary News')),
              PopupMenuItem(
                value: FilterList.alJazeeraNews,
                child: Text('Al Jzeazeera News'),
              ),
              PopupMenuItem(value: FilterList.cnn, child: Text('CNN')),
              PopupMenuItem(value: FilterList.foxNews, child: Text('Fox News')),
              PopupMenuItem(value: FilterList.abcNews, child: Text('ABC News')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * .01),
            SizedBox(
              height: height * .55,
              width: width,
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelsHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(size: 50, color: Colors.blue),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles!.isEmpty) {
                    return Center(child: Text('No articles found'));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        final article = snapshot.data!.articles![index];
                        DateTime dateTime = DateTime.parse(
                          article.publishedAt.toString(),
                        );
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(
                                  author: article.author.toString(),
                                  description: article.description.toString(),
                                  newsDate: article.publishedAt.toString(),
                                  newsImage: article.urlToImage.toString(),
                                  newsTitle: article.title.toString(),
                                  source: article.source!.name.toString(),
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * .02,
                                  ),
                                  width: width * 0.9,
                                  height: height * .6,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: article.urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholder: (context, url) =>
                                          SpinKitFadingCircle(
                                            color: Colors.blue,
                                            size: 50,
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 20,
                                  left: width * .05,
                                  right: width * .05,

                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      alignment: Alignment.bottomCenter,
                                      height: height * 0.20,
                                      width: width * 0.9,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            article!.title.toString(),
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                article.source!.name.toString(),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategorisNewsApi("General"),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(size: 50, color: Colors.indigo),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null ||
                    snapshot.data!.articles!.isEmpty) {
                  return const Center(child: Text('No articles found.'));
                } else {
                  return Column(
                    children: List.generate(snapshot.data!.articles!.length, (
                      index,
                    ) {
                      final article = snapshot.data!.articles![index];
                      final imageUrl = article.urlToImage ?? '';
                      final title = article.title ?? 'No title';
                      final publishedAt = article.publishedAt ?? '';
                      final date = DateTime.tryParse(publishedAt);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                author: article.author.toString(),
                                description: article.description.toString(),
                                newsDate: article.publishedAt.toString(),
                                newsImage: article.urlToImage.toString(),
                                newsTitle: article.title.toString(),
                                source: article.source!.name.toString(),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: imageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          height: 100,
                                          width: 120,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const SpinKitCircle(
                                                color: Colors.indigo,
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.broken_image),
                                        )
                                      : Container(
                                          height: 100,
                                          width: 120,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(Icons.broken_image),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (date != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                format.format(date),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Spacer(),
                                              Expanded(
                                                child: Text(
                                                  article.author ?? 'Unknown',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
