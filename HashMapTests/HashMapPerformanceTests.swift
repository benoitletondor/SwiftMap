//
//  HashMapPerformanceTests.swift
//  SwiftMap
//
//  Created by Benoit Letondor on 03/11/2016.
//  Copyright © 2016 Benoit Letondor. All rights reserved.
//

import XCTest
@testable import SwiftMap

class HashMapPerformanceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDictPerformanceInsert()
    {
        var dict = [Int: Int]()
        
        self.measure
        {
            for i in 1...1000000
            {
                dict[i] = i
            }
        }
    }
    
    func testMapPerformanceInsert()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        self.measure
        {
            for i in 1...1000000
            {
                map.put(i, forKey: i)
            }
        }
    }
    
    func testDictPerformanceGet()
    {
        var dict = [Int: Int]()
        
        for i in 1...1000000
        {
            dict[i] = i
        }
        
        self.measure
        {
            for i in 1...1000000
            {
                _ = dict[i]
            }
        }
    }
    
    func testMapPerformanceGet()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...1000000
        {
            map.put(i, forKey: i)
        }
        
        self.measure
            {
            for i in 1...1000000
            {
                _ = map.get(i)
            }
        }
    }
    
    func testDictPerformanceRemove()
    {
        var dict = [Int: Int]()
        
        for i in 1...1000000
        {
            dict[i] = i
        }
        
        self.measure
        {
            for i in 1...1000000
            {
                dict.removeValue(forKey: i)
            }
        }
    }
    
    func testMapPerformanceRemove()
    {
        let map: AnyMap<Int, Int> = AnyMap(HashMap())
        
        for i in 1...1000000
        {
            map.put(i, forKey: i)
        }
        
        self.measure
        {
            for i in 1...1000000
            {
                map.remove(i)
            }
        }
    }
}
