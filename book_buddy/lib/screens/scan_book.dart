import 'package:book_buddy/screens/library.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:book_buddy/screens/settings.dart';
import 'package:book_buddy/screens/tbr.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:book_buddy/screens/scan_book_adding.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


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

//Custom NavBar 
class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.onTap, required this.currentIndex});

 @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black, // Black background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    
    child: BottomNavigationBar(
        backgroundColor: Colors.transparent, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white70, 
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
            child: Icon(Icons.menu_book),
          ),
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'My TBR- bookmark icon',
            hint: 'Press to go to My TBR screen',
            child: Icon(Icons.bookmark)
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
                  color: Colors.black, // Black circle for camera button
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: Colors.white), // White camera icon
              ),
            ),
            label: "", 
            ),
            

        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Settings- settings icon',
            hint: 'Press to go to Settings screen', 
            child: Icon(Icons.settings),
          ), 
          label: "", 
        ),
        
        BottomNavigationBarItem(
          icon: Semantics(
            label: 'Home- home icon', 
            hint: 'Press to go to the home page screen',
            child: Icon(Icons.home),
          ),
          label: "", 
        ),
      ],
    ),
    );
  }
}



class _ScanBookState extends State<ScanBook>{
  late bool _isDarkMode;
  CameraController? _cameraController;
  //Creates a list of available cameras on the device
  late List<CameraDescription> cameras;
  //Tracks whether camera is initialised
  bool isCameraInitialized = false;
  bool isProcessing = false;

  @override
  void initState(){
    super.initState();
    _isDarkMode = widget.isDarkMode;
    initializeCamera();
  }

  //Method to fetch available cameras, create a camera controller and updates 
  //state of the camera
  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {
      isCameraInitialized = true;
    });
  }

  //Method used to capture the image using the camera and push onto the 
  //scan_book_adding page
  Future<void> captureAndSearch() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    setState(() {
      isProcessing = true;
    });
    
    try {
      final XFile imageFile = await _cameraController!.takePicture();
      
      // Process the image to extract text
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      String? title;
      String? author;
      
      // Simple logic to extract title and author (you might need more sophisticated parsing)
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text.toLowerCase();
          if (text.contains("by") && text.split("by").length > 1) {
            // Assuming format "Title by Author"
            final parts = line.text.split("by");
            title = parts[0].trim();
            author = parts[1].trim();
          } else if (title == null && line.text.length > 10) {
            // If no "by" found, take the longest line as title
            title = line.text;
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
  
  //Used to release resource when the widget is disposed
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }


  //Defines the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(35), 
      child: AppBar(
        backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 223, 245, 252),
        elevation: 5 ,
        iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : Color.fromARGB(255, 20, 9, 45) ),
        )),
      
      backgroundColor: _isDarkMode ? Color.fromARGB(255, 20, 9, 45) : Color.fromARGB(255, 216, 243, 245),
      
      body: Column(
        children: [
          Row(children: [
             // Icon.
                SizedBox(
                  width: 100,
                  height: 100,
                    child: Icon(
                      Icons.camera_alt,
                      size: 90,
                      color: _isDarkMode
                        ? Colors.white
                        : Colors.black
                    )
                ),

                // Heading.
                Text(
                  'Scan Book',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode 
                      ? Colors.white 
                      : Colors.black,
                  ),
                ),
          ],),
          const Padding(
            padding: EdgeInsets.all(0),
            child: Text(
              "Position camera directly above book cover",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: isCameraInitialized
                  ? CameraPreview(_cameraController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          FloatingActionButton(
            onPressed: captureAndSearch,
            backgroundColor: Colors.black,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 4,
        onTap: (index) {
          Widget screen;
          switch (index) {
            case 0:
              screen = Library(
                      isDarkMode: _isDarkMode, 
                      toggleDarkMode: widget.toggleDarkMode
              );
              break;
            case 1: 
              screen = TBR(
                      isDarkMode: _isDarkMode, 
                      toggleDarkMode: widget.toggleDarkMode
              );
              break;
            case 2:
              screen = ScanBook(
                      isDarkMode: _isDarkMode, 
                      toggleDarkMode: widget.toggleDarkMode
              );
              break;
            case 3:
              screen = Settings(
                      isDarkMode: _isDarkMode, 
                      toggleDarkMode: widget.toggleDarkMode
              );
              break;
            case 4:
            default:
              screen = HomePage2(
                      isDarkMode: _isDarkMode, 
                      toggleDarkMode: widget.toggleDarkMode
              );
          }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => screen),
          );
        }
      )
    );

  }
}
