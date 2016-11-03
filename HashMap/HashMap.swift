//
//  HashMap.swift
//  SwiftMap
//
//  Created by Benoit Letondor on 01/11/2016.
//  Copyright © 2016 Benoit Letondor. All rights reserved.
//

import Foundation

public class HashMap<Key: Hashable, Value: Hashable> : Map
{
    /**
     The table, resized as necessary. Length MUST Always be a power of two.
     */
    private var _table: [HashMapNode<Key, Value>?]
    
    /**
     The number of key-value mappings contained in this map.
     */
    private var _size: Int = 0
    
    /**
     The next size value at which to resize (capacity * load factor).
     */
    private var _threshold: Int
    
    /**
     The load factor for the hash table.
     */
    private let _loadFactor: Float
    
// MARK: -
    
    public init(initialCapacity: Int, loadFactor: Float)
    {
        // Find a power of 2 >= initialCapacity
        var capacity:Int = 1
        while (capacity < initialCapacity)
        {
            capacity <<= 1;
        }
        
        self._loadFactor = loadFactor
        self._threshold = Int(Float(capacity) * loadFactor)
        self._table = [HashMapNode<Key, Value>?](repeating: nil, count: capacity)
    }
    
    public convenience init(initialCapacity: Int)
    {
        self.init(initialCapacity: initialCapacity, loadFactor: HashMapConstants.DEFAULT_LOAD_FACTOR)
    }
    
    public convenience init()
    {
        self.init(initialCapacity: HashMapConstants.DEFAULT_INITIAL_CAPICITY, loadFactor: HashMapConstants.DEFAULT_LOAD_FACTOR)
    }
    
// Mark: -
    
    public func clear()
    {
        self._table.removeAll(keepingCapacity: true)
        self._size = 0
    }
    
    public func containsKey(_ key: Key) -> Bool
    {
        return get(key) != nil;
    }
    
    public func containsValue(_ value: Value) -> Bool
    {
        let tab: [HashMapNode<Key, Value>?] = self._table
        for entry:HashMapNode<Key, Value>? in tab
        {
            var currentEntry = entry
            while let e = currentEntry
            {
                if( e.value == value )
                {
                    return true
                }
                
                currentEntry = e.next
            }
        }
        
        return false
    }
    
    public var entrySet: Set<MapEntry<Key, Value>>
    {
        let tab: [HashMapNode<Key, Value>?] = self._table
        var set: Set<MapEntry<Key, Value>> = Set()
        
        for entry: HashMapNode<Key, Value>? in tab
        {
            var currentEntry = entry
            while let e = currentEntry
            {
                if let value: Value = e.value
                {
                    set.insert(MapEntry<Key, Value>(key: e.key, value: value))
                }
                
                currentEntry = e.next
            }
        }
        
        return set
    }
    
    public func get(_ key: Key) -> Value?
    {
        let hash: Int = HashMap.hash(key.hashValue);
        let index: Int = HashMap.indexFor(h: hash, length: self._table.count)
        
        var entry:HashMapNode<Key, Value>? = self._table[index]
        while let e = entry
        {
            if( e.hash == hash && e.key == key )
            {
                return e.value
            }
            
            entry = e.next
        }
        
        return nil
    }
    
    public var keySet: Set<Key>
    {
        let tab: [HashMapNode<Key, Value>?] = self._table
        var set: Set<Key> = Set()
        
        for entry: HashMapNode<Key, Value>? in tab
        {
            var currentEntry = entry
            while let e = currentEntry
            {
                if( e.value != nil )
                {
                    set.insert(e.key)
                }
                
                currentEntry = e.next
            }
        }
        
        return set
    }
    
    @discardableResult
    public func put(_ value: Value, forKey key: Key) -> Value?
    {
        let hash: Int = HashMap.hash(key.hashValue)
        let index: Int = HashMap.indexFor(h: hash, length: self._table.count)
        
        var entry:HashMapNode<Key, Value>? = self._table[index]
        while let e = entry
        {
            if( e.hash == hash && e.key == key )
            {
                let oldValue: Value? = e.value
                e.value = value
                return oldValue
            }
            
            entry = e.next
        }
        
        let e:HashMapNode<Key, Value>? = self._table[index]
        self._table[index] = HashMapNode(key: key, value: value, hash: hash, next: e)
        
        self._size+=1
        if (self._size >= self._threshold)
        {
            resize(newSize: 2 * self._table.count)
        }
        
        return nil
    }
    
