# Xcode Project Setup Instructions

**Project**: JubileeHub (MobileBayJubilee)
**Created**: 2025-10-18
**Phase**: P0-003a - Xcode Project Initialization
**Status**: Manual setup required in Xcode

---

## Current Status

The iOS project structure and Swift files have been created, but the `.xcodeproj` file must be created manually in Xcode. This document provides step-by-step instructions.

**What's Already Done**:
- Directory structure created
- SwiftData models created (User, JubileeReport, ConditionData, Location)
- App entry point created (MobileBayJubileeApp.swift)
- TabView-based ContentView created
- .gitignore configured

**What's Needed**:
- Create .xcodeproj file in Xcode
- Configure build settings
- Add all Swift files to project
- Verify project builds successfully

---

## Step-by-Step Instructions

### Step 1: Open Xcode

1. Launch Xcode (version 15.0 or later required)
2. Click "Create New Project" or File → New → Project

### Step 2: Choose Template

1. Select **iOS** as the platform
2. Choose **App** template
3. Click **Next**

### Step 3: Configure Project

**Product Name**: `MobileBayJubilee`

**Team**: Select your development team (or "None" for now)

**Organization Identifier**: `com.jubilee` (or your preferred reverse-domain)
- Full Bundle ID will be: `com.jubilee.MobileBayJubilee`

**Interface**: **SwiftUI**

**Language**: **Swift**

**Storage**: **SwiftData**

**Include Tests**: **YES** (check both Unit and UI Tests)

Click **Next**

###Step 4: Save Location

**CRITICAL**: Save the project in the existing directory structure:

1. Navigate to: `/Users/blake/Projects/MobileBayJubilee`
2. **DO NOT** create a new folder
3. **IMPORTANT**: Uncheck "Create Git repository" (already exists)
4. Click **Create**

### Step 5: Delete Auto-Generated Files

Xcode will create some files we don't need (we already have better versions):

