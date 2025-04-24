List<String> extractIPs(String header) {
  final ipRegex = RegExp(r'\[?(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\]?');
  return ipRegex
      .allMatches(header)
      .map((match) => match.group(1)!)
      .toSet()
      .toList();
}

String extractSourceEmail(String header) {
  final emailRegex = RegExp(r'(?<=Return-Path: <)[^>]+');
  final match = emailRegex.firstMatch(header);
  return match?.group(0) ?? 'Email ID not found';
}

List<String> extractTracerRoute(String header) {
  final receivedRegex = RegExp(r'Received:.*?;', caseSensitive: false, dotAll: true);
  return receivedRegex
      .allMatches(header)
      .map((match) => match.group(0)!.trim())
      .toList();
}

String extractSenderName(String header) {
  final fromRegex = RegExp(r'From:\s*"?([^"<\n]+)"?\s*<[^>]+>');
  final match = fromRegex.firstMatch(header);
  return match?.group(1)?.trim() ?? 'Name not found';
}

String extractXFromName(String header) {
  final xFromRegex = RegExp(r'X-From:\s*([^\n\r]+)');
  final match = xFromRegex.firstMatch(header);
  return match?.group(1)?.trim() ?? 'Not available';
}

String extractDomainFromEmail(String email) {
  final domainRegex = RegExp(r'@([^\s>]+)');
  final match = domainRegex.firstMatch(email);
  return match?.group(1) ?? 'Unknown domain';
}
