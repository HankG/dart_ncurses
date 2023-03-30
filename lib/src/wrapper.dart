import 'dart:ffi' hide Char;
import 'dart:io';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:ncurses/bindings.dart' as bindings;
import 'package:ncurses/src/helpers.dart';

String get defaultLibraryPath {
  if (Platform.isWindows) {
    return 'libncursesw.dll';
  } else if (Platform.isMacOS) {
    return 'libncursesw.dylib';
  } else {
    return 'libncursesw.so.6';
  }
}

final bindings.NCursesLibrary defaultLibrary = () {
  final library = DynamicLibrary.open(defaultLibraryPath);
  return bindings.NCursesLibrary(library);
}();

// =======================================
//      Constants / Enums / Bitfields
// =======================================

/// Function return value for failure.
const err = bindings.ERR;

/// Function return value for success.
const ok = bindings.OK;

/// The version of NCurses these bindings were generated for.
const version = bindings.NCURSES_VERSION;

/// An OR-ed set of attributes.
class Attributes {
  /// Alternate character set.
  static const altCharSet = Attributes._fromValue(bindings.WA_ALTCHARSET);

  /// Blinking.
  static const blink = Attributes._fromValue(bindings.WA_BLINK);

  /// Extra bright or bold.
  static const bold = Attributes._fromValue(bindings.WA_BOLD);

  /// Half bright.
  static const dim = Attributes._fromValue(bindings.WA_DIM);

  /// Horizontal highlight.
  static const horizontal = Attributes._fromValue(bindings.WA_HORIZONTAL);

  /// Invisible.
  static const invis = Attributes._fromValue(bindings.WA_INVIS);

  /// Left highlight.
  static const left = Attributes._fromValue(bindings.WA_LEFT);

  /// Low highlight.
  static const low = Attributes._fromValue(bindings.WA_LOW);

  /// Protected.
  static const protect = Attributes._fromValue(bindings.WA_PROTECT);

  /// Reverse video.
  static const reverse = Attributes._fromValue(bindings.WA_REVERSE);

  /// Right highlight.
  static const right = Attributes._fromValue(bindings.WA_RIGHT);

  /// Best highlighting mode of the .terminal
  static const standout = Attributes._fromValue(bindings.WA_STANDOUT);

  /// Top highlight.
  static const top = Attributes._fromValue(bindings.WA_TOP);

  /// Underlining.
  static const underline = Attributes._fromValue(bindings.WA_UNDERLINE);

  /// Vertical highlight.
  static const vertical = Attributes._fromValue(bindings.WA_VERTICAL);

  /// No special attributes.
  static const normal = Attributes._fromValue(bindings.WA_NORMAL);

  final int _value;
  const Attributes._fromValue(int value)
      : _value = value & bindings.WA_ATTRIBUTES;

  static const values = [
    altCharSet,
    blink,
    bold,
    dim,
    horizontal,
    invis,
    left,
    low,
    protect,
    reverse,
    right,
    standout,
    top,
    underline,
    vertical,
    normal,
  ];

  @override
  String toString() {
    final attributesByName = <Attributes, String>{
      altCharSet: 'altCharSet',
      blink: 'blink',
      bold: 'bold',
      dim: 'dim',
      horizontal: 'horizontal',
      invis: 'invis',
      left: 'left',
      low: 'low',
      protect: 'protect',
      reverse: 'reverse',
      right: 'right',
      standout: 'standout',
      top: 'top',
      underline: 'underline',
      vertical: 'vertical',
      // Don't include normal
    };

    final applies = values.where((attribute) => attribute._value & _value != 0);

    return 'Attributes(${applies.map((e) => attributesByName[e]).join(', ')})';
  }

  @override
  int get hashCode => _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Attributes && other._value == _value);

  Attributes operator |(Attributes other) =>
      Attributes._fromValue(_value | other._value);
}

/// Color-related constants.
enum Colors {
  black._(bindings.COLOR_BLACK),
  blue._(bindings.COLOR_BLUE),
  green._(bindings.COLOR_GREEN),
  cyan._(bindings.COLOR_CYAN),
  red._(bindings.COLOR_RED),
  magenta._(bindings.COLOR_MAGENTA),
  yellow._(bindings.COLOR_YELLOW),
  white._(bindings.COLOR_WHITE);

  final int _value;
  const Colors._(this._value);

  factory Colors._fromValue(int value) =>
      values.singleWhere((element) => element._value == value);
}

/// Constants representing key values.
class Key {
  /// Break key.
  static const breakKey =
      Key._fromValue(bindings.KEY_BREAK, isFunctionKey: true);

  /// Down arrow key.
  static const down = Key._fromValue(bindings.KEY_DOWN, isFunctionKey: true);

  /// Up arrow key.
  static const up = Key._fromValue(bindings.KEY_UP, isFunctionKey: true);

  /// Left arrow key.
  static const left = Key._fromValue(bindings.KEY_LEFT, isFunctionKey: true);

  /// Right arrow key.
  static const right = Key._fromValue(bindings.KEY_RIGHT, isFunctionKey: true);

  /// Home key.
  static const home = Key._fromValue(bindings.KEY_HOME, isFunctionKey: true);

  /// Backspace.
  static const backspace =
      Key._fromValue(bindings.KEY_BACKSPACE, isFunctionKey: true);

  /// 0th function key.
  static const f0 = Key._fromValue(bindings.KEY_F0, isFunctionKey: true);

  /// 1st function key.
  static const f1 = Key._fromValue(bindings.KEY_F0 + 1, isFunctionKey: true);

  /// 2nd function key.
  static const f2 = Key._fromValue(bindings.KEY_F0 + 2, isFunctionKey: true);

  /// 3rd function key.
  static const f3 = Key._fromValue(bindings.KEY_F0 + 3, isFunctionKey: true);

  /// 4th function key.
  static const f4 = Key._fromValue(bindings.KEY_F0 + 4, isFunctionKey: true);

  /// 5th function key.
  static const f5 = Key._fromValue(bindings.KEY_F0 + 5, isFunctionKey: true);

  /// 6th function key.
  static const f6 = Key._fromValue(bindings.KEY_F0 + 6, isFunctionKey: true);

  /// 7th function key.
  static const f7 = Key._fromValue(bindings.KEY_F0 + 7, isFunctionKey: true);

  /// 8th function key.
  static const f8 = Key._fromValue(bindings.KEY_F0 + 8, isFunctionKey: true);

  /// 9th function key.
  static const f9 = Key._fromValue(bindings.KEY_F0 + 9, isFunctionKey: true);

  /// 10th function key.
  static const f10 = Key._fromValue(bindings.KEY_F0 + 10, isFunctionKey: true);

  /// 11th function key.
  static const f11 = Key._fromValue(bindings.KEY_F0 + 11, isFunctionKey: true);

  /// 12th function key.
  static const f12 = Key._fromValue(bindings.KEY_F0 + 12, isFunctionKey: true);

  /// The [n]th function key.
  int f(int n) => bindings.KEY_F0 + n;

  /// Delete line.
  static const dl = Key._fromValue(bindings.KEY_DL, isFunctionKey: true);

  /// Insert line.
  static const il = Key._fromValue(bindings.KEY_IL, isFunctionKey: true);

  /// Delete character.
  static const dc = Key._fromValue(bindings.KEY_DC, isFunctionKey: true);

  /// Insert char or enter insert mode.
  static const ic = Key._fromValue(bindings.KEY_IC, isFunctionKey: true);

  /// Exit insert char mode.
  static const eic = Key._fromValue(bindings.KEY_EIC, isFunctionKey: true);

  /// Clear screen.
  static const clear = Key._fromValue(bindings.KEY_CLEAR, isFunctionKey: true);

  /// Clear to end of screen.
  static const eos = Key._fromValue(bindings.KEY_EOS, isFunctionKey: true);

  /// Clear to end of line.
  static const eol = Key._fromValue(bindings.KEY_EOL, isFunctionKey: true);

  /// Scroll 1 line forward.
  static const sf = Key._fromValue(bindings.KEY_SF, isFunctionKey: true);

  /// Scroll 1 line backward (reverse).
  static const sr = Key._fromValue(bindings.KEY_SR, isFunctionKey: true);

  /// Next page.
  static const npage = Key._fromValue(bindings.KEY_NPAGE, isFunctionKey: true);

  /// Previous page.
  static const ppage = Key._fromValue(bindings.KEY_PPAGE, isFunctionKey: true);

  /// Set tab.
  static const stab = Key._fromValue(bindings.KEY_STAB, isFunctionKey: true);

  /// Clear tab.
  static const ctab = Key._fromValue(bindings.KEY_CTAB, isFunctionKey: true);

  /// Clear all tabs.
  static const catab = Key._fromValue(bindings.KEY_CATAB, isFunctionKey: true);

  /// Enter or send.
  static const enter = Key._fromValue(bindings.KEY_ENTER, isFunctionKey: true);

  /// Soft (partial) reset.
  static const sreset =
      Key._fromValue(bindings.KEY_SRESET, isFunctionKey: true);

  /// Reset or hard reset.
  static const reset = Key._fromValue(bindings.KEY_RESET, isFunctionKey: true);

  /// Print or copy.
  static const print = Key._fromValue(bindings.KEY_PRINT, isFunctionKey: true);

  /// Home down or bottom.
  static const ll = Key._fromValue(bindings.KEY_LL, isFunctionKey: true);

  /// Upper left of keypad.
  ///
  /// The virtual keypad is a 3-by-3 keypad arranged as follows:
  /// ```
  /// A1    UP    A3
  /// LEFT  B2    RIGHT
  /// C1    DOWN  C3
  /// ```
  static const a1 = Key._fromValue(bindings.KEY_A1, isFunctionKey: true);

  /// Upper right of keypad.
  ///
  /// The virtual keypad is a 3-by-3 keypad arranged as follows:
  /// ```
  /// A1    UP    A3
  /// LEFT  B2    RIGHT
  /// C1    DOWN  C3
  /// ```
  static const a3 = Key._fromValue(bindings.KEY_A3, isFunctionKey: true);

