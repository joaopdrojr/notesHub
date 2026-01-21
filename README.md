# NotesHub

<p align="leading">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" />
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" />
  <img src="https://img.shields.io/badge/SwiftUI-green.svg" />
  <img src="https://img.shields.io/badge/UIKit-green.svg" />
</p>

A modern iOS notes app built with SwiftUI demonstrating **Home Screen Quick Actions** implementation using UIApplicationDelegateAdaptor. Features complete localization in English and Brazilian Portuguese.

## ✨ Key Features

- 📝 Create and edit notes
- ⭐ Favorite system
- 🔍 Real-time search
- 🚀 **Home Screen Quick Actions** (3D Touch/Long Press)
- 💾 Persistent storage with UserDefaults
- 🌎 **Full internationalization** (English & Brazilian Portuguese)
- 🎨 Adaptive SwiftUI interface
- 📱 Native iOS design patterns

## 🎯 Quick Actions

Press and hold the app icon to access:

| Action | Description | Icon |
|--------|-------------|------|
| **New Note** | Create a note quickly | ✏️ |
| **Search** | Find your notes | 🔍 |
| **Favorites** | Access favorite notes | ⭐ |

All Quick Actions are fully localized in both English and Portuguese!

## 🏗️ Architecture

This project follows the **MVVM** (Model-View-ViewModel) pattern with centralized state management:

```
┌─────────────────────────────────────────┐
│           SwiftUI App                    │
│         (notesHubApp)                    │
└──────────────┬──────────────────────────┘
               │
    ┌──────────┴──────────┐
    │                     │
┌───▼────────┐    ┌──────▼────────┐
│ AppDelegate│    │ SceneDelegate │
│  (UIKit)   │    │    (UIKit)    │
└───┬────────┘    └──────┬────────┘
    │                    │
    └──────┬─────────────┘
           │
    ┌──────▼──────┐
    │  AppState   │◄──── QuickAction
    │ (ObservableObject)
    └──────┬──────┘
           │
    ┌──────▼──────────┐
    │  NotesManager   │◄──── Note
    │ (ObservableObject)
    └──────┬──────────┘
           │
    ┌──────▼──────┐
    │  ContentView│
    │   (Views)   │
    └─────────────┘
```

### Design Patterns

- **Delegate Adaptor**: UIKit ↔ SwiftUI integration
- **Observable Pattern**: Reactive state management
- **Repository Pattern**: Abstracted persistence layer
- **Coordinator Pattern**: Navigation via AppState

## 📁 Project Structure

```
notesHub/
├── App/
│   ├── notesHubApp.swift          # SwiftUI entry point
│   ├── AppDelegate.swift          # UIKit delegate
│   └── SceneDelegate.swift        # Scene handling
├── Models/
│   ├── Note.swift                 # Data model
│   └── QuickAction.swift          # Actions enum
├── View Models/
│   ├── AppState.swift             # Global state
│   └── NotesManager.swift         # Notes manager
├── Views/
│   ├── ContentView.swift          # Main TabView
│   ├── NotesListView.swift        # Notes list
│   ├── FavoritesView.swift        # Favorite notes
│   ├── SearchNotesView.swift      # Search interface
│   ├── NewNoteView.swift          # Note creation
│   ├── NoteDetailView.swift       # Note editing
│   ├── SettingsView.swift         # Settings
│   └── QuickActionInfoRow.swift   # Info UI component
├── Language/
│   ├── Localizable.xcstrings      # String catalog
│   ├── EN/
│   │   └── en.lproj/
│   │       └── InfoPlist.strings  # EN Quick Actions
│   └── PT/
│       └── pt-BR.lproj/
│           └── InfoPlist.strings  # PT-BR Quick Actions
├── Assets.xcassets/               # Visual assets
└── Info.plist                     # App configuration
```

## 🚀 Quick Actions Implementation

### Step 1: Configure Info.plist

```xml
<key>UIApplicationShortcutItems</key>
<array>
    <dict>
        <key>UIApplicationShortcutItemType</key>
        <string>com.noteshub.newnote</string>
        <key>UIApplicationShortcutItemTitle</key>
        <string>SHORTCUT_NEW_NOTE_TITLE</string>
        <key>UIApplicationShortcutItemSubtitle</key>
        <string>SHORTCUT_NEW_NOTE_SUBTITLE</string>
        <key>UIApplicationShortcutItemIconType</key>
        <string>UIApplicationShortcutIconTypeCompose</string>
    </dict>
</array>
```

### Step 2: Create QuickAction Enum

```swift
enum QuickAction: String {
    case newNote = "com.noteshub.newnote"
    case search = "com.noteshub.search"
    case favorites = "com.noteshub.favorites"
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let action = QuickAction(rawValue: shortcutItem.type) else {
            return nil
        }
        self = action
    }
}
```

### Step 3: Create AppDelegate

```swift
class AppDelegate: NSObject, UIApplicationDelegate {
    var quickActionToHandle: QuickAction?
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            quickActionToHandle = QuickAction(shortcutItem: shortcutItem)
        }
        
        let config = UISceneConfiguration(
            name: "Quick Action Scene",
            sessionRole: connectingSceneSession.role
        )
        config.delegateClass = SceneDelegate.self
        return config
    }
}
```

### Step 4: Create SceneDelegate

```swift
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        guard let quickAction = QuickAction(shortcutItem: shortcutItem) else {
            completionHandler(false)
            return
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.quickActionToHandle = quickAction
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("ProcessQuickAction"),
            object: nil
        )
        
        completionHandler(true)
    }
}
```

### Step 5: Integrate with SwiftUI

