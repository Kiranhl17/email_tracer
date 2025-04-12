List<String> extractIPs(String header) {
  final ipRegex = RegExp(r'\[?(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\]?');
  return ipRegex
      .allMatches(header)
      .map((match) => match.group(1)!)
      .toSet()
      .toList();
}
