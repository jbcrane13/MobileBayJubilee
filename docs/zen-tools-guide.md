# Zen MCP Tools Guide

**Version**: 1.0  
**Last Updated**: 2025-01-20

---

## Overview

This guide explains how to effectively use Zen MCP tools throughout the development workflow. Each tool has specific use cases and best practices for maximum effectiveness.

---

## Available Zen Tools

| Tool | Primary Use | Phase | Agent Type |
|------|-------------|-------|------------|
| `planner` | Project breakdown, task planning | Phase 0, All | Coordinator |
| `thinkdeep` | Complex problem analysis | Phase 0, When needed | All |
| `analyze` | Codebase analysis, understanding | All phases | All |
| `codereview` | Code quality verification | Before completion | Coordinator, Testing |
| `debug` | Issue resolution, root cause | When issues arise | All |
| `precommit` | Final verification before commit | Before marking complete | Coordinator, Testing |
| `refactor` | Code improvement opportunities | Phase 2+ | All |
| `consensus` | Multi-agent decision making | Major decisions | Coordinator |
| `challenge` | Question assumptions | Critical decisions | Coordinator |
| `apilookup` | API documentation, best practices | During development | All |
| `chat` | General assistance, continuity | Throughout | All |
| `clink` | Link to external AI CLIs | Special cases | Coordinator |

---

## Tool Descriptions & Usage

### `planner` - Project Planning

**When to Use**:
- Start of project (Phase 0)
- Start of each new phase
- When breaking down complex features
- When dependencies are unclear

**How to Use**:
```yaml
Tool: zen:planner
Parameters:
  model: "gemini-2.5-pro"  # or "gpt-5-pro"
  step: "Break down iOS task management app Phase 1 into detailed tasks with dependencies"
  total_steps: 1  # Usually 1 for planning
  step_number: 1
  next_step_required: false
  working_directory: "/path/to/project"
```

**Example Output**:
```markdown
Phase 1: Core Task Management

Task 1: Data Models (SwiftData)
├─ Task.swift model
├─ Category.swift model
└─ Relationships defined

Task 2: Observable Stores
├─ TaskStore.swift
├─ @Observable implementation
└─ CRUD methods

Task 3: UI Views
├─ TaskListView.swift
├─ AddTaskView.swift
└─ Navigation setup

Dependencies:
Task 2 depends on Task 1
Task 3 depends on Task 2
```

**Best Practices**:
- Provide complete project context
- Specify phase clearly
- Ask for dependencies explicitly
- Request parallel work opportunities
- Get time estimates

---

### `thinkdeep` - Deep Analysis

**When to Use**:
- Architecture decisions
- Complex technical problems
- Performance challenges
- Design pattern selection
- Security considerations

**How to Use**:
```yaml
Tool: zen:thinkdeep
Parameters:
  model: "gemini-2.5-pro"
  step: "Analyze best state management approach for complex iOS app with real-time sync"
  findings: "Considering @Observable vs TCA vs Redux pattern"
  hypothesis: "@Observable may be sufficient for this use case"
  confidence: "medium"
  relevant_files:
    - "docs/ios-development.md"
  step_number: 1
  total_steps: 2
  next_step_required: true
  working_directory: "/path/to/project"
```

**Best Practices**:
- Frame as specific question
- Provide context and constraints
- State your current hypothesis
- Request pros/cons analysis
- Ask for recommendation

---

### `analyze` - Codebase Analysis

**When to Use**:
- Understanding existing code
- Identifying code smells
- Finding patterns
- Performance analysis
- Architecture review

**How to Use**:
```yaml
Tool: zen:analyze
Parameters:
  model: "gemini-2.5-pro"
  step: "Analyze TaskStore.swift for potential issues and improvements"
  findings: "Initial review shows clean structure, want deeper analysis"
  relevant_files:
    - "Sources/Stores/TaskStore.swift"
  files_checked:
    - "Sources/Stores/TaskStore.swift"
  analysis_type: "quality"  # or architecture, performance, security
  step_number: 1
  total_steps: 1
  next_step_required: false
  working_directory: "/path/to/project"
```

**Best Practices**:
- Specify analysis_type
- Provide relevant files only
- Ask specific questions
- Request actionable feedback

---

### `codereview` - Code Quality Review

**When to Use**:
- Before marking task complete
- Before phase completion
- After major feature implementation
- When quality concerns exist

