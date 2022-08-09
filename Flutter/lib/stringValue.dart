import 'package:flutter/material.dart';

String theLocate ="en";
double  textSizeValue =24;
String systemText(String text) {
  return Strings().getText(text);
}

TextStyle getTextSetting(double size) {
  return Strings().getTextStyle();
}

class Strings {
  String getText(String text) {
    switch (theLocate) {
    // eng ==================================================================================================================
      case 'en':
        switch (text) {
          case 'title':
            return 'Welcome to Health Monitor System';
            break;
          case 'Login':
            return 'Login in database';
            break;
          case 'apptitle':
            return 'Health Monitor App';
            break;
          case 'bpmtitle':
            return 'Heart Bit bpm';
            break;
          case 'temptitle':
            return 'Body Temperature';
            break;
          case 'nowtempis':
            return 'Now Temperature ';
            break;
          case 'nowbpm':
            return 'Now Heart bit ';
            break;
          case '°C':
            return '°C';
            break;
          case 'bpm':
            return 'bpm';
            break;
          case 'Language':
            return 'Language Setting';
            break;
          case 'english':
            return 'English';
            break;
          case 'chinese':
            return 'Chinese';
            break;
          case 'AppTitle':
            return 'Health Monitor System';
            break;
          case 'settingPage':
            return 'Main Setting';
            break;
          case 'Other Setting':
            return 'Other Setting';
            break;
          case 'close':
            return 'Close';
            break;
          case 'fontsize':
            return 'Text Size';
            break;
          case 'small':
            return 'S';
            break;
          case 'medium':
            return 'M';
            break;
          case 'large':
            return 'L';
            break;
          case 'mode':
            return 'Light Theme';
            break;
          case 'lightmode':
            return 'Light';
            break;
          case 'darkmode':
            return 'Dark';
            break;
          case 'call':
            return 'Ask for help';
            break;
          default:
            return 'error';
            break;
        }
        break;

    // zh locate ==================================================================================================================
      case 'zh':
        switch (text) {
          case 'AppTitle':
            return '健康監測系統';
            break;
          case 'bpm':
            return ' ';
            break;
          case 'bpmtitle':
            return '心跳率監測';
            break;
          case 'nowbpm':
            return '現在心跳率每分鐘';
            break;
          case 'temp':
            return '體溫';
            break;
          case '°C':
            return '度';
            break;
          case 'temptitle':
            return '體溫監測';
            break;
          case 'nowtempis':
            return '現在體溫';
            break;
          case 'Language':
            return '語言設定';
            break;
          case 'english':
            return '英文';
            break;
          case 'chinese':
            return '中文';
            break;
          case 'fontsize':
            return '字體大小';
            break;
          case 'small':
            return '小';
            break;
          case 'medium':
            return '中';
            break;
          case 'large':
            return '大';
            break;
          case 'textmode':
            return '文本模式';
            break;
          case 'Other Setting':
            return '其他設定';
            break;
          case 'settingPage':
            return '主要設定';
            break;
          case 'mode':
            return '顯示模式';
            break;
          case 'lightmode':
            return '亮模式';
            break;
          case 'darkmode':
            return '深色模式';
            break;
          case 'close':
            return '關閉';
            break;


          case 'call':
            return '尋求幫助';
            break;

          default:
            return '文字出現錯誤';
            break;
        }
        break;
    // default ==================================================================================================================
      default:
        switch (text) {
          case 'welcome':
            return 'welcome';
            break;
          default:
            return 'error';
            break;
        }
        break;
    }
  }

  TextStyle getTextStyle() {
    return TextStyle(fontSize: textSizeValue);
  }

  Color getThemeTextColor(String theme) {
    if (theme == 'light') {
      return Colors.black;
    } else if (theme == 'dark') {
      return Colors.white;
    }
    return Colors.white;
  }
}

class ThemeChanger with ChangeNotifier {
  Brightness _themeData;
  double _textFont;
  String _displayList;
  int _sortedNumber;
  ThemeChanger(this._themeData, this._textFont);

  getTheme() => _themeData;
  getTextFont() => _textFont;
  getDisplayList() => _displayList;
  getSortedNumber () => _sortedNumber;
  setSortedNumber (int sortedNumber) {
    _sortedNumber = sortedNumber;
    notifyListeners();
  }
  setTheme(Brightness theme) {
    _themeData = theme;
    notifyListeners();
  }
  setTextFont(double textFont) {
    _textFont = textFont;
    notifyListeners();
  }
  setDisplayList(String displayList) {
    _displayList = displayList;
    notifyListeners();
  }
}