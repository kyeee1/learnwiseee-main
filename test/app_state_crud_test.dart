import 'package:flutter_test/flutter_test.dart';
import 'package:learnwise/app_state.dart';

void main() {
  test('login displays the signed-in user identity', () {
    final state = AppState();

    state.login('maria.santos@example.com');

    expect(state.isLoggedIn, isTrue);
    expect(state.userEmail, 'maria.santos@example.com');
    expect(state.userName, 'Maria Santos');
  });

  test('courses contain Art Appreciation lessons with readable sections', () {
    final state = AppState();

    expect(
        state.allCourses
            .every((course) => course.title.startsWith('Art Appreciation')),
        isTrue);
    expect(
        state.allCourses.every((course) => course.lessonSections.length >= 3),
        isTrue);
    expect(state.allCourses.first.lessonSections.first.body,
        contains('Art appreciation'));
  });

  test('Planner CRUD works for add, update and delete', () {
    final state = AppState();

    state.addTask('Biology Revision', '7:00 PM');
    expect(state.tasks.length, 3);

    final created = state.tasks.last;
    state.updateTask(created.id, title: 'Biology Quiz Prep', time: '8:00 PM');
    expect(
        state.tasks.any((task) => task.title == 'Biology Quiz Prep'), isTrue);
    expect(
        state.tasks.any((task) => task.title == 'Biology Revision'), isFalse);

    state.removeTask(created.id);
    expect(state.tasks.any((task) => task.id == created.id), isFalse);
  });
}
