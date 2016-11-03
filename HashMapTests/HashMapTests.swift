//
//  HashMapTests.swift
//  SwiftMapTests
//
//  Created by Benoit Letondor on 01/11/2016.
//  Copyright © 2016 Benoit Letondor. All rights reserved.
//

import XCTest
@testable import SwiftMap

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
        XCTAssertEqual(4059098911, HashMap<Int, Int>.hash(4294967295))
    }
    
    func testInit()
    {
        let map: AnyMap<String, String> = AnyMap(HashMap())
        XCTAssertEqual(0, map.size)
        XCTAssertTrue(map.isEmpty)
        XCTAssertEqual(0, map.entrySet.count)
        XCTAssertEqual(0, map.keySet.count)
        XCTAssertEqual(0, map.values.count)
    }
    
    func testPutGetRemove()
    {
        let map: AnyMap<String, String> = AnyMap(HashMap())
        let key:String = "testKey"
        let val:String = "testValue"
        
        map.put(val, forKey: key)
        
        XCTAssertEqual(1, map.size)
        XCTAssertFalse(map.isEmpty)
        XCTAssertEqual(val, map.get(key))
        XCTAssertEqual(1, map.entrySet.count)
        XCTAssertEqual(1, map.keySet.count)
        XCTAssertEqual(1, map.values.count)
        
        let removedVal: String? = map.remove(key)
        XCTAssertNotNil(removedVal)
        XCTAssertEqual(val, removedVal!)
        
        XCTAssertEqual(0, map.size)
        XCTAssertTrue(map.isEmpty)
        XCTAssertEqual(0, map.entrySet.count)
        XCTAssertEqual(0, map.keySet.count)
        XCTAssertEqual(0, map.values.count)
        XCTAssertNil(map.get(key))
    }
    
    func testMassValues()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        var values: [Int] = [Int](repeating: 0, count: 10000)
        for i in 0...9999
        {
            values[i] = i
            map.put(i, forKey: i)
        }
        
        XCTAssertEqual(values, map.values.sorted())
        
        for (index, value) in values.enumerated()
        {
            XCTAssertEqual(value, map.get(index))
        }
    }
    
    func testClear()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...15
        {
            map.put(i, forKey: i)
        }
        
        XCTAssertEqual(15, map.size)
        
        map.clear()
        
        XCTAssertEqual(0, map.size)
        XCTAssertTrue(map.isEmpty)
        XCTAssertEqual(0, map.entrySet.count)
        XCTAssertEqual(0, map.keySet.count)
        XCTAssertEqual(0, map.values.count)
    }
    
    func testContainsValue()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...11
        {
            map.put(i, forKey: i)
        }
        
        map.remove(11)
        
        XCTAssertTrue(map.containsValue(1))
        XCTAssertTrue(map.containsValue(2))
        XCTAssertTrue(map.containsValue(3))
        XCTAssertTrue(map.containsValue(4))
        XCTAssertTrue(map.containsValue(5))
        XCTAssertTrue(map.containsValue(6))
        XCTAssertTrue(map.containsValue(7))
        XCTAssertTrue(map.containsValue(8))
        XCTAssertTrue(map.containsValue(9))
        XCTAssertTrue(map.containsValue(10))
        
        XCTAssertFalse(map.containsValue(11))
        XCTAssertFalse(map.containsValue(12))
        XCTAssertFalse(map.containsValue(13))
        XCTAssertFalse(map.containsValue(14))
        XCTAssertFalse(map.containsValue(15))
    }
    
    func testContainsKey()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...11
        {
            map.put(i, forKey: i)
        }
        
        map.remove(11)
        
        XCTAssertTrue(map.containsKey(1))
        XCTAssertTrue(map.containsKey(2))
        XCTAssertTrue(map.containsKey(3))
        XCTAssertTrue(map.containsKey(4))
        XCTAssertTrue(map.containsKey(5))
        XCTAssertTrue(map.containsKey(6))
        XCTAssertTrue(map.containsKey(7))
        XCTAssertTrue(map.containsKey(8))
        XCTAssertTrue(map.containsKey(9))
        XCTAssertTrue(map.containsKey(10))
        
        XCTAssertFalse(map.containsKey(11))
        XCTAssertFalse(map.containsKey(12))
        XCTAssertFalse(map.containsKey(13))
        XCTAssertFalse(map.containsKey(14))
        XCTAssertFalse(map.containsKey(15))
    }
    
    func testKeySet()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...11
        {
            map.put(i, forKey: i)
        }
        
        map.remove(11)
        
        let keys: Set<Int> = map.keySet
        
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
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...11
        {
            map.put(i, forKey: i)
        }
        
        map.remove(11)
        
        let values: [Int] = map.values
        
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
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...11
        {
            map.put(i, forKey: i)
        }
        
        map.remove(11)
        
        let entries: Set<MapEntry<Int, Int>> = map.entrySet
        XCTAssertEqual(10, entries.count)
    }
    
    func testEqual()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        let map2: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...11
        {
            map.put(i, forKey: i)
            map2.put(i, forKey: i)
        }
        
        map.remove(11)
        map2.remove(11)
        
        XCTAssertTrue(map == map2)
        XCTAssertEqual(map.hashValue, map2.hashValue)
    }
    
    func testNotEqual()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        let map2: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...11
        {
            map.put(i, forKey: i)
            map2.put(i, forKey: i)
        }
        
        map.remove(11)
        
        XCTAssertFalse(map == map2)
        XCTAssertNotEqual(map.hashValue, map2.hashValue)
    }
}
