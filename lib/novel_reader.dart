import 'package:flutter/material.dart';

class NovelReader extends StatefulWidget {
  @override
  _NovelReaderState createState() => _NovelReaderState();
}

class _NovelReaderState extends State<NovelReader> {
  final ScrollController _scrollController = ScrollController();
  int _currentChapter = 1;
  Map<int, String> _chapterData = {};

  @override
  void initState() {
    super.initState();
    _loadChapter(_currentChapter);
  }

  void _loadChapter(int chapter) async {
    if (_chapterData.containsKey(chapter)) {
      // Already loaded
      return;
    }

    // Simulate async chapter fetch
    await Future.delayed(Duration(milliseconds: 300));
    _chapterData[chapter] =
        "Chapter $chapter\n\n" +
        List.generate(
          50,
          (i) => "Line ${i + 1} of Chapter $chapter",
        ).join("\n\n");

    setState(() {});
    _scrollController.jumpTo(0); // Reset scroll position to top
  }

  void _goToNextChapter() {
    setState(() {
      _currentChapter++;
      _loadChapter(_currentChapter);
    });
  }

  void _goToPreviousChapter() {
    if (_currentChapter > 1) {
      setState(() {
        _currentChapter--;
        _loadChapter(_currentChapter);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _chapterData[_currentChapter];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            content == null
                ? Center(child: CircularProgressIndicator())
                : Scrollbar(
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      children: [
                        if (_currentChapter > 1)
                          FloatingActionButton(
                            heroTag: 'prev',
                            onPressed: _goToPreviousChapter,
                            child: Icon(Icons.arrow_upward),
                          ),

                        Text(
                          content,
                          style: TextStyle(fontSize: 18, height: 1.6),
                        ),
                        FloatingActionButton(
                          heroTag: 'next',
                          onPressed: _goToNextChapter,
                          child: Icon(Icons.arrow_downward),
                        ),
                        SizedBox(height: 100), // Spacer at bottom
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
