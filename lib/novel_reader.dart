import 'package:flutter/material.dart';

class NovelReader extends StatefulWidget {
  @override
  _NovelReaderState createState() => _NovelReaderState();
}

class _NovelReaderState extends State<NovelReader> {
  final ScrollController _scrollController = ScrollController();
  int _currentChapter = 1;
  Map<int, String> _chapterData = {};
  bool _slideUp = true; // direction controller

  @override
  void initState() {
    super.initState();
    _loadChapter(_currentChapter);
  }

  void _loadChapter(int chapter) async {
    if (_chapterData.containsKey(chapter)) return;

    await Future.delayed(Duration(milliseconds: 300));
    _chapterData[chapter] =
        "Chapter $chapter\n\n" +
        List.generate(
          50,
          (i) => "Line ${i + 1} of Chapter $chapter",
        ).join("\n\n");

    setState(() {});
    _scrollController.jumpTo(0); // Reset scroll
  }

  void _goToNextChapter() {
    setState(() {
      _slideUp = true;
      _currentChapter++;
      _loadChapter(_currentChapter);
    });
  }

  void _goToPreviousChapter() {
    if (_currentChapter > 1) {
      setState(() {
        _slideUp = false;
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
                : AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: _slideUp ? Offset(0, 1) : Offset(0, -1),
                        end: Offset.zero,
                      ).animate(animation);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey<int>(_currentChapter),
                      child: Scrollbar(
                        child: ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          children: [
                            if (_currentChapter > 1)
                              Container(
                                alignment: Alignment.center,
                                height: 200,
                                color: Colors.white38,
                                child: FloatingActionButton(
                                  heroTag: 'prev',
                                  onPressed: _goToPreviousChapter,
                                  child: Icon(Icons.arrow_upward),
                                ),
                              ),
                            Text(
                              content,
                              style: TextStyle(fontSize: 18, height: 1.6),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 200,
                              color: Colors.white38,
                              child: FloatingActionButton(
                                heroTag: 'next',
                                onPressed: _goToNextChapter,
                                child: Icon(Icons.arrow_downward),
                              ),
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
  }
}
