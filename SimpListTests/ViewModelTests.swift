//
//  ViewModelTests.swift
//  SimpList
//
//  Created by kazunari_ueeda on 2021/11/13.
//

import XCTest
@testable import SimpList

class ViewModelTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitializeAtLaunchShouldNotFailZeroRows() throws {
        let viewModel = ItemViewModel(true)
        XCTAssertNotNil(viewModel)
        
        XCTAssertEqual(viewModel.items.count, 0)
    }
    
    func testAddNewItemsTwoItemsShouldBeAppearedInTODOItems() throws {
        let viewModel = ItemViewModel(true)
        
        _ = viewModel.createItem("Title", "2021-11-13", "2021-11-14", "note")
        XCTAssertEqual(viewModel.items.count, 1)
        
        _ = viewModel.createItem("Title2", "2021-11-14", "2021-11-15", "note2")
        XCTAssertEqual(viewModel.items.count, 2)
        
        let item1 = try XCTUnwrap(viewModel.items.first(where: {$0.title == "Title"}))
        XCTAssertEqual(item1.title, "Title")
        XCTAssertEqual(item1.startDate, "2021-11-13")
        XCTAssertEqual(item1.endDate, "2021-11-14")
        XCTAssertEqual(item1.note, "note")
        
        let item2 = try XCTUnwrap(viewModel.items.first(where: {$0.title == "Title2"}))
        XCTAssertEqual(item2.title, "Title2")
        XCTAssertEqual(item2.startDate, "2021-11-14")
        XCTAssertEqual(item2.endDate, "2021-11-15")
        XCTAssertEqual(item2.note, "note2")
    }
    
    func testAddAndRemoveOneItemInTheEndShouldBeAppearedInTODOItems() throws {
        let viewModel = ItemViewModel(true)
        
        let item = viewModel.createItem("Title", "2021-11-13", "2021-11-14", "note")
        let _ = viewModel.createItem("Title2", "2021-11-14", "2021-11-15", "note2")
        let item3 = viewModel.createItem("Title3", "2021-11-15", "2021-11-16", "note3")
        XCTAssertEqual(viewModel.items.count, 3)
        
        viewModel.deleteItem(item)
        XCTAssertEqual(viewModel.items.count, 2)
        XCTAssertNil(viewModel.items.first(where: {$0.title == "Title"}))
        XCTAssertNotNil(viewModel.items.first(where: {$0.title == "Title2"}))
        XCTAssertNotNil(viewModel.items.first(where: {$0.title == "Title3"}))
        
        viewModel.deleteItem(item3)
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertNil(viewModel.items.first(where: {$0.title == "Title"}))
        XCTAssertNotNil(viewModel.items.first(where: {$0.title == "Title2"}))
        XCTAssertNil(viewModel.items.first(where: {$0.title == "Title3"}))
    }
}
