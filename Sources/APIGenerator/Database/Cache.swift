//
//  Cache.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 1/26/19.
//

import Foundation
import Dispatch

fileprivate let defaultCacheLife: TimeInterval = 3600

fileprivate class CachedItem<V> {

    private let lifetime: TimeInterval
    private let cachedOn = Date().timeIntervalSince1970
    fileprivate let value: V

    fileprivate init(value: V, expiresAfter: TimeInterval) {
        self.value = value
        lifetime = expiresAfter
    }

    fileprivate var hasExpired: Bool {
        return cachedOn + lifetime < Date().timeIntervalSince1970
    }
}

class Cache<K: Hashable, V> {

    private var cache = [Int: CachedItem<V>]()
    private let semaphore = DispatchSemaphore(value: 1)

    func set(value: V, forKey: K, expiresAfter: TimeInterval = defaultCacheLife) {
        let key = forKey.hashValue
        let cachedItem = CachedItem(value: value, expiresAfter: expiresAfter)
        cache[key] = cachedItem
    }

    func get(key: K) -> V? {
        let key = key.hashValue
        guard let item = cache[key] else {
            return nil
        }
        if item.hasExpired {
            cache.removeValue(forKey: key)
            return nil
        }
        print("H", terminator: "")
        return item.value
    }

    func getOrFetch(key: K, expiresAfter: TimeInterval = defaultCacheLife,
                    fetch: () throws -> V) rethrows -> V {
        semaphore.wait()
        if let result = get(key: key) {
            semaphore.signal()
            return result
        }
        let result = try fetch()
        set(value: result, forKey: key, expiresAfter: expiresAfter)
        semaphore.signal()
        return result
    }

}
