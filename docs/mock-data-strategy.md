# Mock Data Strategy

**Version**: 1.0  
**Last Updated**: 2025-01-20

---

## Overview

This document defines the strategy for managing mock data throughout the development lifecycle, ensuring a smooth transition from mock data to real API integration while maintaining development velocity.

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [When to Use Mock Data](#when-to-use-mock-data)
3. [Mock Data Guidelines](#mock-data-guidelines)
4. [Mock Data Registry](#mock-data-registry)
5. [Transition Strategy](#transition-strategy)
6. [Implementation Patterns](#implementation-patterns)
7. [Testing with Mock Data](#testing-with-mock-data)
8. [Phase-Specific Approach](#phase-specific-approach)
9. [Quality Gates](#quality-gates)
10. [Examples](#examples)

---

## Core Principles

### 1. **Realistic Mock Data**
Mock data should closely mirror production data:
- Realistic values and formats
- Appropriate data relationships
- Edge cases represented
- Similar data volumes

### 2. **Easy to Replace**
Design for seamless transition:
- Abstract data sources behind protocols
- Dependency injection patterns
- Clear separation of concerns
- Feature flags for switching

### 3. **Track Everything**
Maintain comprehensive registry:
- Which components use mock data
- Where mock data is defined
- Target real API endpoint
- Migration priority and timeline

### 4. **Transition Early**
Don't wait too long:
- Phase 1: Mock acceptable for P1 features
- Phase 2: Begin real API integration
- Phase 3: Eliminate all production mock data

### 5. **Test with Both**
Maintain mock data for testing:
- Production code: Real APIs only
- Test code: Can use mock data
- Clear distinction between environments

---

## When to Use Mock Data

### ✅ Acceptable Use Cases

**Phase 1 (P1 Features)**:
- API not yet available
- Focus on UI/UX development
- Rapid prototyping
- Initial feature validation
- Demo purposes

**All Phases (Testing)**:
- Unit tests
- Integration tests
- UI tests (when appropriate)
- Offline testing
- Performance testing

**Specific Scenarios**:
- Third-party API unavailable
- Rate-limited APIs (during dev)
- Expensive API calls
- Unreliable external services

---

### ❌ Unacceptable Use Cases

**Production Code (Phase 3+)**:
- Never ship mock data to production
- No mock data in release builds
- No "TODO: Replace with real API"

**Critical Features**:
- Authentication/authorization
- Payment processing
- Data persistence (use real databases)
- Security-sensitive operations

**Long-Term**:
- Don't let mock data become permanent
- Avoid dependency on mock patterns
- Don't build features that only work with mocks

---

## Mock Data Guidelines

### Quality Standards

**Realistic Data**:
````swift
// ✅ Good: Realistic mock data
let mockUsers = [
    User(
        id: UUID(),
        name: "Sarah Chen",
        email: "sarah.chen@example.com",
        role: .admin,
        joinedDate: Date().addingTimeInterval(-86400 * 365)
    ),
    User(
        id: UUID(),
        name: "Marcus Johnson",
        email: "marcus.j@example.com",
        role: .member,
        joinedDate: Date().addingTimeInterval(-86400 * 30)
    )
]

// ❌ Bad: Unrealistic mock data
let mockUsers = [
    User(id: UUID(), name: "Test", email: "test@test.com", role: .admin),
    User(id: UUID(), name: "User", email: "user@user.com", role: .member)
]
````

**Edge Cases**:
````swift
// ✅ Include edge cases in mock data
let mockTasks = [
    Task(title: "Normal task"),
    Task(title: "Task with very long title that might cause layout issues in the UI"),
    Task(title: "Task with émojis 🎉 and spëcial çharacters"),
    Task(title: ""),  // Empty edge case
    Task(title: String(repeating: "A", count: 1000))  // Extreme length
]
````

**Relationships**:
````swift
// ✅ Maintain realistic relationships
let mockCategory = Category(name: "Work")
let mockTask = Task(title: "Meeting", category: mockCategory)

// Ensure referential integrity
mockCategory.tasks.append(mockTask)
````

---

## Mock Data Registry

### Registry File: `tracking/mock-data-registry.md`
````markdown
# Mock Data Registry

**Last Updated**: 2025-01-20
**Phase**: Phase 1

---

## Active Mock Data Usage

### Component: TaskListView
- **Location**: `Sources/Views/TaskListView.swift`
- **Mock Data**: `MockData.sampleTasks`
- **Mock Data Location**: `Sources/Utilities/MockData.swift`
- **Real API Endpoint**: `GET /api/tasks`
- **Migration Priority**: P2 (Phase 2)
- **Migration Status**: Not started
- **Notes**: Using for UI development, API available

### Component: UserProfileView
- **Location**: `Sources/Views/UserProfileView.swift`
- **Mock Data**: `MockData.currentUser`
- **Mock Data Location**: `Sources/Utilities/MockData.swift`
- **Real API Endpoint**: `GET /api/user/profile`
- **Migration Priority**: P1 (Phase 2)
- **Migration Status**: Not started
- **Notes**: API not yet available

### Component: AuthStore
- **Location**: `Sources/Stores/AuthStore.swift`
- **Mock Data**: Mock authentication responses
- **Mock Data Location**: Inline in store
- **Real API Endpoint**: `POST /api/auth/login`
- **Migration Priority**: P0 (Critical - Phase 2)
- **Migration Status**: Not started
- **Notes**: Must migrate early for security

---

## Completed Migrations

### Component: TaskDetailView
- **Migration Date**: 2025-01-15
- **Migrated From**: `MockData.sampleTasks`
- **Migrated To**: `TaskService.fetchTask(id:)`
- **Verified By**: Testing Agent
- **Status**: ✅ Complete

---

## Mock Data Inventory

### MockData.swift
```swift
Sources/Utilities/MockData.swift
- sampleTasks: [Task]
- sampleCategories: [Category]
- currentUser: User
- sampleComments: [Comment]
```

### Inline Mocks
- AuthStore: Mock login/logout
- NetworkService: Mock network responses (development only)

---

## Migration Schedule

### Phase 2 (Week 1)
- [ ] Migrate AuthStore to real API
- [ ] Migrate UserProfileView to real API

### Phase 2 (Week 2)
- [ ] Migrate TaskListView to real API
- [ ] Migrate CategoryView to real API

### Phase 3
- [ ] Remove all remaining mock data from production code
- [ ] Verify no mock data in release builds
- [ ] Keep mock data in tests only

---

## Review Checklist

Before Phase 2:
- [ ] All mock data documented
- [ ] Migration priorities assigned
- [ ] Real API availability confirmed
- [ ] Migration plan created

Before Phase 3:
- [ ] All P0 migrations complete
- [ ] All P1 migrations complete
- [ ] P2 migrations in progress
- [ ] No mock data in production builds

Before Production:
- [ ] Zero mock data in production code
- [ ] All tests still pass with test mocks
- [ ] Build verification confirms no mocks
- [ ] Code review confirms clean state
````

---

## Transition Strategy

### Phase-by-Phase Approach

**Phase 1: Accept Mock Data**
````
Goal: Rapid UI/UX development
Approach: Use mock data freely
Registry: Document all usage
Quality: Ensure realistic data
````

**Phase 2: Begin Migration**
````
Goal: Start real API integration
Priority:
  1. Critical features (auth, payments)
  2. Core user flows
  3. Secondary features

Approach:
  - Migrate highest priority first
  - One component at a time
  - Test thoroughly
  - Update registry
````

**Phase 3: Complete Migration**
````
Goal: Eliminate all production mock data
Approach:
  - Migrate remaining components
  - Remove mock data files (production)
  - Keep mocks for tests
  - Verify build doesn't include mocks
````

---

### Migration Process

**Step 1: Prepare**
````
1. Verify real API available
2. Review API documentation
3. Plan migration approach
4. Create feature flag (optional)
````

**Step 2: Implement**
````swift
// Before: Using mock data
class TaskStore {
    var tasks = MockData.sampleTasks
}

// After: Using real API
class TaskStore {
    var tasks: [Task] = []
    
    func fetchTasks() async {
        do {
            tasks = try await TaskService.fetchTasks()
        } catch {
            // Handle error
        }
    }
}
````

**Step 3: Test**
````
1. Unit tests with mock API
2. Integration tests with real API (staging)
3. Manual testing
4. Performance testing
````

**Step 4: Deploy**
````
1. Update registry
2. Remove old mock data (if unused elsewhere)
3. Commit changes
4. Deploy to staging
5. Verify in production
````

**Step 5: Verify**
````
1. Confirm feature works with real API
2. Check error handling
3. Monitor performance
4. Update documentation
````

---

## Implementation Patterns

### Protocol-Based Abstraction

**iOS/Swift Example**:
````swift
// 1. Define protocol
protocol TaskDataSource {
    func fetchTasks() async throws -> [Task]
    func createTask(_ task: Task) async throws
    func updateTask(_ task: Task) async throws
    func deleteTask(id: UUID) async throws
}

// 2. Mock implementation
class MockTaskDataSource: TaskDataSource {
    func fetchTasks() async throws -> [Task] {
        // Return mock data
        return MockData.sampleTasks
    }
    
    func createTask(_ task: Task) async throws {
        // Simulate success
    }
    
    func updateTask(_ task: Task) async throws {
        // Simulate success
    }
    
    func deleteTask(id: UUID) async throws {
        // Simulate success
    }
}

// 3. Real implementation
class APITaskDataSource: TaskDataSource {
    func fetchTasks() async throws -> [Task] {
        let url = URL(string: "https://api.example.com/tasks")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Task].self, from: data)
    }
    
    func createTask(_ task: Task) async throws {
        // Real API call
    }
    
    func updateTask(_ task: Task) async throws {
        // Real API call
    }
    
    func deleteTask(id: UUID) async throws {
        // Real API call
    }
}

// 4. Use in store
@Observable
class TaskStore {
    private let dataSource: TaskDataSource
    var tasks: [Task] = []
    
    init(dataSource: TaskDataSource = APITaskDataSource()) {
        self.dataSource = dataSource
    }
    
    func loadTasks() async {
        do {
            tasks = try await dataSource.fetchTasks()
        } catch {
            // Handle error
        }
    }
}

// 5. Easy switching
// Development/Testing:
let store = TaskStore(dataSource: MockTaskDataSource())

// Production:
let store = TaskStore()  // Uses default APITaskDataSource
````

---

### Environment-Based Configuration
````swift
enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    
    var useMockData: Bool {
        switch self {
        case .development:
            return true  // Can use mocks in dev
        case .staging:
            return false  // Real API in staging
        case .production:
            return false  // Never in production
        }
    }
}

// Usage
class TaskStore {
    private let dataSource: TaskDataSource
    
    init() {
        if Environment.current.useMockData {
            self.dataSource = MockTaskDataSource()
        } else {
            self.dataSource = APITaskDataSource()
        }
    }
}
````

---

### Feature Flags
````swift
enum FeatureFlag {
    case useRealTaskAPI
    case useRealUserAPI
    
    var isEnabled: Bool {
        switch self {
        case .useRealTaskAPI:
            return UserDefaults.standard.bool(forKey: "useRealTaskAPI")
        case .useRealUserAPI:
            return UserDefaults.standard.bool(forKey: "useRealUserAPI")
        }
    }
}

// Usage
class TaskStore {
    func fetchTasks() async {
        if FeatureFlag.useRealTaskAPI.isEnabled {
            // Use real API
        } else {
            // Use mock data
        }
    }
}
````

---

## Testing with Mock Data

### Unit Tests

**Always use mocks in unit tests**:
````swift
final class TaskStoreTests: XCTestCase {
    var store: TaskStore!
    
    override func setUp() {
        super.setUp()
        // Always use mock for tests
        store = TaskStore(dataSource: MockTaskDataSource())
    }
    
    func testFetchTasks() async {
        await store.loadTasks()
        XCTAssertFalse(store.tasks.isEmpty)
    }
}
````

---

### Integration Tests

**Test with real API (staging)**:
````swift
final class TaskIntegrationTests: XCTestCase {
    func testRealAPIFetch() async throws {
        let dataSource = APITaskDataSource(
            baseURL: "https://staging-api.example.com"
        )
        let tasks = try await dataSource.fetchTasks()
        XCTAssertNotNil(tasks)
    }
}
````

---

## Phase-Specific Approach

### Phase 1: Full Mock Data Usage

**Acceptable**:
- All mock data for UI development
- Focus on user experience
- Document everything in registry
- Plan for migration

**Required**:
- Realistic mock data
- Comprehensive registry
- Clear migration plan
- Protocol-based design

**Example Registry Entry**:
````markdown
### Phase 1 Mock Data
- TaskListView: MockData.sampleTasks
- UserProfile: MockData.currentUser
- Categories: MockData.sampleCategories

Migration Plan: Phase 2 Week 1
````

---

### Phase 2: Active Migration

**Priority Order**:
1. Authentication/Security (P0)
2. Core user flows (P1)
3. Secondary features (P2)
4. Nice-to-have features (P3)

**Approach**:
````
Week 1:
- Migrate P0 features
- Verify critical paths work

Week 2:
- Migrate P1 features
- Update tests

Week 3:
- Migrate P2 features
- Remove unused mocks

Week 4:
- Final cleanup
- Documentation update
````

**Registry Updates**:
````markdown
### Completed Migrations (Phase 2)
✅ AuthStore → Real API (2025-01-20)
✅ TaskListView → Real API (2025-01-21)
🔄 UserProfile → In Progress
⏳ Categories → Not Started
````

---

### Phase 3: Production Ready

**Requirements**:
- ✅ Zero mock data in production code
- ✅ All features use real APIs
- ✅ Mocks only in test targets
- ✅ Build verification confirms no mocks
- ✅ Registry shows all migrations complete

**Verification**:
````bash
# Search for mock data in production code
grep -r "MockData" Sources/

# Should return: No results
````

**Final Registry**:
````markdown
# Mock Data Registry - Phase 3 Complete

## Production Code
Mock Data Usage: NONE ✅

## Test Code
Mock Data Usage: Active (unit tests only) ✅

## Migration Summary
- Total Components: 15
- Migrated: 15
- Remaining: 0
- Status: COMPLETE ✅

## Verification
- [x] No mock data in Sources/
- [x] All tests pass
- [x] Production build clean
- [x] Code review confirms
````

---

## Quality Gates

### Before Task Completion

**Mock Data Check**:
- [ ] Mock data usage documented
- [ ] Registry updated
- [ ] Migration priority assigned
- [ ] Realistic data used

### Before Phase 2

**Migration Readiness**:
- [ ] Complete registry exists
- [ ] All mock data documented
- [ ] Migration plan created
- [ ] API availability confirmed
- [ ] Priorities assigned

### Before Phase 3

**Migration Progress**:
- [ ] P0 features migrated
- [ ] P1 features migrated
- [ ] P2 features in progress
- [ ] Registry updated
- [ ] Tests passing

### Before Production

**Zero Mock Data**:
- [ ] No mock data in production code
- [ ] Mocks only in test targets
- [ ] Build verification passed
- [ ] Code review confirms
- [ ] Registry shows complete

---

## Examples

### Example 1: iOS Task App Mock Data

**MockData.swift**:
````swift
import Foundation

enum MockData {
    // Tasks
    static let sampleTasks = [
        Task(
            id: UUID(),
            title: "Review pull request #123",
            isCompleted: false,
            category: sampleCategories[0],
            dueDate: Date().addingTimeInterval(86400)
        ),
        Task(
            id: UUID(),
            title: "Update documentation",
            isCompleted: true,
            category: sampleCategories[0],
            dueDate: Date().addingTimeInterval(-86400)
        ),
        Task(
            id: UUID(),
            title: "Plan sprint retrospective",
            isCompleted: false,
            category: sampleCategories[1],
            dueDate: Date().addingTimeInterval(172800)
        )
    ]
    
    // Categories
    static let sampleCategories = [
        Category(
            id: UUID(),
            name: "Development",
            color: "blue",
            icon: "laptopcomputer"
        ),
        Category(
            id: UUID(),
            name: "Meetings",
            color: "green",
            icon: "person.3"
        ),
        Category(
            id: UUID(),
            name: "Personal",
            color: "purple",
            icon: "house"
        )
    ]
    
    // User
    static let currentUser = User(
        id: UUID(),
        name: "Alex Johnson",
        email: "alex.johnson@example.com",
        avatar: "person.circle.fill",
        joinedDate: Date().addingTimeInterval(-86400 * 365),
        role: .admin
    )
}
````

**Registry Entry**:
````markdown
### MockData.swift
- **Location**: `Sources/Utilities/MockData.swift`
- **Components Using**:
  - TaskListView
  - TaskDetailView
  - CategoryView
  - UserProfileView
- **Migration Plan**:
  - Phase 2 Week 1: Tasks and Categories
  - Phase 2 Week 2: User profile
- **Real APIs**:
  - Tasks: `GET /api/tasks`
  - Categories: `GET /api/categories`
  - User: `GET /api/user/profile`
````

---

### Example 2: Web Application Mock Data

**mockData.ts**:
````typescript
export const mockTasks: Task[] = [
  {
    id: '1',
    title: 'Implement user authentication',
    description: 'Add JWT-based auth with refresh tokens',
    status: 'in-progress',
    priority: 'high',
    assignee: mockUsers[0],
    createdAt: new Date('2025-01-15'),
    dueDate: new Date('2025-01-25')
  },
  {
    id: '2',
    title: 'Design dashboard UI',
    description: 'Create wireframes and mockups',
    status: 'completed',
    priority: 'medium',
    assignee: mockUsers[1],
    createdAt: new Date('2025-01-10'),
    dueDate: new Date('2025-01-20')
  }
];

export const mockUsers: User[] = [
  {
    id: '1',
    name: 'Sarah Chen',
    email: 'sarah.chen@example.com',
    role: 'developer',
    avatar: '/avatars/sarah.jpg'
  },
  {
    id: '2',
    name: 'Marcus Williams',
    email: 'marcus.w@example.com',
    role: 'designer',
    avatar: '/avatars/marcus.jpg'
  }
];
````

**Service with Mock/Real Toggle**:
````typescript
interface TaskService {
  fetchTasks(): Promise<Task[]>;
  createTask(task: Task): Promise<Task>;
  updateTask(task: Task): Promise<Task>;
  deleteTask(id: string): Promise<void>;
}

class MockTaskService implements TaskService {
  async fetchTasks(): Promise<Task[]> {
    // Simulate network delay
    await new Promise(resolve => setTimeout(resolve, 500));
    return mockTasks;
  }
  
  async createTask(task: Task): Promise<Task> {
    await new Promise(resolve => setTimeout(resolve, 500));
    return { ...task, id: String(Date.now()) };
  }
  
  async updateTask(task: Task): Promise<Task> {
    await new Promise(resolve => setTimeout(resolve, 500));
    return task;
  }
  
  async deleteTask(id: string): Promise<void> {
    await new Promise(resolve => setTimeout(resolve, 500));
  }
}

class APITaskService implements TaskService {
  private baseURL = process.env.REACT_APP_API_URL;
  
  async fetchTasks(): Promise<Task[]> {
    const response = await fetch(`${this.baseURL}/tasks`);
    return response.json();
  }
  
  async createTask(task: Task): Promise<Task> {
    const response = await fetch(`${this.baseURL}/tasks`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(task)
    });
    return response.json();
  }
  
  async updateTask(task: Task): Promise<Task> {
    const response = await fetch(`${this.baseURL}/tasks/${task.id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(task)
    });
    return response.json();
  }
  
  async deleteTask(id: string): Promise<void> {
    await fetch(`${this.baseURL}/tasks/${id}`, {
      method: 'DELETE'
    });
  }
}

// Factory
export const createTaskService = (): TaskService => {
  const useMock = process.env.REACT_APP_USE_MOCK_DATA === 'true';
  return useMock ? new MockTaskService() : new APITaskService();
};
````

---

## Best Practices Summary

### Do's ✅
- Document all mock data usage
- Use realistic, production-like data
- Include edge cases in mocks
- Abstract data sources behind protocols
- Plan migration from day one
- Update registry continuously
- Migrate early (Phase 2)
- Keep mocks for testing
- Verify production builds have no mocks

### Don'ts ❌
- Don't ship mock data to production
- Don't use unrealistic mock data
- Don't forget to document usage
- Don't delay migration too long
- Don't hardcode mock data everywhere
- Don't skip quality gates
- Don't leave TODOs in production
- Don't assume mocks will "work for now"

---

## Related Documentation

- [Project Management](./project-management.md) - Phase planning
- [Quality Gates](./quality-gates.md) - Completion criteria
- [Session Management](./session-management.md) - Tracking state
- [iOS Development](./ios-development.md) - iOS patterns
- [Testing Guidelines](./testing-guidelines.md) - Testing with mocks
- [Main Index](../claude.md) - Complete workflow

---

**Last Updated**: 2025-01-20  
**Version**: 1.0  
**Maintained By**: Development Team