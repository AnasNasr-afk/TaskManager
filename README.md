# 📱 Task Manager App

A simple to-do list app for iOS using SwiftUI, Core Data, and Combine.

## What it does
- Add tasks
- Mark tasks complete/incomplete  
- Delete tasks
- Saves data automatically

## Why Core Data?
**Core Data** is Apple's way to save data on the device (like a local database).

**Why not use other options?**
- **UserDefaults**: Only good for simple settings, not lists of data
- **JSON files**: You have to write all the save/load code yourself
- **Core Data**: Handles everything automatically and works great with large amounts of data

**When to use Core Data:**
Apps with lots of data like task managers, note apps, or social media apps.

## How Combine helps
**Combine** makes the app automatically update when data changes.

```swift
// When tasks change in Core Data, the UI updates instantly
@FetchRequest var tasks: FetchedResults<Task>
```

## Data Structure
Each task has:
- `title`: The task text
- `isCompleted`: Done or not done
- `createdAt`: When it was created

## What I built
1. **Core Data setup** - Database to store tasks
2. **Add tasks** - Create new tasks
3. **Show tasks** - Display in a list that updates automatically
4. **Complete tasks** - Tap to mark done
5. **Delete tasks** - Swipe to remove

## What I learned
- How to save data locally on iOS
- How to make UI update automatically when data changes
- How to use Core Data with SwiftUI
- Building a complete app with create, read, update, delete features