  /// Center of keypad.
  ///
  /// The virtual keypad is a 3-by-3 keypad arranged as follows:
  /// ```
  /// A1    UP    A3
  /// LEFT  B2    RIGHT
  /// C1    DOWN  C3
  /// ```
  static const b2 = Key._fromValue(bindings.KEY_B2, isFunctionKey: true);

  /// Lower left of keypad.
  ///
  /// The virtual keypad is a 3-by-3 keypad arranged as follows:
  /// ```
  /// A1    UP    A3
  /// LEFT  B2    RIGHT
  /// C1    DOWN  C3
  /// ```
  static const c1 = Key._fromValue(bindings.KEY_C1, isFunctionKey: true);

  /// Lower right of keypad.
  ///
  /// The virtual keypad is a 3-by-3 keypad arranged as follows:
  /// ```
  /// A1    UP    A3
  /// LEFT  B2    RIGHT
  /// C1    DOWN  C3
  /// ```
  static const c3 = Key._fromValue(bindings.KEY_C3, isFunctionKey: true);

  /// Back tab key
  static const btab = Key._fromValue(bindings.KEY_BTAB, isFunctionKey: true);

  /// Beginning key
  static const beg = Key._fromValue(bindings.KEY_BEG, isFunctionKey: true);

  /// Cancel key
  static const cancel =
      Key._fromValue(bindings.KEY_CANCEL, isFunctionKey: true);

  /// Close key
  static const close = Key._fromValue(bindings.KEY_CLOSE, isFunctionKey: true);

  /// Cmd (command) key
  static const command =
      Key._fromValue(bindings.KEY_COMMAND, isFunctionKey: true);

  /// Copy key
  static const copy = Key._fromValue(bindings.KEY_COPY, isFunctionKey: true);

  /// Create key
  static const create =
      Key._fromValue(bindings.KEY_CREATE, isFunctionKey: true);

  /// End key
  static const end = Key._fromValue(bindings.KEY_END, isFunctionKey: true);

  /// Exit key
  static const exit = Key._fromValue(bindings.KEY_EXIT, isFunctionKey: true);

  /// Find key
  static const find = Key._fromValue(bindings.KEY_FIND, isFunctionKey: true);

  /// Help key
  static const help = Key._fromValue(bindings.KEY_HELP, isFunctionKey: true);

  /// Mark key
  static const mark = Key._fromValue(bindings.KEY_MARK, isFunctionKey: true);

  /// Message key
  static const message =
      Key._fromValue(bindings.KEY_MESSAGE, isFunctionKey: true);

  /// Move key
  static const move = Key._fromValue(bindings.KEY_MOVE, isFunctionKey: true);

  /// Next object key
  static const next = Key._fromValue(bindings.KEY_NEXT, isFunctionKey: true);

  /// Open key
  static const open = Key._fromValue(bindings.KEY_OPEN, isFunctionKey: true);

  /// Options key
  static const options =
      Key._fromValue(bindings.KEY_OPTIONS, isFunctionKey: true);

  /// Previous object key
  static const previous =
      Key._fromValue(bindings.KEY_PREVIOUS, isFunctionKey: true);

  /// Redo key
  static const redo = Key._fromValue(bindings.KEY_REDO, isFunctionKey: true);

  /// Reference key
  static const reference =
      Key._fromValue(bindings.KEY_REFERENCE, isFunctionKey: true);

  /// Refresh key
  static const refresh =
      Key._fromValue(bindings.KEY_REFRESH, isFunctionKey: true);

  /// Replace key
  static const replace =
      Key._fromValue(bindings.KEY_REPLACE, isFunctionKey: true);

  /// Restart key
  static const restart =
      Key._fromValue(bindings.KEY_RESTART, isFunctionKey: true);

  /// Resume key
  static const resume =
      Key._fromValue(bindings.KEY_RESUME, isFunctionKey: true);

  /// Save key
  static const save = Key._fromValue(bindings.KEY_SAVE, isFunctionKey: true);

  /// Shifted beginning key
  static const sbeg = Key._fromValue(bindings.KEY_SBEG, isFunctionKey: true);

  /// Shifted cancel key
  static const scancel =
      Key._fromValue(bindings.KEY_SCANCEL, isFunctionKey: true);

  /// Shifted command key
  static const scommand =
      Key._fromValue(bindings.KEY_SCOMMAND, isFunctionKey: true);

  /// Shifted copy key
  static const scopy = Key._fromValue(bindings.KEY_SCOPY, isFunctionKey: true);

  /// Shifted create key
  static const screate =
      Key._fromValue(bindings.KEY_SCREATE, isFunctionKey: true);

  /// Shifted delete char key
  static const sdc = Key._fromValue(bindings.KEY_SDC, isFunctionKey: true);

  /// Shifted delete line key
  static const sdl = Key._fromValue(bindings.KEY_SDL, isFunctionKey: true);

  /// Select key
  static const select =
      Key._fromValue(bindings.KEY_SELECT, isFunctionKey: true);

  /// Shifted end key
  static const send = Key._fromValue(bindings.KEY_SEND, isFunctionKey: true);

  /// Shifted clear line key
  static const seol = Key._fromValue(bindings.KEY_SEOL, isFunctionKey: true);

  /// Shifted exit key
  static const sexit = Key._fromValue(bindings.KEY_SEXIT, isFunctionKey: true);

  /// Shifted find key
  static const sfind = Key._fromValue(bindings.KEY_SFIND, isFunctionKey: true);

  /// Shifted help key
  static const shelp = Key._fromValue(bindings.KEY_SHELP, isFunctionKey: true);

  /// Shifted home key
  static const shome = Key._fromValue(bindings.KEY_SHOME, isFunctionKey: true);

  /// Shifted input key
  static const sic = Key._fromValue(bindings.KEY_SIC, isFunctionKey: true);

  /// Shifted left arrow key
  static const sleft = Key._fromValue(bindings.KEY_SLEFT, isFunctionKey: true);

  /// Shifted message key
  static const smessage =
      Key._fromValue(bindings.KEY_SMESSAGE, isFunctionKey: true);

  /// Shifted move key
  static const smove = Key._fromValue(bindings.KEY_SMOVE, isFunctionKey: true);

  /// Shifted next key
  static const snext = Key._fromValue(bindings.KEY_SNEXT, isFunctionKey: true);

  /// Shifted options key
  static const soptions =
      Key._fromValue(bindings.KEY_SOPTIONS, isFunctionKey: true);

  /// Shifted prev key
  static const sprevious =
      Key._fromValue(bindings.KEY_SPREVIOUS, isFunctionKey: true);

  /// Shifted print key
  static const sprint =
      Key._fromValue(bindings.KEY_SPRINT, isFunctionKey: true);

  /// Shifted redo key
  static const sredo = Key._fromValue(bindings.KEY_SREDO, isFunctionKey: true);

  /// Shifted replace key
  static const sreplace =
      Key._fromValue(bindings.KEY_SREPLACE, isFunctionKey: true);

  /// Shifted right arrow
  static const sright =
      Key._fromValue(bindings.KEY_SRIGHT, isFunctionKey: true);

  /// Shifted resume key
  static const srsume =
      Key._fromValue(bindings.KEY_SRSUME, isFunctionKey: true);

  /// Shifted save key
  static const ssave = Key._fromValue(bindings.KEY_SSAVE, isFunctionKey: true);

  /// Shifted suspend key
  static const ssuspend =
      Key._fromValue(bindings.KEY_SSUSPEND, isFunctionKey: true);

  /// Shifted undo key
  static const sundo = Key._fromValue(bindings.KEY_SUNDO, isFunctionKey: true);

  /// Suspend key
  static const suspend =
      Key._fromValue(bindings.KEY_SUSPEND, isFunctionKey: true);

  /// Undo key
  static const undo = Key._fromValue(bindings.KEY_UNDO, isFunctionKey: true);

  final int _value;
  final bool isFunctionKey;

  const Key._fromValue(this._value, {required this.isFunctionKey});

  factory Key(String character) {
    if (character.codeUnits.length != 1) {
      throw Exception('Invalid key character $character');
    }

    return Key._fromValue(character.codeUnits.single, isFunctionKey: false);
  }

  String get value => String.fromCharCode(_value);

  /// A string whose value describes this key.
  String? get name {
    try {
      return wrap('name', () => defaultLibrary.key_name(_value))
          .cast<Utf8>()
          .toDartString();
    } on NCursesException {
      return null;
    }
  }

  @override
  int get hashCode => Object.hash(_value, isFunctionKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Key &&
          other._value == _value &&
          other.isFunctionKey == isFunctionKey);
}

/// The visibility of a cursor.
///
/// Use in [Screen.setCursorVisibility].
enum CursorVisibility {
  /// Invisible.
  invisible._(0),

  /// Terminal-specific normal mode
  normal._(1),

  /// Terminal-specific high visibility mode
  highVisibility._(2);

  final int _value;
  const CursorVisibility._(this._value);

  factory CursorVisibility._fromValue(int value) =>
      values.singleWhere((element) => element._value == value);
}

// =======================================
//                Macros
// =======================================

// Since macros aren't included in the generated bindings file, we simply copy their implementation.

/// Replacements for functionality provided by macros.
extension PositionMacros on Window {
  /// Get the cursor position of this window.
  ///
  /// Replaces the `getyx` macro.
  Position getCursorPosition() {
    final y = defaultLibrary.getcury(_native);
    final x = defaultLibrary.getcurx(_native);

    return Position(x, y);
  }

  /// If this window is a subwindow, stores in y and x the coordinates of the window's origin
  /// relative to its parent window. Otherwise, null is returned.
  ///
  /// Replaces the `getparyx` macro.
  Position? getParentPosition() {
    final y = defaultLibrary.getpary(_native);
    final x = defaultLibrary.getparx(_native);

    if (x == -1 && y == -1) {
      return null;
    }

    return Position(x, y);
  }

  /// Get the absolute screen coordinates of this window's origin.
  ///
  /// Replaces the `getbegyx` macro.
  Position getPosition() {
    final y = defaultLibrary.getbegy(_native);
    final x = defaultLibrary.getbegx(_native);

    return Position(x, y);
  }

