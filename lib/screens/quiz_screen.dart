import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../core/theme/theme.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _correctAnswers = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _quizStarted = false;
  
  String? _selectedTopic;

  final List<String> _topics = ['الجميع', 'التشريح', 'التمريض', 'الأمراض'];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final dbProvider = context.read<DatabaseProvider>();
    final topic = _selectedTopic == 'الجميع' ? null : _selectedTopic;
    final questions = await dbProvider.getRandomQuestions(topic: topic, limit: 10);
    setState(() => _questions = questions);
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _currentIndex = 0;
      _correctAnswers = 0;
      _selectedAnswer = null;
      _showResult = false;
    });
  }

  void _answerQuestion(int index) {
    if (_showResult) return;
    setState(() {
      _selectedAnswer = index;
      _showResult = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _correctAnswers++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    final total = _questions.length;
    final correct = _correctAnswers;
    final percentage = (correct / total) * 100;
    final topic = _selectedTopic ?? 'الجميع';

    final result = QuizResult(
      topic: topic,
      totalQuestions: total,
      correctAnswers: correct,
      percentage: percentage,
      date: DateTime.now().toIso8601String(),
    );

    await context.read<DatabaseProvider>().saveQuizResult(result);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            correctAnswers: correct,
            totalQuestions: total,
            percentage: percentage,
            topic: topic,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_quizStarted) {
      return _buildSetupScreen();
    }
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('الاختبارات')),
        body: const Center(child: Text('لا توجد أسئلة متاحة')),
      );
    }
    return _buildQuizScreen();
  }

  Widget _buildSetupScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('الاختبارات')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: const Icon(Icons.quiz_rounded,
                  size: 48, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),
            Text(
              'اختبر معلوماتك',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'أجب عن 10 أسئلة اختيار من متعدد\nفي مواضيع التمريض المختلفة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Text('اختر الموضوع:',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _topics.map((topic) {
                final isSelected = _selectedTopic == topic || 
                    (topic == 'الجميع' && _selectedTopic == null);
                return ChoiceChip(
                  label: Text(topic),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                  onSelected: (selected) {
                    setState(() {
                      _selectedTopic = selected ? (topic == 'الجميع' ? null : topic) : null;
                    });
                    _loadQuestions();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _questions.isEmpty ? null : _startQuiz,
                icon: const Icon(Icons.play_arrow),
                label: const Text('ابدأ الاختبار'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizScreen() {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('سؤال ${_currentIndex + 1} من ${_questions.length}'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(AppTheme.successColor),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      question.topic,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    final isCorrect = index == question.correctIndex;
                    final isSelected = _selectedAnswer == index;

                    Color? bgColor;
                    Color? borderColor;
                    if (_showResult) {
                      if (isCorrect) {
                        bgColor = AppTheme.successColor.withValues(alpha: 0.1);
                        borderColor = AppTheme.successColor;
                      } else if (isSelected && !isCorrect) {
                        bgColor = AppTheme.errorColor.withValues(alpha: 0.1);
                        borderColor = AppTheme.errorColor;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _answerQuestion(index),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: borderColor ?? Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              children: [
                                if (_showResult && isCorrect)
                                  const Icon(Icons.check_circle,
                                      color: AppTheme.successColor)
                                else if (_showResult && isSelected)
                                  const Icon(Icons.cancel,
                                      color: AppTheme.errorColor)
                                else
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.grey[200],
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          if (_showResult)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      question.explanation,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      child: Text(
                        _currentIndex < _questions.length - 1
                            ? 'السؤال التالي'
                            : 'عرض النتيجة',
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
