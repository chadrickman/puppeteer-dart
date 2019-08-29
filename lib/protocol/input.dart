import 'dart:async';
import 'package:meta/meta.dart' show required;
import '../src/connection.dart';

class InputApi {
  final Client _client;

  InputApi(this._client);

  /// Dispatches a key event to the page.
  /// [type] Type of the key event.
  /// [modifiers] Bit field representing pressed modifier keys. Alt=1, Ctrl=2, Meta/Command=4, Shift=8
  /// (default: 0).
  /// [timestamp] Time at which the event occurred.
  /// [text] Text as generated by processing a virtual key code with a keyboard layout. Not needed for
  /// for `keyUp` and `rawKeyDown` events (default: "")
  /// [unmodifiedText] Text that would have been generated by the keyboard if no modifiers were pressed (except for
  /// shift). Useful for shortcut (accelerator) key handling (default: "").
  /// [keyIdentifier] Unique key identifier (e.g., 'U+0041') (default: "").
  /// [code] Unique DOM defined string value for each physical key (e.g., 'KeyA') (default: "").
  /// [key] Unique DOM defined string value describing the meaning of the key in the context of active
  /// modifiers, keyboard layout, etc (e.g., 'AltGr') (default: "").
  /// [windowsVirtualKeyCode] Windows virtual key code (default: 0).
  /// [nativeVirtualKeyCode] Native virtual key code (default: 0).
  /// [autoRepeat] Whether the event was generated from auto repeat (default: false).
  /// [isKeypad] Whether the event was generated from the keypad (default: false).
  /// [isSystemKey] Whether the event was a system key event (default: false).
  /// [location] Whether the event was from the left or right side of the keyboard. 1=Left, 2=Right (default:
  /// 0).
  Future<void> dispatchKeyEvent(
      @Enum(['keyDown', 'keyUp', 'rawKeyDown', 'char']) String type,
      {int modifiers,
      TimeSinceEpoch timestamp,
      String text,
      String unmodifiedText,
      String keyIdentifier,
      String code,
      String key,
      int windowsVirtualKeyCode,
      int nativeVirtualKeyCode,
      bool autoRepeat,
      bool isKeypad,
      bool isSystemKey,
      int location}) async {
    assert(const ['keyDown', 'keyUp', 'rawKeyDown', 'char'].contains(type));
    await _client.send('Input.dispatchKeyEvent', {
      'type': type,
      if (modifiers != null) 'modifiers': modifiers,
      if (timestamp != null) 'timestamp': timestamp,
      if (text != null) 'text': text,
      if (unmodifiedText != null) 'unmodifiedText': unmodifiedText,
      if (keyIdentifier != null) 'keyIdentifier': keyIdentifier,
      if (code != null) 'code': code,
      if (key != null) 'key': key,
      if (windowsVirtualKeyCode != null)
        'windowsVirtualKeyCode': windowsVirtualKeyCode,
      if (nativeVirtualKeyCode != null)
        'nativeVirtualKeyCode': nativeVirtualKeyCode,
      if (autoRepeat != null) 'autoRepeat': autoRepeat,
      if (isKeypad != null) 'isKeypad': isKeypad,
      if (isSystemKey != null) 'isSystemKey': isSystemKey,
      if (location != null) 'location': location,
    });
  }

  /// This method emulates inserting text that doesn't come from a key press,
  /// for example an emoji keyboard or an IME.
  /// [text] The text to insert.
  Future<void> insertText(String text) async {
    await _client.send('Input.insertText', {
      'text': text,
    });
  }

