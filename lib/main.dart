import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter ImagePicker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _increment() {}

  Widget imageBuilder(File file, int index) {
    if (file != null)
      return Image.file(
        File(
          file.path,
        ),
        fit: BoxFit.cover,
      );
    else
      return imagePlaceHolder(index);
  }

  Future<PickedFile> pickImage(ImageSource source) async {
    final PickedFile image =
        await _picker.getImage(source: source, maxWidth: 800, maxHeight: 800, preferredCameraDevice: CameraDevice.rear);
    return image;
  }

  Widget imagePlaceHolder(int index) {
    return Container(
      // padding: EdgeInsets.only(right),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(right: index % 2 == 0 ? BorderSide() : BorderSide.none, bottom: BorderSide()),
      ),
      child: Icon(Icons.add_a_photo),
    );
  }

  final _picker = ImagePicker();

  List<File> images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List.generate(4, (x) => images.add(null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index) => GestureDetector(
                    onTap: () async {
                      bool isGallery = true;
                      final image = await pickImage(!isGallery ? ImageSource.camera : ImageSource.gallery);
                      setState(() {
                        images[index] = File(image.path);
                      });
                    },
                    child: imageBuilder(images[index], index)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
