//
//  ModelTests.swift
//  ModelTests
//
//  Created by kazunari_ueeda on 2021/11/13.
//

import XCTest
@testable import SimpList

class ModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateItemWithCorrectValues() {
        let model = ItemModelStore(true)
        XCTAssertEqual(model.items.count, 0)
        
        // create new item
        model.createItem("Title", "2021-11-13", "2021-11-14", "note", false)
        XCTAssertEqual(model.items.count, 1)
        
        // get item from model
        let item = model.items.first!
        
        XCTAssertEqual(item.title, "Title")
        XCTAssertEqual(item.startDate, "2021-11-13")
        XCTAssertEqual(item.endDate, "2021-11-14")
        XCTAssertEqual(item.note, "note")
        XCTAssertEqual(item.isDone, false)
    }
    
    func testRemoveExistingItemShouldBeVanished() {
        let model = ItemModelStore(true)
        XCTAssertEqual(model.items.count, 0)
        
        // create new item
        model.createItem("Title", "2021-11-13", "2021-11-14", "note", false)
        XCTAssertEqual(model.items.count, 1)
        
        let item = model.items.first!
        
        // delete item
        model.removeItem(item)
        XCTAssertEqual(model.items.count, 0)
    }
}
