import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'complaint.dart';

class ComplaintsProvider extends ChangeNotifier {
  final List<Complaint> _complaints = [];
  int _completedCount = 0;
  final int totalGoal;

  ComplaintsProvider({this.totalGoal = 100});

  List<Complaint> get complaints => List.unmodifiable(_complaints);
  int get currentGoal => _completedCount;
  int get goalTotal => totalGoal;

  void addComplaint(String text) {
    final id = const Uuid().v4();
    _complaints.insert(0, Complaint(id: id, text: text));
    notifyListeners();
  }

  void completeComplaint(String id) {
    _complaints.removeWhere((c) => c.id == id);
    _completedCount++;
    notifyListeners();
  }

  void escalateComplaint(String id) {
    _complaints.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void preload(List<String> texts) {
    for (final t in texts.reversed) {
      addComplaint(t);
    }
  }
}