    private func resize(newSize: Int)
    {
        let oldTable: [HashMapNode<Key, Value>?] = self._table
        let oldSize = oldTable.count
        
        if( oldSize == HashMapConstants.MAXIMUM_CAPACITY )
        {
            self._threshold = Int.max
            return
        }
        
        self._table = createNewTable(newSize: newSize)
        self._threshold = Int(Float(newSize) * self._loadFactor)
    }
    
    private func createNewTable(newSize: Int) -> [HashMapNode<Key, Value>?]
    {
        var newTable: [HashMapNode<Key, Value>?] = [HashMapNode<Key, Value>?](repeating: nil, count: newSize)
        
        for entry: HashMapNode<Key, Value>? in self._table
        {
            var currentEntry = entry
            while let e = currentEntry
            {
                currentEntry = e.next
                
                let index: Int = HashMap.indexFor(h: e.hash, length: newSize)
                e.next = newTable[index]
                newTable[index] = e
            }
        }
        
        return newTable
    }
    
    @discardableResult
    public func remove(_ key: Key) -> Value?
    {
        let hash: Int = HashMap.hash(key.hashValue)
        let index: Int = HashMap.indexFor(h: hash, length: self._table.count)
        var prev: HashMapNode<Key, Value>? = self._table[index]
        var e = prev
        
        while let current = e
        {
            let next = current.next
            if( current.hash == hash && current.key == key )
            {
                self._size -= 1
                if( prev == e )
                {
                    self._table[index] = next
                }
                else
                {
                    prev?.next = next
                }
                
                return current.value
            }
            
            prev = e
            e = next
        }
        
        return e?.value
    }
    
    public var size: Int
    {
        return self._size
    }
    
    public var values: [Value]
    {
        let entries: Set<MapEntry<Key, Value>> = entrySet
        var values: [Value] = [Value]()
        
        for entry:MapEntry<Key, Value> in entries
        {
            values.append(entry.value)
        }
        
        return values
    }
    
    public static func ==(lhs: HashMap, rhs: HashMap) -> Bool
    {
        if( lhs === rhs )
        {
            return true
        }
        
        return lhs.entrySet == rhs.entrySet
    }
    
    public var hashValue: Int
    {        
        var h = 0
        
        for entry:MapEntry<Key, Value> in entrySet
        {
            h += entry.hashValue
        }
        
        return h
    }
}

extension HashMap
{
    /**
     Applies a supplemental hash function to a given hashCode, which
     defends against poor quality hash functions.  This is critical
     because HashMap uses power-of-two length hash tables, that
     otherwise encounter collisions for hashCodes that do not differ
     in lower bits. Note: Null keys always map to hash 0, thus index 0.
     */
    internal static func hash(_ h: Int) -> Int
    {
        // This function ensures that hashCodes that differ only by
        // constant multiples at each bit position have a bounded
        // number of collisions (approximately 8 at default load factor).
        let newH: Int = h ^ (h >> 20) ^ (h >> 12);
        return newH ^ (newH >> 7) ^ (newH >> 4);
    }
    
    /**
     Returns index for hash code h.
     */
    internal static func indexFor(h: Int, length: Int) -> Int
    {
        return h & (length-1)
    }
}

private struct HashMapConstants
{
    /**
     The maximum capacity, used if a higher value is implicitly specified
     by either of the constructors with arguments.
     MUST be a power of two <= 1<<30.
     */
    static let MAXIMUM_CAPACITY: Int = 1 << 30
    
    static let DEFAULT_LOAD_FACTOR: Float = 0.75
    
    static let DEFAULT_INITIAL_CAPICITY: Int = 1 << 4 // = 16
}

private class HashMapNode<K: Hashable, V: Hashable> : Equatable
{
    public let key: K
    public var value: V?
    public var next: HashMapNode<K, V>?
    public let hash: Int
    
    init(key: K, value: V?, hash: Int, next: HashMapNode<K, V>?)
    {
        self.key = key
        self.value = value
        self.next = next
        self.hash = hash
    }
    
    public static func ==(lhs: HashMapNode, rhs: HashMapNode) -> Bool
    {
        return lhs.key == rhs.key &&
            lhs.value == rhs.value &&
            lhs.next == rhs.next &&
            lhs.hash == rhs.hash
    }
}
