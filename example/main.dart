import 'package:ncurses/src/wrapper.dart';

void main() {
  // Create a screen to render to
  final screen = Screen();

  // Create a subwindow in that screen - we'll put a border in the main window, and use this
  // subwindow so we don't overwrite that border.
  final window = Window.subWindow(
    screen.window,
    lines: lines - 2,
    cols: columns - 2,
    begin: Position(1, 1),
  );

  // Disable echoing input; enable raw mode
  screen.echo = false;
  screen.raw = true;

  // Enable keypad (function keys) and scrolling
  window.keypad = true;
  window.allowScroll = true;

  // Make a border
  screen.window.border();

  // Write some text
  window.addString(
    at: Position(1, 1),
    """Hi there!
This is a test string to demonstrate ncurses running in Dart.

This is a really really really really really really really really really really really really really really really really really really long line to demonstrate line wrapping.

Special characters are supported too! 😊
""",
  );

  // Get some values
  window.addString("""

Here are some stats for this screen:
Baudrate: ${screen.baudrate}
Has colors: ${screen.hasColors}
Can change color values: ${screen.canChangeColor}
Terminal name: ${screen.longName}
""");

  window.addString(
    "Try writing some characters and we will display their rendition here (backspace to leave): ",
  );

  // Refresh to render
  screen.window.refresh();

  // Access some keys
  Key key;
  while ((key = window.getKeyPress()) != Key.backspace) {
    window.addString('${key.name ?? 'no known rendition'} ');
    window.refresh();
  }

  // Remember to return to normal mode once you're done
  screen.endWin();
}
