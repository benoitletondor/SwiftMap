//
//  HashMapTests.swift
//  HashMapTests
//
//  Created by Benoit Letondor on 01/11/2016.
//  Copyright © 2016 Benoit Letondor. All rights reserved.
//

import XCTest
@testable import HashMap

class HashMapTests: XCTestCase {
    
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHash()
    {
        XCTAssertEqual(4059098911, HashMap<String, String>.hash(h: 4294967295))
    }
    
    func testInit()
    {
        let hashMap: HashMap<String, String> = HashMap()
        XCTAssertEqual(0, hashMap.size())
        XCTAssertTrue(hashMap.isEmpty())
    }
    
    func testPutGetRemove()
    {
        var hashMap: HashMap<String, String> = HashMap()
        let key:String = "testKey"
        let val:String = "testValue"
        
        hashMap.put(key: key, value: val)
        
        XCTAssertEqual(1, hashMap.size())
        XCTAssertEqual(val, hashMap.get(key: key))
        
        let removedVal: String? = hashMap.remove(key: key)
        XCTAssertNotNil(removedVal)
        XCTAssertEqual(val, removedVal!)
        
        XCTAssertEqual(0, hashMap.size())
        XCTAssertTrue(hashMap.isEmpty())
        XCTAssertNil(hashMap.get(key: key))
    }
    
    func testClear()
    {
        var hashMap: HashMap<Int, Int> = HashMap()
        
        for i in 1...15
        {
            hashMap.put(key: i, value: i)
        }
        
        XCTAssertEqual(15, hashMap.size())
        
        hashMap.clear()
        
        XCTAssertEqual(0, hashMap.size())
        XCTAssertTrue(hashMap.isEmpty())
    }
    
    func testPerformanceInsert()
    {
        self.measure
        {
            var hashMap: HashMap<Int, Int> = HashMap()
            
            for i in 1...1000000
            {
                hashMap.put(key: i, value: i)
            }
        }
    }
    
    func testPerformanceGet()
    {
        var hashMap: HashMap<Int, Int> = HashMap()
        
        for i in 1...1000000
        {
            hashMap.put(key: i, value: i)
        }
        
        self.measure
        {
            for i in 1...1000000
            {
                _ = hashMap.get(key: i)
            }
        }
    }
    
    func testPerformanceRemove()
    {
        var hashMap: HashMap<Int, Int> = HashMap()
        
        for i in 1...1000000
        {
            hashMap.put(key: i, value: i)
        }
        
        self.measure
        {
            for i in 1...1000000
            {
                hashMap.remove(key: i)
            }
        }
    }
    
}