  /// Gets the maximum position in this window, that is, the position with the highest possible x
  /// value and the highest possible y value.
  ///
  /// Replaces the `getmaxyx` macro.
  Position getMaxPosition() {
    final y = defaultLibrary.getmaxy(_native);
    final x = defaultLibrary.getmaxx(_native);

    return Position(x, y);
  }
}

// =======================================
//      Functions / Global Variables
// =======================================

/// The number of colours that the terminal supports.
///
/// If [colors] is 0, the terminal does not support redefinition of colours (and
/// [Screen.canChangeColor] will return `false`).
int get colors => defaultLibrary.COLORS;

/// The maximum number of colour-pairs that the terminal supports.
int get colorPairs => defaultLibrary.COLOR_PAIRS;

/// The number of lines in the current terminal.
int get lines => defaultLibrary.LINES;

/// The number of columns in the current terminal.
int get columns => defaultLibrary.COLS;

/// Controls whether the terminal returns 7 or 8 significant bits on input.
///
/// Initially, whether the terminal returns 7 or 8 significant bits on input depends on the
/// control mode of the display driver (see the XBD specification, General Terminal Interface). To
/// force 8 bits to be returned, set [meta] to `true`. To force 7 bits to be returned, set [meta] to
/// `false`.
///
/// If the terminfo capabilities smm (meta_on) and rmm (meta_off) are defined for
/// the terminal, smm is sent to the terminal when `meta = true` is called and rmm is sent when
/// `meta = false` is called.
set meta(bool value) =>
    wrap('meta=', () => defaultLibrary.meta(nullptr, value));

/// Controls the currently active screen.
///
/// See [setTerm] for more details.
set screen(Screen screen) => setTerm(screen);

/// Determines the terminal type and initialises all implementation data structures.
///
/// The environment variable specifies the terminal type.
///
/// The [initScreen] function also causes the first refresh operation to clear the screen.
///
/// If errors occur, [initScreen] writes an appropriate error message to standard error and exits.
///
/// The only functions that can be called before [initScreen] or [newTerminal] are [Screen.filter],
/// [Screen.ripoffLine], [slk_init], [use_env] and the functions whose prototypes are defined in
/// <term.h>.
///
/// Portable applications must not call [initScreen] twice.
// TODO: Clarify native functions in above docs
// Window initScreen() => Window._fromPointer(defaultLibrary.initscr());

/// Write the current contents of the virtual screen to the file named by [filename] in an
/// unspecified format.
///
/// This file can then be loaded by [Screen.setScreen], [Screen.restoreScreen] or
/// [Screen.initScreen].
void dumpScreen(String filename) => wrap<int>('dumpScreen', () {
      final ptr = filename.toNativeUtf8();
      final ret = defaultLibrary.scr_dump(ptr.cast());
      malloc.free(ptr);

      return ret;
    });

/// Switch between different screens.
///
/// The [newScreen] argument specifies the new current screen.
///
/// The returned [Screen] is the previous screen.
Screen setTerm(Screen newScreen) {
  final previousWindow = Window.stdscr;
  return Screen._fromPointer(
      wrap('setTerm', () => defaultLibrary.set_term(newScreen._native)),
      previousWindow);
}

// =======================================
//                  Types
// =======================================

/// A representation of a y-x pair.
typedef Position = Point<int>;

class Char implements Finalizable {
  final Pointer<bindings.cchar_t> _native;

  const Char._fromPointer(this._native);

  factory Char(
    String value, {
    Attributes attributes = Attributes.normal,
    required /* ? */ ColorPair colorPair,
  }) {
    final ptr = malloc<bindings.cchar_t>();

    // Create the result early so it gets finalized if `wrap` throws an error.
    final result = Char._fromPointer(ptr).._attachFinalizer();

    wrap('Char', () {
      final stringPtr = value.toNativeWChars();
      final ret = defaultLibrary.setcchar(
        ptr,
        stringPtr,
        attributes._value,
        colorPair._value,
        nullptr,
      );
      malloc.free(stringPtr);

      return ret;
    });

    return result;
  }

  // TODO: Using a dart function as the finalizer target breaks stuff
  static void _freeMemory(Pointer<Void> memory) => malloc.free(memory);
  static final _finalizer = NativeFinalizer(
    Pointer.fromFunction<Void Function(Pointer<NativeType>)>(_freeMemory)
        .cast(),
  );

  void _attachFinalizer() => _finalizer.attach(this, _native.cast(),
      detach: this, externalSize: sizeOf<bindings.cchar_t>());

  /// The number of wide characters in this [Char].
  int get length =>
      defaultLibrary.getcchar(_native, nullptr, nullptr, nullptr, nullptr);

  List<dynamic> _values() {
    late List<dynamic> values;

    wrap('_values', () {
      final wchPtr = malloc<WChar>(bindings.CCHARW_MAX);
      final attrPtr = malloc<bindings.attr_t>();
      final colorPairPtr = malloc<Short>();

      final ret = defaultLibrary.getcchar(
        _native,
        wchPtr,
        attrPtr,
        colorPairPtr,
        nullptr,
      );

      values = [
        wchPtr.cast<WChar>().toDartString(),
        Attributes._fromValue(attrPtr.value),
        ColorPair._fromValue(colorPairPtr.value),
      ];

      malloc.free(wchPtr);
      malloc.free(attrPtr);
      malloc.free(colorPairPtr);

      return ret;
    });

    return values;
  }

  String get value => _values()[0];

  Attributes get attributes => _values()[1];

  ColorPair get colorPair => _values()[2];
}

class ColorPair {
  final int _value;

  ColorPair._fromValue(this._value);
}

class Screen implements Finalizable {
  final Pointer<bindings.SCREEN> _native;

  /// This screen's window (stdscr).
  final Window window;

  Screen._fromPointer(this._native, this.window);

  factory Screen({String? terminal}) {
    final ptr = wrap('Screen', () {
      final terminalPtr = terminal?.toNativeUtf8();

      final ret = defaultLibrary.newterm(
        terminalPtr?.cast() ?? nullptr,
        // TODO: Allow passing files other than stdin/stdout
        defaultLibrary.stdout,
        defaultLibrary.stdin,
      );

      if (terminalPtr != null) {
        malloc.free(terminalPtr);
      }

      return ret;
    });

    final screen = Screen._fromPointer(ptr, Window.stdscr);

    _finalizer.attach(
      screen,
      screen._native.cast(),
      detach: screen,
      // externalSize: sizeOf<bindings.SCREEN>(),
    );

    return screen;
  }

  static final _finalizer =
      NativeFinalizer(defaultLibrary.addresses.delscreen.cast());

  /// The output speed of the terminal in bits per second.
  int get baudrate => defaultLibrary.baudrate_sp(_native);

  /// Control cbreak mode.
  ///
  /// If `true`, ets the input mode for the current terminal to cbreak mode and overrides a call to
  /// [raw]. Otherwise, sets the input mode for the current terminal to Cooked Mode without
  /// changing the state of ISIG and IXON.
  set cbreak(bool value) {
    if (value) {
      wrap('cbreak=', () => defaultLibrary.cbreak_sp(_native));
    } else {
      wrap('cbreak=', () => defaultLibrary.nocbreak_sp(_native));
    }
  }

  /// Control raw mode.
  ///
  /// If `true`, sets the input mode for the current terminal to Raw Mode. Otherwise, sets the input
  /// mode for the current terminal to Cooked Mode and sets the ISIG and IXON flags.
  set raw(bool value) {
    if (value) {
      wrap('raw=', () => defaultLibrary.raw_sp(_native));
    } else {
      wrap('raw=', () => defaultLibrary.noraw_sp(_native));
    }
  }

  /// Whether the terminal is a colour terminal.
  bool get hasColors => defaultLibrary.has_colors_sp(_native);

  /// Whether the terminal is a colour terminal on which colours can be redefined.
  bool get canChangeColor => defaultLibrary.can_change_color_sp(_native);

  /// Sets the appearance of the cursor based on [visibility].
  ///
  /// See [setCursorVisibility] for details.
  set cursorVisibility(CursorVisibility visibility) =>
      setCursorVisibility(visibility);

  /// Control Echo mode.
  ///
  /// Initially, curses software echo mode is enabled and hardware echo mode of the tty driver is
  /// disabled. [echo] controls software echo only. Hardware echo must remain disabled for
  /// the duration of the application, else the behaviour is undefined.
  set echo(bool value) {
    if (value) {
      wrap('echo=', () => defaultLibrary.echo_sp(_native));
    } else {
      wrap('echo=', () => defaultLibrary.noecho_sp(_native));
    }
  }

  /// Sets the input mode for the current window to Half-Delay Mode and specifies [duration] as the
  /// half-delay interval.
  ///
  /// [duration] must satisfy `.1s <= duration <= 25.5s`
  set halfDelay(Duration duration) => wrap(
        'halfDelay=',
        () => defaultLibrary.halfdelay_sp(_native,
            duration.inMilliseconds ~/ (Duration.millisecondsPerSecond / 10)),
      );

  /// Whether the terminal has insert- and delete-character capabilities.
  bool get hasInsertDeleteCharacter => defaultLibrary.has_ic_sp(_native);

  /// Whether the terminal has insert- and delete-line capabilities, or can simulate them using
  /// scrolling regions.
  bool get hasInsertDeleteLine => defaultLibrary.has_il_sp(_native);

  /// The current erase character.
  String get eraseCharacter {
    late String result;

    wrap('eraseCharacter', () {
      final ptr = malloc<WChar>();
      final ret = defaultLibrary.erasewchar(ptr);
      result = String.fromCharCode(ptr.value);
      malloc.free(ptr);

      return ret;
    });

    return result;
  }

  /// The current line kill character.
  String get killCharacter {
    late String result;

    wrap('eraseCharacter', () {
      final ptr = malloc<WChar>();
      final ret = defaultLibrary.killwchar(ptr);
      result = String.fromCharCode(ptr.value);
      malloc.free(ptr);

      return ret;
    });

    return result;
  }

  /// Specify whether pressing an interrupt key (interrupt, suspend or quit) will flush the input
  /// buffer associated with the current screen.
  ///
  /// If the value of [value] is `true`, then flushing of the output buffer associated with the
  /// screen will occur when an interrupt key (interrupt, suspend, or quit) is pressed. If the value
  /// of [value] is `false` then no flushing of the buffer will occur when an interrupt key is pressed.
  ///
  /// The default for the option is inherited from the display driver settings.
  set flushOnInterrupt(bool value) => wrap('flushOnInterrupt=',
      () => defaultLibrary.intrflush_sp(_native, nullptr, value));

