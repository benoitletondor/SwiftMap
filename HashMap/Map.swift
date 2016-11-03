//
//  Map.swift
//  SwiftMap
//
//  Created by Benoit Letondor on 01/11/2016.
//  Copyright © 2016 Benoit Letondor. All rights reserved.
//

import Foundation

public protocol Map: Hashable
{
    associatedtype Key: Hashable
    associatedtype Value: Hashable
    
    mutating func clear()
    func containsKey(_ key: Key) -> Bool
    func containsValue(_ value: Value) -> Bool
    var entrySet: Set<MapEntry<Key, Value>> { get }
    func get(_ key: Key) -> Value?
    var keySet: Set<Key> { get }
    @discardableResult mutating func put(key: Key, value: Value) -> Value?
    @discardableResult mutating func remove(_ key: Key) -> Value?
    var size: Int { get }
    var values: [Value] { get }
}

extension Map
{
    var isEmpty: Bool
    {
        return size == 0
    }
}

public class AnyMap<K: Hashable, V: Hashable> : Map
{
    private let _clear:() -> Void
    private let _containsKey:(_ key: K) -> Bool
    private let _containsValue:(_ value: V) -> Bool
    private let _entrySet:() -> Set<MapEntry<K, V>>
    private let _get:(_ key: K) -> V?
    private let _keySet:()-> Set<K>
    private let _put: (_ key: K, _ value: V) -> V?
    private let _remove:(_ key: K) -> V?
    private let _size:() -> Int
    private let _values:() -> [V]
    private let _hashValue:() -> Int
    
    public init<M : Map>(_ base: M) where M.Key == K, M.Value == V
    {
        var copy = base
        
        self._clear = { copy.clear() }
        self._containsKey = copy.containsKey
        self._containsValue = copy.containsValue
        self._entrySet = { copy.entrySet }
        self._get = copy.get
        self._keySet = { copy.keySet }
        self._put = { (key: K, value: V) in copy.put (key: key, value: value) }
        self._remove = { (_ key: K) in return copy.remove(key) }
        self._size = { copy.size }
        self._values = { copy.values }
        self._hashValue = { copy.hashValue }
    }
    
    public func clear()
    {
        _clear()
    }
    
    public func containsKey(_ key: K) -> Bool
    {
        return _containsKey(key)
    }
    
    public func containsValue(_ value: V) -> Bool
    {
        return _containsValue(value)
    }
    
    public var entrySet: Set<MapEntry<K, V>>
    {
        return _entrySet()
    }
    
    public func get(_ key: K) -> V?
    {
        return _get(key)
    }
    
    public var keySet: Set<K>
    {
        return _keySet()
    }
    
    @discardableResult
    public func put(key: K, value: V) -> V?
    {
        return _put(key, value)
    }

    @discardableResult
    public func remove(_ key: K) -> V?
    {
        return _remove(key)
    }
    
    public var size: Int
    {
        return _size()
    }
    
    public var values: [V]
    {
        return _values()
    }
    
    public static func ==(lhs: AnyMap<K, V>, rhs: AnyMap<K, V>) -> Bool
    {
        return lhs.entrySet == rhs.entrySet
    }
    
    public var hashValue: Int
    {
        return _hashValue()
    }
}

public struct MapEntry<K: Hashable, V: Hashable>: Hashable
{
    public let key: K
    public let value: V
    
    public init(key: K, value: V)
    {
        self.key = key
        self.value = value
    }

    public var hashValue: Int
    {
        return key.hashValue + value.hashValue
    }
    
    public static func ==(lhs: MapEntry, rhs: MapEntry) -> Bool
    {        
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}
