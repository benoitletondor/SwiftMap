//
//  Map.swift
//  HashMap
//
//  Created by Benoit Letondor on 01/11/2016.
//  Copyright © 2016 Benoit Letondor. All rights reserved.
//

import Foundation

public protocol Map: Hashable
{
    associatedtype KeyType: Hashable
    associatedtype ValueType: Hashable
    
    func clear()
    func containsKey(key: KeyType) -> Bool
    func containsValue(value: ValueType) -> Bool
    func entrySet() -> Set<MapEntry<KeyType, ValueType>>
    func get(key: KeyType) -> ValueType?
    func isEmpty() -> Bool
    func keySet()-> Set<KeyType>
    func put(key: KeyType, value: ValueType) -> ValueType?
    func putAll(map: Self)
    func remove(key: KeyType) -> ValueType?
    func size() -> Int
    func values() -> [ValueType]
}

public struct MapEntry<K: Hashable, V: Hashable>: Hashable
{
    public let key: K
    public var value: V?
    
    public init(key: K, value: V?)
    {
        self.key = key;
        self.value = value
    }

    public var hashValue: Int
    {
        if let val = value
        {
            return key.hashValue ^ val.hashValue
        }
        else
        {
            return key.hashValue
        }
    }
    
    public static func ==(lhs: MapEntry, rhs: MapEntry) -> Bool
    {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}