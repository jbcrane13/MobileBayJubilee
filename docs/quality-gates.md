# Quality Gates - Completion Criteria

**Version**: 1.0  
**Last Updated**: 2025-01-20

---

## Overview

This document defines the mandatory quality gates that must pass before marking any task, feature, or phase as complete. **Nothing is complete until all relevant quality gates pass.**

---

## Core Principle

> **If it doesn't build, run, and show proof via screenshot, it's not complete.**

---

## Task-Level Quality Gates

### Required for EVERY Task

**1. Code Quality** ✅
- [ ] Follows relevant guidelines ([iOS Dev](./ios-development.md), Web, etc.)
- [ ] No compiler errors
- [ ] No linting warnings (or documented exceptions)
- [ ] Meaningful variable/function names
- [ ] Code comments on complex logic
- [ ] No hardcoded values (use constants/config)
- [ ] No force unwrapping (`!`) unless justified
- [ ] Proper error handling (no silent failures)
- [ ] Code reviewed (Zen `codereview` passed)

**2. Functionality** ✅
- [ ] Feature works as specified
- [ ] All user stories/requirements met
- [ ] Edge cases handled gracefully
- [ ] Error states display properly
- [ ] User flow complete end-to-end
- [ ] No crashes during normal use
- [ ] Performance acceptable
- [ ] Accessibility labels present

**3. Testing** ✅
- [ ] Unit tests written for business logic
- [ ] Unit tests passing (100% of tests)
- [ ] Integration tests (where applicable)
- [ ] Manual testing completed
- [ ] Test coverage ≥ 70% for new code
- [ ] Edge cases tested
- [ ] Error handling tested

**4. Build Verification** ✅

**iOS Specific**:
- [ ] `.xcodeproj` builds successfully
- [ ] No build warnings (or documented)
- [ ] Runs on iOS Simulator
- [ ] App launches without crash
- [ ] Feature accessible via navigation
- [ ] Clean build log

**Web Specific**:
- [ ] Development server runs
- [ ] Production build succeeds
- [ ] No console errors
- [ ] Works in target browsers

**5. Evidence & Documentation** ✅
- [ ] **Screenshot(s) provided** showing feature working
- [ ] Screenshot saved in `tracking/screenshots/`
- [ ] Screenshot filename descriptive (e.g., `phase1-add-task.png`)
- [ ] Test results documented
- [ ] Build log clean (or issues documented)
- [ ] Code comments for complex sections
- [ ] README updated (if public API changes)

**6. Integration** ✅
- [ ] Integrates cleanly with existing code
- [ ] No merge conflicts
- [ ] Doesn't break other features
- [ ] Dependencies updated (if needed)
- [ ] Mock data tracking updated

**7. Session Management** ✅
- [ ] Session state updated
- [ ] Decisions documented
- [ ] Task marked complete in tracking
- [ ] Git commit with clear message

---

## Feature-Level Quality Gates

### Before Marking Feature Complete

**All Task Gates Above**, PLUS:

**1. Complete User Flow** ✅
- [ ] Entire feature works end-to-end
- [ ] All user stories completed
- [ ] Happy path functional
- [ ] Error paths handled
- [ ] Navigation complete
- [ ] Data persists correctly (if applicable)

**2. Comprehensive Testing** ✅
- [ ] All features have unit tests
- [ ] Integration tests between components
- [ ] UI tests for critical flows (optional Phase 1)
- [ ] Manual testing on all scenarios
- [ ] Edge cases verified

**3. Multiple Screenshots** ✅
- [ ] Screenshot of each screen/state
- [ ] Screenshot of success case
- [ ] Screenshot of error case (if applicable)
- [ ] Screenshots show feature working

**4. Code Review** ✅
- [ ] Zen `codereview` tool used
- [ ] All findings addressed
- [ ] Second pair of eyes (if team)
- [ ] Architecture approved

**5. Performance** ✅
- [ ] No performance regressions
- [ ] Acceptable load times
- [ ] Smooth animations/transitions
- [ ] Efficient data fetching

---

## Phase-Level Quality Gates

### Before Completing Any Phase

**All Feature Gates Above**, PLUS:

**1. Phase Completeness** ✅
- [ ] All planned features implemented
- [ ] All P1/P2/P3 features (as planned for phase)
- [ ] No incomplete work
- [ ] No placeholders or TODOs in production code

**2. Integration Verification** ✅
- [ ] All features work together
- [ ] No integration bugs
- [ ] Full app builds clean
- [ ] Full app runs without issues
- [ ] All navigation flows work

**3. Comprehensive Quality** ✅
- [ ] Zen `codereview` on all phase code
- [ ] Zen `precommit` passed
- [ ] All tests passing (no skipped tests)
- [ ] Test coverage meets target (≥ 70%)
- [ ] No critical or high severity bugs

**4. Screenshot Evidence** ✅
- [ ] Every feature has screenshots
- [ ] Every user flow documented visually
- [ ] Screenshots organized by feature
- [ ] Screenshot index created

