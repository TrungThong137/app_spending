import 'dart:io';

class AppValid {
  AppValid._();
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    } else if (value.length < 6) {
      return 'Name must be more than 6 characters';
    }
    final regex = RegExp(
      r'^[a-z A-ZỳọáầảấờễàạằệếýộậốũứĩõúữịỗìềểẩớặòùồợãụủíỹắẫựỉỏừỷởóéửỵẳẹèẽổẵẻỡơôưăêâđỲỌÁẦẢẤỜỄÀẠẰỆẾÝỘẬỐŨỨĨÕÚỮỊỖÌỀỂẨỚẶÒÙỒỢÃỤỦÍỸẮẪỰỈỎỪỶỞÓÉỬỴẲẸÈẼỔẴẺỠƠÔƯĂÊÂĐ]+$',
    );
    if (!regex.hasMatch(value)) {
      return 'Do not enter special characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    } 
    return null;
  }

  static String? validPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8 || value.length > 16) {
      return 'Password must be greater than 8 characters and less than 16 characters';
    }
    return null;
  }

  static String? validatePasswordConfirm(String pass, String? confirmPass) {
    if (confirmPass == null || confirmPass.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPass != pass) {
      return 'Confirmation password does not match';
    }
    return null;
  }

  static String? validateChangePass(String passOld, String? passNew) {
    if (passOld == passNew) {
      return 'The new password must not be the same as the old password';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    } else {
      final regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      );

      if (!regex.hasMatch(value)) {
        return 'Invalid email';
      } else {
        return null;
      }
    }
  }

  static String? validateVerificationCode(String? value) {
    final regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (value == null || value.isEmpty) {
      return '';
    } else if (value.length != 6 && !regex.hasMatch(value)) {
      return '';
    } else {
      return null;
    }
  }

  static String? validAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    } else {
      return null;
    }
  }

  static String? validMoney(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter money';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? value) {
    final regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (value == null || value.isEmpty) {
      return 'Please enter the phone number';
    } else {
      final checkPhoneNumber = value.split('')[0];
      if (checkPhoneNumber != '0') {
        return 'Invalid phone number';
      }
      if (value.length != 10) {
        return 'The phone number cannot be less than or greater than 10 digits';
      } else if (!regex.hasMatch(value)) {
        return 'Do not enter special characters or letters';
      } else {
        return null;
      }
    }
  }

  static bool isNetWork(dynamic value) {
    if (value is SocketException) {
      return false;
    }
    return true;
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}
