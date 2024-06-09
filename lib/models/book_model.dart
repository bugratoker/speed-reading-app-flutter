class Book {
  final String id;
  final String name;
  final int currentChunkIndex;
  final int wordIndex;
  final int totalChunkCount;
  
  Book({
    required this.id,
    required this.name,
    required this.currentChunkIndex,
    required this.wordIndex,
    required this.totalChunkCount
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      currentChunkIndex: json['currentChunkIndex'],
      wordIndex: json['wordIndex'],
      totalChunkCount: json['totalChunkCount']
    );
  }
}