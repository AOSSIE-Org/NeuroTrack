import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:patient/core/constants/updates_constants.dart';

class UpdatesScreen extends StatelessWidget {
  // Helper method to launch URLs with multiple fallback options
  Future<void> _launchURL(BuildContext context, String url) async {
    if (url.isEmpty) {
      print('URL is empty!');
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link unavailable.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    print('Attempting to launch: $url');
    
    try {
      final uri = Uri.parse(url);
      print('Parsed URI: $uri');
      
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening...'),
            duration: Duration(milliseconds: 800),
            backgroundColor: Colors.blue,
          ),
        );
      }
      
      // Try method 1: externalApplication
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      print('Launch attempt 1 (externalApplication): $launched');
      
      // Try method 2: platformDefault if first fails
      if (!launched) {
        print('Trying platformDefault mode...');
        launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        print('Launch attempt 2 (platformDefault): $launched');
      }
      
      // Try method 3: inAppWebView as last resort
      if (!launched) {
        print('Trying inAppWebView mode...');
        launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
        );
        print('Launch attempt 3 (inAppWebView): $launched');
      }
      
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open link. Please check your browser settings.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening link: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> get latestVideos => UpdatesConstants.latestVideos;
  List<Map<String, dynamic>> get latestArticles => UpdatesConstants.latestArticles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Updates",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        fontFamily: 'League Spartan',
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Stay informed with the latest insights",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontFamily: 'League Spartan',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.play_circle_filled,
                            color: Color(0xFF7A86F8), size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          "Latest Videos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            fontFamily: 'League Spartan',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 235,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: latestVideos.length,
                  itemBuilder: (context, index) {
                    final video = latestVideos[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildVideoCard(context, video),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                child: Row(
                  children: [
                    Icon(Icons.article_outlined,
                        color: Color(0xFF7A86F8), size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      "Latest Articles",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        fontFamily: 'League Spartan',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final article = latestArticles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildArticleCard(context, article),
                    );
                  },
                  childCount: latestArticles.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, dynamic> video) {
    return GestureDetector(
      onTap: () {
        final url = video['url']?.toString() ?? '';
        print('Video card tapped: ${video['title']}');
        _launchURL(context, url);
      },
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  video['thumbnailUrl']?.toString() ?? '',
                  width: 240,
                  height: 135,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 240,
                      height: 135,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 240,
                      height: 135,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${video['duration'] ?? ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFF7A86F8),
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${video['title'] ?? ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.3,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.visibility_outlined,
                        size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${video['views'] ?? ''}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {
        final url = article['url']?.toString() ?? '';
        print('Article card tapped: ${article['title']}');
        _launchURL(context, url);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.network(
                  article['thumbnailUrl']?.toString() ?? '',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A86F8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${article['category'] ?? ''}',
                        style: const TextStyle(
                          color: Color(0xFF7A86F8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${article['title'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.3,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${article['date'] ?? ''}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.schedule_outlined,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${article['readTime'] ?? ''}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}