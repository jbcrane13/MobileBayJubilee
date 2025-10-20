# 📱 Mobile Bay Jubilee Tracker

An iOS app that helps the Mobile Bay community monitor, report, and predict jubilee events - rare natural phenomena unique to Mobile Bay, Alabama, where marine life (crabs, flounder, shrimp) moves to the shoreline in massive numbers due to low oxygen conditions.

## 🌊 What is a Jubilee?

A Mobile Bay jubilee occurs when specific environmental conditions (wind direction, temperature, tide, oxygen levels) create a hypoxic zone that drives marine life to shore. These events are:
- **Rare**: Only happens a few times per year
- **Unpredictable**: Requires specific environmental conditions
- **Time-sensitive**: Typically occur in early morning hours (2-6 AM)
- **Localized**: Specific to the eastern shore of Mobile Bay

## ✨ Key Features

**Phase 1 (Current):**
- 📊 **Live Condition Monitoring**: Real-time environmental data with jubilee likelihood scoring
- 🗺️ **Interactive Map**: Community-reported sightings with verification system
- 🔔 **Smart Alerts**: Customizable notifications based on condition thresholds
- 👥 **Community Feed**: Share reports, photos, and updates with other watchers
- ⭐ **Reputation System**: Verified watcher badges for trusted reporters
- 🔐 **Sign in with Apple**: Secure authentication

**Upcoming Features:**
- 💬 Real-time event chat rooms
- 📈 Historical data and trend analysis
- 🎯 Favorite location tracking
- 🌡️ Advanced weather pattern integration
- 📸 Photo sharing with reports

## 🛠️ Technology Stack

**Frontend:**
- SwiftUI (iOS 17+)
- SwiftData for local persistence
- MapKit for interactive mapping
- CoreLocation for GPS tracking

**Backend:**
- Firebase Authentication (Sign in with Apple)
- Cloud Firestore (real-time database)
- Firebase Cloud Functions (upcoming)
- Firebase Cloud Messaging (push notifications)

**Architecture:**
- MVVM pattern
- Protocol-oriented design
- Reactive state management with ObservableObject
- Comprehensive test coverage (46/48 tests passing)

## 🏗️ Project Structure

```
MobileBayJubilee/
├── App/                    # App initialization and configuration
├── Models/                 # Data models (SwiftData + Firestore)
├── Views/                  # SwiftUI views
│   ├── Dashboard/         # Main condition monitoring
│   ├── Map/               # Interactive jubilee map
│   ├── Community/         # Community feed
│   └── Profile/           # User settings and reputation
├── Services/              # Business logic and Firebase integration
│   ├── FirebaseService.swift
│   ├── LocationService.swift
│   ├── ReputationManager.swift
│   └── ConditionScoreService.swift
├── Utilities/             # Extensions and helpers
└── Tests/                 # Unit and UI tests
```

## 🚀 Getting Started

1. **Prerequisites:**
   - Xcode 15.0+
   - iOS 17.0+ device or simulator
   - Firebase account (for backend integration)

2. **Setup:**
   ```bash
   git clone https://github.com/blakecrane/MobileBayJubilee.git
   cd MobileBayJubilee
   ```

3. **Firebase Configuration:**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Download `GoogleService-Info.plist` and add to project
   - Enable Authentication, Firestore, and Cloud Messaging
   - See `FIREBASE-SETUP-CHECKLIST.md` for detailed instructions

4. **Build and Run:**
   - Open `MobileBayJubilee.xcodeproj` in Xcode
   - Select your target device/simulator
   - Press ⌘R to build and run

## 🧪 Testing

Run the comprehensive test suite:
```bash
xcodebuild test -project MobileBayJubilee.xcodeproj \
  -scheme MobileBayJubilee \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

**Test Coverage:**
- Alert level calculations
- Condition scoring algorithms
- Reputation system logic
- UI navigation and interactions
- 46/48 tests passing ✅

## 🔐 Security & Privacy

- **Privacy-First**: Location data never leaves your device without consent
- **Anonymous Reporting**: Optional - users can report without account
- **Secure Authentication**: Sign in with Apple (no passwords stored)
- **Data Encryption**: All Firebase data encrypted in transit and at rest
- **Community Moderation**: Verified watcher system prevents spam

## 📊 Jubilee Condition Scoring

The app uses a sophisticated scoring algorithm based on scientific research:

- **Seasonal Factors** (0-20 pts): Peak season July-September
- **Time Window** (0-20 pts): Optimal 2-6 AM window
- **Wind Patterns** (0-20 pts): South/southeast wind direction
- **Tide Phase** (0-15 pts): Rising tide optimal
- **Water Quality** (0-15 pts): Temperature, salinity, dissolved oxygen
- **Weather Patterns** (0-10 pts): Recent weather stability

**Score Interpretation:**
- 90-100: **Confirmed** - Active jubilee reported
- 70-89: **Watch** - High probability conditions
- 40-69: **Quiet** - Normal conditions
- 0-39: **None** - Unlikely conditions

## 🤝 Contributing

Contributions are welcome! This project follows:
- iOS development best practices
- SwiftUI design patterns
- Comprehensive testing requirements
- Code review process with automated validation

See `docs/CONTRIBUTING.md` for guidelines.

## 📝 Development Workflow

This project uses a rigorous development workflow:
- **Phase-based development** with clear milestones
- **Zen MCP tools** for code review and validation
- **4 rounds of expert review** before any commit
- **Zero-tolerance** for compilation errors/warnings
- **Quality gates** at every phase

See `CLAUDE.md` for complete development workflow documentation.

## 🗺️ Roadmap

- [x] **Phase 1**: Core functionality (Dashboard, Map, Community, Profile)
- [ ] **Phase 2**: Real-time chat and enhanced notifications
- [ ] **Phase 3**: Historical data analysis and trend prediction
- [ ] **Phase 4**: ML-based jubilee prediction model
- [ ] **Phase 5**: Public launch and community growth

## 📄 License

[Add your license here - e.g., MIT, Apache 2.0, etc.]

## 👥 Authors

- Blake Crane - *Initial work*
- Built with assistance from Claude Code

## 🙏 Acknowledgments

- Mobile Bay community for domain knowledge
- Alabama Marine Resources Division for environmental data
- Firebase team for excellent backend infrastructure
- SwiftUI community for best practices

## 📞 Contact

- Email: blake.crane@gmail.com
- Issues: [GitHub Issues](https://github.com/blakecrane/MobileBayJubilee/issues)

---

**⭐ Star this repo if you find it useful!**

**🦀 Join the Mobile Bay Jubilee community and never miss an event!**
