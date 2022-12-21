import 'dart:ffi' hide Char;

import 'package:ffi/ffi.dart';
import 'package:ncurses/bindings.dart' as bindings;
import 'package:ncurses/src/wrapper.dart';

class NCursesException implements Exception {
  final String functionName;

  const NCursesException(this.functionName);

  @override
  String toString() => 'Native call returned error in $functionName';
}

T wrap<T extends Object>(String functionName, T Function() cb) {
  final result = cb();

  if (result is int) {
    if (result == bindings.ERR) {
      throw NCursesException(functionName);
    }
  } else if (result is Pointer) {
    if (result == nullptr) {
      throw NCursesException(functionName);
    }
  } else {
    throw ArgumentError('Type argument T must be int or pointer');
  }

  return result;
}

extension ToNativeCharArray on List<Char> {
  static final Char _nullCharacter = Char(
    String.fromCharCode(0),
    colorPair: NativeColorPair.fromValue(0),
    attributes: NativeAttributes.fromValue(0),
  );

  Pointer<bindings.cchar_t> toNativeCharArray() {
    final ptr = malloc<bindings.cchar_t>(length + 1); // +1 for null terminator

    for (int i = 0; i < length; i++) {
      ptr[i] = this[i].native.ref;
    }
    ptr[length] = _nullCharacter.native.ref;

    return ptr;
  }
}

extension ToDartCharList on Pointer<bindings.cchar_t> {
  List<Char> toDartCharList(int n) {
    final result = <Char>[];

    for (int i = 0; i < n; i++) {
      if (elementAt(i).cast<Int>().value == 0) {
        break;
      }

      final ptr = malloc<bindings.cchar_t>();
      // Copy data so we can free this pointer
      ptr.ref = this[i];
      final char = NativeChar.fromPointer(ptr)..attachFinalizer();

      // TODO: Better way of handling end of input?
      if (char.value.isEmpty) {
        break;
      }

      result.add(char);
    }

    return result;
  }
}

extension WCharPointer on Pointer<WChar> {
  String toDartString({int? length}) {
    final buffer = StringBuffer();

    if (length != null) {
      for (int i = 0; i < length; i++) {
        buffer.writeCharCode(this[i]);
      }
    } else {
      int i = 0;
      int value = this[0];

      if (value == 0) {
        return '';
      }

      do {
        buffer.writeCharCode(value);
        value = this[++i];
      } while (value != 0);
    }

    return buffer.toString();
  }
}

extension WCharStringPointer on String {
  Pointer<WChar> toNativeWChars({Allocator allocator = malloc}) {
    final units = codeUnits;
    final result = allocator<WChar>(units.length + 1);
    for (int i = 0; i < units.length; i++) {
      result[i] = units[i];
    }
    result[units.length] = 0;
    return result;
  }
}