  /// Whether the screen has been refreshed since the last call to [endWin].
  bool get isEndWindow => defaultLibrary.isendwin_sp(_native);

  /// Generates a verbose description of the current terminal.
  ///
  /// The maximum length of a verbose description is 128 bytes.
  ///
  /// It is defined only after the call to [initScreen] or [newTerm].
  String get longName =>
      wrap('longName', () => defaultLibrary.longname_sp(_native))
          .cast<Utf8>()
          .toDartString();

  /// Control whether carriage returns are translated to newlines on input.
  set newlineMode(bool value) {
    if (value) {
      wrap('newLineMode=', () => defaultLibrary.nl_sp(_native));
    } else {
      wrap('newLineMode=', () => defaultLibrary.nonl_sp(_native));
    }
  }

  /// Control whether output in the display driver queue is flushed whenever an interrupt key
  /// (interrupt, suspend, or quit) is pressed.
  set qiFlush(bool value) {
    if (value) {
      defaultLibrary.qiflush_sp(_native);
    } else {
      defaultLibrary.noqiflush_sp(_native);
    }
  }

  /// Obtain the terminal name as recorded by [setupTerm].
  String get termName =>
      defaultLibrary.termname_sp(_native).cast<Utf8>().toDartString();

  /// Extract the video attributes of the current terminal which is supported by the [Char] data type.
  Attributes get termAttrs =>
      Attributes._fromValue(defaultLibrary.term_attrs_sp(_native));

  /// Specify the technique by which the implementation determines the size of the screen.
  ///
  /// If [value] is `false`, the implementation uses the values of lines and columns specified in
  /// the terminfo database. If [value] is `true`, the implementation uses the and environment
  /// variables.
  ///
  /// The initial value is `true`.
  ///
  /// Any call to [useEnv] must precede calls to [initScreen], [newTerm] or [setupTerm].
  set useEnv(bool value) => defaultLibrary.use_env_sp(_native, value);

  /// Alert the user.
  ///
  /// This function sounds the audible alarm on the terminal, or if that is not possible, it flashes
  /// the screen (visible bell). If neither signal is possible, nothing happens.
  void beep() => wrap('beep', () => defaultLibrary.beep_sp(_native));

  /// Must be called in order to enable use of colours and before any colour manipulation function
  /// is called.
  ///
  /// This function initialises eight basic colours ([Colors.black], [Colors.blue], [Colors.green],
  /// [Colors.cyan], [Colors.red], [Colors.magenta], [Colors.yellow], and [Colors.white]).
  ///
  /// The initial appearance of these eight colours is not specified.
  ///
  /// This function also initialises two global variables:
  /// - [colors]
  /// - [colorPairs]
  ///
  /// This function also restores the colours on the terminal to terminal-specific initial values.
  /// The initial background colour is assumed to be black for all terminals.
  void startColor() =>
      wrap('startColor', () => defaultLibrary.start_color_sp(_native));

  /// Sets the appearance of the cursor based on the value of [visibility].
  ///
  /// If the terminal supports the cursor mode specified by [visibility], then this function returns
  /// the previous cursor state. Otherwise, this function throws.
  CursorVisibility setCursorVisibility(CursorVisibility visibility) =>
      CursorVisibility._fromValue(
        wrap('setCursorVisibility',
            () => defaultLibrary.curs_set_sp(_native, visibility._value)),
      );

  /// Saves the current terminal modes as the "program" (in Curses) state for use by
  /// [resetProgramMode].
  ///
  /// This functions affects the mode of the terminal associated with the current screen.
  void saveProgramMode() =>
      wrap('saveProgramMode', () => defaultLibrary.def_prog_mode_sp(_native));

  /// Saves the current terminal modes as the "shell" (not in Curses) state for use by
  /// [resetShellMode].
  ///
  /// This functions affects the mode of the terminal associated with the current screen.
  ///
  /// Applications normally do not need to refer to the shell terminal mode.
  void saveShellMode() =>
      wrap('saveShellMode', () => defaultLibrary.def_shell_mode_sp(_native));

  /// Restores the terminal to the "program" (in Curses) state.
  ///
  /// This functions affects the mode of the terminal associated with the current screen.
  void resetProgramMode() => wrap(
      'resetProgramMode', () => defaultLibrary.reset_prog_mode_sp(_native));

  /// Restores the terminal to the "shell" (not in Curses) state.
  ///
  /// This functions affects the mode of the terminal associated with the current screen.
  ///
  /// Applications normally do not need to refer to the shell terminal mode.
  void resetShellMode() =>
      wrap('resetShellMode', () => defaultLibrary.reset_shell_mode_sp(_native));

  /// On terminals that support pad characters, pause the output for at least [duration].
  ///
  /// Otherwise, the length of the delay is unspecified.
  ///
  /// Whether or not the terminal supports pad characters, this function is not a precise method of
  /// timekeeping.
  void delayOutput(Duration duration) => wrap('delayOutput',
      () => defaultLibrary.delay_output_sp(_native, duration.inMilliseconds));

  /// Sends to the terminal the commands to perform any required changes.
  void doUpdate() =>
      wrap('doUpdate', () => defaultLibrary.doupdate_sp(_native));

  /// Restores the terminal after Curses activity by at least restoring the saved shell terminal mode,
  /// flushing any output to the terminal and moving the cursor to the first column of the last line
  /// of the screen.
  ///
  /// Refreshing a window resumes program mode.
  ///
  /// The application must call [endWin] for each terminal being used before exiting. If [newTerm] is
  /// called more than once for the same terminal, the first screen created must be the last one for
  /// which [endWin] is called.
  void endWin() => wrap('endWin', () => defaultLibrary.endwin_sp(_native));

  /// Changes the algorithm for initialising terminal capabilities that assume that the terminal has
  /// more than one line.
  ///
  /// A subsequent call to [initScreen] or [newTerm] performs the following additional actions:
  ///
  /// - Disable use of `clear`, `cud`, `cud1`, `cup`, `cuu1` and `vpa`.
  /// - Set the value of the home string to the value of the cr. string
  /// - Set lines equal to 1.
  ///
  /// Any call to [filter] must precede the call to [initScreen] or [newTerm].
  void filter() => defaultLibrary.filter_sp(_native);

  /// Alerts the user.
  ///
  /// This function flashes the screen, or if that is not possible, it sounds the audible alarm on the
  /// terminal. If neither signal is possible, nothing happens.
  void flash() => wrap('flash', () => defaultLibrary.flash_sp(_native));

  /// Discards (flushes) any characters in the input buffer associated with the current screen.
  void flushInput() =>
      wrap('flushInput', () => defaultLibrary.flushinp_sp(_native));

// TODO
// Screen newTerminal(String type, FILE *outfile, FILE *infile) => Screen.fromPointer(wrap(() => defaultLibrary.newterm_sp(native, arg0, arg1, arg2)));

  /// Outputs one or more commands to the terminal that move the terminal's cursor to [newPosition],
  /// an absolute position on the terminal screen.
  ///
  /// The [oldPosition] argument specifies the former cursor position. Specifying the former position
  /// is necessary on terminals that do not provide coordinate-based movement commands. On terminals
  /// that provide these commands, Curses may select a more efficient way to move the cursor based on
  /// the former position.
  ///
  /// If [newPosition] is not a valid address for the terminal in use, [moveCursor] fails.
  ///
  /// If [oldPosition] is the same as [newPosition], then [moveCursor] succeeds without taking any
  /// action.
  ///
  /// If [moveCursor] outputs a cursor movement command, it updates its information concerning the
  /// location of the cursor on the terminal.
  void moveCursor(Position oldPosition, Position newPosition) => wrap(
      'moveCursor',
      () => defaultLibrary.mvcur_sp(
          _native, oldPosition.y, oldPosition.x, newPosition.y, newPosition.x));

  /// Takes at least [duration] to return.
  @Deprecated('Avoid using nap and prefer using await')
  void nap(Duration duration) => wrap(
      'nap', () => defaultLibrary.napms_sp(native, duration.inMilliseconds));

  /// Reserve a screen line for use by the application.
  ///
  /// Any call to [ripoffLine] must precede the call to [initScreen] or [newTerm].
  ///
  /// If [line] is positive, one line is removed from the beginning of stdscr; if [line] is negative,
  /// one line is removed from the end. Removal occurs during the subsequent call to [initScreen] or
  /// [newTerm]. When the subsequent call is made, [init] is called with two arguments: a [Window]
  /// representing the one-line window that has been allocated and an integer with the number of
  /// columns in the window. The initialisation function cannot use the [lines] and [columns] global
  /// variables and cannot call [Window.refresh] or [doUpdate], but may call [Window.outRefresh].
  ///
  /// Up to five lines can be ripped off. Calls to [ripoffLine] above this limit have no effect but
  /// report success.
  // TODO: Fix - FFI doesn't allow functions
  // void ripoffLine(int line, int Function(Window, int) init) =>
  //     wrap(() => defaultLibrary.ripoffline_sp(
  //           _native,
  //           line,
  //           Pointer.fromFunction<Int Function(Pointer<bindings.WINDOW>, Int)>(
  //             (Pointer<bindings.WINDOW> ptr, int cols) {
  //               if (ptr == nullptr) {
  //                 throw Exception('Invalid window in ripoffLine');
  //               }

  //               final window = Window._fromPointer(ptr);

  //               return init(window, cols);
  //             },
  //             1,
  //           ),
  //         ));

  /// Save the state that would be put in place by a call to [resetProgramMode].
  void saveTty() => wrap('saveTty', () => defaultLibrary.savetty_sp(_native));

  /// Restore the program mode as of the most recent call to [saveTty].
  void resetTty() => wrap('resetTty', () => defaultLibrary.resetty_sp(_native));