1. In the Project Navigator (left sidebar), locate and **DELETE** these files:
   - `MobileBayJubileeApp.swift` (we have a better one in App/)
   - `ContentView.swift` (we have a better one in App/)
   - `Item.swift` (we don't need this)

2. When prompted, choose **Move to Trash** (not just remove reference)

### Step 6: Add Existing Files to Project

Now add our pre-created files:

**Add App Files**:
1. Right-click on `MobileBayJubilee` group in Project Navigator
2. Select **Add Files to "MobileBayJubilee"...**
3. Navigate to `MobileBayJubilee/App/`
4. Select:
   - `MobileBayJubileeApp.swift`
   - `ContentView.swift`
5. **Ensure**: "Copy items if needed" is **UNCHECKED** (files are already in place)
6. **Ensure**: "Create groups" is selected
7. Click **Add**

**Add Model Files**:
1. Right-click on `MobileBayJubilee` group
2. Select **Add Files to "MobileBayJubilee"...**
3. Navigate to `MobileBayJubilee/Models/`
4. Select ALL model files:
   - `User.swift`
   - `JubileeReport.swift`
   - `ConditionData.swift`
   - `Location.swift`
5. **Ensure**: "Copy items if needed" is **UNCHECKED**
6. **Ensure**: "Create groups" is selected (will create Models folder)
7. Click **Add**

### Step 7: Organize Project Structure

Create groups to match our folder structure:

1. In Project Navigator, create these groups (New Group):
   - App (move MobileBayJubileeApp.swift and ContentView.swift here)
   - Models (move all model files here)
   - Views (empty for now)
   - Stores (empty for now)
   - Services (empty for now)
   - Utilities (empty for now)
   - Resources (empty for now)

2. Your Project Navigator should look like:
   ```
   MobileBayJubilee
   ├── App
   │   ├── MobileBayJubileeApp.swift
   │   └── ContentView.swift
   ├── Models
   │   ├── User.swift
   │   ├── JubileeReport.swift
   │   ├── ConditionData.swift
   │   └── Location.swift
   ├── Views
   ├── Stores
   ├── Services
   ├── Utilities
   ├── Resources
   └── Assets.xcassets
   ```

### Step 8: Configure Build Settings

1. Click on the **MobileBayJubilee** project (blue icon at top)
2. Select the **MobileBayJubilee** target
3. Go to **General** tab

**Deployment Info**:
- **Minimum Deployments**: iOS 17.0
- **iPhone Orientation**: Portrait, Landscape Left, Landscape Right
- **iPad Orientation**: All
- **Status Bar Style**: Default
- **Hide status bar**: NO

**App Icons and Launch Screen**:
- Leave default for now (will add in Phase 1)

4. Go to **Build Settings** tab

Search for and configure:
- **Swift Language Version**: Swift 6
- **iOS Deployment Target**: 17.0

### Step 9: Configure Capabilities

1. Go to **Signing & Capabilities** tab
2. **Automatically manage signing**: Check this (for development)
3. **Team**: Select your team (or add Apple ID if needed)

### Step 10: Build and Run

1. Select a simulator: **iPhone 15** (or latest available)
2. Press **Cmd+B** to build
3. Wait for build to complete (should succeed)
4. Press **Cmd+R** to run
5. App should launch in simulator with TabView showing 4 tabs:
   - Dashboard (blue gauge icon)
   - Map (green map icon)
   - Community (purple chat bubbles icon)
   - Profile (orange person icon)

### Step 11: Take Screenshot

1. Once app is running successfully, take a screenshot:
   - In Simulator: Cmd+S (saves to Desktop)
2. Move screenshot to: `tracking/screenshots/P0-003a-xcode-project-init.png`

### Step 12: Commit to Git

```bash
cd /Users/blake/Projects/MobileBayJubilee
git add .
git status  # Verify what's being added
git commit -m "P0-003a: Initialize Xcode project with SwiftData models

- Created MobileBayJubilee.xcodeproj
- Configured iOS 17.0+ target with Swift 6
- Added SwiftData models: User, JubileeReport, ConditionData, Location
- Implemented TabView navigation structure
- Project builds successfully on iPhone 15 simulator

Phase 0: 4/12 tasks complete (33%)

Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Troubleshooting

### Build Errors After Adding Files

**Error**: "Cannot find 'User' in scope"
- **Solution**: Make sure all model files are added to the target
- Check: Project Navigator → Select file → File Inspector (right sidebar) → Target Membership → Ensure "MobileBayJubilee" is checked

**Error**: "No such module 'SwiftData'"
- **Solution**: Check iOS Deployment Target is set to 17.0 or later
- SwiftData requires iOS 17.0+

**Error**: "Fatalizable initializer 'init(for:configurations:)' has not been used"
- **Solution**: This is normal during initial setup
- Will resolve once the app runs and creates the database

### Simulator Issues

**Simulator won't launch**:
1. Quit Xcode
2. Quit Simulator
3. Run: `xcrun simctl erase all` (WARNING: Deletes all simulator data)
4. Reopen Xcode and try again

**App crashes on launch**:
1. Check Console for error messages
2. Most likely: SwiftData model issue
3. Verify all @Model classes are properly defined

---

## Verification Checklist

Before marking P0-003a complete:

- [ ] Xcode project created (MobileBayJubilee.xcodeproj exists)
- [ ] Project opens in Xcode without errors
- [ ] All Swift files added to target
- [ ] Project structure organized (App/, Models/, etc.)
- [ ] Build settings configured (iOS 17.0+, Swift 6)
- [ ] Project builds successfully (Cmd+B)
- [ ] App runs on simulator (Cmd+R)
- [ ] TabView displays all 4 tabs correctly
- [ ] Screenshot saved to tracking/screenshots/
- [ ] Changes committed to git
- [ ] phase-status.md updated (P0-003a marked complete)

---

## Next Steps

After completing this setup:

1. Update `tracking/phase-status.md`:
   - Mark P0-003a as complete
   - Update progress to 4/12 (33%)

2. Continue with Phase 0:
   - P0-002a: Backend Architecture Decision
   - P0-004a: Legal Documentation
   - P0-005a: Design System & Style Guide

3. Phase 1 (Feb 2026):
   - Begin implementing actual Dashboard view
   - Create network layer for API calls
   - Implement SwiftData persistence

---

## File Locations Reference

**Xcode Project**:
- `/Users/blake/Projects/MobileBayJubilee/MobileBayJubilee.xcodeproj`

**Swift Files**:
- App: `/Users/blake/Projects/MobileBayJubilee/MobileBayJubilee/App/`
- Models: `/Users/blake/Projects/MobileBayJubilee/MobileBayJubilee/Models/`

**Documentation**:
- This file: `/Users/blake/Projects/MobileBayJubilee/XCODE-SETUP.md`
- Phase status: `/Users/blake/Projects/MobileBayJubilee/tracking/phase-status.md`

**Git**:
- Repository: `/Users/blake/Projects/MobileBayJubilee/.git`
- Ignore file: `/Users/blake/Projects/MobileBayJubilee/.gitignore`

---

## Support

**Issues**: Review tracking/session-state.md for current context
**Documentation**: See docs/ for workflow guidelines
**API Research**: See tracking/P0-001-API-Research-Report.md

---

**Created by**: Claude Code (Phase 0 Execution)
**Date**: 2025-10-18
**Version**: 1.0
