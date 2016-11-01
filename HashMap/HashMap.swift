//
//  HashMap.swift
//  SwiftMap
//
//  Created by Benoit Letondor on 01/11/2016.
//  Copyright © 2016 Benoit Letondor. All rights reserved.
//

import Foundation

public struct HashMap<KeyType: Hashable, ValueType: Hashable> : Map
{
    /**
     The maximum capacity, used if a higher value is implicitly specified
     by either of the constructors with arguments.
     MUST be a power of two <= 1<<30.
     */
    private let MAXIMUM_CAPACITY: Int = 1 << 30
    
// MARK: -
    
    /**
     The table, resized as necessary. Length MUST Always be a power of two.
     */
    private var _table: [HashMapEntry<KeyType, ValueType>?]
    
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
        self._table = [HashMapEntry<KeyType, ValueType>?](repeating: nil, count: capacity)
    }
    
    public init(initialCapacity: Int)
    {
        self.init(initialCapacity: initialCapacity, loadFactor: 0.75)
    }
    
    public init()
    {
        // aka 16
        self.init(initialCapacity: 1 << 4, loadFactor: 0.75)
    }
    
// Mark: -
    
    public mutating func clear()
    {
        for i in 0...self._table.count - 1
        {
            self._table[i] = nil
        }
        
        self._size = 0
    }
    
    public func containsKey(key: KeyType) -> Bool
    {
        return get(key: key) != nil;
    }
    
    public func containsValue(value: ValueType) -> Bool
    {
        let tab: [HashMapEntry<KeyType, ValueType>?] = self._table
        for entry:HashMapEntry<KeyType, ValueType>? in tab
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
    
    public func entrySet() -> Set<MapEntry<KeyType, ValueType>>
    {
        let tab: [HashMapEntry<KeyType, ValueType>?] = self._table
        var set: Set<MapEntry<KeyType, ValueType>> = Set()
        
        for entry: HashMapEntry<KeyType, ValueType>? in tab
        {
            var currentEntry = entry
            while let e = currentEntry
            {
                if( e.value != nil )
                {
                    set.insert(e)
                }
                
                currentEntry = e.next
            }
        }
        
        return set
    }
    
    public func get(key: KeyType) -> ValueType?
    {
        let hash: Int = HashMap.hash(h: key.hashValue);
        
        var entry:HashMapEntry<KeyType, ValueType>? = self._table[HashMap.indexFor(h: hash, length: self._table.count)]
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
    
    public func isEmpty() -> Bool
    {
        return self._size == 0
    }
    
    public func keySet()-> Set<KeyType>
    {
        let tab: [HashMapEntry<KeyType, ValueType>?] = self._table
        var set: Set<KeyType> = Set()
        
        for entry: HashMapEntry<KeyType, ValueType>? in tab
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
    public mutating func put(key: KeyType, value: ValueType) -> ValueType?
    {
        let hash: Int = HashMap.hash(h: key.hashValue)
        let index: Int = HashMap.indexFor(h: hash, length: self._table.count)
        
        var entry:HashMapEntry<KeyType, ValueType>? = self._table[index]
        while let e = entry
        {
            if( e.hash == hash && e.key == key )
            {
                let oldValue: ValueType? = e.value
                e.value = value
                return oldValue
            }
            
            entry = e.next
        }
        
        let e:HashMapEntry<KeyType, ValueType>? = self._table[index]
        self._table[index] = HashMapEntry(key: key, value: value, hash: hash, next: e)
        
        self._size+=1
        if (self._size >= self._threshold)
        {
            resize(newSize: 2 * self._table.count)
        }
        
        return nil
    }
    
    private mutating func resize(newSize: Int)
    {
        let oldTable: [HashMapEntry<KeyType, ValueType>?] = self._table
        let oldSize = oldTable.count
        
        if( oldSize == MAXIMUM_CAPACITY )
        {
            self._threshold = Int.max
            return
        }
        
        self._table = createNewTable(newSize: newSize)
        self._threshold = Int(Float(newSize) * self._loadFactor)
    }
    
    private func createNewTable(newSize: Int) -> [HashMapEntry<KeyType, ValueType>?]
    {
        var newTable: [HashMapEntry<KeyType, ValueType>?] = [HashMapEntry<KeyType, ValueType>?](repeating: nil, count: newSize)
        
        var src: [HashMapEntry<KeyType, ValueType>?] = self._table
        let newSize: Int = newTable.count
        
        for i in 0...src.count - 1
        {
            if let e = src[i]
            {
                src[i] = nil
                while let next = e.next
                {
                    let index: Int = HashMap.indexFor(h: next.hash, length: newSize)
                    next.next = newTable[index]
                    newTable[index] = next
                }
            }
        }
        
        return newTable
    }
    
    public mutating func putAll(map: HashMap<KeyType, ValueType>)
    {
        
    }
    
    @discardableResult
    public mutating func remove(key: KeyType) -> ValueType?
    {
        let hash: Int = HashMap.hash(h: key.hashValue)
        let index: Int = HashMap.indexFor(h: hash, length: self._table.count)
        var prev: HashMapEntry<KeyType, ValueType>? = self._table[index]
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
    
    public func size() -> Int
    {
        return self._size
    }
    
    public func values() -> [ValueType]
    {
        let entries: Set<MapEntry<KeyType, ValueType>> = entrySet()
        var values: [ValueType] = [ValueType]()
        
        for entry:MapEntry<KeyType, ValueType> in entries
        {
            values.append(entry.value!)
        }
        
        return values
    }
    
    public static func ==(lhs: HashMap, rhs: HashMap) -> Bool
    {
        return false
    }
    
    public var hashValue: Int {
        return 0
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
    internal static func hash(h: Int) -> Int
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

internal class HashMapEntry<K: Hashable, V: Hashable>: MapEntry<K, V>
{
    public var next: HashMapEntry<K, V>?
    public let hash: Int
    
    init(key: K, value: V?, hash: Int, next: HashMapEntry<K, V>?)
    {
        self.next = next
        self.hash = hash
        
        super.init(key: key, value: value)
    }
}
