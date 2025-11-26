// mask_formatter.dart
import 'package:flutter/services.dart';

class PhoneMaskTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    final cleanedText = newText.replaceAll(RegExp(r'[^\d]'), '');

    if (newText.length < oldText.length) {
      return newValue;
    }

    if (cleanedText.length > 11) {
      return oldValue;
    }

    String maskedText = _applyMask(cleanedText);

    return newValue.copyWith(
      text: maskedText,
      selection: TextSelection.collapsed(offset: maskedText.length),
    );
  }

  String _applyMask(String digits) {
    if (digits.isEmpty) return '';
    
    if (digits.length <= 2) {
      return '($digits';
    } else if (digits.length <= 6) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2)}';
    } else if (digits.length <= 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    } else {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
    }
  }
}

class CpfMaskTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    final cleanedText = newText.replaceAll(RegExp(r'[^\d]'), '');

    if (newText.length < oldText.length) {
      return newValue;
    }

    if (cleanedText.length > 11) {
      return oldValue;
    }

    String maskedText = _applyMask(cleanedText);

    return newValue.copyWith(
      text: maskedText,
      selection: TextSelection.collapsed(offset: maskedText.length),
    );
  }

  String _applyMask(String digits) {
    if (digits.isEmpty) return '';
    
    if (digits.length <= 3) {
      return digits;
    } else if (digits.length <= 6) {
      return '${digits.substring(0, 3)}.${digits.substring(3)}';
    } else if (digits.length <= 9) {
      return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6)}';
    } else {
      return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}';
    }
  }
}

class RaMaskTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    final cleanedText = newText.replaceAll(RegExp(r'[^\d]'), '');

    if (newText.length < oldText.length) {
      return newValue;
    }

    if (cleanedText.length > 11) {
      return oldValue;
    }

    return newValue.copyWith(
      text: cleanedText,
      selection: TextSelection.collapsed(offset: cleanedText.length),
    );
  }
}

bool validarTelefone(String telefoneComMascara) {
  final digits = telefoneComMascara.replaceAll(RegExp(r'[^\d]'), '');
  return digits.length == 10 || digits.length == 11;
}

bool validarCPF(String cpfComMascara) {
  final digits = cpfComMascara.replaceAll(RegExp(r'[^\d]'), '');
  
  if (digits.length != 11) return false;
  
  if (RegExp(r'^(\d)\1{10}$').hasMatch(digits)) return false;
  
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(digits[i]) * (10 - i);
  }
  
  int firstDigit = (sum * 10) % 11;
  if (firstDigit == 10) firstDigit = 0;
  
  if (firstDigit != int.parse(digits[9])) return false;
  
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(digits[i]) * (11 - i);
  }
  
  int secondDigit = (sum * 10) % 11;
  if (secondDigit == 10) secondDigit = 0;
  
  return secondDigit == int.parse(digits[10]);
}

bool validarRA(String ra) {
  return RegExp(r'^\d{11}$').hasMatch(ra);
}

bool validarEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

bool validarNome(String nome) {
  final palavras = nome.trim().split(' ');
  return palavras.length >= 2 && 
         palavras.every((palavra) => palavra.length >= 2) &&
         nome.length >= 6;
}

String obterApenasNumerosTelefone(String telefoneComMascara) {
  return telefoneComMascara.replaceAll(RegExp(r'[^\d]'), '');
}

String obterApenasNumerosCPF(String cpfComMascara) {
  return cpfComMascara.replaceAll(RegExp(r'[^\d]'), '');
}