  /// Reads the contents of the file named by [filename] and uses them to initialise the Curses data
  /// structures to what the terminal currently has on its screen.
  ///
  /// The next refresh operation bases any updates on this information, unless either of the following
  /// conditions is true:
  /// - The terminal has been written to since the virtual screen was dumped to filename
  /// - The terminfo capabilities rmcup and nrrmc are defined for the current terminal.
  void initScreen(String filename) => wrap<int>('initScreen', () {
        final ptr = filename.toNativeUtf8();
        final ret = defaultLibrary.scr_init_sp(_native, ptr.cast());
        malloc.free(ptr);

        return ret;
      });

  /// Set the virtual screen to the contents of the file named by [filename], which must have been
  /// written using [dumpScreen].
  ///
  /// The next refresh operation restores the screen to the way it looked in the dump file.
  void restoreScreen(String filename) => wrap<int>('restoreScreen', () {
        final ptr = filename.toNativeUtf8();
        final ret = defaultLibrary.scr_restore_sp(_native, ptr.cast());
        malloc.free(ptr);

        return ret;
      });

  /// A combination of [restoreScreen] and [initScreen].
  ///
  /// This function tells the program that the information in the file named by [filename] is what is
  /// currently on the screen, and also what the program wants on the screen. This can be thought of
  /// as a screen inheritance function.
  void setScreen(String filename) => wrap<int>('setScreen', () {
        final ptr = filename.toNativeUtf8();
        final ret = defaultLibrary.scr_set_sp(_native, ptr.cast());
        malloc.free(ptr);

        return ret;
      });

// TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/del_curterm.html
// TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/slk_attr_off.html

// TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/tigetflag.html
// TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/tigetnum.html
// TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/tigetstr.html
// TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/tparm.html

// TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/typeahead.html

  /// Push the single-byte character [key] onto the head of the input queue.
  void ungetKey(Key key) =>
      wrap('ungetKey', () => defaultLibrary.unget_wch_sp(_native, key._value));

  void setVideoAttributes(Attributes attributes, ColorPair colorPair) => wrap(
      'setVideoAttributes',
      () => defaultLibrary.vid_attr(
          attributes._value, colorPair._value, nullptr));

  /// Redefine [color], on terminals that support the redefinition of colours, to have the red,
  /// green, and blue intensity components specified by [r], [g], and [b], respectively.
  ///
  /// Calling [setColorValues] also changes all occurrences of the specified colour on the screen to the
  /// new definition.
  ///
  /// [r], [g] and [b] range from 0 to 1000.
  void setColorValues(Colors color, int r, int g, int b) => wrap(
      'setColorValues', () => defaultLibrary.init_color(color._value, r, g, b));

  /// Identify the intensity components of [color].
  ///
  /// The return value is a list containing the r, g and b components of [color] in that order.
  /// The values can range from 0 to 1000.
  List<int> getColorValues(Colors color) {
    late List<int> values;

    wrap('getColorValues', () {
      final ptr = malloc<Short>(3);
      final ret = defaultLibrary.color_content(
        color._value,
        ptr.elementAt(0),
        ptr.elementAt(1),
        ptr.elementAt(2),
      );
      values = [ptr[0], ptr[1], ptr[2]];
      malloc.free(ptr);

      return ret;
    });

    return values;
  }

  /// Redefines this colour-pair to have foreground colour [f] and background colour [b].
  ///
  /// Calling [setValues] changes any characters that were displayed in the colour pair's old
  /// definition to the new definition and refreshes the screen.
  void setColorPairValues(ColorPair pair, Colors f, Colors b) => wrap(
      'setColorPairValues',
      () => defaultLibrary.init_pair(pair._value, f._value, b._value));

  /// Retrieves the component colours of this colour-pair.
  ///
  /// Returns a list containing the foreground color and background color in that order.
  List<Colors> getColorPairValues(ColorPair pair) {
    late List<Colors> values;

    wrap('getColorPairValues', () {
      final ptr = malloc<Short>(2);
      final ret = defaultLibrary.pair_content(
        pair._value,
        ptr.elementAt(0),
        ptr.elementAt(1),
      );
      values = [ptr[0], ptr[1]].map(Colors._fromValue).toList();
      malloc.free(ptr);

      return ret;
    });

    return values;
  }

  /// Creates a new window with [lines] and [cols] so that the origin is at [begin].
  ///
  /// If [lines] is `0`, it defaults to `lines - origin.y` - where `lines` is the global
  /// [dart_ncurses.lines] variable - if [cols] is zero, it defaults to `cols - begin_x` - where
  /// `cols` is the global [columns] variable.
  Window createWindow({required Position begin, int lines = 0, int cols = 0}) {
    final ptr = wrap('Window',
        () => defaultLibrary.newwin_sp(_native, lines, cols, begin.y, begin.x));
    return Window._fromPointer(ptr).._attachFinalizer();
  }

  /// Creates a specialised [Window] representing a pad with [lines] and [cols].
  ///
  /// A pad is like a window, except that it is not necessarily associated with a viewable part of
  /// the screen. Automatic refreshes of pads do not occur.
  Window createPad({required int lines, required int cols}) {
    final ptr = wrap(
        'Window.pad', () => defaultLibrary.newpad_sp(_native, lines, cols));
    return Window._fromPointer(ptr).._attachFinalizer();
  }

  @override
  int get hashCode => _native.address;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Screen && other._native == _native);
}

/// An NCurses window.
///
/// Functions that take a [Position] `at` parameter imply a call to [move] before performing the
/// operation that function specifies - these correspond to the native functions prefixed `mv`.
class Window implements Finalizable {
  final Pointer<bindings.WINDOW> _native;

  Window._fromPointer(this._native);

  /// Creates a new window with [lines] and [cols], positioned so that the origin is at [begin].
  ///
  /// [begin] is an absolute screen position, not a position relative to the window [origin].
  ///
  /// If any part of the new window is outside [origin], the function fails and the window is not
  /// created.
  factory Window.subWindow(
    Window origin, {
    required int lines,
    required int cols,
    required Position begin,
  }) {
    final ptr = wrap(
        'Window.subWindow',
        () => defaultLibrary.subwin(
            origin._native, lines, cols, begin.y, begin.x));
    return Window._fromPointer(ptr).._attachFinalizer();
  }

  /// The same as [Window.subWindow], except that [begin] is relative to the origin of the window
  /// [origin] rather than absolute screen positions.
  factory Window.derWindow(
    Window origin, {
    required int lines,
    required int cols,
    required Position begin,
  }) {
    final ptr = wrap(
        'Window.derWindow',
        () => defaultLibrary.derwin(
            origin._native, lines, cols, begin.y, begin.x));
    return Window._fromPointer(ptr).._attachFinalizer();
  }

  /// Creates a subwindow within a pad with [lines] and [cols].
  ///
  /// Unlike [Window.subWindow], which uses screen coordinates, the window is at position [begin] on
  /// the pad. The window is made in the middle of the window [origin], so that changes made to one
  /// window affect both windows.
  factory Window.subPad(
    Window origin, {
    required int lines,
    required int cols,
    required Position begin,
  }) {
    final ptr = wrap(
        'Window.subPad',
        () => defaultLibrary.subpad(
            origin._native, lines, cols, begin.y, begin.x));
    return Window._fromPointer(ptr).._attachFinalizer();
  }

  static final _finalizer =
      NativeFinalizer(defaultLibrary.addresses.delwin.cast());
  void _attachFinalizer() => _finalizer.attach(
        this,
        _native.cast(),
        detach: this,
        externalSize: sizeOf<bindings.WINDOW>(),
      );

  static Window get curscr => Window._fromPointer(defaultLibrary.curscr);
  static Window get stdscr => Window._fromPointer(defaultLibrary.stdscr);

  /// The attributes of window rendition of the current window.
  Attributes get attributes {
    late Attributes attributes;

    wrap('attributes', () {
      final ptr = malloc<bindings.attr_t>();
      final ret = defaultLibrary.wattr_get(_native, ptr, nullptr, nullptr);
      attributes = Attributes._fromValue(ptr.value);
      malloc.free(ptr);

      return ret;
    });

    return attributes;
  }

  set attributes(Attributes value) => setAttributes(value);

  /// The color pair of the window rendition of this window.
  ColorPair get colorPair {
    late ColorPair colorPair;

    wrap('colorPair', () {
      final ptr = malloc<Short>();
      final ret = defaultLibrary.wattr_get(_native, nullptr, ptr, nullptr);
      colorPair = ColorPair._fromValue(ptr.value);
      malloc.free(ptr);

      return ret;
    });

    return colorPair;
  }

  set colorPair(ColorPair value) => wrap('colorPair=',
      () => defaultLibrary.wcolor_set(_native, value._value, nullptr));

  /// This window's background character and rendition.
  Char get background {
    late Char result;

    wrap('background', () {
      final ptr = malloc<bindings.cchar_t>();
      final ret = defaultLibrary.wgetbkgrnd(_native, ptr);
      result = Char._fromPointer(ptr).._attachFinalizer();

      return ret;
    });

    return result;
  }

  /// Turn off the previous background attributes, logical OR the requested attributes into the
  /// window rendition, and set the background property of this window and then apply this setting
  /// to every character position in that window.
  ///
  /// - The rendition of every character on the screen is changed to the new window rendition.
  /// - Wherever the former background character appears, it is changed to the new background
  ///   character.
  set background(Char background) => wrap(
      'backrgound=', () => defaultLibrary.wbkgrnd(_native, background._native));

  /// Set whether the next refresh redraws the entire screen.
  ///
  /// Assigns the [value] to an internal flag in this window that governs clearing of the
  /// screen during a refresh. If, during a refresh operation on this window, the flag is `true`,
  /// then the implementation clears the screen, redraws it in its entirety, and sets the flag to
  /// `false` in this window.
  ///
  /// The initial state is unspecified.
  set clearOk(bool value) =>
      wrap('clearOk=', () => defaultLibrary.clearok(_native, value));

  /// Specifies whether the implementation may use the hardware insert-line, delete-line, and scroll
  /// features of terminals so equipped.
  ///
  /// If `true`, use of these features is enabled. If `false`, use of these features
  /// is disabled and lines are instead redrawn as required.
  ///
  /// The initial state is `false`.
  set allowInsertDeleteLine(bool value) => wrap(
      'allowInsertDeleteLine=', () => defaultLibrary.idlok(_native, value));

