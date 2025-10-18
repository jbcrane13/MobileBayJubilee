# Agent Deployment & Team Structures

**Version**: 1.0  
**Last Updated**: 2025-01-20

---

## Overview

This document defines multi-agent team structures for parallel development with coordinated oversight. Each team includes a **Coordinator Agent** responsible for orchestration, quality assurance, and session continuity.

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [iOS Development Team](#ios-development-team)
3. [Web Application Team](#web-application-team)
4. [General Software Team](#general-software-team)
5. [Coordinator Agent Responsibilities](#coordinator-agent-responsibilities)
6. [Agent Communication Protocol](#agent-communication-protocol)
7. [Deployment Process](#deployment-process)
8. [Expanding for New Domains](#expanding-for-new-domains)

---

## Core Principles

### 1. Coordinator-Led Architecture
Every team has one **Coordinator Agent** who:
- Manages workflow and task distribution
- Ensures quality gates are met
- Maintains session continuity
- Resolves conflicts between agents
- Uses Zen tools for strategic decisions

### 2. Parallel Execution
- Agents work simultaneously on independent tasks
- Dependencies clearly defined
- Regular sync points via Coordinator

### 3. Clear Role Boundaries
- Each agent has specific expertise
- Minimal overlap in responsibilities
- Clear escalation paths

### 4. Quality First
- All work reviewed before integration
- Quality gates enforced by Coordinator
- Zen tools used for validation

---

## iOS Development Team

### Team Composition (5 Agents)

```yaml
Team Name: iOS Development Team
Team Size: 5 agents
Execution Mode: Parallel with coordination
Primary Focus: iOS applications using SwiftUI, SwiftData, Swift Concurrency

Agents:
  1. Coordinator Agent
  2. Architecture & Data Agent
  3. UI/UX Implementation Agent
  4. Feature Development Agent
  5. Testing & Quality Assurance Agent
```

---

### 1. Coordinator Agent

**Primary Role**: Orchestration and Quality Management

**Responsibilities**:
- Break down project into phases and tasks (Zen `planner`)
- Assign tasks to appropriate agents
- Monitor progress and dependencies
- Enforce quality gates before task completion
- Maintain session state and continuity
- Resolve agent conflicts (Zen `consensus`)
- Make architectural decisions (Zen `thinkdeep`)
- Ensure documentation completeness

**Zen Tools Usage**:
- `planner`: Project breakdown and planning
- `consensus`: Multi-agent decision making
- `challenge`: Question assumptions
- `thinkdeep`: Complex problem analysis
- `chat`: Coordination communication

**Work Pattern**:
- Start each session: Load context, review status
- During session: Monitor agent progress, unblock issues
- End session: Save state, document decisions, plan next steps

**Quality Gates Enforcement**:
- ✅ Verify builds succeed
- ✅ Confirm tests pass
- ✅ Require screenshot evidence
- ✅ Review code quality
- ✅ Check session documentation

---

### 2. Architecture & Data Agent

**Primary Role**: System Design and Data Modeling

**Responsibilities**:
- Design SwiftUI architecture (MV pattern)
- Create SwiftData models and relationships
- Define Observable stores and state management
- Plan navigation structure
- Design service layers and networking
- API integration planning
- Performance optimization strategy

**Zen Tools Usage**:
- `analyze`: Codebase analysis
- `thinkdeep`: Architecture decisions
- `apilookup`: API documentation and best practices
- `refactor`: Code structure improvements

**Work Pattern**:
- Create data models using SwiftData
- Design Observable stores
- Define navigation flows
- Set up networking services
- Review with Coordinator before implementation

**Deliverables**:
- SwiftData model definitions
- Observable store classes
- Navigation coordinator (if needed)
- API service protocols
- Architecture documentation

---

### 3. UI/UX Implementation Agent

**Primary Role**: User Interface Development

**Responsibilities**:
- Implement SwiftUI views and components
- Create reusable UI components
- Implement navigation (NavigationStack)
- Handle user interactions
- Implement accessibility features
- Responsive layouts and animations
- Follow iOS Human Interface Guidelines

**Zen Tools Usage**:
- `codereview`: UI code quality
- `apilookup`: SwiftUI best practices
- `refactor`: Component optimization
- `chat`: Clarify requirements

**Work Pattern**:
- Build views based on Architecture Agent's design
- Create reusable components
- Implement navigation flows
- Add accessibility labels
- Test on multiple device sizes
- Provide screenshots for verification

**Deliverables**:
- SwiftUI view implementations
- Custom view components
- Navigation implementation
- Screenshots of all screens
- Accessibility audit

---

### 4. Feature Development Agent

**Primary Role**: Business Logic and Feature Implementation

**Responsibilities**:
- Implement feature logic
- Integrate with data layer (SwiftData)
- Implement async operations (async/await)
- Form validation and data processing
- Error handling
- Work with mock data initially
- Transition to real APIs

**Zen Tools Usage**:
- `debug`: Issue resolution
- `codereview`: Logic verification
- `apilookup`: Swift Concurrency patterns
- `chat`: Feature clarification

**Work Pattern**:
- Implement business logic in stores
- Use async/await for operations
- Add proper error handling
- Work with Architecture Agent's models
- Test with mock data first
- Coordinate API integration

**Deliverables**:
- Feature logic implementation
- Async operation handlers
- Error handling
- Data transformations
- Feature tests

---

### 5. Testing & Quality Assurance Agent

**Primary Role**: Testing and Quality Verification

**Responsibilities**:
- Write unit tests
- Write UI tests (where applicable)
- Test error handling
- Verify accessibility
- Test on simulator
- Build verification (`.xcodeproj`)
- Quality gate validation
- Bug identification and reporting

**Zen Tools Usage**:
- `precommit`: Pre-integration checks
- `debug`: Test failure analysis
- `codereview`: Test coverage review
- `analyze`: Code quality metrics

**Work Pattern**:
- Write tests for new features
- Run all tests before completion
- Build project and verify
- Test on simulator
- Take screenshots
- Report issues to relevant agents
- Verify quality gates met

**Deliverables**:
- Unit test suites
- UI test cases
- Build verification report
- Screenshot evidence
- Test coverage report
- Quality gate checklist

---

### iOS Team Workflow Example

```
Phase 1: User Authentication (P1 Feature)

Coordinator Agent:
├─ Uses `planner` to break down auth feature
├─ Creates tasks: [Models, UI, Logic, Tests]
├─ Assigns to agents
└─ Monitors progress

Architecture Agent:
├─ Designs User model (SwiftData)
├─ Creates AuthStore (@Observable)
└─ Defines AuthService protocol

UI Agent (Parallel):
├─ Builds LoginView
├─ Builds RegisterView
└─ Implements navigation

Feature Agent (Parallel):
├─ Implements login logic in AuthStore
├─ Adds error handling
└─ Uses mock auth initially

Testing Agent (After Implementation):
├─ Writes unit tests
├─ Builds .xcodeproj
├─ Runs on simulator
├─ Takes screenshots
└─ Reports to Coordinator

Coordinator Agent:
├─ Reviews all deliverables
├─ Uses `codereview` for quality check
├─ Verifies quality gates
└─ Marks phase complete ✅
```

---

## Web Application Team

### Team Composition (6 Agents)

```yaml
Team Name: Web Application Team
Team Size: 6 agents
Execution Mode: Parallel with coordination
Primary Focus: Full-stack web applications

Agents:
  1. Coordinator Agent
  2. Backend/API Agent
  3. Frontend Framework Agent
  4. UI/Component Agent
  5. Database & Integration Agent
  6. Testing & DevOps Agent
```

---

### 1. Coordinator Agent (Web)

**Same core responsibilities as iOS Coordinator**

**Additional Web-Specific**:
- Coordinate frontend/backend development
- Manage API contract definitions
- Ensure cross-browser compatibility
- Monitor deployment pipeline

**Zen Tools**: `planner`, `consensus`, `thinkdeep`, `challenge`

---

### 2. Backend/API Agent

**Responsibilities**:
- Design RESTful or GraphQL APIs
- Implement server-side logic
- Authentication and authorization
- API documentation
- Performance optimization

**Zen Tools**: `apilookup`, `codereview`, `debug`, `analyze`

**Deliverables**:
- API endpoints
- API documentation (OpenAPI/Swagger)
- Authentication system
- Error handling
- API tests

---

### 3. Frontend Framework Agent

**Responsibilities**:
- Set up React/Vue/Angular application
- State management (Redux, Zustand, etc.)
- Routing configuration
- API integration
- Performance optimization

**Zen Tools**: `apilookup`, `refactor`, `analyze`

**Deliverables**:
- Framework setup
- State management
- Routing system
- API client
- Build configuration

---

### 4. UI/Component Agent

**Responsibilities**:
- Build UI components
- Implement responsive design
- Accessibility (WCAG compliance)
- CSS/styling
- Component library

**Zen Tools**: `codereview`, `refactor`

**Deliverables**:
- Reusable components
- Responsive layouts
- Style system
- Component documentation
- Accessibility audit

---

### 5. Database & Integration Agent

**Responsibilities**:
- Database schema design
- ORM configuration
- Data migrations
- Third-party integrations
- Caching strategy

**Zen Tools**: `thinkdeep`, `analyze`, `debug`

**Deliverables**:
- Database schema
- Migration scripts
- Integration code
- Data access layer
- Performance optimizations

---

### 6. Testing & DevOps Agent

**Responsibilities**:
- Unit and integration tests
- E2E tests (Cypress, Playwright)
- CI/CD pipeline setup
- Build verification
- Deployment automation

**Zen Tools**: `precommit`, `debug`, `analyze`

**Deliverables**:
- Test suites
- CI/CD configuration
- Build scripts
- Deployment documentation
- Quality reports

---

## General Software Team

### Team Composition (4-5 Agents)

```yaml
Team Name: General Software Team
Team Size: 4-5 agents (adaptable)
Execution Mode: Parallel with coordination
Primary Focus: Any software project not specifically iOS/Web

Agents:
  1. Coordinator Agent
  2. Architecture & Design Agent
  3. Implementation Agent(s) (1-2)
  4. Testing & Quality Agent
```

This is a flexible template - adjust team size and roles based on project needs.

---

## Coordinator Agent Responsibilities

### Universal Coordinator Functions

Regardless of team type, the Coordinator:

**Planning & Organization**
- Use Zen `planner` to create detailed project plans
- Break work into phases with clear P1 features
- Define dependencies between tasks
- Create timeline and milestones

**Task Assignment**
- Match tasks to agent expertise
- Enable parallel work where possible
- Clearly communicate requirements
- Set deadlines and priorities

**Quality Management**
- Enforce quality gates (see [Quality Gates](./quality-gates.md))
- Review all deliverables
- Use Zen `codereview` for verification
- Require screenshot evidence
- Ensure tests pass before completion

**Session Continuity**
- Maintain comprehensive session state
- Document all decisions and rationale
- Track blockers and dependencies
- Enable smooth handoffs to next session

**Conflict Resolution**
- Mediate disagreements between agents
- Use Zen `consensus` for team alignment
- Make final decisions when needed
- Escalate to human when appropriate

**Communication**
- Regular status updates
- Clear documentation of decisions
- Facilitate agent collaboration
- Report progress to stakeholders

---

## Agent Communication Protocol

### Sync Points

**Daily Standup** (Start of major work session):
```
Coordinator: Posts status request
Each Agent: Reports:
  - What was completed
  - What's in progress
  - Any blockers
  - Next tasks
Coordinator: Adjusts plan if needed
```

**Mid-Session Check-ins**:
- Every 3-5 major tasks completed
- When dependencies unblock
- When blockers arise

**Phase Completion**:
- All agents report final status
- Coordinator runs quality gates
- Team retrospective (Zen `consensus`)

---

### Communication Format

**Task Assignment**:
```markdown
FROM: Coordinator
TO: [Agent Name]
TASK: [Task ID] [Brief Description]
PRIORITY: P1/P2/P3
DEPENDENCIES: [List blocking tasks]
ACCEPTANCE CRITERIA:
  - [ ] Criterion 1
  - [ ] Criterion 2
QUALITY GATES:
  - [ ] Tests pass
  - [ ] Builds successfully
  - [ ] Screenshot provided
REFERENCE: [Link to requirements]
```

**Status Update**:
```markdown
FROM: [Agent Name]
TO: Coordinator
TASK: [Task ID]
STATUS: In Progress / Blocked / Complete
PROGRESS: [Description]
BLOCKERS: [Any issues]
NEXT STEPS: [What's next]
DELIVERABLES: [What's ready for review]
```

**Completion Report**:
```markdown
FROM: [Agent Name]
TO: Coordinator
TASK: [Task ID] - COMPLETE
DELIVERABLES:
  - File 1: [Description]
  - File 2: [Description]
QUALITY GATES MET:
  ✅ Tests passing: [Test results]
  ✅ Build successful: [Build log]
  ✅ Screenshot: [Link/attachment]
  ✅ Code reviewed: [Review notes]
NOTES: [Any important context]
```

---

## Deployment Process

### Step 1: Project Initiation

**Coordinator**:
1. Review project requirements
2. Use Zen `planner` to create initial plan
3. Select appropriate team structure
4. Define phases and P1 features
5. Set up [Session Management](./session-management.md)
6. Initialize [Mock Data Strategy](./mock-data-strategy.md)

### Step 2: Agent Deployment

**Coordinator**:
1. Assign roles to available AI instances
2. Provide each agent with:
   - Role description
   - Relevant guidelines ([iOS Dev](./ios-development.md), etc.)
   - Current project context
   - Initial tasks

### Step 3: Parallel Execution

**All Agents**:
- Work on assigned tasks
- Follow [Session Management](./session-management.md) practices
- Use appropriate Zen tools
- Report progress to Coordinator
- Document decisions

**Coordinator**:
- Monitor progress
- Unblock issues
- Adjust assignments as needed
- Maintain project state

### Step 4: Integration & Quality

**Before Task Completion**:
1. Testing Agent verifies quality gates
2. Coordinator reviews all deliverables
3. Use Zen `codereview` for verification
4. Screenshot evidence required
5. All tests must pass
6. Build must succeed

### Step 5: Phase Completion

**Coordinator**:
1. Verify all phase tasks complete
2. Run comprehensive quality check
3. Document phase outcomes
4. Plan next phase (if applicable)
5. Team retrospective (Zen `consensus`)

---

## Expanding for New Domains

### Creating a New Team Template

**Step 1: Identify Core Roles**
- What expertise areas are needed?
- How many agents for parallel work?
- What are the main deliverables?

**Step 2: Define Agent Responsibilities**
- Specific tasks for each agent
- Required skills/knowledge
- Tools and technologies
- Zen tool usage patterns

**Step 3: Plan Workflow**
- How do agents collaborate?
- What are the dependencies?
- Where can work happen in parallel?
- What are the integration points?

**Step 4: Define Quality Gates**
- What must be verified?
- How to confirm completion?
- What tests are required?
- What documentation is needed?

**Step 5: Document Template**
- Add to this file
- Create specific guidelines (like [iOS Development](./ios-development.md))
- Define success criteria
- Provide examples

---

### Example: Adding Mobile (Android) Team

```yaml
Team Name: Android Development Team
Team Size: 5 agents
Execution Mode: Parallel with coordination

Agents:
  1. Coordinator Agent
     - Same core responsibilities
     - Android-specific quality gates
     
  2. Architecture & Data Agent
     - Jetpack Compose architecture
     - Room database
     - ViewModel pattern
     
  3. UI/UX Agent
     - Jetpack Compose UI
     - Material Design 3
     - Navigation Component
     
  4. Feature Agent
     - Business logic
     - Kotlin Coroutines
     - Repository pattern
     
  5. Testing & QA Agent
     - JUnit tests
     - Espresso UI tests
     - APK build verification
```

Then create `docs/android-development.md` with detailed guidelines.

---

## Team Performance Metrics

### Success Indicators

**Velocity**
- Tasks completed per phase
- Time to complete phases
- Parallel efficiency ratio

**Quality**
- First-time pass rate on quality gates
- Number of bugs found post-completion
- Test coverage percentage

**Collaboration**
- Communication clarity
- Blocker resolution time
- Handoff smoothness

**Agent Effectiveness**
- Tasks completed successfully
- Rework required
- Tool usage efficiency

---

## Troubleshooting

### Common Issues

**Agents Working on Conflicting Tasks**
- **Solution**: Coordinator reviews dependencies more carefully
- **Tool**: Zen `planner` to visualize dependencies

**Quality Gates Failing Repeatedly**
- **Solution**: Review requirements clarity, provide more examples
- **Tools**: Zen `debug`, `challenge` assumptions

**Session Continuity Lost**
- **Solution**: Improve [Session Management](./session-management.md) practices
- **Action**: Coordinator ensures comprehensive state documentation

**Parallel Work Not Efficient**
- **Solution**: Better task decomposition
- **Tool**: Zen `analyze` to identify bottlenecks

---

## Best Practices

### For Coordinators

1. **Plan Thoroughly**: Use Zen `planner` extensively
2. **Communicate Clearly**: Unambiguous task descriptions
3. **Monitor Actively**: Regular check-ins
4. **Enforce Quality**: Never compromise on gates
5. **Document Everything**: Enable future sessions
6. **Use Zen Tools**: Leverage for better decisions

### For Specialized Agents

1. **Stay in Scope**: Focus on your role
2. **Ask Questions**: Clarify with Coordinator
3. **Document Decisions**: Why, not just what
4. **Test Your Work**: Before reporting complete
5. **Use Zen Tools**: Debug, review, lookup as needed
6. **Provide Evidence**: Screenshots, test results

### For All Agents

1. **Session Continuity**: Follow [Session Management](./session-management.md)
2. **Quality First**: Never skip gates
3. **Collaboration**: Work together, not in silos
4. **Continuous Improvement**: Learn from each phase
5. **User Focus**: Build for the end user

---

## Related Documentation

- [Project Management](./project-management.md) - Phase planning and execution
- [Session Management](./session-management.md) - Continuity and handoffs
- [Quality Gates](./quality-gates.md) - Completion criteria
- [Zen Tools Guide](./zen-tools-guide.md) - Effective tool usage
- [iOS Development](./ios-development.md) - iOS technical standards
- [Main Index](../claude.md) - Complete workflow overview

---

**Last Updated**: 2025-01-20  
**Version**: 1.0  
**Maintained By**: Development Team