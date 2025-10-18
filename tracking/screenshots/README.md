# Screenshots Directory

This directory stores screenshot evidence for all features implemented during development.

---

## Purpose

Screenshots serve as **proof of completion** for every feature. Nothing is considered complete without screenshot evidence showing the feature working.

---

## Naming Convention

Use descriptive filenames that clearly indicate what the screenshot shows:

```
phase[N]-[feature-name]-[state].png
```

### Examples

**Good** ✅:
- `phase1-task-list-empty.png`
- `phase1-task-list-with-items.png`
- `phase1-add-task-form.png`
- `phase1-add-task-success.png`
- `phase1-add-task-validation-error.png`
- `phase2-categories-picker.png`
- `phase2-task-detail-view.png`

**Bad** ❌:
- `screenshot1.png`
- `IMG_1234.png`
- `test.png`

---

## Organization

### By Phase

Organize screenshots by development phase:

```
screenshots/
├── phase1-task-list.png
├── phase1-add-task.png
├── phase1-delete-task.png
├── phase2-categories.png
├── phase2-search.png
└── phase3-settings.png
```

### By Feature (Alternative)

For larger projects, organize by feature:

```
screenshots/
├── tasks/
│   ├── list-view.png
│   ├── add-task.png
│   ├── edit-task.png
│   └── delete-task.png
├── categories/
│   ├── category-picker.png
│   └── category-management.png
└── settings/
    └── settings-screen.png
```

---

## What to Capture

### Required Screenshots

For each feature, capture:

1. **Default/Empty State**
   - What users see when there's no data
   - Example: Empty task list with "No tasks" message

2. **Populated State**
   - Feature with realistic data
   - Example: Task list with 5-10 tasks

3. **Interaction State**
   - Feature being used
   - Example: Add task form filled out

4. **Success State**
   - Successful completion
   - Example: Task successfully added, appears in list

5. **Error State** (if applicable)
   - Error handling and validation
   - Example: Form validation error messages

---

## Screenshot Quality

### Requirements

- ✅ **Clear and readable** - Text must be legible
- ✅ **Relevant context** - Shows the feature in context
- ✅ **Realistic data** - Use realistic, production-like data
- ✅ **Full screen** - Capture entire relevant area
- ✅ **Proper device** - Use target device size (iPhone 15, etc.)

### Format

- **Format**: PNG (preferred) or JPG
- **Resolution**: Native device resolution
- **Size**: Keep under 5MB per screenshot

---

## Index

Maintain an index of all screenshots:

### Phase 1: Core Features

| Screenshot | Feature | Status | Date |
|------------|---------|--------|------|
| phase1-task-list.png | Task list view | ✅ | 2025-01-20 |
| phase1-add-task.png | Add task form | ✅ | 2025-01-20 |
| phase1-complete-task.png | Complete toggle | ✅ | 2025-01-20 |
| phase1-delete-task.png | Delete task | ✅ | 2025-01-20 |

### Phase 2: Enhanced Features

| Screenshot | Feature | Status | Date |
|------------|---------|--------|------|
| phase2-categories.png | Category picker | ✅ | 2025-01-21 |
| phase2-search.png | Search functionality | ✅ | 2025-01-21 |
| phase2-filters.png | Filter options | 🔄 | Pending |

### Phase 3: Polish

| Screenshot | Feature | Status | Date |
|------------|---------|--------|------|
| phase3-settings.png | Settings screen | ⏳ | Not started |
| phase3-onboarding.png | Onboarding flow | ⏳ | Not started |

---

## Quality Gates

### Before Marking Feature Complete

Every feature must have:
- [ ] Screenshot of default state
- [ ] Screenshot of feature working
- [ ] Screenshot of success case
- [ ] Screenshot of error case (if applicable)
- [ ] Screenshots saved in this directory
- [ ] Screenshots indexed above

---

## Tips

### For iOS

Use Xcode Simulator:
1. Run app on simulator
2. Navigate to feature
3. `Cmd + S` to save screenshot
4. Screenshot saved to Desktop
5. Move to this directory with proper name

### For Web

Use browser dev tools:
1. Open feature in browser
2. `Cmd + Shift + 4` (Mac) for screenshot
3. Or use browser screenshot tools
4. Save to this directory

### For Android

Use Android Emulator:
1. Run app on emulator
2. Navigate to feature
3. Use emulator screenshot button
4. Save to this directory

---

## Notes

- Screenshots are **mandatory** for quality gates
- Keep screenshots updated as features change
- Delete obsolete screenshots
- Reference screenshots in session summaries
- Include screenshots in code reviews

---

**Remember**: If there's no screenshot, the feature isn't complete! 📸
