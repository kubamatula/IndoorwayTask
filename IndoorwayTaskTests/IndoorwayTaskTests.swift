//
//  IndoorwayTaskTests.swift
//  IndoorwayTaskTests
//
//  Created by Jakub Matuła on 03/10/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import XCTest
@testable import IndoorwayTask

class IndoorwayTaskTests: XCTestCase {
    
    let expectedUrl1 = URL(string: "http://placehold.it")!
    let expectedUrl2 = URL(string: "http://placehold.pl")!
    
    lazy var photo1 = Photo(albumId: 1, id: 1, title: "asd", url: expectedUrl1, thumbnailUrl: expectedUrl1)
    lazy var photo2 = Photo(albumId: 1, id: 2, title: "asd2", url: expectedUrl2, thumbnailUrl: expectedUrl2)
    
    //MARK:- Helper methods for testing jsonDecoding
    func genericDecodingTest<T>(_ expectedResult: T, filename: String, predicate: (T,T) -> Bool) where T: Equatable & Decodable {
        let decodedObject: T = loadResource(filename: filename)
        XCTAssert(predicate(expectedResult, decodedObject))
    }
    
    func loadResource<T>(filename: String) -> T where T: Decodable {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: filename, ofType: "json")!
        let fileURL = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let decodedObject = try! decoder.decode(T.self, from: data)
        return decodedObject
    }
    
    func testSinglePhotoDecoding() {
        genericDecodingTest(photo1, filename: "SinglePhoto", predicate: ==)
        genericDecodingTest(photo2, filename: "SinglePhoto", predicate: !=)
    }
    
    func testSinglePhotoArray() {
        let photos1 = [photo1, photo2]
        let photos2 = [photo2, photo1]
        let decodedPhotos: [Photo] = loadResource(filename: "Photos")
        XCTAssertEqual(photos1, decodedPhotos)
        XCTAssertNotEqual(photos2, decodedPhotos)
    }
}