**5. Documentation** ✅
- [ ] Phase summary written
- [ ] Key decisions documented
- [ ] Known issues listed (if any)
- [ ] Mock data status updated
- [ ] Next phase planned

**6. Mock Data Status** ✅
- [ ] Phase 1: Mock data documented
- [ ] Phase 2: Migration plan exists
- [ ] Phase 3+: No mock data remaining (except tests)

**7. Performance & Quality** ✅
- [ ] No memory leaks
- [ ] No performance regressions
- [ ] Accessibility audit passed
- [ ] Security review (if applicable)

---

## iOS-Specific Quality Gates

### Before ANY iOS Task/Feature/Phase Complete

**Build Verification** ✅
```bash
# Must succeed:
xcodebuild -project MyApp.xcodeproj \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# Expected: BUILD SUCCEEDED
# Any warnings: Documented or fixed
```

**Simulator Verification** ✅
```bash
# Must launch and run:
xcodebuild -project MyApp.xcodeproj \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  test  # if tests exist

# OR manual launch on simulator:
# 1. Open simulator
# 2. Install app
# 3. Launch app
# 4. Navigate to feature
# 5. Verify feature works
# 6. Take screenshot
```

**SwiftUI Previews** ✅
- [ ] All new views have previews
- [ ] Previews render without errors
- [ ] Previews show relevant states

**SwiftData Verification** ✅
- [ ] Models build correctly
- [ ] Relationships work as expected
- [ ] Queries return expected data
- [ ] CRUD operations succeed
- [ ] No data corruption

**Swift Concurrency** ✅
- [ ] All async functions use async/await
- [ ] No completion handlers
- [ ] MainActor used for UI updates
- [ ] No data races (Swift 6 when available)
- [ ] Task cancellation handled

**Observation Framework** ✅
- [ ] Uses `@Observable` (not ObservableObject)
- [ ] No `@Published` properties
- [ ] `@State` for ownership
- [ ] `@Bindable` for editing
- [ ] `@Environment` for shared state

---

## Web-Specific Quality Gates

### Before ANY Web Task/Feature/Phase Complete

**Build Verification** ✅
```bash
# Development build:
npm run dev
# Must start without errors

# Production build:
npm run build
# Must complete successfully
# No build errors
# No critical warnings
```

**Browser Verification** ✅
- [ ] Chrome: Feature works
- [ ] Safari: Feature works (if iOS target)
- [ ] Firefox: Feature works (if specified)
- [ ] No console errors
- [ ] No console warnings (or documented)

**Accessibility** ✅
- [ ] Semantic HTML used
- [ ] ARIA labels where needed
- [ ] Keyboard navigation works
- [ ] Screen reader compatible
- [ ] Color contrast meets WCAG AA

---

## Testing Quality Gates

### Test Requirements

**Unit Tests** ✅
- [ ] Every public function tested
- [ ] Business logic coverage ≥ 80%
- [ ] Edge cases covered
- [ ] Error cases tested
- [ ] All tests passing
- [ ] No flaky tests

**Integration Tests** ✅ (Phase 2+)
- [ ] Component integration tested
- [ ] API integration tested
- [ ] Data flow tested
- [ ] All tests passing

**UI Tests** ✅ (Phase 3+)
- [ ] Critical user flows tested
- [ ] Happy path verified
- [ ] Error handling verified
- [ ] All tests passing

---

## Screenshot Requirements

### What Constitutes Valid Screenshot Evidence

**Required Elements** ✅
- [ ] Clear, readable screenshot
- [ ] Shows feature in action
- [ ] Includes relevant UI context
- [ ] No placeholder data (use realistic mock data)
- [ ] Timestamp or session noted
- [ ] Descriptive filename

**Screenshot Checklist** ✅
- [ ] Feature in default state
- [ ] Feature in action (if interactive)
- [ ] Success state (if applicable)
- [ ] Error state (if applicable)
- [ ] Multiple device sizes (if responsive)

**Screenshot Storage** ✅
```
tracking/screenshots/
├── phase1-task-list.png
├── phase1-add-task.png
├── phase1-task-complete.png
├── phase1-task-delete.png
├── phase2-categories.png
└── README.md (screenshot index)
```

---

## Documentation Quality Gates

### Required Documentation

**Code Documentation** ✅
- [ ] Complex algorithms commented
- [ ] Public APIs documented
- [ ] Important decisions noted
- [ ] Non-obvious code explained

**Project Documentation** ✅
- [ ] README.md up-to-date
- [ ] Setup instructions accurate
- [ ] Dependencies documented
- [ ] Known issues listed

**Session Documentation** ✅
- [ ] Session state updated
- [ ] Phase status current
- [ ] Decisions logged
- [ ] Next steps clear

---

## Zen Tool Verification

### Required Tool Usage

**Before Task Complete** ✅
- [ ] Zen `codereview` run
- [ ] All findings addressed or documented
- [ ] Quality issues resolved