  /// Controls the cursor position after a refresh operation.
  ///
  /// If `true`, refresh operations on the specified window may leave the terminal's cursor
  /// at an arbitrary position. If  `false`, then at the end of any refresh operation, the
  /// terminal's cursor is positioned at the cursor position contained in this window.
  ///
  /// The initial state is `false`.
  set leaveCursor(bool value) =>
      wrap('leaveCursor=', () => defaultLibrary.leaveok(_native, value));

  /// Controls the use of scrolling.
  ///
  /// If `true`, then scrolling is enabled for this window, with the consequences discussed
  /// in [Truncation, Wrapping and Scrolling](https://pubs.opengroup.org/onlinepubs/7908799/xcurses/intov.html#tag_001_004_002_002).
  /// If `false`, scrolling is disabled for this window.
  ///
  /// The initial state is `false`.
  set allowScroll(bool value) =>
      wrap('allowScroll=', () => defaultLibrary.scrollok(_native, value));

  /// Specify whether the implementation may use hardware insert- and delete-character features in
  /// this window if the terminal is so equipped.
  ///
  /// If [value] is `true`, use of these features in this window is enabled. If [value] is `false`, use
  /// of these features in this window is disabled. The initial state is `true`.
  set allowInsertDeleteCharacters(bool value) =>
      defaultLibrary.idcok(_native, value);

  /// Specifies whether the screen is refreshed whenever this window is changed.
  ///
  /// If [value] is `true`, this window is implicitly refreshed on each such change. If [value] is
  /// `false`, this window is not implicitly refreshed.
  ///
  /// The initial state is `false`.
  set immediate(bool value) => defaultLibrary.immedok(_native, value);

  /// Whether this window is touched.
  bool get isTouched => defaultLibrary.is_wintouched(_native);

  /// Controls keypad translation.
  ///
  /// If `true`, keypad translation is turned on. If `false`, keypad translation is
  /// turned off. The initial state is `false`.
  ///
  /// This function affects the behaviour of any function that provides keyboard input.
  ///
  /// If the terminal in use requires a command to enable it to transmit distinctive codes when a
  /// function key is pressed, then after keypad translation is first enabled, the implementation
  /// transmits this command to the terminal before an affected input function tries to read any
  /// characters from that terminal.
  set keypad(bool value) =>
      wrap('keypad=', () => defaultLibrary.keypad(_native, value));

  /// Whether Delay Mode or No Delay Mode is in effect for the screen associated with this
  /// window.
  ///
  /// If `true`, this screen is set to No Delay Mode. If `false`, this screen is set
  /// to Delay Mode. The initial state is `false`.
  set noDelay(bool value) =>
      wrap('noDelay=', () => defaultLibrary.nodelay(_native, value));

  /// Whether Timeout Mode or No Timeout Mode is in effect for the screen associated with
  /// this window.
  ///
  /// If  `true`, this screen is set to No Timeout Mode. If  `false`, this screen is
  /// set to Timeout Mode.
  ///
  /// The initial state is `false`.
  set noTimeout(bool value) =>
      wrap('noTimeout=', () => defaultLibrary.notimeout(_native, value));

  /// Set blocking or non-blocking read for this window based on the value of [delay]:
  ///
  /// - delay < 0:
  ///   One or more blocking reads (indefinite waits for input) are used.
  /// - delay = 0:
  ///   One or more non-blocking reads are used. Any Curses input function will fail if every
  ///   character of the requested string is not immediately available.
  /// - delay > 0:
  ///   Any Curses input function blocks for delay milliseconds and fails if there is still no
  ///   input.
  set timeout(Duration delay) =>
      defaultLibrary.wtimeout(_native, delay.inMilliseconds);

  /// Determines whether all ancestors of this window are implicitly touched whenever there is a
  /// change in this window.
  ///
  /// If `true`, such implicit touching occurs. If `false`, such implicit touching
  /// does not occur. The initial state is `false`.
  set sync(bool value) =>
      wrap('sync=', () => defaultLibrary.syncok(_native, value));

  /// Add information to this window at the current or specified position, and then advance the
  /// cursor.
  ///
  /// This function performs wrapping. This function performs special-character processing.
  ///
  /// - If [ch] refers to a spacing character, then any previous character at that location is
  ///   removed, a new character specified by [ch] is placed at that location with rendition specified
  ///   by [ch]; then the cursor advances to the next spacing character on the screen.
  /// - If [ch] refers to a non-spacing character, all previous characters at that location are
  ///   preserved, the non-spacing characters of [ch] are added to the spacing complex character,
  ///   and the rendition specified by [ch] is ignored.
  void addChar(Char ch, {Position? at}) {
    if (at != null) {
      wrap('addChar',
          () => defaultLibrary.mvwadd_wch(_native, at.y, at.x, ch._native));
    } else {
      wrap('addChar', () => defaultLibrary.wadd_wch(_native, ch._native));
    }
  }

  /// Overlay the contents of this window, starting at the current position, with the contents of
  /// [chars].
  ///
  /// This function does not change the cursor position. This function does not perform
  /// special-character processing. This function does not perform wrapping.
  ///
  /// This function copies at most [count] items, but no more than will fit on the current line. If [count]
  /// is `-1` then the whole string is copied, to the maximum number that fit on the current line.
  void addChars(List<Char> chars, {int count = -1, Position? at}) =>
      wrap<int>('addChars', () {
        final nativeChars = chars.toNativeCharArray();
        final int ret;

        if (at != null) {
          ret = defaultLibrary.mvwadd_wchnstr(
              _native, at.y, at.x, nativeChars, count);
        } else {
          ret = defaultLibrary.wadd_wchnstr(_native, nativeChars, count);
        }

        malloc.free(nativeChars);

        return ret;
      });

  /// Write the characters of [str] on this window starting at the current position using the
  /// background rendition.
  ///
  /// This function advances the cursor position. This function performs special character
  /// processing. This function performs wrapping.
  ///
  /// This function writes at most [count] characters. If [count] is `-1`, then the entire
  /// will be added.
  void addString(String str, {int count = -1, Position? at}) =>
      wrap<int>('addString', () {
        final nativeChars = str.toNativeWChars();

        final int ret;
        if (at != null) {
          ret = defaultLibrary.mvwaddnwstr(
              _native, at.y, at.x, nativeChars, count);
        } else {
          ret = defaultLibrary.waddnwstr(_native, nativeChars, count);
        }

        malloc.free(nativeChars);

        return ret;
      });

  /// Turn off [attributes] in this window without affecting any others.
  void disableAttributes(Attributes attributes) => wrap('disableAttributes',
      () => defaultLibrary.wattr_off(_native, attributes._value, nullptr));

  /// Turn on [attributes] in this window without affecting any others.
  void enableAttributes(Attributes attributes) => wrap('enableAttributes',
      () => defaultLibrary.wattr_on(_native, attributes._value, nullptr));

  /// Set the attributes of this window rendition to [attributes].
  ///
  /// If [colorPair] is specified, also set the color pair.
  void setAttributes(Attributes attributes, [ColorPair? colorPair]) => wrap(
      'setAttributes',
      () => defaultLibrary.wattr_set(_native, attributes._value,
          colorPair?._value ?? this.colorPair._value, nullptr));

  /// Draw a border around the edges of this window.
  ///
  /// This function does not advance the cursor position. This function does not perform special
  /// character processing. This function does not perform wrapping.
  ///
  /// The arguments have the following uses in drawing the border:
  /// - [ls]: Starting-column side (Defaults to WACS_VLINE)
  /// - [rs]: Ending-column side (Defaults to WACS_VLINE)
  /// - [ts]: First-line side (Defaults to WACS_HLINE)
  /// - [bs]: Last-line side (Defaults to WACS_HLINE)
  /// - [tl]: Corner of the first line and the starting column (Defaults to WACS_ULCORNER)
  /// - [tr]: Corner of the first line and the ending column (Defaults to WACS_URCORNER)
  /// - [bl]: Corner of the last line and the starting column (Defaults to WACS_LLCORNER)
  /// - [br]: Corner of the last line and the ending column (Defaults to WACS_LRCORNER)
  void border({
    Char? ls,
    Char? rs,
    Char? ts,
    Char? bs,
    Char? tl,
    Char? tr,
    Char? bl,
    Char? br,
  }) =>
      wrap(
          'border',
          () => defaultLibrary.wborder_set(
                _native,
                ls?._native ?? nullptr,
                rs?._native ?? nullptr,
                ts?._native ?? nullptr,
                bs?._native ?? nullptr,
                tl?._native ?? nullptr,
                tr?._native ?? nullptr,
                bl?._native ?? nullptr,
                br?._native ?? nullptr,
              ));

  /// Change the renditions of the next [count] characters in this window (or of the remaining
  /// characters on the current or specified line, if [count] is `-1`), starting at the current cursor
  /// position.
  ///
  /// The attributes and colors are specified by [attributes] and [colorPair].
  ///
  /// This function does not update the cursor. This function does not perform wrapping.
  ///
  /// A value of [count] that is greater than the remaining characters on a line is not an error.
  void changeAttributes(Attributes attributes, ColorPair colorPair,
      {int count = -1, Position? at}) {
    if (at != null) {
      wrap(
          'changeAttributes',
          () => defaultLibrary.mvwchgat(_native, at.y, at.x, count,
              attributes._value, colorPair._value, nullptr));
    } else {
      wrap(
          'changeAttributes',
          () => defaultLibrary.wchgat(
              _native, count, attributes._value, colorPair._value, nullptr));
    }
  }

  /// Define a software scrolling region in this window.
  ///
  /// The [top] and [bottom] arguments are the line numbers of the first and last line defining the
  /// scrolling region. (Line 0 is the top line of the window.)
  ///
  /// If this option and [allowScroll] are enabled, an attempt to move off the last line of the margin
  /// causes all lines in the scrolling region to scroll one line in the direction of the first
  /// line. Only characters in the window are scrolled. If a software scrolling region is set and
  /// [allowScroll] is not enabled, an attempt to move off the last line of the margin does not
  /// reposition any lines in the scrolling region.
  void setScrollRegion(int top, int bottom) => wrap(
      'setScrollRegion', () => defaultLibrary.wsetscrreg(_native, top, bottom));