  /// Dispatches a mouse event to the page.
  /// [type] Type of the mouse event.
  /// [x] X coordinate of the event relative to the main frame's viewport in CSS pixels.
  /// [y] Y coordinate of the event relative to the main frame's viewport in CSS pixels. 0 refers to
  /// the top of the viewport and Y increases as it proceeds towards the bottom of the viewport.
  /// [modifiers] Bit field representing pressed modifier keys. Alt=1, Ctrl=2, Meta/Command=4, Shift=8
  /// (default: 0).
  /// [timestamp] Time at which the event occurred.
  /// [button] Mouse button (default: "none").
  /// [buttons] A number indicating which buttons are pressed on the mouse when a mouse event is triggered.
  /// Left=1, Right=2, Middle=4, Back=8, Forward=16, None=0.
  /// [clickCount] Number of times the mouse button was clicked (default: 0).
  /// [deltaX] X delta in CSS pixels for mouse wheel event (default: 0).
  /// [deltaY] Y delta in CSS pixels for mouse wheel event (default: 0).
  /// [pointerType] Pointer type (default: "mouse").
  Future<void> dispatchMouseEvent(
      @Enum(['mousePressed', 'mouseReleased', 'mouseMoved', 'mouseWheel'])
          String type,
      num x,
      num y,
      {int modifiers,
      TimeSinceEpoch timestamp,
      @Enum(['none', 'left', 'middle', 'right', 'back', 'forward'])
          String button,
      int buttons,
      int clickCount,
      num deltaX,
      num deltaY,
      @Enum(['mouse', 'pen'])
          String pointerType}) async {
    assert(const ['mousePressed', 'mouseReleased', 'mouseMoved', 'mouseWheel']
        .contains(type));
    assert(button == null ||
        const ['none', 'left', 'middle', 'right', 'back', 'forward']
            .contains(button));
    assert(pointerType == null || const ['mouse', 'pen'].contains(pointerType));
    await _client.send('Input.dispatchMouseEvent', {
      'type': type,
      'x': x,
      'y': y,
      if (modifiers != null) 'modifiers': modifiers,
      if (timestamp != null) 'timestamp': timestamp,
      if (button != null) 'button': button,
      if (buttons != null) 'buttons': buttons,
      if (clickCount != null) 'clickCount': clickCount,
      if (deltaX != null) 'deltaX': deltaX,
      if (deltaY != null) 'deltaY': deltaY,
      if (pointerType != null) 'pointerType': pointerType,
    });
  }

