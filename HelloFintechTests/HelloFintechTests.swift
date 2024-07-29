//
//  HelloFintechTests.swift
//  HelloFintechTests
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/22.
//

import XCTest
@testable import HelloFintech

final class HelloFintechTests: XCTestCase {
    
    private var viewModel: FriendListViewModel!
    private var networking: NetworkingMock!
    var sut: FriendModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        networking = NetworkingMock(response)
        viewModel = FriendListViewModel(session:networking)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        networking = nil
        viewModel = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFriendModelDecoding() throws {
            
        let path = Bundle(for: HelloFintechTests.self).path(forResource: "friend", ofType: "json")!
        let data = NSData(contentsOfFile: path)! as Data
        
        let decoder = JSONDecoder()
        sut = try! decoder.decode(FriendModel.self, from: data)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.fid, "001")
        XCTAssertEqual(sut.name, "黃靖僑")
        XCTAssertEqual(sut.isTop, "0")
        XCTAssertEqual(sut.status, FriendStatus.invited)
        XCTAssertEqual(sut.updateDate, "20190801")
    }
    
    func testViewModelData() async throws {
        
        let viewModel = FriendListViewModel(session: URLSession.shared)
        let expectation = expectation(description: "testViewModelLoadData")
        
        let task = Task { 
            try await viewModel.getData(for: .full(), using: ())
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])

        let data: () = try await task.value
        XCTAssertNotNil(data)
    }

    func testViewModelLoadDataFailed() async {
        let endPoint: Endpoint = .full()
        
        guard let request = endPoint.makeRequest(with: ()), let url = request.url else {
            return
        }
        
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let error = NSError(domain: "testDomain.com", code: 999, userInfo: nil)
        
        networking.result = .failure(error)
        networking.nextResponse = fakeResponse
        
        let expectation = expectation(description: "testViewModelLoadDataFailed")
        
        Task {
            try await viewModel.getData(for: endPoint, using: ())
    
            if viewModel.error != nil {
                XCTAssertNotNil(viewModel.error)
            } else {
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])

        XCTAssertEqual(error.code, 999)
    }
    
    func testViewModelCompareDateFunction() {
        let isDateBefore = viewModel.compareDateIsBefore(date1: "2019/08/02", date2: "2019/08/01")
        
        XCTAssertTrue(isDateBefore)
    }
    
    func testViewModelFetchDataFunction() async throws {
        let viewModel = FriendListViewModel(session: URLSession.shared)
        let data = try await viewModel.fetchData(for: .full(), using: ())
        
        XCTAssertNotNil(data)
    }
    
    func testViewModelGetData2Function() async throws {
        let viewModel = FriendListViewModel(session: URLSession.shared)
        
        let expectation = expectation(description: "testViewModelLoadData")
        
        let task = Task {
            try await viewModel.getData2(for: .only(), for: .only2(), using: (), using: ())
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])

        let data: () = try await task.value
        XCTAssertNotNil(data)
    }
    
    func testViewModelGetData2Failed() async throws {
        
        let endPoint: Endpoint = .only()
        
        guard let request = endPoint.makeRequest(with: ()), let url = request.url else {
            return
        }
        
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let error = NSError(domain: "testDomain.com", code: 999, userInfo: nil)
        
        networking.result = .failure(error)
        networking.nextResponse = fakeResponse
        
        let expectation = expectation(description: "testViewModelLoadDataFailed")
        
        Task {
            try await viewModel.getData2(for: .only(), for: .only2(), using: (), using: ())
    
            if viewModel.error != nil {
                XCTAssertNotNil(viewModel.error)
            } else {
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])

        XCTAssertEqual(error.code, 999)
    }
}
