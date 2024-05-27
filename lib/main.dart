// Import necessary packages for Flutter and custom widgets.
import 'package:flutter/material.dart';
import 'package:image_color_picker/color_scheme_view.dart';
import 'package:image_color_picker/data.dart';

// Define constants for the app.
const Widget divider = SizedBox(height: 10);
const double narrowScreenWidthThreshold = 400;

// Entry point of the application.
void main() => runApp(const DynamicColorExample());

// StatefulWidget representing the main UI of the app.
class DynamicColorExample extends StatefulWidget {
  const DynamicColorExample({super.key});

  @override
  State<DynamicColorExample> createState() => _DynamicColorExampleState();
}

// State class for DynamicColorExample widget.
class _DynamicColorExampleState extends State<DynamicColorExample> {
  // Define state variables.
  late ColorScheme currentColorScheme;
  String currentHyperlinkImage = '';
  late int selectedImage;
  late bool isLight;
  late bool isLoading;

  // Initialize state variables.
  @override
  void initState() {
    super.initState();
    selectedImage = 0;
    isLight = true;
    isLoading = true;
    currentColorScheme = const ColorScheme.light();

    // After the first frame, load the first image.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateImage(images[selectedImage]);
      isLoading = false;
    });
  }

  // Build the UI of the app.
  @override
  Widget build(BuildContext context) {
    // Define color schemes for light and dark themes.
    final ColorScheme colorScheme = currentColorScheme;
    final ThemeData lightTheme = ThemeData(
      colorSchemeSeed: colorScheme.primary,
      brightness: Brightness.light,
      useMaterial3: false,
    );
    final ThemeData darkTheme = ThemeData(
      colorSchemeSeed: colorScheme.primary,
      brightness: Brightness.dark,
      useMaterial3: false,
    );

    // Helper function to create a label for color schemes.
    Widget schemeLabel(String brightness, ColorScheme colorScheme) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          brightness,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      );
    }

    // Helper function to create a view for color schemes.
    Widget schemeView(ThemeData theme) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ColorSchemeView(colorScheme: theme.colorScheme),
      );
    }

    // Build the MaterialApp with theme and Scaffold.
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: colorScheme),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: const Text('Image Color Picker'),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            actions: <Widget>[
              // Icon and switch for toggling between light and dark modes.
              const Icon(Icons.light_mode),
              Switch(
                activeColor: colorScheme.primary,
                activeTrackColor: colorScheme.surface,
                inactiveTrackColor: colorScheme.onSecondary,
                value: isLight,
                onChanged: (bool value) {
                  setState(() {
                    isLight = value;
                    _updateImage(images[selectedImage]);
                  });
                },
              )
            ],
          ),
          body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : ColoredBox(
                    color: colorScheme.secondaryContainer,
                    child: Column(
                      children: <Widget>[
                        // Divider and image selection row.
                        divider,
                        _imagesRow(context, images, colorScheme),
                        divider,
                        // Display color schemes based on screen width.
                        Expanded(
                          child: ColoredBox(
                            color: colorScheme.background,
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                if (constraints.maxWidth <
                                    narrowScreenWidthThreshold) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        divider,
                                        schemeLabel(
                                            'Light ColorScheme', colorScheme),
                                        schemeView(lightTheme),
                                        divider,
                                        divider,
                                        schemeLabel(
                                            'Dark ColorScheme', colorScheme),
                                        schemeView(darkTheme),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    schemeLabel(
                                                        'Light ColorScheme',
                                                        colorScheme),
                                                    schemeView(lightTheme),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    schemeLabel(
                                                        'Dark ColorScheme',
                                                        colorScheme),
                                                    schemeView(darkTheme),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // Function to update the selected image and its color scheme.
  Future<void> _updateImage(ImageProvider provider) async {
    final ColorScheme newColorScheme = await ColorScheme.fromImageProvider(
      provider: provider,
      brightness: isLight ? Brightness.light : Brightness.dark,
    );
    setState(() {
      selectedImage = images.indexOf(provider);
      currentColorScheme = newColorScheme;
    });
  }

  // Helper function to build the row of selectable images.
  Widget _imagesRow(
    BuildContext context,
    List<ImageProvider> images,
    ColorScheme colorScheme,
  ) {
    final double windowHeight = MediaQuery.of(context).size.height;
    final double windowWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 800) {
            // For wider screens, display images in one row.
            return _adaptiveLayoutImagesRow(images, colorScheme, windowHeight);
          } else {
            // For narrow screens, split images into two rows.
            return Column(
              children: <Widget>[
                _adaptiveLayoutImagesRow(
                    images.sublist(0, 3), colorScheme, windowWidth),
                _adaptiveLayoutImagesRow(
                    images.sublist(3), colorScheme, windowWidth),
              ],
            );
          }
        },
      ),
    );
  }

  // Helper function to build adaptive image rows
  Widget _adaptiveLayoutImagesRow(
    List<ImageProvider> images,
    ColorScheme colorScheme,
    double windowWidth,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images.map((ImageProvider image) {
        return Flexible(
          flex: (images.length / 3).floor(),
          child: GestureDetector(
            onTap: () => _updateImage(image),
            child: Card(
              color: images.indexOf(image) == selectedImage
                  ? colorScheme.primaryContainer
                  : colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: windowWidth * .25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(image: image),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
