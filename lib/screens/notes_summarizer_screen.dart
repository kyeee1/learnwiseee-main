import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';

class NotesSummarizerScreen extends StatefulWidget {
  const NotesSummarizerScreen({super.key});

  @override
  State<NotesSummarizerScreen> createState() => _NotesSummarizerScreenState();
}

class _NotesSummarizerScreenState extends State<NotesSummarizerScreen> {
  final _notesController = TextEditingController();
  bool _summarizing = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _summarize() async {
    final state = AppScope.of(context);
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Paste some notes first so LearnWise can summarize them.')),
      );
      return;
    }
    setState(() => _summarizing = true);
    await Future.delayed(
        const Duration(milliseconds: 800)); // simulate AI processing
    if (!mounted) return;
    state.summarizeNotes(_notesController.text);
    setState(() => _summarizing = false);
  }

  void _uploadFile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded,
                  color: Colors.redAccent),
              title: const Text('Upload PDF'),
              onTap: () => _finishUpload('sample-notes.pdf'),
            ),
            ListTile(
              leading: const Icon(Icons.description_rounded,
                  color: Colors.blueAccent),
              title: const Text('Upload DOCX'),
              onTap: () => _finishUpload('lecture-notes.docx'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.text_snippet_rounded, color: Colors.green),
              title: const Text('Upload TXT'),
              onTap: () => _finishUpload('chapter-3.txt'),
            ),
          ],
        ),
      ),
    );
  }

  void _finishUpload(String filename) {
    Navigator.pop(context);
    setState(() {
      _notesController.text =
          'Imported from $filename: Force is directly proportional to acceleration and inversely '
          'proportional to mass, as described by Newton\'s Second Law (F = ma). This principle '
          'underlies classical mechanics and explains how objects respond to applied forces.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Imported "$filename"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text('Notes Summarizer',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Transform heavy notes into quick revision blocks',
              style: TextStyle(color: AppColors.subtitle)),
          const SizedBox(height: 22),
          TextField(
            controller: _notesController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText:
                  'Paste your detailed textbook pages, notes, or essays here...',
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _uploadFile,
            child: const DottedBorderBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_rounded, color: AppColors.primary),
                  SizedBox(width: 10),
                  Text('Upload File (PDF, DOCX, TXT)',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Summary Result',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              if (state.summaryResult != null)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Summary copied to clipboard')),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        state.savedSummaries.contains(state.summaryResult)
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          final result = state.summaryResult!;
                          if (state.savedSummaries.contains(result)) {
                            state.savedSummaries.remove(result);
                          } else {
                            state.savedSummaries.add(result);
                          }
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (state.summaryResult == null)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: context.adaptiveField,
                  borderRadius: BorderRadius.circular(16)),
              child: const Text(
                'Your AI-generated summary will appear here once you tap "Summarize Notes".',
                style: TextStyle(color: AppColors.subtitle),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: context.adaptiveSoftPrimary,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Key Takeaway',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(state.summaryResult!,
                      style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          if (state.summaryTags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.summaryTags
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: context.adaptiveBorder),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:
                            Text('#$tag', style: const TextStyle(fontSize: 12)),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _summarizing ? null : _summarize,
            child: _summarizing
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: Colors.white),
                  )
                : const Text('Summarize Notes'),
          ),
        ],
      ),
    );
  }
}

/// Simple dashed-border container (no external package needed).
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );
    final path = Path()..addRRect(rrect);
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
