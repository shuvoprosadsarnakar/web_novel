import 'package:flutter/material.dart';

class NovelReader extends StatefulWidget {
  @override
  State<NovelReader> createState() => _NovelReaderState();
}

class _NovelReaderState extends State<NovelReader> {
  final PageController _pageController = PageController();
  final Map<int, String> _chapterData = {};
  int _currentChapter = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _loadChapters();
    _scrollController.addListener(_handleScroll);
  }

  void _loadChapters() {
    for (int i = 0; i < 10; i++) {
      _chapterData[i] =
          "Chapter ${i + 1}\n\n${List.generate(
            50,
            (j) => "Line ${j + 1} of Chapter ${i + 1}",
          ).join("\n\n")}";
    }
    setState(() {});
  }

  void _goToNextChapter() {
    if (_currentChapter < _chapterData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // Reset scroll position for the new chapter
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(0);
      });
    }
  }

  void _goToPreviousChapter() {
    if (_currentChapter > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // Reset scroll position for the new chapter
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(0);
      });
    }
  }

  void _handleScroll() {
    final metrics = _scrollController.position;
    // Check if scrolled beyond 30 pixels from bottom
    if (metrics.pixels > metrics.maxScrollExtent + 30 &&
        _currentChapter < _chapterData.length - 1 &&
        !_isScrolling) {
      _isScrolling = true;
      _goToNextChapter();
      Future.delayed(Duration(milliseconds: 500), () => _isScrolling = false);
    }
    // Check if scrolled beyond 30 pixels from top
    else if (metrics.pixels < -30 && _currentChapter > 0 && !_isScrolling) {
      _isScrolling = true;
      _goToPreviousChapter();
      Future.delayed(Duration(milliseconds: 500), () => _isScrolling = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _chapterData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) => setState(() => _currentChapter = index),
              itemCount: _chapterData.length,
              itemBuilder: (_, index) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: ListView(
                      controller: _scrollController,
                      physics: ClampingScrollPhysics(),
                      children: [
                        if (index > 0)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FloatingActionButton(
                                heroTag: 'prev_$index',
                                mini: true,
                                onPressed: _goToPreviousChapter,
                                child: Icon(Icons.arrow_upward),
                              ),
                            ),
                          ),
                        Text(
                          _chapterData[index]!,
                          style: TextStyle(fontSize: 18, height: 1.6),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: FloatingActionButton(
                              heroTag: 'next_$index',
                              mini: true,
                              onPressed: _goToNextChapter,
                              child: Icon(Icons.arrow_downward),
                            ),
                          ),
                        ),
                        SizedBox(height: 30), // Extra space for overscroll
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
