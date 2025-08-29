//
//  Untitled.swift
//  Task5
//
//  Created by Cassper on 29/08/2025.
//
import XCTest
import CoreData
@testable import Task5

func makeInMemoryContainer() -> NSPersistentContainer {
    let container = NSPersistentContainer(name: "Task5")
    let desc = NSPersistentStoreDescription()
    desc.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [desc]
    container.loadPersistentStores { _, error in
        XCTAssertNil(error)
    }
    return container
}

