class BookView {
  final String id;
  final String name;
  final int currentChunkIndex;
  final int totalChunkCount;
  final int wordIndex;
  final List<String> pdfContent;
  
  BookView({
    required this.id,
    required this.name,
    required this.currentChunkIndex,
    required this.totalChunkCount,
    required this.wordIndex,
    required this.pdfContent
  });
}