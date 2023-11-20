
import 'package:flutter/material.dart';
import 'package:os_gpu_detection/results.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';  
import 'benchmark_results.dart';


class FilePickBench extends StatefulWidget {
  final String title;
  final String imagePath;
  final String description;
  final String gpu;
  

  FilePickBench({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.gpu, 
    required String gpuName, 
    required int gpuoffest,
  });

  @override
  ChooseFile createState() => ChooseFile();
}

class ChooseFile extends State<FilePickBench> {
  late String title;
  late String imagePath;
  late String description;
  late String gpu;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    imagePath = widget.imagePath;
    description = widget.description;
    gpu = widget.gpu;
  }

  List<String> allowedExtensions = [
    'jpg',
    'png',
    'pdf',
    'txt',
    'mp4',
    'mov',
    'docx',
    'heif',
    'jpeg'
  ];
  String fileExt = "";
  String selectedFileName = "";
  TextEditingController keyController = TextEditingController();
  String submittedKey = "";
  String filePath = "";
  String outputFilePath = ""; 
  String trimmedPath = "";

  void _selectPath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      dialogTitle: 'Select Output Path',
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'pdf',
        'txt',
        'mp4',
        'mov',
        'docx',
        'heif',
        'jpeg',
      ],
    );

    if (result != null) {
      String selectedExtension = result.files.first.extension?.toLowerCase() ?? "";

      if (allowedExtensions.contains(selectedExtension)) {
        setState(() {
          // Store the selected path in the new variable
          outputFilePath = result.files.first.path ?? "";
        });
      } else {
        // Show an alert dialog for inappropriate file extension
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("ERROR ⚠️"),
              content: Text("Please select an appropriate file."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }

    _trimPath(outputFilePath);
  }

   void _trimPath(String fullPath) {

    String pathWithoutPrefix = fullPath.replaceFirst("file:///", "");
    String directory = path.dirname(pathWithoutPrefix);
    String fileName = path.basename(pathWithoutPrefix);

    trimmedPath = path.join(directory, "");
    print(trimmedPath);
  
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      dialogTitle: 'Select a File you would like to Compress',
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'pdf',
        'txt',
        'mp4',
        'mov',
        'docx',
        'heif',
        'jpeg'
      ],
    );

    if (result != null) {
      String selectedExtension =
          result.files.first.extension?.toLowerCase() ?? "";

      if (allowedExtensions.contains(selectedExtension)) {
        setState(() {
          selectedFileName = result.files.first.name ?? "";
          fileExt = selectedExtension;
          filePath = result.files.first.path ?? "";
        });
      } else {
        // Show an alert dialog for inappropriate file extension
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("ERROR ⚠️"),
              content: const Text("Please select an appropriate file."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _submitKey() {
   
    //Default value for Benchmarking
      setState(() {
        submittedKey = "0000000000000000";
      });

      // FOR BENCHMARKING MODE ONLY!!!!!!!
      if (title == "Benchmarking") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BarChartSample3()
            // builder: (context) => BenchMark_Results(
            //   selectedFileName: selectedFileName,
            //   fileExt: fileExt,
            //   filePath: filePath,
            //   submittedKey: submittedKey,
            //   outputFilePath: "none",
            // ),
          ),
        );
      }
    
  }

  @override
  void dispose() {
    keyController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    Color benchmarkingCardColor =
        description.toLowerCase() == 'nvidia' ? Colors.green : Colors.deepOrange;
    return Scaffold(
      appBar: AppBar(
        title: Text('GPGPU Based File Encryption'),
        backgroundColor: benchmarkingCardColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _openFilePicker,
                  child: Text('Select File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: benchmarkingCardColor,
                    fixedSize: const Size(180, 60),
                    textStyle: const TextStyle(
                      fontFamily: "Cascadia Code",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed:_selectPath,
                  child: Text('Output Path'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: benchmarkingCardColor,
                    fixedSize: const Size(180, 60),
                    textStyle: const TextStyle(
                      fontFamily: "Cascadia Code",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "FileName: " +selectedFileName,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Output Path: " +trimmedPath,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Mode: " + title,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              selectedFileName,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Extension: " + fileExt,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Path: " + filePath,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _submitKey();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Entering Benchmarking Mode...'),
                  ),
                );
              },
              child: const Text('Benchmark'),
              style: ElevatedButton.styleFrom(
                backgroundColor: benchmarkingCardColor,
                fixedSize: const Size(180, 60),
                textStyle: const TextStyle(
                  fontFamily: "Cascadia Code",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              submittedKey,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
