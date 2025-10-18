# Project Management - Phase-Based Development

**Version**: 1.0  
**Last Updated**: 2025-01-20

---

## Overview

This document defines a phase-based, iterative development methodology that prioritizes delivering functional features quickly while maintaining quality. Every phase produces working, tested, verified code before moving forward.

---

## Table of Contents

1. [Core Philosophy](#core-philosophy)
2. [Phase Structure](#phase-structure)
3. [Feature Prioritization](#feature-prioritization)
4. [Phase Planning Process](#phase-planning-process)
5. [Task Definition & Tracking](#task-definition--tracking)
6. [Quality Gates](#quality-gates)
7. [Phase Completion Criteria](#phase-completion-criteria)
8. [Mock Data Management](#mock-data-management)
9. [Progress Tracking](#progress-tracking)
10. [Examples](#examples)

---

## Core Philosophy

### Principles

**1. Incremental Delivery**
- Deliver working features in small increments
- Each phase produces functional, tested code
- Users can interact with P1 features quickly

**2. Quality Over Speed**
- Never sacrifice quality for velocity
- All quality gates must pass
- Screenshot evidence required

**3. P1 Features First**
- Minimum viable functionality in Phase 1
- Enhanced features in subsequent phases
- Clear prioritization framework

**4. Continuous Verification**
- Build and test after every major change
- No task complete without verification
- Evidence-based completion

**5. Iterative Refinement**
- Learn from each phase
- Adapt plans based on findings
- Continuous improvement

---

## Phase Structure

### Standard Phase Progression

```
Phase 0: Foundation & Planning
   ↓
Phase 1: Core P1 Features (MVP)
   ↓
Phase 2: Enhanced P1 + P2 Features
   ↓
Phase 3: P3 Features + Polish
   ↓
Phase N: Production Ready
```

---

### Phase 0: Foundation & Planning

**Duration**: 1-2 sessions
**Goal**: Establish project foundation

**Tasks**:
- [ ] Create or review Product Requirements Document (PRD)
- [ ] Project setup and initialization
- [ ] Architecture planning (Zen `thinkdeep`)
- [ ] Technology stack confirmation
- [ ] Data model design
- [ ] Mock data strategy definition
- [ ] Quality gates definition
- [ ] Complete project plan creation (Zen `planner` with PRD)
- [ ] Phase 1-N planning with priorities
- [ ] Risk identification

**Deliverables**:
- Product Requirements Document (PRD.md)
- Project structure created
- Architecture documented
- Data models defined
- Mock data registry initialized
- Complete project plan (all phases)
- Quality gate checklist

**Zen Tools**: `planner`, `thinkdeep`, `analyze`

**Completion Criteria**:
- ✅ Project builds successfully
- ✅ Basic app structure runs
- ✅ All planning documents complete
- ✅ Team understands the plan

---

### Phase 1: Core P1 Features (MVP)

**Duration**: 2-5 sessions (depending on scope)  
**Goal**: Deliver minimum viable functionality

**Characteristics**:
- Essential user flows only
- Basic UI (functional, not polished)
- Mock data acceptable
- Core features work end-to-end

**Example P1 Features (iOS Task App)**:
- User can view list of tasks
- User can add a new task
- User can mark task complete
- User can delete a task
- Data persists (SwiftData)

**Tasks**:
- [ ] Core data models (SwiftData)
- [ ] Basic UI screens
- [ ] Essential navigation
- [ ] CRUD operations
- [ ] Basic error handling
- [ ] Unit tests for core logic
- [ ] Build verification
- [ ] Screenshot evidence

**Deliverables**:
- Working P1 features
- All tests passing
- Screenshot evidence of each feature
- Mock data registry updated
- Documentation updated

**Zen Tools**: `codereview`, `debug`, `precommit`, `apilookup`

**Completion Criteria**:
- ✅ All P1 features functional
- ✅ All tests passing
- ✅ Builds successfully
- ✅ Runs on simulator/browser without crash
- ✅ Screenshots confirm functionality
- ✅ Code reviewed
- ✅ Quality gates passed

---

### Phase 2: Enhanced P1 + P2 Features

**Duration**: 3-6 sessions  
**Goal**: Enhance core features and add secondary features

**Characteristics**:
- Improved UX/UI
- Additional functionality
- Begin real API integration
- Better error handling
- Performance considerations

**Example Phase 2 Features (iOS Task App)**:
- Task categories/tags
- Task search and filter
- Due dates with reminders
- Improved UI with animations
- Task priority levels
- Real API sync (if applicable)

**Tasks**:
- [ ] P2 feature implementation
- [ ] UI/UX enhancements
- [ ] Transition mock data to real APIs
- [ ] Comprehensive error handling
- [ ] Integration tests
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Updated screenshots

**Deliverables**:
- Enhanced P1 features
- Working P2 features
- Real API integration (partial or complete)
- Comprehensive test suite
- Performance metrics
- Updated documentation

**Zen Tools**: `refactor`, `analyze`, `consensus`, `apilookup`

**Completion Criteria**:
- ✅ All P1 enhancements complete
- ✅ All P2 features functional
- ✅ Mock data migration plan executed
- ✅ All tests passing
- ✅ Performance acceptable
- ✅ Screenshots updated
- ✅ Quality gates passed

---

### Phase 3+: Additional Features & Polish

**Duration**: Variable  
**Goal**: Complete feature set and prepare for production

**Characteristics**:
- P3+ features implemented
- No remaining mock data
- Production-ready code
- Comprehensive testing
- Performance optimized
- Security reviewed

**Example Phase 3+ Features**:
- Advanced features
- Analytics integration
- Social sharing
- Export/import functionality
- Advanced settings
- Onboarding flow

**Tasks**:
- [ ] P3+ feature implementation
- [ ] All mock data replaced
- [ ] Comprehensive testing
- [ ] Security audit
- [ ] Performance optimization
- [ ] Accessibility compliance (WCAG/iOS standards)
- [ ] Production build verification
- [ ] App Store/deployment preparation

**Deliverables**:
- Complete feature set
- Production-ready build
- Full test coverage
- Security audit report
- Performance benchmarks
- User documentation
- Deployment guide

**Zen Tools**: `refactor`, `precommit`, `consensus`, `challenge`

**Completion Criteria**:
- ✅ All features complete and tested
- ✅ Zero mock data in production code
- ✅ Production build succeeds
- ✅ All quality gates passed
- ✅ Security reviewed
- ✅ Ready for deployment

---

## Feature Prioritization

### Priority Framework

**P0 (Critical - Phase 0)**
- Project setup
- Architecture decisions
- Foundation work
- Must complete before any features

**P1 (Must-Have - Phase 1)**
- Core functionality
- Essential user flows
- Minimum viable product
- Cannot launch without these

**P2 (Should-Have - Phase 2)**
- Important features
- Significant UX improvements
- Enhances user experience
- Strong business value

**P3 (Nice-to-Have - Phase 3+)**
- Additional features
- Polish and refinement
- Advanced functionality
- Can be added post-launch

**P4 (Future)**
- Future considerations
- Low priority
- May never be implemented
- Good ideas for later

---

### Prioritization Process

**Using Zen `planner` and `consensus`**:

1. **List All Features**
   ```
   Feature: User Authentication
   Feature: Task Management
   Feature: Data Sync
   Feature: Analytics
   Feature: Social Sharing
   etc.
   ```

2. **Use Zen `consensus` for Team Alignment**
   ```
   Coordinator: Proposes priority for each feature
   Architecture Agent: Technical complexity assessment
   Feature Agent: Implementation effort estimate
   All Agents: Vote/discuss
   Coordinator: Makes final decision
   ```

3. **Assign Priorities**
   ```
   P1: User Authentication, Task CRUD
   P2: Categories, Search, Filters
   P3: Social Sharing, Analytics
   P4: Advanced Reporting
   ```

4. **Map to Phases**
   ```
   Phase 1: All P1 features
   Phase 2: Enhanced P1 + P2 features
   Phase 3: P2 completion + P3 features
   ```

---

## Phase Planning Process

### Step 1: Use Zen `planner` with PRD

**Coordinator initiates**:
```
Tool: zen:planner
Input: Product Requirements Document (PRD.md) + Project context
Output: Detailed phase breakdown with dependencies
```

**PRD Review First**:
Before using `planner`, ensure PRD.md is complete with:
- Product vision and goals
- Target users and personas
- Feature list with priorities
- User flows and requirements
- Success metrics
- Technical constraints

**Example Output**:
```markdown
Project: iOS Task Management App
(Based on PRD.md requirements)

Phase 0: Foundation (1-2 sessions)
├─ Step 1: Review and finalize PRD
├─ Step 2: Project setup
├─ Step 3: Data model design
├─ Step 4: Architecture planning
└─ Step 5: Mock data strategy

Phase 1: Core Features (3-4 sessions)
├─ Step 1: Task model (SwiftData)
├─ Step 2: Task list view
├─ Step 3: Add task functionality
├─ Step 4: Delete task functionality
├─ Step 5: Mark complete functionality
└─ Step 6: Testing & verification

Phase 2: Enhanced Features (4-5 sessions)
├─ Step 1: Task categories
├─ Step 2: Search functionality
├─ Step 3: Filters
├─ Step 4: UI improvements
└─ Step 5: API integration
```

---

### Step 2: Define Dependencies

**Use Zen `analyze` to identify**:
- Which tasks must complete before others
- Which tasks can run in parallel
- What are the critical path items

**Example**:
```
Task: Add Task UI
Depends on: Task Model, Basic Navigation
Enables: Edit Task, Task Categories

Task: Task Model
Depends on: SwiftData setup
Enables: All task features
```

---

### Step 3: Assign to Agents

**Coordinator distributes work**:
```
Architecture Agent:
- Task: Design Task model
- Task: Design Category model
- Priority: P1
- Timeline: Session 1

UI Agent:
- Task: Task List View
- Task: Add Task Sheet
- Depends on: Task model complete
- Priority: P1
- Timeline: Session 2

Feature Agent:
- Task: CRUD operations
- Depends on: Task model, UI complete
- Priority: P1
- Timeline: Session 2

Testing Agent:
- Task: Unit tests
- Task: Build verification
- Depends on: Feature implementation
- Priority: P1
- Timeline: Session 2-3
```

---

### Step 4: Define Success Metrics

**For each phase** (aligned with PRD):
- What makes it "done"? (Reference PRD acceptance criteria)
- What tests must pass?
- What screenshots needed?
- What documentation required?
- How does this align with PRD success metrics?

---

## Task Definition & Tracking

### Task Template

```markdown
## Task ID: PROJ-001
**Phase**: 1
**Priority**: P1
**Assigned To**: Architecture Agent
**Status**: Not Started / In Progress / Blocked / Review / Complete

### Description
Create the Task model using SwiftData with all required properties.

### Acceptance Criteria
- [ ] Task model has: title, isCompleted, createdAt, dueDate
- [ ] Proper SwiftData annotations
- [ ] Relationships defined (categories, tags)
- [ ] Model follows iOS development guidelines

### Dependencies
- Depends on: PROJ-000 (SwiftData setup)
- Enables: PROJ-002 (Task list view), PROJ-003 (CRUD operations)

### Deliverables
- [ ] Task.swift file
- [ ] Documentation in code
- [ ] Model diagram (if complex)

### Quality Gates
- [ ] Code follows [iOS Development](./ios-development.md) guidelines
- [ ] Builds successfully
- [ ] Code reviewed (Zen `codereview`)

### Estimated Effort
2 hours

### Actual Effort
[To be filled]

### Notes
[Any important decisions or context]
```

---

### Status Tracking

**Use `tracking/phase-status.md`**:

```markdown
# Project Phase Status

**Current Phase**: Phase 1 - Core Features
**Phase Progress**: 60% (6/10 tasks complete)
**Status**: On Track
**Last Updated**: 2025-01-20 14:30

## Phase 1 Tasks

### Completed ✅
- [x] PROJ-001: Task model (Architecture Agent) ✅
- [x] PROJ-002: Category model (Architecture Agent) ✅
- [x] PROJ-003: Basic navigation (UI Agent) ✅
- [x] PROJ-004: Task list view (UI Agent) ✅
- [x] PROJ-005: Add task UI (UI Agent) ✅
- [x] PROJ-006: CRUD operations (Feature Agent) ✅

### In Progress 🔄
- [ ] PROJ-007: Delete task functionality (Feature Agent)
- [ ] PROJ-008: Mark complete toggle (Feature Agent)

### Not Started ⏳
- [ ] PROJ-009: Unit tests (Testing Agent)
- [ ] PROJ-010: Build verification (Testing Agent)

### Blocked 🚫
None

## Next Session Focus
- Complete PROJ-007, PROJ-008
- Begin PROJ-009, PROJ-010
- Code review of completed work

## Blockers & Risks
None currently

## Screenshots
- Task List: tracking/screenshots/phase1-task-list.png ✅
- Add Task: tracking/screenshots/phase1-add-task.png ✅
- Task Complete: [Pending PROJ-008]
```

---

## Quality Gates

### Task-Level Quality Gates

**Before marking any task complete**:

1. **Code Quality**
   - ✅ Follows relevant guidelines (iOS, Web, etc.)
   - ✅ No linting errors or warnings
   - ✅ Code reviewed (Zen `codereview`)
   - ✅ Meaningful variable/function names
   - ✅ Proper error handling

2. **Functionality**
   - ✅ Feature works as specified
   - ✅ No crashes or critical bugs
   - ✅ Edge cases handled
   - ✅ User flow complete

3. **Testing**
   - ✅ Unit tests written and passing
   - ✅ Integration tests (where applicable)
   - ✅ Manual testing completed

4. **Build Verification**
   - ✅ iOS: `.xcodeproj` builds successfully
   - ✅ iOS: Runs on simulator without crash
   - ✅ Web: Dev server runs, production builds
   - ✅ No build warnings

5. **Evidence**
   - ✅ Screenshot(s) provided
   - ✅ Test results documented
   - ✅ Build logs clean

6. **Documentation**
   - ✅ Code comments (complex logic)
   - ✅ README updated (if needed)
   - ✅ API docs (if applicable)

**See [Quality Gates](./quality-gates.md) for complete checklist**

---

### Phase-Level Quality Gates

**Before completing a phase**:

1. **All Tasks Complete**
   - ✅ Every task in phase meets task-level gates
   - ✅ All tests passing
   - ✅ All builds successful

2. **Integration Verification**
   - ✅ Features work together correctly
   - ✅ No integration issues
   - ✅ Full app builds and runs

3. **Screenshot Evidence**
   - ✅ Every feature has screenshot
   - ✅ Every user flow documented visually
   - ✅ Screenshots in `tracking/screenshots/`

4. **Code Quality**
   - ✅ Comprehensive code review (Zen `codereview`)
   - ✅ Pre-commit checks pass (Zen `precommit`)
   - ✅ No technical debt (or documented if unavoidable)

5. **Documentation**
   - ✅ Phase summary written
   - ✅ Decisions documented
   - ✅ Known issues listed
   - ✅ Next phase planned

6. **Mock Data Status**
   - ✅ Mock data registry updated
   - ✅ Migration plan for Phase 2+
   - ✅ Phase 3+: No mock data remaining

---

## Phase Completion Criteria

### Phase 0: Foundation
- ✅ Project builds and runs
- ✅ Architecture documented
- ✅ All models designed
- ✅ All phases planned
- ✅ Team aligned (Zen `consensus`)

### Phase 1: Core P1 Features
- ✅ All P1 features functional
- ✅ End-to-end user flows work
- ✅ All tests passing
- ✅ Builds and runs on simulator/browser
- ✅ Screenshot of every feature
- ✅ Code reviewed
- ✅ Mock data documented

### Phase 2: Enhanced Features
- ✅ All P1 enhancements complete
- ✅ All P2 features functional
- ✅ Mock data → Real API migration started
- ✅ Performance acceptable
- ✅ All tests passing
- ✅ Screenshots updated

### Phase 3+: Production Ready
- ✅ All features complete
- ✅ Zero mock data in production
- ✅ Production build succeeds
- ✅ Performance optimized
- ✅ Security reviewed
- ✅ Ready for deployment

---

## Mock Data Management

### Throughout Phases

**Phase 1**: Mock data is acceptable
- Use realistic mock data
- Document all mock data sources
- Plan for real data transition

**Phase 2**: Begin real API integration
- Replace critical paths first
- Maintain mock data for non-critical features
- Update mock data registry

**Phase 3**: Eliminate all mock data
- All production code uses real APIs
- Mock data only in tests
- Mock data registry complete

**See [Mock Data Strategy](./mock-data-strategy.md) for details**

---

## Progress Tracking

### Daily Progress Updates

**Coordinator maintains `tracking/phase-status.md`**:
- Current phase and progress percentage
- Completed tasks
- In-progress tasks
- Blocked tasks
- Next steps
- Screenshots

### Session Summary

**End of each session**:
```markdown
# Session Summary: 2025-01-20

**Session Duration**: 3 hours
**Phase**: Phase 1 - Core Features
**Progress**: 60% → 75%

## Completed This Session
- PROJ-007: Delete task functionality ✅
- PROJ-008: Mark complete toggle ✅
- Code review of all features (Zen `codereview`)

## In Progress
- PROJ-009: Unit tests (80% complete)

## Blockers Resolved
- SwiftData delete issue fixed (Zen `debug`)

## Quality Gates
- ✅ Builds successfully
- ✅ All features tested manually
- ✅ Screenshots captured
- ⏳ Unit tests pending completion

## Next Session
- Complete PROJ-009: Unit tests
- Start PROJ-010: Build verification
- Final code review before Phase 1 completion

## Decisions Made
- Decided to use cascade delete for categories
- Confirmed P2 will include task search

## Screenshots
- Delete task: tracking/screenshots/phase1-delete.png
- Complete toggle: tracking/screenshots/phase1-complete.png
```

---

## Examples

### Example 1: iOS Task App - Complete Phase 1 Plan

```markdown
# Phase 1: Core P1 Features - Task Management App

**Goal**: Users can create, view, complete, and delete tasks

**Duration**: 3-4 sessions

**Priority**: P1 (Must-Have)

## Features
1. View list of tasks
2. Add new task
3. Mark task as complete/incomplete
4. Delete task
5. Data persists using SwiftData

## Tasks

### PROJ-001: Task Model
- **Agent**: Architecture Agent
- **Priority**: P1
- **Depends on**: SwiftData setup
- **Deliverables**: Task.swift with SwiftData annotations
- **Quality Gates**: Builds, reviewed

### PROJ-002: Task List View
- **Agent**: UI Agent
- **Priority**: P1
- **Depends on**: PROJ-001
- **Deliverables**: TaskListView.swift
- **Quality Gates**: Builds, runs, screenshot

### PROJ-003: Add Task UI
- **Agent**: UI Agent
- **Priority**: P1
- **Depends on**: PROJ-001
- **Deliverables**: AddTaskView.swift
- **Quality Gates**: Builds, runs, screenshot

### PROJ-004: Task CRUD Logic
- **Agent**: Feature Agent
- **Priority**: P1
- **Depends on**: PROJ-001, PROJ-002, PROJ-003
- **Deliverables**: TaskStore.swift with @Observable
- **Quality Gates**: Logic works, tests pass

### PROJ-005: Unit Tests
- **Agent**: Testing Agent
- **Priority**: P1
- **Depends on**: PROJ-004
- **Deliverables**: TaskTests.swift
- **Quality Gates**: All tests pass

### PROJ-006: Build & Screenshot Verification
- **Agent**: Testing Agent
- **Priority**: P1
- **Depends on**: All above
- **Deliverables**: Build log, screenshots
- **Quality Gates**: Builds clean, screenshots confirm features

## Completion Criteria
- ✅ All 6 tasks complete
- ✅ All features work end-to-end
- ✅ All tests passing
- ✅ Builds successfully
- ✅ Runs on simulator
- ✅ Screenshots confirm all features
- ✅ Code reviewed (Zen `codereview`)
- ✅ Pre-commit checks pass (Zen `precommit`)

## Mock Data
- None needed for Phase 1 (local SwiftData only)

## Success Metrics
- User can perform all CRUD operations
- Data persists across app restarts
- No crashes
- Smooth user experience
```

---

## Best Practices

### Planning
1. Use Zen `planner` for initial breakdown
2. Identify P1 features early
3. Plan all phases upfront
4. Update plan as you learn

### Execution
1. Focus on one phase at a time
2. Complete tasks fully before moving on
3. Never skip quality gates
4. Document decisions

### Quality
1. Test continuously
2. Build frequently
3. Screenshot everything
4. Review before completion (Zen `codereview`)

### Communication
1. Update phase status daily
2. Document blockers immediately
3. Celebrate phase completions
4. Learn from retrospectives (Zen `consensus`)

---

## Related Documentation

- [PRD Template](./PRD.md) - Product Requirements Document
- [Quality Gates](./quality-gates.md) - Completion requirements
- [Agent Deployment](./agent-deployment.md) - Team coordination
- [Session Management](./session-management.md) - Continuity
- [Mock Data Strategy](./mock-data-strategy.md) - Data planning
- [Zen Tools Guide](./zen-tools-guide.md) - Tool usage
- [iOS Development](./ios-development.md) - Technical standards

---

**Last Updated**: 2025-01-20  
**Version**: 1.0  
**Maintained By**: Development Team