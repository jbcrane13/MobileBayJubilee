# MobileBayJubilee

iOS application built using the Claude Dev Workflow.

---

## 📱 Project Info

- **Platform**: iOS 17.0+
- **Language**: Swift 6.0+
- **UI Framework**: SwiftUI
- **Data**: SwiftData
- **Architecture**: Model-View with @Observable
- **Concurrency**: Swift Concurrency (async/await)

---

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0+
- macOS 14.0+
- iOS 17.0+ Simulator or Device

### Setup

1. Open `MobileBayJubilee.xcodeproj` in Xcode
2. Select your target device/simulator
3. Press `Cmd+R` to build and run

### First Steps

1. Review `claude.md` (project root) for workflow overview
2. Check `tracking/phase-status.md` for current phase
3. Read `docs/ios-development.md` for iOS standards
4. Follow phase-based development process

---

## 📁 Project Structure

```
MobileBayJubilee/
├── MobileBayJubilee.xcodeproj
├── claude.md                   # Master workflow (PROJECT ROOT)
├── README.md
├── MobileBayJubilee/
│   ├── App/                    # Application entry point
│   ├── Models/                 # SwiftData models
│   ├── Views/                  # SwiftUI views
│   ├── Stores/                 # @Observable stores
│   ├── Services/               # Business logic & APIs
│   ├── Utilities/              # Helpers & extensions
│   └── Resources/              # Assets, strings, etc.
├── Tests/                      # Unit tests
├── UITests/                    # UI tests
├── tracking/                   # Development tracking
│   ├── session-state.md
│   ├── phase-status.md
│   ├── mock-data-registry.md
│   └── screenshots/
└── docs/                       # Detailed documentation
    ├── PRD.md
    ├── ios-development.md
    ├── project-management.md
    └── ...
```

---

## 📋 Development Workflow

### Phase-Based Development

```
Phase 0: Foundation & Planning
   ↓
Phase 1: Core P1 Features (MVP)
   ↓
Phase 2: Enhanced Features
   ↓
Phase 3+: Production Ready
```

### Current Status

**Phase**: [Update in tracking/phase-status.md]
**Progress**: [X%]
**Status**: [On Track / At Risk / Blocked]

---

## ✅ Quality Gates

Before marking any task complete:

- [ ] Code follows iOS development guidelines
- [ ] All tests passing
- [ ] Builds successfully on simulator
- [ ] Screenshot evidence provided
- [ ] Code reviewed
- [ ] Documentation updated

---

## 🧪 Testing

### Run Tests

```bash
# Run all tests
xcodebuild test -project MobileBayJubilee.xcodeproj -scheme MobileBayJubilee -destination 'platform=iOS Simulator,name=iPhone 15'

# Run in Xcode
Cmd+U
```

### Test Coverage

Target: ≥ 70% for Phase 1, ≥ 80% for production

---

## 📸 Screenshots

All feature screenshots stored in `tracking/screenshots/`

Required for every completed feature!

---

## 📚 Documentation

- [Master Workflow](claude.md) - Complete workflow reference (project root)
- [iOS Development](docs/ios-development.md) - iOS technical standards
- [Project Management](docs/project-management.md) - Phase planning
- [Quality Gates](docs/quality-gates.md) - Completion criteria
- [Testing Guidelines](docs/testing-guidelines.md) - Testing standards

---

## 🔧 Development Tools

### Zen MCP Tools

Use throughout development:
- `planner` - Project breakdown
- `analyze` - Codebase analysis
- `codereview` - Quality verification
- `debug` - Issue resolution
- `precommit` - Final checks

See [Zen Tools Guide](docs/zen-tools-guide.md)

---

## 🤝 Contributing

Follow the Claude Dev Workflow:

1. Review current phase in `tracking/phase-status.md`
2. Pick a task from phase plan
3. Follow iOS development guidelines
4. Write tests
5. Ensure all quality gates pass
6. Provide screenshot evidence
7. Update tracking files

---

## 📝 License

[Your License Here]

---

## 🆘 Support

- Review documentation in `docs/`
- Check `tracking/session-state.md` for current context
- See `tracking/phase-status.md` for progress

---

**Built with Claude Dev Workflow v2.0**
