class QuizQuestion {
  final String? id;
  final String? question;
  final List<String>? options;
  final int? correctAnswerIndex;
  final String? questionTitle;
  final String? imageUrl;
  final String? userId;

  QuizQuestion({
    this.id,
    this.question,
    this.options,
    this.correctAnswerIndex,
    this.questionTitle,
    this.imageUrl,
    this.userId,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'],
      question: map['question'],
      options: List<String>.from(map['options']),
      correctAnswerIndex: map['correctAnswerIndex'],
      questionTitle: map['questionTitle'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
    );
  }
}