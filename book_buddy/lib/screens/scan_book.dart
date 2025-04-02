import 'package:book_buddy/screens/library.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/settings.dart';
import 'package:book_buddy/screens/tbr.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:book_buddy/screens/scan_book_adding.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as image;
import 'dart:io';

class ScanBook extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

  const ScanBook({
    required this.isDarkMode,
    required this.toggleDarkMode,
    super.key,
  });

  @override
  _ScanBookState createState() => _ScanBookState();
}

// Navigation bar.
class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDarkMode;

  const NavBar({
    super.key, 
    required this.onTap, 
    required this.currentIndex,
    required this.isDarkMode});

 @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode 
          ? Colors.white
          : Colors.black, // Nav bar background colour
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    
    child: BottomNavigationBar(
        backgroundColor: Colors.transparent, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white, 
        showSelectedLabels: false, 
        showUnselectedLabels: false, 
        currentIndex: currentIndex, 
        onTap: onTap, 
        type: BottomNavigationBarType.fixed,  

      items: [
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Library- book icon',
            hint: 'Press to go to My Library screen',
            child: Icon(Icons.menu_book, color: isDarkMode ? Colors.black: Colors.white,),
          ),
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'My TBR- bookmark icon',
            hint: 'Press to go to My TBR screen',
            child: Icon(Icons.bookmark, color: isDarkMode ? Colors.black: Colors.white,)
          ),
          label: "", 
        ),
        
        BottomNavigationBarItem(
            icon: Semantics(
              label: 'Scan book- camera icon',
              hint: 'Press to to go to scan book screen',
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode? Colors.white70: Colors.black, // Black circle for camera button
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: isDarkMode ? Colors.black: Colors.white,), // White camera icon
              ),
            ),
            label: "", 
            ),
            

        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Settings- settings icon',
            hint: 'Press to go to Settings screen', 
            child: Icon(Icons.settings, color: isDarkMode ? Colors.black: Colors.white,),
          ), 
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Home- home icon', 
            hint: 'Press to go to the home page screen',
            child: Icon(Icons.home, color: isDarkMode ? Colors.black: Colors.white,),
          ),
          label: "", 
        ),
      ],
    ),
    );
  }
}

class _ScanBookState extends State<ScanBook> {
  late bool _isDarkMode;
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    initializeCamera();
  }

  // Initialize the Camera
  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    await _cameraController!.initialize();
    await _cameraController!.setFocusMode(FocusMode.auto);       
    await _cameraController!.setExposureMode(ExposureMode.auto); 
    if (!mounted) return;
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<InputImage> preprocessImage(String imagePath) async {
    final originalImage = image.decodeImage(await File(imagePath).readAsBytes())!;
    final grayImage = image.grayscale(originalImage);
    final contrastImage = image.adjustColor(grayImage, contrast: 1.5);
    final processedPath = '${imagePath}_processed.jpg';

    await File(processedPath).writeAsBytes(image.encodeJpg(contrastImage));
    return InputImage.fromFilePath(processedPath);
  }

  // Capture Image & Extract Text
  Future<void> captureAndSearch() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    setState(() {
      isProcessing = true;
    });

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = await preprocessImage(imageFile.path); 
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      // NEW: Step 4 - Improved Text Parsing
      String? title;
      String? author;

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text.trim();

          if (text.length > 3) { 
            if (title == null && text.length > 20) title = text; 
            if (author == null && text.contains(RegExp(r'^[A-Za-z\s]+$'))) author = text; 
          }
        }
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanBookAdding(
            imagePath: imageFile.path, 
            initialTitle: title ?? '',
            initialAuthor: author ?? '',
            isDarkMode: _isDarkMode,
            toggleDarkMode: widget.toggleDarkMode,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error processing image: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  // Dispose Camera
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 223, 245, 252),
          elevation: 5,
          iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : Color.fromARGB(255, 20, 9, 45)),
        ),
      ),
      backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 216, 243, 245),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Icon(
                  Icons.camera_alt,
                  size: 90,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'Scan Book',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Text(
              "Position camera directly above book cover",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white: Colors.black),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: isCameraInitialized ? CameraPreview(_cameraController!) : const Center(child: CircularProgressIndicator()),
            ),
          ),
          FloatingActionButton(
            onPressed: captureAndSearch,
            backgroundColor: _isDarkMode? Colors.white: Colors.black,
            child: Icon(Icons.camera_alt, color: _isDarkMode ? Colors.black : Colors.white),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2,
        onTap: (index) {
          Widget screen;
          switch (index) {
            case 0:
              screen = Library(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
              break;
            case 1:
              screen = TBR(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
              break;
            case 2:
              screen = ScanBook(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
              break;
            case 3:
              screen = Settings(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
              break;
            default:
              screen = HomePage2(isDarkMode: _isDarkMode, toggleDarkMode: widget.toggleDarkMode);
          }
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
        },
        isDarkMode: _isDarkMode,
      ),
    );
  }
}