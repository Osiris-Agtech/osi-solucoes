import 'dart:convert';

String encodeAtividadeDescricao(String text) => utf8.encode(text).toString();

String normalizeAtividadeDescricao(String? value) {
  if (value == null) return '';

  final text = value.trim();
  if (!text.startsWith('[') || !text.endsWith(']')) return value;

  final content = text.substring(1, text.length - 1).trim();
  if (content.isEmpty) return '';
  if (!RegExp(r'^\d+(\s*,\s*\d+)*$').hasMatch(content)) return value;

  final bytes = <int>[];
  for (final part in content.split(',')) {
    final byte = int.tryParse(part.trim());
    if (byte == null || byte < 0 || byte > 255) return value;
    bytes.add(byte);
  }

  try {
    return utf8.decode(bytes);
  } on FormatException {
    return value;
  }
}
