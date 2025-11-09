# FlowDay 🌊

**Find your flow, one task at a time.**

FlowDay is a beautiful, minimal task management app built with Flutter. Designed to help you organize your day with elegant UI, smooth animations, and powerful productivity features.

## ✨ Features

### 🎯 **Core Functionality**
- **Task Management**: Add, edit, delete, and complete tasks
- **Smart Organization**: Today, Upcoming, Overdue, and Completed sections
- **Priority Levels**: High, Medium, Low with color coding
- **Categories**: Personal, Work, Health, Learning, Shopping, Other
- **Subtasks**: Break down complex tasks into smaller steps
- **Search & Filter**: Find tasks quickly with real-time search

### 🚀 **Productivity Features**
- **Focus Mode**: Pomodoro timer with 15/25/45 minute sessions
- **Streak Tracking**: Daily completion streaks with achievements
- **Quick Actions**: One-tap task creation for common categories
- **Task Templates**: Pre-built workflows (Morning Routine, Work Project, Learning Goal)
- **Progress Tracking**: Visual progress bars for subtasks

### 📊 **Analytics & Insights**
- **7-Day Activity**: Visual habit tracking calendar
- **Completion Statistics**: Overall progress and productivity metrics
- **Priority Breakdown**: Task distribution by priority levels
- **Streak Achievements**: Motivational notifications for milestones

### 🎨 **Design & Experience**
- **Material 3 Design**: Modern, clean interface
- **Dark Mode**: Automatic theme switching
- **Smooth Animations**: Staggered animations and micro-interactions
- **Google Fonts**: Beautiful Poppins typography
- **Gradient Backgrounds**: Subtle visual depth
- **Custom Icons**: Unique app branding

## 🛠️ Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Local Storage**: Hive (NoSQL database)
- **Fonts**: Google Fonts (Poppins)
- **Animations**: Flutter Staggered Animations
- **Architecture**: Clean Architecture (MVC pattern)

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flowday.git
   cd flowday
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.1
  hive_flutter: ^1.1.0
  google_fonts: ^6.1.0
  lottie: ^3.0.0
  flutter_staggered_animations: ^1.1.1
  intl: ^0.19.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
  flutter_launcher_icons: ^0.13.1
```

## 🏗️ Project Structure

```
lib/
├── models/          # Data models (Task, Subtask)
├── providers/       # State management (TaskProvider)
├── screens/         # App screens (Home, Stats, Focus, Settings)
├── widgets/         # Reusable UI components
└── main.dart        # App entry point

assets/
└── icon/           # App icons and images
```

## 🎯 Key Features Breakdown

### Task Management
- **CRUD Operations**: Full task lifecycle management
- **Swipe Gestures**: Swipe right to complete, left to delete
- **Visual Feedback**: Smooth animations and state changes
- **Persistent Storage**: Local data with Hive database

### Productivity Tools
- **Focus Sessions**: Distraction-free work periods
- **Achievement System**: Streak tracking and celebrations
- **Quick Creation**: Rapid task entry with templates
- **Progress Visualization**: Linear progress bars and percentages

### User Experience
- **Responsive Design**: Adapts to different screen sizes
- **Accessibility**: Screen reader support and semantic labels
- **Performance**: Optimized rendering and smooth 60fps animations
- **Offline First**: Works without internet connection

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for the design system
- Google Fonts for beautiful typography
- Hive for efficient local storage

---

**FlowDay** - *Find your flow, one task at a time.* 🌊✨