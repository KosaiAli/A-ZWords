class Statement {
  Node? head;
  Node? temp;
}

class Node {
  String word;
  Node? next;
  Sentence? head;
  Sentence? temp;
  Node({required this.word});
}

class Sentence {
  String sentence;
  Sentence? next;
  Sentence({required this.sentence});
}