```swift
@main
struct notesHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @StateObject private var notesManager = NotesManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(notesManager)
                .onAppear {
                    handleQuickAction()
                }
                .onReceive(NotificationCenter.default.publisher(
                    for: NSNotification.Name("ProcessQuickAction")
                )) { _ in
                    handleQuickAction()
                }
        }
    }
    
    private func handleQuickAction() {
        guard let quickAction = appDelegate.quickActionToHandle else {
            return
        }
        
        appState.handle(quickAction)
        appDelegate.quickActionToHandle = nil
    }
}
```

## 🌍 Internationalization

NotesHub supports **two languages** with complete localization:

- 🇺🇸 **English (EN)** - Default language
- 🇧🇷 **Brazilian Portuguese (PT-BR)** - Full translation

### Quick Actions Localization

**en.lproj/InfoPlist.strings:**
```
"SHORTCUT_NEW_NOTE_TITLE" = "New Note";
"SHORTCUT_NEW_NOTE_SUBTITLE" = "Create a note quickly";

"SHORTCUT_SEARCH_TITLE" = "Search";
"SHORTCUT_SEARCH_SUBTITLE" = "Find your notes";

"SHORTCUT_FAVORITES_TITLE" = "Favorites";
"SHORTCUT_FAVORITES_SUBTITLE" = "Access your favorite notes";
```

**pt-BR.lproj/InfoPlist.strings:**
```
"SHORTCUT_NEW_NOTE_TITLE" = "Nova Nota";
"SHORTCUT_NEW_NOTE_SUBTITLE" = "Crie uma anotação rapidamente";

"SHORTCUT_SEARCH_TITLE" = "Buscar";
"SHORTCUT_SEARCH_SUBTITLE" = "Encontre suas notas";

"SHORTCUT_FAVORITES_TITLE" = "Favoritos";
"SHORTCUT_FAVORITES_SUBTITLE" = "Acesse suas notas favoritas";
```

The iOS system automatically selects the correct language based on device settings.

## 🔄 Data Flow

### Quick Action Execution Flow

```
[User presses app icon] → [Selects "New Note"]
          ↓
[AppDelegate stores quickAction]
          ↓
[SceneDelegate sends notification]
          ↓
[App receives notification via onReceive]
          ↓
[handleQuickAction() processes]
          ↓
[appState.handle(.newNote) is called]
          ↓
[shouldShowNewNote = true]
          ↓
[ContentView presents NewNoteView via .sheet]
          ↓
[User fills and saves]
          ↓
[notesManager.addNote() called]
          ↓
[Note added to array]
          ↓
[saveNotes() persists to UserDefaults]
          ↓
[Sheet dismissed]
          ↓
[Notes list auto-updates via @Published]
```

## 💾 Data Persistence

Notes are persisted using **UserDefaults** with JSON encoding:

```swift
private func saveNotes() {
    if let encoded = try? JSONEncoder().encode(notes) {
        UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
    }
}

private func loadNotes() {
    if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
       let decoded = try? JSONDecoder().decode([Note].self, from: data) {
        notes = decoded
    }
}
```

## 🛠️ Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/noteshub.git
```

2. Open the project:
```bash
cd noteshub
open notesHub.xcodeproj
```

3. Build and run on simulator or device

## 🧪 Testing Quick Actions

### On Simulator
1. Run the app
2. Go to home screen
3. Long-press (click and hold) the app icon
4. Select a Quick Action
5. Verify the correct screen appears

### On Device
1. Install the app
2. Force-press (3D Touch) or long-press the app icon
3. Select a Quick Action
4. Verify functionality

### Testing Localization
1. **Change device language:**
   - Settings → General → Language & Region → iPhone Language
2. **Test Quick Actions:**
   - Press and hold app icon
   - Verify actions appear in selected language
3. **Verify interface:**
   - Navigate through app
   - Confirm all strings are translated

## 📋 Best Practices

### ✅ Do

- Limit to 4 actions (iOS maximum)
- Use system icons for consistency
- Keep titles concise (2-3 words max)
- Localize all actions in supported languages
- Test in different languages for truncation
- Implement fallback (app should work without Quick Actions)

### ❌ Don't

- Create complex or time-consuming actions
- Require immediate authentication
- Duplicate obvious functionality
- Use custom icons unnecessarily
- Forget to clear `quickActionToHandle` after use
- Leave strings hardcoded without translation

## 🐛 Troubleshooting

**Quick Actions don't appear:**
- ✅ Verify Info.plist is correct
- ✅ Reinstall app (system cache)
- ✅ Test on physical device

**Action is not processed:**
- ✅ Verify SceneDelegate is registered
- ✅ Debug `completionHandler(true)` is called
- ✅ Check NotificationCenter is posting correctly

**App doesn't launch with action:**
- ✅ Verify `application:configurationForConnecting:` is capturing
- ✅ Debug timing of `handleQuickAction()`
- ✅ Use minimal delay before presenting UI

## 📚 Resources

### Apple Documentation
- [UIApplicationShortcutItem](https://developer.apple.com/documentation/uikit/uiapplicationshortcutitem)
- [UIApplicationDelegateAdaptor](https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor)
- [UIApplicationDelegate](https://developer.apple.com/documentation/uikit/uiapplicationdelegate)
- [UIWindowSceneDelegate](https://developer.apple.com/documentation/uikit/uiwindowscenedelegate)

## 👨‍💻 Author

**João Pedro (JP)**

Connect with me:
- 💼 [LinkedIn](https://linkedin.com/in/joaopdrojr) 
- 🌐 [Portfolio](http://joaopdrojr.framer.website)
- 📸 [Instagram](https://www.instagram.com/joaopdro.dev/)
---