**How to Use**:
```yaml
Tool: zen:codereview
Parameters:
  model: "gemini-2.5-pro"
  step: "Review Phase 1 implementation for iOS best practices and quality"
  findings: "All features work, tests pass, need quality verification"
  relevant_files:
    - "Sources/Models/Task.swift"
    - "Sources/Stores/TaskStore.swift"
    - "Sources/Views/TaskListView.swift"
    - "Sources/Views/AddTaskView.swift"
  files_checked:
    - [all source files]
  review_type: "full"  # or security, performance, quick
  step_number: 1
  total_steps: 2  # 1 for review, 1 for expert validation
  next_step_required: true
  working_directory: "/path/to/project"
```

**Best Practices**:
- Review complete features
- Include all related files
- Specify review focus
- Check against guidelines
- Address all findings

---

### `debug` - Issue Resolution

**When to Use**:
- Build failures
- Test failures
- Runtime crashes
- Unexpected behavior
- Performance issues

**How to Use**:
```yaml
Tool: zen:debug
Parameters:
  model: "gemini-2.5-pro"
  step: "App crashes when deleting task with category. Investigating root cause."
  findings: "Crash occurs in TaskStore.deleteTask. Error mentions SwiftData relationship."
  hypothesis: "Missing cascade delete rule on relationship"
  confidence: "high"
  relevant_files:
    - "Sources/Models/Task.swift"
    - "Sources/Models/Category.swift"
    - "Sources/Stores/TaskStore.swift"
  files_checked:
    - [files reviewed so far]
  issues_found:
    - severity: "critical"
      type: "crash"
      description: "App crashes on task delete when task has category"
  step_number: 1
  total_steps: 3
  next_step_required: true
  working_directory: "/path/to/project"
```

**Best Practices**:
- Provide error messages
- Include stack traces
- State what you've tried
- Narrow down scope
- Request step-by-step solution

---

### `precommit` - Pre-Commit Verification

**When to Use**:
- Before every git commit
- Before marking task complete
- Before phase completion
- Quality gate verification

**How to Use**:
```yaml
Tool: zen:precommit
Parameters:
  model: "gemini-2.5-pro"
  step: "Verify Phase 1 completion readiness - all tasks complete, tests pass"
  findings: "All features implemented, tests passing, builds clean"
  path: "/path/to/project"  # Repository root
  include_staged: true
  include_unstaged: false
  relevant_files:
    - [all modified files]
  step_number: 1
  total_steps: 3  # Analysis, follow-ups, summary
  next_step_required: true
  working_directory: "/path/to/project"
```

**Best Practices**:
- Run before every commit
- Check both staged and unstaged
- Verify all quality gates
- Fix all issues found
- Document what was verified

---

### `refactor` - Code Improvement

**When to Use**:
- Code smells identified
- Technical debt accumulation
- Performance optimization needed
- Code duplication
- After feature completion

**How to Use**:
```yaml
Tool: zen:refactor
Parameters:
  model: "gemini-2.5-pro"
  step: "Identify refactoring opportunities in task management views"
  findings: "Some code duplication in add/edit task views"
  relevant_files:
    - "Sources/Views/AddTaskView.swift"
    - "Sources/Views/EditTaskView.swift"
  refactor_type: "codesmells"  # or decompose, modernize, organization
  confidence: "complete"
  step_number: 1
  total_steps: 1
  next_step_required: false
  working_directory: "/path/to/project"
```

**Best Practices**:
- Refactor working code only
- Test before and after
- One refactoring at a time
- Keep tests passing
- Document improvements

---

### `consensus` - Team Alignment

**When to Use**:
- Conflicting opinions
- Major architectural decisions
- Technology selection
- Prioritization disputes
- Resource allocation

**How to Use**:
```yaml
Tool: zen:consensus
Parameters:
  model: "gemini-2.5-pro"
  step: "Should we use SwiftData or Core Data for this project?"
  models:
    - model: "gemini-2.5-pro"
      stance: "for"  # For SwiftData
      stance_prompt: "Argue for SwiftData as modern, type-safe choice"
    - model: "gpt-5-pro"
      stance: "against"  # For Core Data
      stance_prompt: "Argue for Core Data as battle-tested, flexible"
    - model: "claude-sonnet-4-5-20250929"
      stance: "neutral"
      stance_prompt: "Provide balanced analysis of both"
  findings: "Team is split on database choice"
  step_number: 1
  total_steps: 4  # Your analysis + 3 models + synthesis
  next_step_required: true
  working_directory: "/path/to/project"
```

