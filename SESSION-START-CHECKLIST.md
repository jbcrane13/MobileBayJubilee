# Session Start Checklist

**Purpose**: Ensure every session follows quality standards and maintains context continuity.

**Status**: MANDATORY - Read this BEFORE starting any work in a new session.

---

## 1. Session Context Loading ✅

- [ ] **Load Previous Session State**
  - Review `tracking/phase-status.md` for current phase/sprint
  - Check `tracking/quality-gates-log.md` for compliance status
  - Review last session's git commits and open todos
  - Load any Zen continuation IDs if resuming complex work

- [ ] **Identify Current Work**
  - What sprint/phase are we in?
  - What tasks are in-progress vs pending?
  - Are there any blockers or dependencies?
  - What was accomplished in the last session?

---

## 2. Quality Gate Awareness 🚨

**READ AND ACKNOWLEDGE BEFORE PROCEEDING:**

### Git Safety Protocol (MANDATORY)

- [ ] **I understand**: `precommit` validation MUST run BEFORE every commit
- [ ] **I understand**: `codereview` MUST run for significant code changes
- [ ] **I understand**: Build must succeed (zero errors/warnings) before commit
- [ ] **I understand**: Screenshot evidence required for UI changes

### Quality Gate Sequence

```
Code Change → Build Verify → precommit → codereview (if complex) → Commit → Push
```

**NO EXCEPTIONS. Skipping quality gates = Process Failure.**

---

## 3. Todo List Structure 📋

When creating todos for commits, ALWAYS use this structure:

```markdown
CORRECT:
- [ ] Complete feature X implementation
- [ ] Run precommit validation for feature X
- [ ] Run codereview for feature X (if complex)
- [ ] Commit feature X (blocked until validations pass)

INCORRECT:
- [ ] Implement and commit feature X
```

**Quality gates must be explicit, separate todo items.**

---

## 4. Session Setup Verification ✅

- [ ] **Review CLAUDE.md Critical Quality Gates Section**
  - Location: `CLAUDE.md` → "🚨 CRITICAL QUALITY GATES 🚨"
  - Confirm understanding of precommit workflow
  - Confirm understanding of commit message requirements

- [ ] **Check for Pending Validations**
  - Review `tracking/quality-gates-log.md`
  - Are there any retroactive validations needed?
  - Are there any failed quality gates from previous sessions?

- [ ] **Verify Development Environment**
  - Xcode project builds successfully
  - No uncommitted changes (unless intentional)
  - Git branch is correct (`main` or feature branch)

---

## 5. Session Goals & Planning 🎯

- [ ] **Define Session Objectives**
  - What specific tasks will be completed this session?
  - What quality gates will be required?
  - Are there any dependencies or blockers?

- [ ] **Create Todo List with Quality Gates**
  - Use TodoWrite to create task list
  - Include precommit/codereview steps for all commits
  - Estimate time for quality gate validations

- [ ] **Identify Success Criteria**
  - What deliverables mark session completion?
  - What evidence is needed (screenshots, test results)?
  - What documentation needs updating?

---

## 6. Workflow Reference 📚

**Key Documents**:
- `CLAUDE.md` - Master workflow index
- `docs/session-management.md` - Session continuity guidelines
- `docs/quality-gates.md` - Quality gate requirements
- `tracking/phase-status.md` - Current phase/sprint status
- `tracking/quality-gates-log.md` - Compliance tracking

**Zen Tools Workflow**:
- Planning: `planner`, `thinkdeep`
- Development: `chat`, `clink`, `apilookup`
- Quality: `codereview`, `precommit`, `debug`
- Validation: `analyze`, `challenge`

---

## 7. Session Start Confirmation ✅

**Before proceeding with work, confirm:**

- [ ] I have loaded previous session context
- [ ] I understand all quality gate requirements
- [ ] I have created todos with explicit quality gate steps
- [ ] I know what success looks like for this session
- [ ] I have reviewed the compliance log and know pending items

**If ANY checkbox is unchecked, STOP and complete it before proceeding.**

---

## Checklist Compliance Log

| Session Date | Context Loaded? | Quality Gates Reviewed? | Todos Created? | Success Criteria Defined? |
|--------------|-----------------|------------------------|----------------|---------------------------|
| 2025-10-20   | ✅              | ✅                     | ✅             | ✅                        |

---

**Last Updated**: 2025-10-20
**Version**: 1.0
**Status**: ACTIVE - Use this checklist at the start of EVERY session

**Next Session**: Start by reading this file top-to-bottom, then proceed with work.