  /// Clear every position in this window.
  ///
  /// This function also achieves the same effect as calling [clearOk], so that the window is
  /// cleared completely on the next call to [refresh] for the window and is redrawn in its
  /// entirety.
  void clear() => wrap('clear', () => defaultLibrary.wclear(_native));

  /// Rlear every position in this window.
  void erase() => wrap('erase', () => defaultLibrary.werase(_native));

  /// Erase all lines following the cursor in this window, and erase the current line from the
  /// cursor to the end of the line, inclusive.
  ///
  /// This function does not update the cursor.
  void clearToBottom() =>
      wrap('clearToBottom', () => defaultLibrary.wclrtobot(_native));

  /// Erase the current line from the cursor to the end of the line, inclusive, in this window.
  ///
  /// This function does not update the cursor.
  void clearToEol() =>
      wrap('clearToEol', () => defaultLibrary.wclrtoeol(_native));

  /// Copys a region of this window into [other].
  ///
  /// A rectangle is specified in the destination window, [destinationStart] and [destinationEnd],
  /// and the upper-left-corner coordinates of the source window, [sourceStart].
  ///
  /// If overlay is `true`, then copying is non-destructive, as in overlay. If overlay is `false`,
  /// then copying is destructive, as in [overwrite].
  void copyRegionInto(
    Window other, {
    required Position destinationStart,
    required Position destinationEnd,
    required Position sourceStart,
    required bool overlay,
  }) =>
      wrap(
          'copyRegionInto',
          () => defaultLibrary.copywin(
                _native,
                other._native,
                sourceStart.y,
                sourceStart.x,
                destinationStart.y,
                destinationStart.x,
                destinationEnd.y,
                destinationEnd.x,
                overlay ? 1 : 0,
              ));

  /// Delete the character at the current position in this window.
  ///
  /// This function does not change the cursor position.
  void deleteChar({Position? at}) {
    if (at != null) {
      wrap('deleteChar', () => defaultLibrary.mvwdelch(_native, at.y, at.x));
    } else {
      wrap('deleteChar', () => defaultLibrary.wdelch(_native));
    }
  }

  /// Delete the line containing the cursor in this window and move all lines following the current
  /// line one line toward the cursor.
  ///
  /// The last line of this window is cleared. The cursor position does not change.
  void deleteLine() =>
      wrap('deleteLine', () => defaultLibrary.wdeleteln(_native));

  /// Refresh this window.
  ///
  /// This function position the terminal's cursor at the cursor position of the window, except that
  /// if the [leaveCursor] mode has been enabled, they may leave the cursor at an arbitrary position.
  void refresh() => wrap('refresh', () => defaultLibrary.wrefresh(_native));

  /// Determines which parts of the terminal may need updating.
  void outRefresh() =>
      wrap('outRefresh', () => defaultLibrary.wnoutrefresh(_native));

  /// Creates a duplicate of this window.
  Window duplicate() => Window._fromPointer(
      wrap('duplicate', () => defaultLibrary.dupwin(_native)))
    .._attachFinalizer();

  /// Equivalent to a call to [addChar] followed by a call to [refresh].
  void echoChar(Char char) =>
      wrap('echoChar', () => defaultLibrary.wecho_wchar(_native, char._native));

  /// Read a character from the terminal associated with this window.
  /// Processing of terminal input is subject to the general rules described in [Input Processing](https://pubs.opengroup.org/onlinepubs/7908799/xcurses/intov.html#tag_001_005).
  ///
  /// If echoing is enabled, then the character is echoed as though it were provided as an input
  /// argument to [addChar], except for the following characters:
  ///
  /// - `<backspace>`, `<left-arrow>` and the current erase character: The input is interpreted as
  ///   specified in and then the character at the resulting cursor position is deleted as though
  ///   were called, except that if the cursor was originally in the first column of the line, then
  ///   the user is alerted as though were called.
  /// - Function keys: The user is alerted as though were called. Information concerning the
  ///   function keys is not returned to the caller.
  ///
  /// If this window is not a pad, and it has been moved or modified since the last refresh
  /// operation, then it will be refreshed before another character is read.
  Key getKeyPress({Position? at}) {
    late Key result;

    wrap('getKeyPress', () {
      final ptr = malloc<bindings.wint_t>();

      final int ret;
      if (at != null) {
        ret = defaultLibrary.mvwget_wch(_native, at.y, at.x, ptr);
      } else {
        ret = defaultLibrary.wget_wch(_native, ptr);
      }

      if (ret == bindings.KEY_CODE_YES) {
        result = Key._fromValue(ptr.value, isFunctionKey: true);
      } else if (ret == bindings.OK) {
        result = Key._fromValue(ptr.value, isFunctionKey: false);
      }

      malloc.free(ptr);

      return ret;
    });

    return result;
  }

  /// As though a series of calls to [getChar] were made, until a newline, carriage return or
  /// end-of-file is received.
  ///
  /// The user's erase and kill characters are interpreted and affect the sequence of characters
  /// returned.
  ///
  /// This function reads at most [n] characters.
  String getString(int n, {Position? at}) {
    late String result;

    wrap('getString', () {
      final ptr = malloc<bindings.wint_t>(n);

      final int ret;
      if (at != null) {
        ret = defaultLibrary.mvwgetn_wstr(_native, at.y, at.x, ptr, n);
      } else {
        ret = defaultLibrary.wgetn_wstr(_native, ptr, n);
      }

      result = ptr.cast<WChar>().toDartString();
      malloc.free(ptr);

      return ret;
    });

    return result;
  }

  // TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/get_wch.html

  // TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/getwin.html

  /// Draw a line in this window starting at the current position, using [char]. The line is at most
  /// [n] positions long, or as many as fit into the window.
  ///
  /// This function does not advance the cursor position. This function does not perform special
  /// character processing. This function does not perform wrapping.
  ///
  /// This function draws a line proceeding toward the last column of the same line.
  void horizontalLine(Char char, int n, {Position? at}) {
    if (at != null) {
      wrap(
          'horizontalLine',
          () => defaultLibrary.mvwhline_set(
              _native, at.y, at.x, char._native, n));
    } else {
      wrap('horizontalLine',
          () => defaultLibrary.whline_set(_native, char._native, n));
    }
  }

  /// Draw a line in this window starting at the current position, using [char]. The line is at most
  /// [n] positions long, or as many as fit into the window.
  ///
  /// This function does not advance the cursor position. This function does not perform special
  /// character processing. This function does not perform wrapping.
  ///
  /// This function draws a line proceeding toward the last line of the window.
  void verticalLine(Char char, int n, {Position? at}) {
    if (at != null) {
      wrap(
          'verticalLine',
          () => defaultLibrary.mvwvline_set(
              _native, at.y, at.x, char._native, n));
    } else {
      wrap('verticalLine',
          () => defaultLibrary.wvline_set(_native, char._native, n));
    }
  }

  // TODO: https://pubs.opengroup.org/onlinepubs/7908799/xcurses/hline_set.html

  /// Return the character and rendition, at the current position in this window.
  Char inputChar({Position? at}) {
    late Char result;

    wrap('inputChar', () {
      final ptr = malloc<bindings.cchar_t>();

      final int ret;
      if (at != null) {
        ret = defaultLibrary.mvwin_wch(_native, at.y, at.x, ptr);
      } else {
        ret = defaultLibrary.win_wch(_native, ptr);
      }

      result = Char._fromPointer(ptr).._attachFinalizer();

      return ret;
    });

    return result;
  }

  /// Extract characters from this window, starting at the current or specified position and ending
  /// at the end of the line, and place them in the array pointed to by wchstr.
  ///
  /// At most [n] items are returned.
  List<Char> inputChars(int n, {Position? at}) {
    late List<Char> result;

    wrap('inputChars', () {
      final ptr = malloc<bindings.cchar_t>(n);

      final int ret;
      if (at != null) {
        ret = defaultLibrary.mvwin_wchnstr(_native, at.y, at.x, ptr, n);
      } else {
        ret = defaultLibrary.win_wchnstr(_native, ptr, n);
      }

      result = ptr.toDartCharList(n);
      malloc.free(ptr);

      return ret;
    });

    return result;
  }

  /// Get a string from this window, starting at the current position and ending at the end of the
  /// line.
  ///
  /// At most [n] bytes are read.
  String inputString(int n, {Position? at}) {
    late String result;

    wrap('inputString', () {
      final ptr = malloc<WChar>(n);

      final int ret;
      if (at != null) {
        ret = defaultLibrary.mvwinnwstr(_native, at.y, at.x, ptr, n);
      } else {
        ret = defaultLibrary.winnwstr(_native, ptr, n);
      }

      result = ptr.cast<WChar>().toDartString();
      malloc.free(ptr);

      return ret;
    });

    return result;
  }

  /// Insert the character and rendition from [char] into this window at the current position.
  ///
  /// This function does not perform wrapping. This function does not advance the cursor position.
  /// This function performs special-character processing, with the exception that if a newline is
  /// inserted into the last line of a window and scrolling is not enabled, the behavior is
  /// unspecified.
  void insertChar(Char char, {Position? at}) {
    if (at != null) {
      wrap('insertChar',
          () => defaultLibrary.mvwins_wch(_native, at.y, at.x, char._native));
    } else {
      wrap('insertChar', () => defaultLibrary.wins_wch(_native, char._native));
    }
  }

  /// Insert or delete lines from this window.
  ///
  /// - If [n] is positive, this function inserts [n] lines into this window before the current
  ///   line. The [n] last lines are no longer displayed.
  /// - If [n] is negative, this function deletes [n] lines from this window starting with the
  ///   current line, and move the remaining lines toward the cursor. The last [n] lines are
  ///   cleared.
  ///
  /// The current cursor position remains the same.
  void insertLines(int n) =>
      wrap('insertLines', () => defaultLibrary.winsdelln(_native, n));

  /// Insert a blank line before the current line in this window.
  ///
  /// The bottom line is no longer displayed.
  ///
  /// The cursor position does not change.
  void insertLine() =>
      wrap('insertLine', () => defaultLibrary.winsertln(_native));