**Best Practices**:
- Frame decision clearly
- Provide full context
- Use diverse models
- Consider all perspectives
- Document decision rationale

---

### `challenge` - Question Assumptions

**When to Use**:
- Major architectural decisions
- Before committing to approach
- When something feels wrong
- To prevent groupthink
- Critical path decisions

**How to Use**:
```yaml
Tool: zen:challenge
Parameters:
  prompt: "We plan to use @Observable for all state management. Challenge this assumption."
```

**Best Practices**:
- Use before finalizing decisions
- Be open to criticism
- Consider alternatives presented
- Document why you proceed anyway (if you do)

---

### `apilookup` - Documentation Search

**When to Use**:
- Need latest API documentation
- Version-specific features
- Breaking changes
- Migration guides
- Best practices updates

**How to Use**:
```yaml
Tool: zen:apilookup
Parameters:
  prompt: "Latest SwiftUI NavigationStack API for iOS 17+"
```

**Best Practices**:
- Verify version compatibility
- Check for deprecations
- Look for migration guides
- Confirm best practices

---

### `chat` - General Assistance

**When to Use**:
- Throughout all work
- Quick questions
- Clarifications
- Session continuity
- Brainstorming

**How to Use**:
```yaml
Tool: zen:chat
Parameters:
  model: "gemini-2.5-pro"
  prompt: "How should I structure error handling in SwiftUI views?"
  continuation_id: "cont_previous_session"  # For continuity
  files:
    - "Sources/Views/TaskListView.swift"
  working_directory: "/path/to/project"
```

**Best Practices**:
- Use continuation_id for context
- Provide relevant files
- Ask specific questions
- Save continuation_id for next time

---

## Workflow Integration

### Phase 0: Foundation & Planning

```
1. Use `planner` to break down project
2. Use `thinkdeep` for architecture decisions
3. Use `apilookup` for latest API documentation
4. Use `consensus` for major decisions
5. Use `challenge` to validate approach
```

---

### Phase 1-N: Feature Development

```
1. Use `planner` to break down phase
2. Use `chat` for ongoing assistance
3. Use `apilookup` as needed for APIs
4. Use `debug` when issues arise
5. Use `codereview` before completion
6. Use `precommit` before marking complete
```

---

### Throughout Development

```
Continuous:
- `chat` for questions
- `apilookup` for documentation
- `debug` for issues

Before Task Complete:
- `codereview` for quality
- `precommit` for verification

Before Phase Complete:
- `analyze` for comprehensive review
- `refactor` for improvements
- `consensus` for team alignment
```

---

## Best Practices

### Tool Selection

**Use the right tool for the job**:
- Planning → `planner`
- Complex decisions → `thinkdeep`
- Quality checks → `codereview`
- Final verification → `precommit`
- Problems → `debug`
- Documentation → `apilookup`
- Everything else → `chat`

---

### Model Selection

**Choose appropriate model**:
- Fast/simple: `claude-sonnet-4-5-20250929`
- Complex/deep: `gemini-2.5-pro` or `gpt-5-pro`
- Code-focused: `gpt-5-codex`
- Balanced: `gpt-5`

---

### Continuation Management

**Always save continuation_id**:
```
After important tool use:
1. Save continuation_id from response
2. Document in session-state.md
3. Use in next related tool call
```

---

### File References

**Provide full paths**:
```
✅ Good: "Sources/Stores/TaskStore.swift"
❌ Bad: "TaskStore.swift"

✅ Good: "/absolute/path/to/project"
❌ Bad: "~/project" or "./project"
```

---

## Troubleshooting

### Problem: Tool returns unclear results

**Solution**:
- Provide more context
- Be more specific
- Include relevant files
- State your goal clearly

---

### Problem: Tool suggests wrong approach

**Solution**:
- Use `challenge` to question it
- Get second opinion with `consensus`
- Provide more constraints
- Verify against guidelines

---

### Problem: Lost continuation_id

**Solution**:
- Check session-state.md
- Start new conversation
- Provide comprehensive context
- Reference previous work

---

## Related Documentation

- [Session Management](./session-management.md) - Continuity practices
- [Project Management](./project-management.md) - Workflow phases
- [Quality Gates](./quality-gates.md) - When to use tools
- [Agent Deployment](./agent-deployment.md) - Which agents use which tools
- [Main Index](../claude.md) - Complete workflow

---

**Last Updated**: 2025-01-20  
**Version**: 1.0