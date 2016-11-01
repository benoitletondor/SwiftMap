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
    
    func testContainsValue()
    {
        var hashMap: HashMap<Int, Int> = HashMap()
        
        for i in 1...11
        {
            hashMap.put(key: i, value: i)
        }
        
        hashMap.remove(key: 11)
        
        XCTAssertTrue(hashMap.containsValue(value: 1))
        XCTAssertTrue(hashMap.containsValue(value: 2))
        XCTAssertTrue(hashMap.containsValue(value: 3))
        XCTAssertTrue(hashMap.containsValue(value: 4))
        XCTAssertTrue(hashMap.containsValue(value: 5))
        XCTAssertTrue(hashMap.containsValue(value: 6))
        XCTAssertTrue(hashMap.containsValue(value: 7))
        XCTAssertTrue(hashMap.containsValue(value: 8))
        XCTAssertTrue(hashMap.containsValue(value: 9))
        XCTAssertTrue(hashMap.containsValue(value: 10))
        
        XCTAssertFalse(hashMap.containsValue(value: 11))
        XCTAssertFalse(hashMap.containsValue(value: 12))
        XCTAssertFalse(hashMap.containsValue(value: 13))
        XCTAssertFalse(hashMap.containsValue(value: 14))
        XCTAssertFalse(hashMap.containsValue(value: 15))
    }
    
    func testContainsKey()
    {
        var hashMap: HashMap<Int, Int> = HashMap()
        
        for i in 1...11
        {
            hashMap.put(key: i, value: i)
        }
        
        hashMap.remove(key: 11)
        
        XCTAssertTrue(hashMap.containsKey(key: 1))
        XCTAssertTrue(hashMap.containsKey(key: 2))
        XCTAssertTrue(hashMap.containsKey(key: 3))
        XCTAssertTrue(hashMap.containsKey(key: 4))
        XCTAssertTrue(hashMap.containsKey(key: 5))
        XCTAssertTrue(hashMap.containsKey(key: 6))
        XCTAssertTrue(hashMap.containsKey(key: 7))
        XCTAssertTrue(hashMap.containsKey(key: 8))
        XCTAssertTrue(hashMap.containsKey(key: 9))
        XCTAssertTrue(hashMap.containsKey(key: 10))
        
        XCTAssertFalse(hashMap.containsKey(key: 11))
        XCTAssertFalse(hashMap.containsKey(key: 12))
        XCTAssertFalse(hashMap.containsKey(key: 13))
        XCTAssertFalse(hashMap.containsKey(key: 14))
        XCTAssertFalse(hashMap.containsKey(key: 15))
    }
    
    func testKeySet()
    {
        var hashMap: HashMap<Int, Int> = HashMap()
        
        for i in 1...11
        {
            hashMap.put(key: i, value: i)
        }
        
        hashMap.remove(key: 11)
        
        let keys: Set<Int> = hashMap.keySet()
        
        XCTAssertEqual(10, keys.count)
        XCTAssertTrue(keys.contains(1))
        XCTAssertTrue(keys.contains(2))
        XCTAssertTrue(keys.contains(3))
        XCTAssertTrue(keys.contains(4))
        XCTAssertTrue(keys.contains(5))
        XCTAssertTrue(keys.contains(6))
        XCTAssertTrue(keys.contains(7))
        XCTAssertTrue(keys.contains(8))
        XCTAssertTrue(keys.contains(9))
        XCTAssertTrue(keys.contains(10))
        
        XCTAssertFalse(keys.contains(11))
        XCTAssertFalse(keys.contains(12))
        XCTAssertFalse(keys.contains(13))
        XCTAssertFalse(keys.contains(14))
        XCTAssertFalse(keys.contains(15))
    }
    
    func testValues()
    {
        var hashMap: HashMap<Int, Int> = HashMap()
        
        for i in 1...11
        {
            hashMap.put(key: i, value: i)
        }
        
        hashMap.remove(key: 11)
        
        let values: [Int] = hashMap.values()
        
        XCTAssertEqual(10, values.count)
        XCTAssertTrue(values.contains(1))
        XCTAssertTrue(values.contains(2))
        XCTAssertTrue(values.contains(3))
        XCTAssertTrue(values.contains(4))
        XCTAssertTrue(values.contains(5))
        XCTAssertTrue(values.contains(6))
        XCTAssertTrue(values.contains(7))
        XCTAssertTrue(values.contains(8))
        XCTAssertTrue(values.contains(9))
        XCTAssertTrue(values.contains(10))
        
        XCTAssertFalse(values.contains(11))
        XCTAssertFalse(values.contains(12))
        XCTAssertFalse(values.contains(13))
        XCTAssertFalse(values.contains(14))
        XCTAssertFalse(values.contains(15))
    }
    
    func testEntrySet()
    {
        var hashMap: HashMap<Int, Int> = HashMap()
        
        for i in 1...11
        {
            hashMap.put(key: i, value: i)
        }
        
        hashMap.remove(key: 11)
        
        let entries: Set<MapEntry<Int, Int>> = hashMap.entrySet()
        XCTAssertEqual(10, entries.count)
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
