import 'package:flutter/widgets.dart';

import './mouse_state_builder.dart';
import './window_caption.dart';
import '../icons/icons.dart';
import '../app_window.dart';

typedef WindowButtonIconBuilder = Widget Function(
    WindowButtonContext buttonContext);
typedef WindowButtonBuilder = Widget Function(
    WindowButtonContext buttonContext, Widget icon);

class WindowButtonContext {
  BuildContext context;
  MouseState mouseState;
  Color backgroundColor;
  Color iconColor;
}

class WindowButtonColors {
  final Color normal;
  final Color mouseOver;
  final Color mouseDown;
  final Color iconNormal;
  final Color iconMouseOver;
  final Color iconMouseDown;
  const WindowButtonColors(
      {this.normal,
      this.mouseOver,
      this.mouseDown,
      @required this.iconNormal,
      this.iconMouseOver,
      this.iconMouseDown});
}

const _defaultButtonColors = WindowButtonColors(
    iconNormal: Color(0xFF805306),
    mouseOver: Color(0xFF404040),
    mouseDown: Color(0xFF202020),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFF0F0F0));

class WindowButton extends StatelessWidget {
  final WindowButtonBuilder builder;
  final WindowButtonIconBuilder iconBuilder;
  final WindowButtonColors colors;
  final EdgeInsets padding;
  final VoidCallback onPressed;

  WindowButton(
      {Key key,
      this.colors,
      this.builder,
      @required this.iconBuilder,
      this.padding,
      this.onPressed})
      : super(key: key);

  Color getBackgroundColor(MouseState mouseState) {
    var colors = this.colors ?? _defaultButtonColors;
    if ((mouseState.isMouseDown) && (colors.mouseDown != null))
      return colors.mouseDown;
    if ((mouseState.isMouseOver) && (colors.mouseOver != null))
      return colors.mouseOver;
    return colors.normal;
  }

  Color getIconColor(MouseState mouseState) {
    var colors = this.colors ?? _defaultButtonColors;
    if ((mouseState.isMouseDown) && (colors.iconMouseDown != null))
      return colors.iconMouseDown;
    if ((mouseState.isMouseOver) && (colors.iconMouseOver != null))
      return colors.iconMouseOver;
    return colors.iconNormal;
  }

  @override
  Widget build(BuildContext context) {
    var buttonSize = getTitleBarButtonSize();
    return MouseStateBuilder(
      builder: (context, mouseState) {
        WindowButtonContext buttonContext = WindowButtonContext()
          ..context = context
          ..backgroundColor = getBackgroundColor(mouseState)
          ..iconColor = getIconColor(mouseState);

        var icon = (this.iconBuilder != null)
            ? this.iconBuilder(buttonContext)
            : Container();

        var padding = this.padding ?? EdgeInsets.all(9.0);
        var iconWithPadding = Padding(padding: padding, child: icon);
        var button = (this.builder != null)
            ? this.builder(buttonContext, icon)
            : Container(
                color: buttonContext.backgroundColor, child: iconWithPadding);

        return SizedBox(
            width: buttonSize.width, height: buttonSize.height, child: button);
      },
      onPressed: () {
        if (this.onPressed != null) this.onPressed();
      },
    );
  }
}

class MinimizeWindowButton extends WindowButton {
  MinimizeWindowButton(
      {Key key, WindowButtonColors colors, VoidCallback onPressed})
      : super(
            key: key,
            colors: colors,
            iconBuilder: (buttonContext) =>
                MinimizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.minimize());
}

class MaximizeWindowButton extends WindowButton {
  MaximizeWindowButton(
      {Key key, WindowButtonColors colors, VoidCallback onPressed})
      : super(
            key: key,
            colors: colors,
            iconBuilder: (buttonContext) =>
                MaximizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.maximizeOrRestore());
}

const _defaultCloseButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: Color(0xFF805306),
    iconMouseOver: Color(0xFFFFFFFF));

class CloseWindowButton extends WindowButton {
  CloseWindowButton(
      {Key key, WindowButtonColors colors, VoidCallback onPressed})
      : super(
            key: key,
            colors: colors ?? _defaultCloseButtonColors,
            iconBuilder: (buttonContext) =>
                CloseIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.close());
}
