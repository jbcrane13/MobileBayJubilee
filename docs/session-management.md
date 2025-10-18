# Session Management - Continuity & Handoffs

**Version**: 1.0  
**Last Updated**: 2025-01-20

---

## Overview

This document defines practices for maintaining context, ensuring continuity across sessions, and enabling smooth handoffs between agents. Effective session management is critical for multi-session projects and multi-agent collaboration.

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [Session State Structure](#session-state-structure)
3. [Starting a Session](#starting-a-session)
4. [During a Session](#during-a-session)
5. [Ending a Session](#ending-a-session)
6. [Agent Handoffs](#agent-handoffs)
7. [Context Recovery](#context-recovery)
8. [Zen Tools for Continuity](#zen-tools-for-continuity)
9. [Session Templates](#session-templates)
10. [Troubleshooting](#troubleshooting)

---

## Core Principles

### 1. **Comprehensive State Documentation**
Every session must document:
- What was done
- Why decisions were made
- What's next
- Current blockers
- Project context

### 2. **Continuation ID Usage**
- Use Zen `chat` with `continuation_id` parameter
- Maintains conversation history
- Preserves context across sessions
- Enables seamless resumption

### 3. **Explicit Handoff Protocol**
- Clear transfer of responsibility
- Comprehensive context provided
- No assumptions about prior knowledge
- Verification of understanding

### 4. **State Persistence**
- Session state files in `tracking/`
- Git commits with descriptive messages
- Documentation updates
- Screenshot archives

### 5. **Recovery Mechanisms**
- Every session can be reconstructed
- Multiple sources of truth
- Clear escalation paths
- Human intervention when needed

---

## Session State Structure

### Primary State File: `tracking/session-state.md`

```markdown
# Session State

**Last Updated**: 2025-01-20 15:45
**Current Phase**: Phase 1 - Core Features
**Phase Progress**: 75%
**Active Agents**: Coordinator, Feature Agent, Testing Agent

---

## Current Context

### What We're Building
iOS Task Management App using SwiftUI, SwiftData, and Swift Concurrency.
Target: iOS 17+

### Current Phase Goal
Deliver core P1 features: Create, Read, Update, Delete tasks with persistence.

### Where We Are
- Task model: Complete ✅
- Task list UI: Complete ✅
- Add task: Complete ✅
- CRUD logic: Complete ✅
- Unit tests: In Progress (80%) 🔄
- Build verification: Not Started ⏳

---

## Recent Decisions

### Decision Log
1. **2025-01-20 14:00** - Architecture Decision
   - Decision: Use @Observable instead of traditional MVVM
   - Rationale: Better SwiftUI integration, less boilerplate
   - Made by: Coordinator + Architecture Agent
   - Tool used: Zen `consensus`

2. **2025-01-20 14:30** - Data Model Decision
   - Decision: Task relationships use cascade delete
   - Rationale: Simplifies data management
   - Made by: Architecture Agent
   - Reviewed by: Coordinator

3. **2025-01-20 15:00** - Testing Decision
   - Decision: Defer UI tests to Phase 2
   - Rationale: P1 focuses on unit tests only
   - Made by: Coordinator
   - Tool used: Zen `planner`

---

## Active Tasks

### In Progress
**PROJ-009: Unit Tests** (Testing Agent)
- Status: 80% complete
- Blockers: None
- Expected completion: This session
- Next: Complete remaining test cases

### Pending
**PROJ-010: Build Verification** (Testing Agent)
- Status: Not started
- Depends on: PROJ-009
- Next: Build on simulator, capture screenshots

---

## Blockers & Issues

### Current Blockers
None

### Recently Resolved
1. SwiftData delete cascade issue
   - Resolved: 2025-01-20 14:45
   - Solution: Used @Relationship(deleteRule: .cascade)
   - Tool used: Zen `debug`

---

## Mock Data Status

### Current Mock Data
None (using SwiftData for local persistence)

### Migration Plan
Phase 2 will add cloud sync with real API.

See: `tracking/mock-data-registry.md`

---

## Quality Gates Status

### Phase 1 Gates
- [x] Code follows iOS guidelines
- [x] Builds successfully
- [x] Features work end-to-end
- [ ] All tests passing (pending PROJ-009)
- [ ] Screenshots captured (pending PROJ-010)
- [ ] Code review complete (pending)

---

## Next Steps

### Immediate (This Session)
1. Complete PROJ-009: Unit tests
2. Start PROJ-010: Build verification
3. Capture all screenshots

### Next Session
1. Final code review (Zen `codereview`)
2. Pre-commit verification (Zen `precommit`)
3. Complete Phase 1
4. Plan Phase 2

---

## Files Modified This Session
- Sources/Models/Task.swift
- Sources/Stores/TaskStore.swift
- Tests/TaskTests.swift
- tracking/session-state.md (this file)
- tracking/phase-status.md

---

## Screenshots
- Task list: tracking/screenshots/phase1-task-list.png ✅
- Add task: tracking/screenshots/phase1-add-task.png ✅
- Complete task: tracking/screenshots/phase1-complete.png ✅
- Delete task: tracking/screenshots/phase1-delete.png ✅

---

## Agent Notes

### Coordinator Notes
Phase 1 is nearly complete. Only testing remains. Quality looks good.
Consider accelerating Phase 2 planning.

### Testing Agent Notes
Unit tests straightforward. Found minor edge case in delete logic (fixed).
Build verification next.

### Architecture Agent Notes
Data model stable. No changes anticipated for Phase 2.

---

## Continuation Context

**For Next Session/Agent**:
We are 95% complete with Phase 1. All features work, just finishing tests.
Next agent should:
1. Complete unit tests (mostly done)
2. Run build verification
3. Do final code review
4. Mark Phase 1 complete
5. Begin Phase 2 planning

**Zen Continuation ID**: [Store continuation_id here if using Zen chat]

---

## Emergency Recovery Info

**Project Root**: /path/to/project
**Git Branch**: main
**Last Commit**: abc123 "Complete task CRUD operations"
**Build Last Successful**: 2025-01-20 15:30
**Tests Last Passed**: 2025-01-20 15:00
```

---

## Starting a Session

### Step 1: Load Context

**Coordinator Agent Starts Every Session**:

```
1. Read tracking/session-state.md
2. Read tracking/phase-status.md
3. Review last git commits
4. Check for new issues/blockers
5. Use Zen chat with continuation_id if available
```

**Using Zen Tools**:
```yaml
Tool: zen:chat
Parameters:
  model: "gemini-2.5-pro"
  prompt: "Load project context and provide current status summary"
  continuation_id: "[previous_session_id]"
  files: 
    - "tracking/session-state.md"
    - "tracking/phase-status.md"
  working_directory: "/path/to/project"
```

---

### Step 2: Verify Understanding

**Coordinator Self-Check**:
- ✅ I understand the current phase
- ✅ I know what's complete
- ✅ I know what's in progress
- ✅ I know the blockers
- ✅ I know next steps

**If unclear**: Ask clarifying questions before proceeding

---

### Step 3: Communicate Status

**Post to team**:
```markdown
## Session Start: 2025-01-20 16:00

**Current Status**: Phase 1 at 75% completion
**Active Work**: Unit tests (80% done)
**Next Steps**: Complete tests, build verification
**Blockers**: None
**Expected Completion**: This session

All agents: Review tracking/session-state.md for context.
```

---

### Step 4: Confirm Agent Availability

**Check which agents are active**:
- Coordinator (you) ✅
- Architecture Agent - available?
- Feature Agent - available?
- UI Agent - available?
- Testing Agent - needed ✅

**Assign or reassign as needed**

---

## During a Session

### Continuous State Updates

**Update `session-state.md` after**:
- Major decisions (log in Decision Log)
- Task completions
- Blocker discoveries or resolutions
- File modifications
- Test results
- Build results

**Frequency**: Every 30-60 minutes or after significant milestones

---

### Decision Documentation

**Every important decision gets logged**:

```markdown
### Decision: [Short Title]
- **Date/Time**: 2025-01-20 16:30
- **Decision**: [What was decided]
- **Rationale**: [Why this decision]
- **Made by**: [Agent name(s)]
- **Tool used**: [Zen tool if applicable]
- **Impact**: [What this affects]
- **Alternatives considered**: [Other options]
```

---

### Progress Tracking

**Update `tracking/phase-status.md`**:
```markdown
## Phase 1 Progress: 75% → 85%

### Just Completed
- [x] PROJ-009: Unit tests ✅ (16:30)

### Now Working On
- [ ] PROJ-010: Build verification (in progress)

### Updated Files
- Tests/TaskTests.swift
- tracking/session-state.md
```

---

### Communication Pattern

**Regular status updates**:
```
Every 1-2 hours:
Coordinator: "Status check - any blockers?"
Agents: Report progress
Coordinator: Adjusts plan if needed
```

---

## Ending a Session

### Step 1: Complete Session Summary

**Coordinator creates summary**:

```markdown
# Session Summary: 2025-01-20

**Duration**: 16:00 - 19:00 (3 hours)
**Phase**: Phase 1 - Core Features
**Starting Progress**: 75%
**Ending Progress**: 95%

---

## Accomplishments
- ✅ Completed PROJ-009: Unit tests (all passing)
- ✅ Completed PROJ-010: Build verification (success)
- ✅ Captured all screenshots
- ✅ Build runs clean on simulator

---

## What's Working Well
- All P1 features functional
- No crashes
- Clean build
- Good test coverage (85%)

---

## Pending Items
- [ ] Final code review (Zen `codereview`)
- [ ] Pre-commit check (Zen `precommit`)
- [ ] Mark Phase 1 complete

---

## Blockers
None

---

## Decisions Made This Session
1. Confirmed Phase 1 ready for final review
2. Scheduled Phase 2 planning for next session

---

## Next Session Plan
1. Run Zen `codereview` on all Phase 1 code
2. Run Zen `precommit` verification
3. Mark Phase 1 complete
4. Begin Phase 2 with Zen `planner`

---

## Files Modified
- Tests/TaskTests.swift (added 15 test cases)
- tracking/session-state.md (updated)
- tracking/phase-status.md (updated)
- tracking/screenshots/ (added 4 images)

---

## Git Commits
- abc456: "Complete unit tests for task CRUD"
- abc457: "Add build verification and screenshots"
- abc458: "Update session tracking"

---

## Handoff Notes
Phase 1 is essentially complete. All features work, all tests pass, builds clean.
Next session just needs final review and sign-off. Should be quick.

Phase 2 planning can begin immediately after Phase 1 completion.

---

## Continuation ID
[Save Zen chat continuation_id here: cont_abc123xyz]
```

---

### Step 2: Update All Tracking Files

**Files to update**:
- ✅ `tracking/session-state.md`
- ✅ `tracking/phase-status.md`
- ✅ `tracking/session-summaries/2025-01-20.md` (create new)
- ✅ `README.md` (if major changes)

---

### Step 3: Commit to Git

```bash
git add .
git commit -m "Session end: Phase 1 95% complete - tests and build verified

- Completed unit tests (all passing)
- Verified build on simulator
- Captured all screenshots
- Ready for final code review

Next: Final review and Phase 1 sign-off"
```

---

### Step 4: Save Continuation Context

**For Zen tools**:
```markdown
Continuation ID for next session: cont_abc123xyz

To resume:
Tool: zen:chat
Parameters:
  continuation_id: "cont_abc123xyz"
  prompt: "Resume Phase 1 completion - need final review"
  files: ["tracking/session-state.md"]
```

---

## Agent Handoffs

### Scenario 1: Same Agent, Next Session

**Handoff is to yourself later**:

1. **Update session-state.md comprehensively**
2. **Write clear "Next Steps"**
3. **Save continuation_id**
4. **Commit all changes**

**Next session, you just load and continue**

---

### Scenario 2: Different Agent, Same Role

**Example: Feature Agent A → Feature Agent B**

**Agent A Prepares Handoff**:

```markdown
## Handoff to Next Feature Agent

**Context**: Implementing task categories (Phase 2, PROJ-201)

**What I Completed**:
- Created Category model (SwiftData)
- Added relationship to Task
- Updated TaskStore to handle categories

**Current State**:
- Code: 70% complete
- Location: Sources/Models/Category.swift, Sources/Stores/TaskStore.swift
- Tests: Not yet written
- Build: Successful
- Status: Working, but needs category UI integration

**What's Next**:
1. UI Agent needs to create category picker UI
2. Then: Add category assignment to AddTaskView
3. Then: Filter tasks by category in list
4. Then: Write tests

**Blockers**:
None, but waiting on UI Agent for category picker

**Important Notes**:
- Used cascade delete for category relationships
- Category has name, color, and icon properties
- Max 10 categories per user (business rule)

**Files**:
- Sources/Models/Category.swift
- Sources/Models/Task.swift (updated)
- Sources/Stores/TaskStore.swift (updated)

**Continuation ID**: cont_feature_xyz789

**Zen Tools Used**:
- `analyze` for data model design
- `codereview` for relationship verification
```

**Agent B Receives**:
1. Reads handoff notes
2. Loads continuation_id
3. Reviews modified files
4. Asks questions if unclear
5. Acknowledges understanding
6. Continues work

---

### Scenario 3: Agent Role Change

**Example: Feature Agent → Testing Agent**

**Feature Agent**:
```markdown
## Handoff to Testing Agent

**Task Complete**: PROJ-205 - Task category assignment

**What Was Built**:
- Users can now assign categories to tasks
- Category picker in AddTaskView
- Filter by category in TaskListView
- All features working

**Testing Needed**:
1. Unit tests for category assignment
2. Unit tests for category filtering
3. Unit tests for edge cases:
   - Task with no category
   - Deleting category with tasks
   - Max category limit
4. Build verification
5. Screenshots of category features

**Test Data Scenarios**:
- Create task with category
- Create task without category
- Change task category
- Delete category (should cascade)
- Filter by category (empty results)
- Filter by category (multiple tasks)

**Expected Results**:
All tests should pass, build clean, features work smoothly

**Quality Gates to Verify**:
See quality-gates.md checklist

**Files to Test**:
- Sources/Models/Category.swift
- Sources/Models/Task.swift
- Sources/Stores/TaskStore.swift
- Sources/Views/AddTaskView.swift
- Sources/Views/TaskListView.swift

**Mock Data**:
None needed - using SwiftData

**Continuation ID**: cont_test_abc456
```

---

## Context Recovery

### When Context is Lost

**Recovery Steps**:

1. **Check Git History**
   ```bash
   git log --oneline -20
   git show HEAD
   git diff HEAD~5
   ```

2. **Review Session State Files**
   ```
   cat tracking/session-state.md
   cat tracking/phase-status.md
   ls tracking/session-summaries/
   ```

3. **Review Phase Documentation**
   ```
   Understand current phase goal
   Check what's supposed to be complete
   Identify gaps
   ```

4. **Use Zen `analyze`**
   ```yaml
   Tool: zen:analyze
   Parameters:
     model: "gemini-2.5-pro"
     step: "Analyze project state and identify what was being worked on"
     files: 
       - "tracking/session-state.md"
       - [all source files]
     working_directory: "/path/to/project"
   ```

5. **Rebuild Mental Model**
   - What phase are we in?
   - What's the phase goal?
   - What's complete?
   - What's in progress?
   - What's next?

6. **Verify Understanding**
   - Build the project
   - Run tests
   - Review recent commits
   - Check screenshots

7. **Document Recovery**
   ```markdown
   ## Context Recovery: 2025-01-20

   **Issue**: Continuation ID lost, unclear state
   
   **Recovery Actions**:
   1. Reviewed git history
   2. Read session-state.md
   3. Used Zen `analyze` on codebase
   4. Built project successfully
   5. Ran tests (all passing)
   
   **Current Understanding**:
   Phase 1 at 95%, needs final review
   
   **Confidence**: High
   
   **Next Steps**:
   Proceeding with code review
   ```

---

## Zen Tools for Continuity

### Using `chat` with continuation_id

**Best for**: Maintaining conversation context

```yaml
Tool: zen:chat
Parameters:
  model: "gemini-2.5-pro"
  prompt: "Continue working on task categories feature"
  continuation_id: "cont_previous_session"
  files:
    - "tracking/session-state.md"
  working_directory: "/path/to/project"
```

**Benefits**:
- Preserves full conversation history
- Maintains decision context
- Reduces need for re-explanation

---

### Using `analyze` for State Assessment

**Best for**: Understanding current codebase state

```yaml
Tool: zen:analyze
Parameters:
  model: "gemini-2.5-pro"
  step: "Analyze current implementation status of task categories"
  relevant_files:
    - "Sources/Models/Category.swift"
    - "Sources/Stores/TaskStore.swift"
  findings: "Need to understand what's complete and what's pending"
  next_step_required: true
  working_directory: "/path/to/project"
```

---

### Using `planner` for Next Steps

**Best for**: Planning continuation of work

```yaml
Tool: zen:planner
Parameters:
  model: "gemini-2.5-pro"
  step: "Given current Phase 1 status, plan next steps to completion"
  next_step_required: false
  working_directory: "/path/to/project"
```

---

## Session Templates

### Template 1: Starting a New Phase

```markdown
# Session Start: New Phase

**Date**: [Date]
**Phase**: [Phase Number] - [Phase Name]
**Goal**: [Phase goal]

## Context Loaded
- [x] Read session-state.md
- [x] Read phase-status.md
- [x] Reviewed prior phase completion
- [x] Loaded continuation_id (if available)

## Understanding Check
- [x] I understand the phase goal
- [x] I know the P1/P2/P3 features for this phase
- [x] I understand dependencies
- [x] I know quality gates for this phase

## Initial Planning
Using Zen `planner` to break down phase into tasks...

[Planner output here]

## Agent Assignment
- Coordinator: [Name] ✅
- Architecture: [Name] 
- Feature: [Name]
- UI: [Name]
- Testing: [Name]

## First Tasks
1. [Task 1]
2. [Task 2]
3. [Task 3]

## Session Goals
By end of this session:
- [ ] Goal 1
- [ ] Goal 2
- [ ] Goal 3
```

---

### Template 2: Continuing In-Progress Work

```markdown
# Session Start: Continuation

**Date**: [Date]
**Phase**: [Current Phase]
**Progress**: [X%]

## Context Loaded
- [x] Read session-state.md
- [x] Loaded continuation_id: [ID]
- [x] Reviewed last session summary
- [x] Checked for new blockers

## Current State
**In Progress**:
- [Task 1]: [Status]
- [Task 2]: [Status]

**Blocked**:
- [Any blockers]

**Pending**:
- [Upcoming tasks]

## This Session Focus
1. [Primary goal]
2. [Secondary goal]
3. [Tertiary goal]

## Expected Outcomes
- [ ] [Expected outcome 1]
- [ ] [Expected outcome 2]
```

---

### Template 3: Agent Handoff

```markdown
# Agent Handoff

**From**: [Agent Name/Role]
**To**: [Agent Name/Role]
**Date**: [Date]
**Task**: [Task ID] - [Task Name]

## Context
[Brief description of what's being handed off]

## Work Completed
- [Item 1]
- [Item 2]
- [Item 3]

## Current State
- **Status**: [Percentage or description]
- **Location**: [Files/directories]
- **Build**: [Success/Failure]
- **Tests**: [Status]

## What's Next
1. [Next step 1]
2. [Next step 2]
3. [Next step 3]

## Important Notes
- [Note 1]
- [Note 2]

## Blockers
- [Blocker 1 or "None"]

## Quality Gates Status
- [ ] Code quality
- [ ] Tests passing
- [ ] Build successful
- [ ] Screenshots

## Files Modified
- [File 1]
- [File 2]

## Continuation ID
[Zen continuation ID if applicable]

## Questions for Receiving Agent
1. [Question 1]
2. [Question 2]

---

**Receiving Agent Acknowledgment**:
- [ ] I have read and understood this handoff
- [ ] I have reviewed the modified files
- [ ] I have loaded the continuation context
- [ ] I am ready to proceed
- [ ] I have clarifying questions: [Yes/No]
```

---

## Troubleshooting

### Problem: Cannot find continuation_id

**Solution**:
1. Check tracking/session-state.md
2. Check last session summary
3. Review git commit messages
4. Use Zen `analyze` to rebuild context
5. Proceed without continuation_id (document this)

---

### Problem: Session state contradicts code

**Solution**:
1. Trust the code (source of truth)
2. Build and test to verify actual state
3. Update session-state.md to match reality
4. Document the discrepancy
5. Investigate cause to prevent recurrence

---

### Problem: Unclear what was being worked on

**Solution**:
1. Check git diff
2. Review recent commits
3. Run tests to see what's covered
4. Use Zen `analyze` on modified files
5. Ask human for clarification if needed

---

### Problem: Multiple agents worked simultaneously

**Solution**:
1. Review all session summaries
2. Check for merge conflicts
3. Use git log to understand changes
4. Consolidate session states
5. Update to unified current state

---

## Best Practices

### For All Agents

1. **Update session-state.md frequently**
   - After decisions
   - After completions
   - Before long breaks
   - At session end

2. **Use continuation_ids consistently**
   - Save after every session
   - Reference in next session
   - Document in session summaries

3. **Write clear handoff notes**
   - Assume reader knows nothing
   - Provide complete context
   - List explicit next steps

4. **Verify understanding**
   - Don't assume
   - Ask questions
   - Acknowledge receipt

5. **Document decisions**
   - Why, not just what
   - Alternatives considered
   - Impact assessment

### For Coordinators

1. **Own session state**
   - You are responsible for accuracy
   - You ensure completeness
   - You verify continuity

2. **Start every session with context load**
   - Never skip this step
   - Verify understanding
   - Update team

3. **End every session with summary**
   - Comprehensive
   - Clear next steps
   - Handoff ready

4. **Use Zen tools for orchestration**
   - `planner` for organization
   - `chat` for continuity
   - `consensus` for alignment

---

## Related Documentation

- [Project Management](./project-management.md) - Phase planning
- [Agent Deployment](./agent-deployment.md) - Team coordination
- [Quality Gates](./quality-gates.md) - Completion criteria
- [Zen Tools Guide](./zen-tools-guide.md) - Tool usage
- [Main Index](../claude.md) - Complete workflow

---

**Last Updated**: 2025-01-20  
**Version**: 1.0  
**Maintained By**: Development Team