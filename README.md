# LearnWise — Flutter App

A full Flutter/Dart implementation of the LearnWise AI-study-assistant UI, built from the
provided mockups (onboarding, login, sign up, search/learn, AI quiz generator, notes summarizer,
planner, bookmarks, notifications, profile, settings, help & support).

Every button, toggle, form, and navigation flow is wired up with real (local, in-memory) state —
no backend is included, so "AI" features (quiz generation, notes summarization, chat) are mocked
with lightweight local logic you can swap for real API calls later.

## Project structure

```
lib/
  main.dart                  # App entry point, theming, routes
  theme.dart                 # Light/dark ThemeData + brand colors
  app_state.dart             # Global app state (ChangeNotifier) + models
  screens/
    onboarding_screen.dart
    login_screen.dart
    signup_screen.dart
    root_shell.dart          # Bottom-nav shell (Home / Learn / AI Tutor / Planner / Profile)
    home_screen.dart
    course_detail_sheet.dart
    search_screen.dart       # "Learn" tab
    ai_hub_screen.dart       # "AI Tutor" tab + chat sheet
    quiz_generator_screen.dart
    notes_summarizer_screen.dart
    planner_screen.dart
    bookmarks_screen.dart
    notifications_screen.dart
    profile_screen.dart
    settings_screen.dart
    help_support_screen.dart
assets/images/logo.png
```

## How to run this in VS Code

1. Install the **Flutter** and **Dart** extensions in VS Code (if you haven't already).
2. Create a fresh Flutter project shell (this generates the required `android/`, `ios/`, `web/`
   platform folders that aren't included in this zip):
   ```bash
   flutter create learnwise
   ```
3. Copy the contents of this zip (`lib/`, `assets/`, `pubspec.yaml`, `analysis_options.yaml`)
   into the `learnwise` folder you just created, overwriting the generated `lib/main.dart` and
   `pubspec.yaml`.
4. Fetch packages:
   ```bash
   cd learnwise
   flutter pub get
   ```
5. Run it:
   - Open the folder in VS Code.
   - Pick a device/emulator in the bottom-right status bar (or press `F5`).
   - Press **F5** / **Run > Start Debugging**, or run `flutter run` from the terminal.

## What's functional

- **Onboarding** — swipeable pages, animated dot indicator, Skip/Next buttons.
- **Login / Sign Up** — full form validation, password visibility toggles, "Forgot Password"
  dialog, mocked social buttons, loading spinner on submit, navigation between the two screens.
- **Home** — streak banner, today's schedule (checkbox toggles synced with Planner), notification
  bell with live unread badge, horizontally scrolling course carousel that opens a course detail
  sheet (with working bookmark toggle and "Start Lesson").
- **Learn (Search)** — live text filtering, tappable recent-search chips (with Clear), trending
  topics, a 2-column results grid, and a "more options" sheet.
- **AI Tutor hub** — a working mocked chat sheet (send a message, get a reply), and cards linking
  to:
  - **AI Quiz Generator** — difficulty chips, question-type chips, a stepper for question count
    (5–50), a time-limit switch, and a "Generate Quiz" flow that shows a summary sheet.
  - **Notes Summarizer** — paste notes or "upload" a mock file, tap **Summarize Notes** to get a
    locally generated key-takeaway + tags, copy/bookmark actions.
- **Planner** — week strip with month navigation, add/complete/swipe-to-delete tasks (a bottom
  sheet form), assignment list with a "mark complete" action, and a bookmark shortcut.
- **Bookmarks** — filter tabs (Courses / Notes / Quizzes) backed by real toggle state from the
  Home and Search screens.
- **Notifications** — category filter chips, tap to mark as read, swipe to delete, and a "mark all
  as read / clear all" menu.
- **Profile** — edit-profile dialog, stat cards, navigation to Bookmarks/Settings/Help, and a
  confirm-before-logout dialog that returns you to the Login screen.
- **Settings** — dark mode toggle (re-themes the whole app live), a font-size slider (rescales all
  text app-wide), language picker, change-password dialog, and notification toggles.
- **Help & Support** — searchable FAQ accordion, "Live AI Chat" / "Email Support" cards, and a
  feedback dialog.

## Wiring up real AI later

The mocked "AI" logic lives in two small, isolated spots so it's easy to swap out:
- `AppState.summarizeNotes()` in `lib/app_state.dart`
- The quiz-generation delay/result in `lib/screens/quiz_generator_screen.dart`
- The chat reply logic in `_ChatSheetState._send()` in `lib/screens/ai_hub_screen.dart`

Replace those with real `http`/API calls (e.g. to your backend or an LLM API) whenever you're
ready — the rest of the UI already reacts to state changes automatically.
