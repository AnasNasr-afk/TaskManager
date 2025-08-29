//
//  TaskCRUDTests.swift
//  Task5
//
//  Created by Cassper on 29/08/2025.
//
import XCTest
import CoreData
@testable import Task5

final class TaskCRUDTests: XCTestCase {
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        container = makeInMemoryContainer()
        context = container.viewContext
    }

    override func tearDown() {
        context = nil
        container = nil
        super.tearDown()
    }

    // MARK: - Helpers

    @discardableResult
    func insertTask(title: String = "Test Task",
                    isCompleted: Bool = false,
                    createdAt: Date = .init()) throws -> Task {
        let task = Task(context: context)
        task.title = title
        task.isCompleted = isCompleted
        task.createdAt = createdAt
        try context.save()
        return task
    }

    func fetchAll() throws -> [Task] {
        let req: NSFetchRequest<Task> = Task.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        return try context.fetch(req)
    }

    // MARK: - Tests

    func testAddTask() throws {
        XCTAssertEqual(try fetchAll().count, 0)
        _ = try insertTask(title: "Groceries")
        let all = try fetchAll()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all.first?.title, "Groceries")
        XCTAssertEqual(all.first?.isCompleted, false)
    }

    func testToggleTaskCompletion() throws {
        let task = try insertTask()
        task.isCompleted.toggle()
        try context.save()

        let fetched = try fetchAll().first
        XCTAssertEqual(fetched?.isCompleted, true)
    }

    func testDeleteTask() throws {
        let task = try insertTask()
        context.delete(task)
        try context.save()

        XCTAssertEqual(try fetchAll().count, 0)
    }
}

