/// Extracts the title from markdown content by searching for the first line
/// that starts with a '#'. If no such line is found, returns 'Untitled Lesson'.
String extractTitleFromMarkdown(String lessonData) {
  // Split the content into lines and search for the first line that starts with '#'
  for (final line in lessonData.split('\n')) {
    final trimmedLine = line.trim();
    if (trimmedLine.startsWith('#')) {
      return trimmedLine.replaceFirst('#', '').trim();
    }
  }
  // Return default title if no heading line is found
  return 'Untitled Lesson';
}