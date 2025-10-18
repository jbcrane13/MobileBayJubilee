# iOS Development Guidelines

**Version**: 1.0  
**Last Updated**: 2025-01-20  
**Minimum Target**: iOS 17.0+

---

## Table of Contents

1. [Project Requirements](#project-requirements)
2. [Architecture Principles](#architecture-principles)
3. [State Management](#state-management)
4. [Swift Concurrency](#swift-concurrency)
5. [SwiftData Implementation](#swiftdata-implementation)
6. [Navigation Patterns](#navigation-patterns)
7. [Performance Optimization](#performance-optimization)
8. [Error Handling](#error-handling)
9. [Testing Considerations](#testing-considerations)
10. [Project Structure](#project-structure)
11. [Common Patterns](#common-patterns)
12. [Code Quality Checklist](#code-quality-checklist)
13. [Git Commit Workflow](#git-commit-workflow)

---

## Project Requirements

### Minimum Specifications
- **Target Platform**: iOS 17.0+
- **Language**: Swift 6.0+
- **UI Framework**: SwiftUI (exclusively)
- **Data Persistence**: SwiftData
- **State Management**: Observation framework
- **Concurrency**: Swift Concurrency (async/await, actors)
- **Project Format**: `.xcodeproj` or `.xcworkspace`

### Never Use
- ❌ UIKit (unless absolutely necessary for specific APIs not available in SwiftUI)
- ❌ Core Data (use SwiftData instead)
- ❌ Combine framework (use Observation and async/await)
- ❌ `@Published`, `@ObservableObject`, `@StateObject` (use `@Observable` and `@State`)
- ❌ NavigationView (use NavigationStack)
- ❌ Completion handlers/closures for async operations (use async/await)

---

## Architecture Principles

### 1. Simplified Architecture Pattern
Use **Model-View (MV)** pattern with SwiftUI's native features:

```swift
// ✅ CORRECT: Observable Model
import SwiftUI
import Observation

@Observable
final class UserStore {
    var users: [User] = []
    var isLoading = false
    var errorMessage: String?
    
    func fetchUsers() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Async operation
            users = try await NetworkService.shared.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// ✅ CORRECT: SwiftUI View using @State
struct UsersView: View {
    @State private var store = UserStore()
    
    var body: some View {
        NavigationStack {
            List(store.users) { user in
                UserRow(user: user)
            }
            .navigationTitle("Users")
            .task {
                await store.fetchUsers()
            }
        }
    }
}
```

### 2. Unidirectional Data Flow
- State flows down through the view hierarchy
- Actions flow up through callbacks or environment
- Single source of truth for each piece of data

### 3. State Management Hierarchy

```swift
// Local View State
@State private var isPresented = false

// Shared Observable Objects
@State private var store = AppStore()

// Environment Objects
@Environment(AppStore.self) private var store

// Bindable Properties (for editing)
@Bindable var user: User
```

---

## State Management with Observation Framework

### Observable Models

```swift
import Observation

@Observable
final class AppStore {
    // No @Published needed - all properties are automatically observable
    var items: [Item] = []
    var selectedItem: Item?
    var isLoading = false
    
    // Use @ObservationIgnored for non-observable properties
    @ObservationIgnored
    private let apiClient = APIClient()
    
    func loadItems() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            items = try await apiClient.fetchItems()
        } catch {
            // Handle error
        }
    }
}
```

### Property Wrappers Guide

```swift
// ✅ For creating/owning observable objects
@State private var store = MyStore()

// ✅ For creating bindings to observable properties
struct EditView: View {
    @Bindable var item: Item
    
    var body: some View {
        TextField("Name", text: $item.name)
    }
}

// ✅ For accessing environment objects
@Environment(AppStore.self) private var appStore

// ✅ For simple value types
@State private var count = 0
@State private var isPresented = false
```

### Environment Setup

```swift
// ✅ App Setup with Observable Environment
@main
struct MyApp: App {
    @State private var appStore = AppStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appStore)
        }
    }
}

// ✅ Accessing in Views
struct ContentView: View {
    @Environment(AppStore.self) private var store
    
    var body: some View {
        // Use store directly
        Text("Items: \(store.items.count)")
    }
}
```

---

## Swift Concurrency Best Practices

### Async/Await Patterns

```swift
// ✅ CORRECT: Async function
func fetchData() async throws -> [Item] {
    let url = URL(string: "https://api.example.com/items")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([Item].self, from: data)
}

// ✅ CORRECT: Calling async from SwiftUI
struct DataView: View {
    @State private var items: [Item] = []
    
    var body: some View {
        List(items) { item in
            Text(item.name)
        }
        .task {
            do {
                items = try await fetchData()
            } catch {
                // Handle error
            }
        }
    }
}

// ✅ CORRECT: MainActor for UI updates
@MainActor
final class ViewModel {
    var items: [Item] = []
    
    func updateUI() {
        // Automatically on main thread
        items.append(Item())
    }
}

// ✅ CORRECT: Parallel async operations
func loadMultipleResources() async throws {
    async let users = fetchUsers()
    async let posts = fetchPosts()
    async let comments = fetchComments()
    
    // All execute in parallel
    let (userResults, postResults, commentResults) = try await (users, posts, comments)
}
```

### Task Groups for Concurrent Operations

```swift
// ✅ CORRECT: TaskGroup for multiple operations
func fetchImages(urls: [URL]) async throws -> [UIImage] {
    try await withThrowingTaskGroup(of: UIImage.self) { group in
        var images: [UIImage] = []
        
        for url in urls {
            group.addTask {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    throw ImageError.invalidData
                }
                return image
            }
        }
        
        for try await image in group {
            images.append(image)
        }
        
        return images
    }
}
```

### Actors for Thread Safety

```swift
// ✅ CORRECT: Actor for shared mutable state
actor DatabaseManager {
    private var cache: [String: Data] = [:]
    
    func saveData(_ data: Data, forKey key: String) {
        cache[key] = data
    }
    
    func getData(forKey key: String) -> Data? {
        cache[key]
    }
}

// Usage
let db = DatabaseManager()
await db.saveData(someData, forKey: "user")
let retrieved = await db.getData(forKey: "user")
```

---

## SwiftData Implementation

### Model Definition

```swift
import SwiftData

@Model
final class Item {
    var name: String
    var timestamp: Date
    var isCompleted: Bool
    
    // Relationships
    @Relationship(deleteRule: .cascade)
    var tags: [Tag] = []
    
    init(name: String, timestamp: Date = .now, isCompleted: Bool = false) {
        self.name = name
        self.timestamp = timestamp
        self.isCompleted = isCompleted
    }
}

@Model
final class Tag {
    var name: String
    var color: String
    
    @Relationship(inverse: \Item.tags)
    var items: [Item]?
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
}
```

### Container Setup

```swift
import SwiftData

@main
struct MyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Tag.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
```

### CRUD Operations

```swift
import SwiftData

struct ItemsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    ItemRow(item: item)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = Item(name: "New Item")
        modelContext.insert(newItem)
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}
```

### Advanced Queries

```swift
// ✅ Query with predicates and sorting
@Query(
    filter: #Predicate<Item> { item in
        item.isCompleted == false
    },
    sort: \Item.timestamp,
    order: .reverse
)
private var activeItems: [Item]

// ✅ Dynamic query based on state
struct FilteredItemsView: View {
    @State private var searchText = ""
    
    var body: some View {
        ItemsList(searchText: searchText)
    }
}

struct ItemsList: View {
    let searchText: String
    
    @Query private var items: [Item]
    
    init(searchText: String) {
        self.searchText = searchText
        
        let predicate = #Predicate<Item> { item in
            searchText.isEmpty || item.name.contains(searchText)
        }
        
        _items = Query(filter: predicate, sort: \.name)
    }
    
    var body: some View {
        List(items) { item in
            Text(item.name)
        }
    }
}
```

---

## Navigation Patterns

### NavigationStack with Type-Safe Routing

```swift
// ✅ CORRECT: Define routes as enum
enum Route: Hashable {
    case detail(id: UUID)
    case edit(item: Item)
    case settings
}

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("View Details") {
                    path.append(Route.detail(id: UUID()))
                }
                Button("Settings") {
                    path.append(Route.settings)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detail(let id):
                    DetailView(id: id)
                case .edit(let item):
                    EditView(item: item)
                case .settings:
                    SettingsView()
                }
            }
        }
    }
}
```

### Programmatic Navigation

```swift
// ✅ CORRECT: Navigation coordinator in environment
@Observable
final class NavigationCoordinator {
    var path = NavigationPath()
    
    func navigateTo(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}

@main
struct MyApp: App {
    @State private var coordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(coordinator)
        }
    }
}
```

---

## Performance Optimization

### Lazy Loading

```swift
// ✅ CORRECT: Use lazy stacks for large lists
ScrollView {
    LazyVStack(spacing: 10) {
        ForEach(items) { item in
            ItemRow(item: item)
        }
    }
}

// ✅ CORRECT: Use lazy grids
ScrollView {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
        ForEach(items) { item in
            ItemCard(item: item)
        }
    }
}
```

### View Composition

```swift
// ✅ CORRECT: Extract expensive views
struct ParentView: View {
    @State private var items: [Item] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                ItemsList(items: items) // Isolated component
            }
        }
    }
}

// Separate view prevents unnecessary re-renders
struct ItemsList: View {
    let items: [Item]
    
    var body: some View {
        List(items) { item in
            Text(item.name)
        }
    }
}
```

### Equatable for Value Types

```swift
// ✅ CORRECT: Implement Equatable for better performance
struct ItemView: View, Equatable {
    let item: Item
    
    static func == (lhs: ItemView, rhs: ItemView) -> Bool {
        lhs.item.id == rhs.item.id
    }
    
    var body: some View {
        Text(item.name)
    }
}

// Usage
ForEach(items) { item in
    ItemView(item: item)
        .equatable()
}
```

---

## Error Handling

### Proper Error Handling Pattern

```swift
// ✅ CORRECT: Comprehensive error handling
@Observable
final class DataStore {
    var items: [Item] = []
    var isLoading = false
    var errorMessage: String?
    
    func loadItems() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            items = try await fetchItems()
        } catch let error as NetworkError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = "An unexpected error occurred"
        }
    }
}

// Custom error types
enum NetworkError: LocalizedError {
    case noConnection
    case serverError(Int)
    case invalidResponse
    
    var userMessage: String {
        switch self {
        case .noConnection:
            return "No internet connection"
        case .serverError(let code):
            return "Server error: \(code)"
        case .invalidResponse:
            return "Invalid server response"
        }
    }
}
```

---

## Testing Considerations

### Testable Architecture

```swift
// ✅ CORRECT: Protocol-based dependencies for testing
protocol DataFetching {
    func fetchItems() async throws -> [Item]
}

@Observable
final class ItemStore {
    private let dataFetcher: DataFetching
    var items: [Item] = []
    
    init(dataFetcher: DataFetching = APIClient()) {
        self.dataFetcher = dataFetcher
    }
    
    func loadItems() async {
        do {
            items = try await dataFetcher.fetchItems()
        } catch {
            // Handle error
        }
    }
}

// Mock for testing
final class MockDataFetcher: DataFetching {
    func fetchItems() async throws -> [Item] {
        [Item(name: "Test Item")]
    }
}
```

---

## Project Structure

### Recommended Folder Structure

```
MyApp/
├── MyApp.xcodeproj
├── MyApp/
│   ├── App/
│   │   ├── MyAppApp.swift
│   │   └── ContentView.swift
│   ├── Models/
│   │   ├── Item.swift
│   │   └── Tag.swift
│   ├── Views/
│   │   ├── Items/
│   │   │   ├── ItemsView.swift
│   │   │   ├── ItemRow.swift
│   │   │   └── ItemDetailView.swift
│   │   └── Settings/
│   │       └── SettingsView.swift
│   ├── Stores/
│   │   ├── AppStore.swift
│   │   └── ItemStore.swift
│   ├── Services/
│   │   ├── NetworkService.swift
│   │   └── AuthService.swift
│   ├── Utilities/
│   │   ├── Extensions/
│   │   └── Helpers/
│   └── Resources/
│       ├── Assets.xcassets
│       └── Localizable.strings
└── Tests/
    └── MyAppTests/
```

---

## Common Patterns & Examples

### List with Pull to Refresh

```swift
struct ItemsView: View {
    @State private var store = ItemStore()
    
    var body: some View {
        List(store.items) { item in
            ItemRow(item: item)
        }
        .refreshable {
            await store.refresh()
        }
        .overlay {
            if store.isLoading && store.items.isEmpty {
                ProgressView()
            }
        }
    }
}
```

### Search Implementation

```swift
struct SearchableItemsView: View {
    @Query private var items: [Item]
    @State private var searchText = ""
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredItems) { item in
                Text(item.name)
            }
            .searchable(text: $searchText)
            .navigationTitle("Search Items")
        }
    }
}
```

### Form with Validation

```swift
struct CreateItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var showError = false
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
                
                if showError {
                    Section {
                        Text("Name is required")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if isValid {
                            saveItem()
                        } else {
                            showError = true
                        }
                    }
                }
            }
        }
    }
    
    private func saveItem() {
        let item = Item(name: name)
        modelContext.insert(item)
        dismiss()
    }
}
```

### Accessibility

```swift
// ✅ CORRECT: Proper accessibility labels
Button(action: deleteItem) {
    Image(systemName: "trash")
}
.accessibilityLabel("Delete item")

// ✅ CORRECT: Group related elements
HStack {
    Image(systemName: "star.fill")
    Text("4.5")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("Rating: 4.5 stars")
```

---

## Code Quality Checklist

Before delivering code, ensure:

- ✅ Minimum iOS 17 deployment target
- ✅ Uses SwiftUI exclusively
- ✅ Uses `@Observable` instead of Combine
- ✅ Uses NavigationStack (not NavigationView)
- ✅ Uses async/await (no completion handlers)
- ✅ Uses SwiftData for persistence (if needed)
- ✅ Proper error handling
- ✅ Accessibility labels on interactive elements
- ✅ No force unwrapping (`!`) unless absolutely necessary
- ✅ Meaningful variable and function names
- ✅ Proper separation of concerns
- ✅ No memory leaks (avoid strong reference cycles)

---

## Git Commit Workflow

**CRITICAL**: Every commit MUST follow this workflow:

### Pre-Commit Validation (REQUIRED)

Before creating any commit, **ALWAYS** run Zen MCP `precommit` tool to validate changes:

```bash
# 1. Stage your changes
git add .

# 2. Run precommit validation (via Zen MCP tool)
# This validates:
# - Git diffs and impacts
# - Code quality issues
# - Security concerns
# - Test coverage
# - Breaking changes
# - Build verification

# 3. Review precommit feedback
# - Address any critical or high severity issues
# - Fix bugs identified by analysis
# - Add missing tests if flagged

# 4. Only after precommit passes, create the commit.
# This will open your default text editor to fill out the detailed message.
git commit
```

### Commit Message Format

Follow this structure for all commits:

```
Brief summary (imperative mood, 50 chars max)

IMPLEMENTATION:
- Feature/component details
- Files created/modified
- Architecture decisions

FEATURES COMPLETE:
✅ Feature 1 description
✅ Feature 2 description

BUG FIXES (if applicable):
- Issue description and fix

SPRINT PROGRESS: X/Y stories (Z%)

Next: [Next priority task]

Phase [X] - Month [Y] - Week [Z]

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Validation Checklist

Before every commit, verify:

- ✅ **Zen precommit** validation passed
- ✅ Code builds successfully (no errors or warnings)
- ✅ All tests passing (if tests exist)
- ✅ No sensitive data (API keys, credentials)
- ✅ No debug code or console.log statements
- ✅ Proper code formatting
- ✅ Documentation updated (if API changed)
- ✅ Commit message follows format

**Never skip precommit validation** - it catches issues before they enter the codebase.

---

## Complete Feature Example

```swift
// MARK: - Model
import SwiftData

@Model
final class Task {
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = .now
    }
}

// MARK: - Store (if needed for business logic)
import Observation

@Observable
final class TaskStore {
    var isLoading = false
    var errorMessage: String?
    
    // Business logic methods here
    func syncTasks() async {
        isLoading = true
        defer { isLoading = false }
        
        // Sync logic
    }
}

// MARK: - Views
struct TasksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Task.createdAt, order: .reverse) private var tasks: [Task]
    @State private var store = TaskStore()
    @State private var isAddingTask = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    TaskRow(task: task)
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAddingTask = true
                    } label: {
                        Label("Add Task", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingTask) {
                AddTaskView()
            }
            .overlay {
                if tasks.isEmpty {
                    ContentUnavailableView(
                        "No Tasks",
                        systemImage: "checkmark.circle",
                        description: Text("Add a task to get started")
                    )
                }
            }
        }
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
    }
}

struct TaskRow: View {
    @Bindable var task: Task
    
    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(task.isCompleted ? .secondary : .primary)
            
            Spacer()
        }
    }
}

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var title = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task title", text: $title)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addTask() {
        let task = Task(title: title)
        modelContext.insert(task)
        dismiss()
    }
}
```

---

## Final Notes

This guide represents current best practices as of 2025. Always:

1. **Stay Current**: Apple's frameworks evolve; prioritize official documentation
2. **Be Pragmatic**: Use the simplest solution that works
3. **Focus on User Experience**: Performance and accessibility matter
4. **Write Maintainable Code**: Others (including future you) will thank you
5. **Test Thoroughly**: Ensure your code works across different scenarios

When in doubt, favor **simplicity**, **clarity**, and **Swift/SwiftUI native solutions** over complex patterns or third-party dependencies.

---

**Related Documentation**:
- [Session Management](./session-management.md)
- [Project Management](./project-management.md)
- [Agent Deployment](./agent-deployment.md)
- [Main Index](../claude.md)