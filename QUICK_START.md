# MobileBayJubilee - Quick Start Guide

Welcome to your new iOS project created with Claude Dev Workflow!

---

## 🎯 Next Steps (In Order)

### 1. Create Xcode Project File

The directory structure is ready, but you need to create the .xcodeproj file:

**Option A: Create New Project in Xcode** (Recommended)
1. Open Xcode
2. File > New > Project
3. Select: iOS > App
4. Settings:
   - Product Name: `MobileBayJubilee`
   - Team: [Your Team]
   - Organization Identifier: [Your identifier]
   - Interface: SwiftUI
   - Storage: SwiftData
   - Language: Swift
   - Include Tests: Yes
5. **Important**: Save to `/Users/blake/Projects/MobileBayJubilee`
6. **Delete** the auto-generated files:
   - MobileBayJubilee/MobileBayJubileeApp.swift (use the one in App/ folder)
   - MobileBayJubilee/ContentView.swift (use the one in App/ folder)
   - MobileBayJubilee/Item.swift (if generated)
7. **Add** the existing source files to the project:
   - Right-click MobileBayJubilee group > Add Files
   - Add: App/, Models/, Views/, Stores/, Services/, Utilities/, Resources/

**Option B: Manual Setup** (Advanced)
- Create Xcode project configuration manually
- Add all source files and folders
- Configure build settings
- Set up test targets

---

### 2. Verify Project Builds

```bash
cd /Users/blake/Projects/MobileBayJubilee

# Build the project
xcodebuild -project MobileBayJubilee.xcodeproj \
  -scheme MobileBayJubilee \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# Or in Xcode: Cmd+B
```

You should see "Ready to build! ✅" when you run the app.

---

### 3. Review Workflow Documentation

Read these in order:

1. **`claude.md`** (at project root) (5-10 min)
   - Master workflow overview
   - Quick reference guide

2. **`docs/ios-development.md`** (10-15 min)
   - iOS technical standards
   - SwiftUI/SwiftData patterns
   - Code quality guidelines

3. **`docs/project-management.md`** (10 min)
   - Phase-based development
   - Task planning
   - Quality gates

4. **`docs/agent-deployment.md`** (10 min)
   - Multi-agent coordination
   - Role definitions
   - Team structures

---

### 4. Begin Phase 0 Planning

Use Zen tools to plan your project:

**Step 1: Project Breakdown**
```
Use Zen tool: planner

Input: "Plan iOS app: MobileBayJubilee
[Describe your app idea, target users, key features]"

Output: Detailed phase breakdown with tasks and dependencies
```

**Step 2: Architecture Planning**
```
Use Zen tool: thinkdeep

Input: "Design architecture for MobileBayJubilee
Requirements: [Your specific needs]"

Output: Architecture recommendations and decisions
```

**Step 3: Define Features**
- Create list of all features
- Prioritize as P0/P1/P2/P3
- Map to phases
- Update `tracking/phase-status.md`

---

### 5. Track Your Progress

Update these files regularly:

**`tracking/session-state.md`**
- Current work
- Decisions made
- Blockers
- Next steps

**`tracking/phase-status.md`**
- Task progress
- Completed items
- Timeline

**`tracking/mock-data-registry.md`**
- Mock data usage
- Migration plan

**`tracking/screenshots/`**
- Feature evidence
- Proof of completion

---

## 📚 Essential Commands

### Build & Test
```bash
# Build
xcodebuild -project MobileBayJubilee.xcodeproj -scheme MobileBayJubilee build

# Test
xcodebuild test -project MobileBayJubilee.xcodeproj \
  -scheme MobileBayJubilee \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Or in Xcode
# Build: Cmd+B
# Test: Cmd+U
# Run: Cmd+R
```

### Git Workflow
```bash
# Check status
git status

# Stage changes
git add .

# Commit (after quality gates pass!)
git commit -m "Descriptive message"

# View history
git log --oneline
```

---

## ✅ Phase 0 Checklist

Before moving to Phase 1:

- [ ] Xcode project created and builds
- [ ] All workflow documentation reviewed
- [ ] Used Zen `planner` for project breakdown
- [ ] Architecture designed (Zen `thinkdeep`)
- [ ] Data models planned
- [ ] Phase 1-N features defined
- [ ] P1/P2/P3 priorities assigned
- [ ] Mock data strategy created
- [ ] Quality gates understood
- [ ] Team roles assigned (if multi-agent)

---

## 🎓 Learning Resources

### Workflow Guides
- [Master Index](claude.md) (project root)
- [iOS Development](docs/ios-development.md)
- [Project Management](docs/project-management.md)
- [Quality Gates](docs/quality-gates.md)

### Zen MCP Tools
- [Zen Tools Guide](docs/zen-tools-guide.md)
- Tools: planner, thinkdeep, analyze, codereview, debug, precommit

### Technical References
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata/)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

---

## 🆘 Troubleshooting

### "Xcode project won't build"
1. Check file paths are correct
2. Ensure all source files added to target
3. Verify Swift version set to 6.0+
4. Check iOS deployment target is 17.0+

### "Can't find workflow docs"
- Master index: `claude.md` (at project root)
- Detailed docs: `/Users/blake/Projects/MobileBayJubilee/docs/`

### "Lost context between sessions"
- Check `tracking/session-state.md`
- Review git commit history
- Use Zen `chat` with continuation_id

---

## 🎯 Success Criteria

You're ready for Phase 1 when:

✅ Project builds successfully
✅ Tests run (even if minimal)
✅ Architecture documented
✅ All phases planned
✅ P1 features defined clearly
✅ Quality gates understood
✅ Tracking files initialized

---

**Questions?** Review the docs or use Zen `chat` tool for assistance!

**Ready to build something amazing! 🚀**