**Before Phase Complete** ✅
- [ ] Zen `codereview` on all code
- [ ] Zen `precommit` verification passed
- [ ] All findings addressed
- [ ] Quality acceptable

---

## Quality Gate Checklist Template

### Copy/Paste for Each Task

```markdown
## Quality Gate Checklist: [Task ID]

### Code Quality
- [ ] Follows iOS/Web guidelines
- [ ] No errors or warnings
- [ ] Code reviewed (Zen)
- [ ] Meaningful names
- [ ] Proper error handling

### Functionality
- [ ] Works as specified
- [ ] Edge cases handled
- [ ] No crashes
- [ ] User flow complete

### Testing
- [ ] Unit tests written
- [ ] All tests passing
- [ ] Coverage ≥ 70%
- [ ] Manual testing done

### Build
iOS:
- [ ] .xcodeproj builds
- [ ] Runs on simulator
- [ ] No crashes on launch

Web:
- [ ] Dev server runs
- [ ] Production builds
- [ ] No console errors

### Evidence
- [ ] Screenshot(s) provided
- [ ] Test results documented
- [ ] Build log clean

### Integration
- [ ] Integrates cleanly
- [ ] No merge conflicts
- [ ] Doesn't break existing features

### Documentation
- [ ] Session state updated
- [ ] Decisions documented
- [ ] Task marked complete
```

---

## Enforcement

### Who Enforces Quality Gates

**Coordinator Agent**:
- Primary responsibility
- Reviews all completion claims
- Verifies evidence
- Approves or rejects

**Testing Agent**:
- Runs tests
- Verifies builds
- Captures screenshots
- Reports results

**All Agents**:
- Self-check before claiming complete
- Provide evidence
- Address findings

---

### What Happens if Gates Fail

**Immediate Actions**:
1. Task remains "In Progress"
2. Failing gates documented
3. Issues logged
4. Assigned back to responsible agent

**Recovery**:
1. Agent fixes issues
2. Re-runs quality gates
3. Provides updated evidence
4. Coordinator re-reviews

**No Shortcuts**:
- Cannot skip gates
- Cannot partially complete
- Cannot defer critical issues
- Quality is non-negotiable

---

## Examples

### Example 1: Task Completion - iOS Add Task Feature

```markdown
## Task: PROJ-003 - Add Task UI

### Quality Gate Results:

✅ Code Quality
- Follows iOS development guidelines
- No errors or warnings
- Zen codereview passed (score: 9/10)
- All variables meaningfully named
- Proper error handling for empty task name

✅ Functionality
- User can add task with name
- Validation prevents empty names
- Task appears in list immediately
- SwiftData saves successfully
- Error message shows for invalid input

✅ Testing
- Unit tests: 8/8 passing (100%)
- Coverage: 85%
- Edge cases tested (empty, long name, special chars)
- Manual testing: Pass

✅ Build (iOS)
- .xcodeproj builds successfully
- Runs on iPhone 15 simulator
- No crashes on launch or during use
- Feature accessible from main screen

✅ Evidence
- Screenshot: tracking/screenshots/phase1-add-task.png
- Shows: Add task sheet, validation, success
- Test results: All 8 tests passing
- Build log: Clean

✅ Integration
- Integrates with TaskStore
- No conflicts with existing code
- TaskListView updates automatically

✅ Documentation
- Code comments on validation logic
- Session state updated
- Decision to use sheet (not full screen) documented

**RESULT**: ✅ ALL GATES PASSED - TASK COMPLETE
```

---

### Example 2: Phase Completion - Phase 1

```markdown
## Phase 1 Completion: Core Features

### All Task Gates: ✅ Passed (6/6 tasks)

### Phase-Level Gates:

✅ Completeness
- All P1 features implemented
- No incomplete work
- No TODOs in production code

✅ Integration
- All features work together
- Full app builds clean
- All navigation flows work
- No integration bugs found

✅ Quality
- Zen codereview: Phase-wide (score: 8.5/10)
- Zen precommit: Passed
- All tests passing (48/48)
- Coverage: 78%

✅ Screenshots
- 12 screenshots total
- Every feature documented
- Every flow captured
- Index created: tracking/screenshots/README.md

✅ Documentation
- Phase summary: docs/phase1-summary.md
- Decisions logged: 8 major decisions
- Known issues: None
- Phase 2 planned: Yes

✅ Mock Data
- No mock data needed (local only)
- SwiftData working correctly

✅ Performance
- No memory leaks (Instruments verified)
- Smooth animations
- Fast data operations

**RESULT**: ✅ ALL GATES PASSED - PHASE 1 COMPLETE
```

---

## Related Documentation

- [Testing Guidelines](./testing-guidelines.md) - Testing details
- [Project Management](./project-management.md) - Phase planning
- [Session Management](./session-management.md) - State tracking
- [Zen Tools Guide](./zen-tools-guide.md) - Tool usage
- [iOS Development](./ios-development.md) - Technical standards
- [Main Index](../claude.md) - Complete workflow

---

**Last Updated**: 2025-01-20  
**Version**: 1.0