  /// Dispatches a touch event to the page.
  /// [type] Type of the touch event. TouchEnd and TouchCancel must not contain any touch points, while
  /// TouchStart and TouchMove must contains at least one.
  /// [touchPoints] Active touch points on the touch device. One event per any changed point (compared to
  /// previous touch event in a sequence) is generated, emulating pressing/moving/releasing points
  /// one by one.
  /// [modifiers] Bit field representing pressed modifier keys. Alt=1, Ctrl=2, Meta/Command=4, Shift=8
  /// (default: 0).
  /// [timestamp] Time at which the event occurred.
  Future<void> dispatchTouchEvent(
      @Enum(['touchStart', 'touchEnd', 'touchMove', 'touchCancel']) String type,
      List<TouchPoint> touchPoints,
      {int modifiers,
      TimeSinceEpoch timestamp}) async {
    assert(const ['touchStart', 'touchEnd', 'touchMove', 'touchCancel']
        .contains(type));
    await _client.send('Input.dispatchTouchEvent', {
      'type': type,
      'touchPoints': touchPoints.map((e) => e).toList(),
      if (modifiers != null) 'modifiers': modifiers,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  /// Emulates touch event from the mouse event parameters.
  /// [type] Type of the mouse event.
  /// [x] X coordinate of the mouse pointer in DIP.
  /// [y] Y coordinate of the mouse pointer in DIP.
  /// [button] Mouse button.
  /// [timestamp] Time at which the event occurred (default: current time).
  /// [deltaX] X delta in DIP for mouse wheel event (default: 0).
  /// [deltaY] Y delta in DIP for mouse wheel event (default: 0).
  /// [modifiers] Bit field representing pressed modifier keys. Alt=1, Ctrl=2, Meta/Command=4, Shift=8
  /// (default: 0).
  /// [clickCount] Number of times the mouse button was clicked (default: 0).
  Future<void> emulateTouchFromMouseEvent(
      @Enum(['mousePressed', 'mouseReleased', 'mouseMoved', 'mouseWheel'])
          String type,
      int x,
      int y,
      @Enum(['none', 'left', 'middle', 'right'])
          String button,
      {TimeSinceEpoch timestamp,
      num deltaX,
      num deltaY,
      int modifiers,
      int clickCount}) async {
    assert(const ['mousePressed', 'mouseReleased', 'mouseMoved', 'mouseWheel']
        .contains(type));
    assert(const ['none', 'left', 'middle', 'right'].contains(button));
    await _client.send('Input.emulateTouchFromMouseEvent', {
      'type': type,
      'x': x,
      'y': y,
      'button': button,
      if (timestamp != null) 'timestamp': timestamp,
      if (deltaX != null) 'deltaX': deltaX,
      if (deltaY != null) 'deltaY': deltaY,
      if (modifiers != null) 'modifiers': modifiers,
      if (clickCount != null) 'clickCount': clickCount,
    });
  }

  /// Ignores input events (useful while auditing page).
  /// [ignore] Ignores input events processing when set to true.
  Future<void> setIgnoreInputEvents(bool ignore) async {
    await _client.send('Input.setIgnoreInputEvents', {
      'ignore': ignore,
    });
  }

  /// Synthesizes a pinch gesture over a time period by issuing appropriate touch events.
  /// [x] X coordinate of the start of the gesture in CSS pixels.
  /// [y] Y coordinate of the start of the gesture in CSS pixels.
  /// [scaleFactor] Relative scale factor after zooming (>1.0 zooms in, <1.0 zooms out).
  /// [relativeSpeed] Relative pointer speed in pixels per second (default: 800).
  /// [gestureSourceType] Which type of input events to be generated (default: 'default', which queries the platform
  /// for the preferred input type).
  Future<void> synthesizePinchGesture(num x, num y, num scaleFactor,
      {int relativeSpeed, GestureSourceType gestureSourceType}) async {
    await _client.send('Input.synthesizePinchGesture', {
      'x': x,
      'y': y,
      'scaleFactor': scaleFactor,
      if (relativeSpeed != null) 'relativeSpeed': relativeSpeed,
      if (gestureSourceType != null) 'gestureSourceType': gestureSourceType,
    });
  }

  /// Synthesizes a scroll gesture over a time period by issuing appropriate touch events.
  /// [x] X coordinate of the start of the gesture in CSS pixels.
  /// [y] Y coordinate of the start of the gesture in CSS pixels.
  /// [xDistance] The distance to scroll along the X axis (positive to scroll left).
  /// [yDistance] The distance to scroll along the Y axis (positive to scroll up).
  /// [xOverscroll] The number of additional pixels to scroll back along the X axis, in addition to the given
  /// distance.
  /// [yOverscroll] The number of additional pixels to scroll back along the Y axis, in addition to the given
  /// distance.
  /// [preventFling] Prevent fling (default: true).
  /// [speed] Swipe speed in pixels per second (default: 800).
  /// [gestureSourceType] Which type of input events to be generated (default: 'default', which queries the platform
  /// for the preferred input type).
  /// [repeatCount] The number of times to repeat the gesture (default: 0).
  /// [repeatDelayMs] The number of milliseconds delay between each repeat. (default: 250).
  /// [interactionMarkerName] The name of the interaction markers to generate, if not empty (default: "").
  Future<void> synthesizeScrollGesture(num x, num y,
      {num xDistance,
      num yDistance,
      num xOverscroll,
      num yOverscroll,
      bool preventFling,
      int speed,
      GestureSourceType gestureSourceType,
      int repeatCount,
      int repeatDelayMs,
      String interactionMarkerName}) async {
    await _client.send('Input.synthesizeScrollGesture', {
      'x': x,
      'y': y,
      if (xDistance != null) 'xDistance': xDistance,
      if (yDistance != null) 'yDistance': yDistance,
      if (xOverscroll != null) 'xOverscroll': xOverscroll,
      if (yOverscroll != null) 'yOverscroll': yOverscroll,
      if (preventFling != null) 'preventFling': preventFling,
      if (speed != null) 'speed': speed,
      if (gestureSourceType != null) 'gestureSourceType': gestureSourceType,
      if (repeatCount != null) 'repeatCount': repeatCount,
      if (repeatDelayMs != null) 'repeatDelayMs': repeatDelayMs,
      if (interactionMarkerName != null)
        'interactionMarkerName': interactionMarkerName,
    });
  }

  /// Synthesizes a tap gesture over a time period by issuing appropriate touch events.
  /// [x] X coordinate of the start of the gesture in CSS pixels.
  /// [y] Y coordinate of the start of the gesture in CSS pixels.
  /// [duration] Duration between touchdown and touchup events in ms (default: 50).
  /// [tapCount] Number of times to perform the tap (e.g. 2 for double tap, default: 1).
  /// [gestureSourceType] Which type of input events to be generated (default: 'default', which queries the platform
  /// for the preferred input type).
  Future<void> synthesizeTapGesture(num x, num y,
      {int duration, int tapCount, GestureSourceType gestureSourceType}) async {
    await _client.send('Input.synthesizeTapGesture', {
      'x': x,
      'y': y,
      if (duration != null) 'duration': duration,
      if (tapCount != null) 'tapCount': tapCount,
      if (gestureSourceType != null) 'gestureSourceType': gestureSourceType,
    });
  }
}

class TouchPoint {
  /// X coordinate of the event relative to the main frame's viewport in CSS pixels.
  final num x;

  /// Y coordinate of the event relative to the main frame's viewport in CSS pixels. 0 refers to
  /// the top of the viewport and Y increases as it proceeds towards the bottom of the viewport.
  final num y;

  /// X radius of the touch area (default: 1.0).
  final num radiusX;

  /// Y radius of the touch area (default: 1.0).
  final num radiusY;

  /// Rotation angle (default: 0.0).
  final num rotationAngle;

  /// Force (default: 1.0).
  final num force;

  /// Identifier used to track touch sources between events, must be unique within an event.
  final num id;

  TouchPoint(
      {@required this.x,
      @required this.y,
      this.radiusX,
      this.radiusY,
      this.rotationAngle,
      this.force,
      this.id});

  factory TouchPoint.fromJson(Map<String, dynamic> json) {
    return TouchPoint(
      x: json['x'],
      y: json['y'],
      radiusX: json.containsKey('radiusX') ? json['radiusX'] : null,
      radiusY: json.containsKey('radiusY') ? json['radiusY'] : null,
      rotationAngle:
          json.containsKey('rotationAngle') ? json['rotationAngle'] : null,
      force: json.containsKey('force') ? json['force'] : null,
      id: json.containsKey('id') ? json['id'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      if (radiusX != null) 'radiusX': radiusX,
      if (radiusY != null) 'radiusY': radiusY,
      if (rotationAngle != null) 'rotationAngle': rotationAngle,
      if (force != null) 'force': force,
      if (id != null) 'id': id,
    };
  }
}

class GestureSourceType {
  static const default$ = GestureSourceType._('default');
  static const touch = GestureSourceType._('touch');
  static const mouse = GestureSourceType._('mouse');
  static const values = {
    'default': default$,
    'touch': touch,
    'mouse': mouse,
  };

  final String value;

  const GestureSourceType._(this.value);

  factory GestureSourceType.fromJson(String value) => values[value];

  String toJson() => value;

  @override
  bool operator ==(other) =>
      (other is GestureSourceType && other.value == value) || value == other;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

/// UTC time in seconds, counted from January 1, 1970.
class TimeSinceEpoch {
  final num value;

  TimeSinceEpoch(this.value);

  factory TimeSinceEpoch.fromJson(num value) => TimeSinceEpoch(value);

  num toJson() => value;

  @override
  bool operator ==(other) =>
      (other is TimeSinceEpoch && other.value == value) || value == other;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