  /// Insert a string (as many characters as will fit on the line) before the current position in
  /// this window.
  ///
  /// This function does not advance the cursor position. This function performs special-character
  /// processing. This function performs wrapping.
  ///
  /// This function inserts at most [count] characters. If [count] is less than `1`, the entire
  /// string is inserted.
  void insertString(String s, {int count = -1, Position? at}) =>
      wrap<int>('insertString', () {
        final ptr = s.toNativeWChars();

        final int ret;
        if (at != null) {
          ret = defaultLibrary.mvwins_nwstr(
              _native, at.y, at.x, ptr.cast(), count);
        } else {
          ret = defaultLibrary.wins_nwstr(_native, ptr.cast(), count);
        }

        malloc.free(ptr);

        return ret;
      });

  /// Whether the [line] of this window is touched.
  bool isLineTouched(int line) => defaultLibrary.is_linetouched(_native, line);

  /// Touches this window (that is, marks it as having changed more recently than the last refresh
  /// operation).
  void touch() => wrap('touch', () => defaultLibrary.touchwin(_native));

  /// Marks all lines in this window as unchanged since the last refresh operation.
  void untouch() => wrap('untouch', () => defaultLibrary.untouchwin(_native));

  /// If [changed] is `true`, touches [count] lines in this window, starting at line [start]. If
  /// [changed] is `false`, marks such lines as unchanged since the last refresh operation.
  // TODO: Better name
  void touchLines(int start, int count, bool changed) => wrap('touchLines',
      () => defaultLibrary.wtouchln(_native, start, count, changed ? 1 : 0));

  /// Move the cursor associated with this window to [position] relative to the window's origin.
  ///
  /// This function does not move the terminal's cursor until the next refresh operation.
  void move(Position position) =>
      wrap('move', () => defaultLibrary.wmove(_native, position.y, position.x));

  /// Specifies a mapping of characters.
  ///
  /// This function identifies a mapped area of the parent of this window, whose size is the same as
  /// the size of this window and whose origin is at [parentPosition] of the parent window.
  ///
  /// During any refresh of this window, the characters displayed in this window's display area of
  /// the terminal are taken from the mapped area.
  ///
  /// Any references to characters in the specified window obtain or modify characters in the mapped
  /// area.
  ///
  /// That is, [copyFrom] defines a coordinate transformation from each position in the mapped area
  /// to a corresponding position (same y, x offset from the origin) in this window.
  void copyFrom(Position parentPosition) => wrap(
      'copyFrom',
      () =>
          defaultLibrary.mvderwin(_native, parentPosition.y, parentPosition.x));

  /// Moves this window so that its origin is at [position].
  ///
  /// If the move would cause any portion of this window to extend past any edge of the screen, this
  /// function fails and the window is not moved.
  void moveWindow(Position position) => wrap('moveWindow',
      () => defaultLibrary.mvwin(_native, position.y, position.x));

  /// Analogous to [refresh] except that this function relates to pads instead of windows.
  ///
  /// The additional arguments indicate what part of the pad and screen are involved. The [inPad]
  /// argument specifies the origin of the rectangle to be displayed in the pad. The [start] and
  /// [end] arguments specify the edges of the rectangle to be displayed on the screen.
  ///
  /// The lower right-hand corner of the rectangle to be displayed in the pad is calculated from the
  /// screen coordinates, since the rectangles must be the same size. Both rectangles must be
  /// entirely contained within their respective structures.
  ///
  /// Negative values of [inPad] and [start] are treated as if they were zero.
  void refreshPad({
    required Position inPad,
    required Position start,
    required Position end,
  }) =>
      wrap(
          'refreshPad',
          () => defaultLibrary.prefresh(
              _native, inPad.y, inPad.x, start.y, start.x, end.y, end.x));

  /// Analogous to [outRefresh] except that this function relates to pads instead of windows.
  ///
  /// The additional arguments indicate what part of the pad and screen are involved. The [inPad]
  /// argument specifies the origin of the rectangle to be displayed in the pad. The [start] and
  /// [end] arguments specify the edges of the rectangle to be displayed on the screen.
  ///
  /// The lower right-hand corner of the rectangle to be displayed in the pad is calculated from the
  /// screen coordinates, since the rectangles must be the same size. Both rectangles must be
  /// entirely contained within their respective structures.
  ///
  /// Negative values of [inPad] and [start] are treated as if they were zero.
  void outRefreshPad({
    required Position inPad,
    required Position start,
    required Position end,
  }) =>
      wrap(
          'outRefreshPad',
          () => defaultLibrary.pnoutrefresh(
              _native, inPad.y, inPad.x, start.y, start.x, end.y, end.x));

  /// Overlay [source] on top of this window.
  ///
  /// The [source] argument and this window need not be the same size; only text where the two
  /// windows overlap is copied.
  ///
  /// The [overwrite] function copies characters as though a sequence of win_wch() and wadd_wch()
  /// were performed with the destination window's attributes and background attributes cleared.
  ///
  /// The [overlay] function does the same thing, except that, whenever a character to be copied is
  /// the background character of the source window, [overlay] does not copy the character but
  /// merely moves the destination cursor the width of the source background character.
  ///
  /// If any portion of the overlaying window border is not the first column of a multi-column
  /// character then all the column positions will be replaced with the background character and
  /// rendition before the overlay is done. If the default background character is a multi-column
  /// character when this occurs, then these functions fail.
  // TODO: Improve docs
  void overlay(Window source) =>
      wrap('overlay', () => defaultLibrary.overlay(source._native, _native));

  /// Overlay [source] on top of this window.
  ///
  /// The [source] argument and this window need not be the same size; only text where the two
  /// windows overlap is copied.
  ///
  /// The [overwrite] function copies characters as though a sequence of [inputChar] and [addChar]
  /// were performed with the destination window's attributes and background attributes cleared.
  ///
  /// The [overlay] function does the same thing, except that, whenever a character to be copied is
  /// the background character of the source window, [overlay] does not copy the character but
  /// merely moves the destination cursor the width of the source background character.
  ///
  /// If any portion of the overlaying window border is not the first column of a multi-column
  /// character then all the column positions will be replaced with the background character and
  /// rendition before the overlay is done. If the default background character is a multi-column
  /// character when this occurs, then these functions fail.
  void overwrite(Window source) => wrap(
      'overwrite', () => defaultLibrary.overwrite(source._native, _native));

  /// Output one character to a pad and immediately refresh the pad.
  ///
  /// This is equivalent to a call to [addChar] followed by a call to [refreshPad]. The last
  /// location of the pad on the screen is reused for the arguments to [refreshPad].
  void padEchoChar(Char char) => wrap(
      'padEchoChar', () => defaultLibrary.pecho_wchar(_native, char._native));

  /// Inform the implementation that some or all of the information physically displayed for this
  /// window may have been corrupted.
  ///
  /// This function marks the entire window.
  ///
  /// This function prevents the next refresh operation on this window from performing any
  /// optimisation based on assumptions about what is physically displayed there.
  void redraw() => wrap('redraw', () => defaultLibrary.redrawwin(_native));

  /// Inform the implementation that some or all of the information physically displayed for this
  /// window may have been corrupted.
  ///
  /// This function marks only [count] lines starting at line number [start].
  ///
  /// This function prevents the next refresh operation on this window from performing
  /// optimisation based on assumptions about what is physically displayed there.
  void redrawLines(int start, int count) => wrap(
      'redrawLines', () => defaultLibrary.wredrawln(_native, start, count));

  /// Scroll this window.
  ///
  /// If [n] is positive, this window scrolls [n] lines toward the first line. Otherwise, the window
  /// scrolls -[n] lines toward the last line.
  ///
  /// This function does not change the cursor position. If scrolling is disabled for this window,
  /// this function has no effect. The interaction of these functions with [setScrollRegion] is
  /// currently unspecified.
  void scroll([int n = 1]) =>
      wrap('scroll', () => defaultLibrary.wscrl(_native, n));

  /// Turn off all attributes of this window.
  void standEnd() => wrap('standEnd', () => defaultLibrary.wstandend(_native));

  /// Turn on the standout attribute of this window.
  void standOut() => wrap('standOut', () => defaultLibrary.wstandout(_native));

  /// Updates the current cursor position of the ancestors of this window to reflect the current
  /// cursor position of this window.
  void cursorSyncUp() => defaultLibrary.wcursyncup(_native);

  /// Touches this window if any ancestor window has been touched.
  void syncDown() => defaultLibrary.wsyncdown(_native);

  /// Unconditionally touches all ancestors of this window.
  void syncUp() => defaultLibrary.wsyncup(_native);
}

// =======================================
//              Extensions
// =======================================

// These extensions provide access to the (normally private) members allowing access to the native
// pointers and constructors.

extension NativeAttributes on Attributes {
  int get value => _value;

  static Attributes fromValue(int value) => Attributes._fromValue(value);
}

extension NativeColors on Colors {
  int get value => _value;

  static Colors fromValue(int value) => Colors._fromValue(value);
}

extension NativeCursorVisibility on CursorVisibility {
  int get value => _value;

  static CursorVisibility fromValue(int value) =>
      CursorVisibility._fromValue(value);
}

extension NativeChar on Char {
  Pointer<bindings.cchar_t> get native => _native;

  static Char fromPointer(Pointer<bindings.cchar_t> ptr) =>
      Char._fromPointer(ptr);

  static NativeFinalizer get finalizer => Char._finalizer;

  void attachFinalizer() => _attachFinalizer();
}

extension NativeColorPair on ColorPair {
  int get value => _value;

  static ColorPair fromValue(int value) => ColorPair._fromValue(value);
}

extension NativeScreen on Screen {
  Pointer<bindings.SCREEN> get native => _native;

  static Screen fromPointer(Pointer<bindings.SCREEN> ptr, Window stdscr) =>
      Screen._fromPointer(ptr, stdscr);

  static NativeFinalizer get finalizer => Screen._finalizer;
}

extension NativeWindow on Window {
  Pointer<bindings.WINDOW> get native => _native;

  static Window fromPointer(Pointer<bindings.WINDOW> ptr) =>
      Window._fromPointer(ptr);

  static NativeFinalizer get finalizer => Window._finalizer;

  void attachFinalizer() => _attachFinalizer();
}
