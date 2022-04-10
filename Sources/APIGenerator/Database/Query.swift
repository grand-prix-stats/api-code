//
//  Query.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 1/26/19.
//

import Foundation
import MySQLKit

class Query {
    let sql: String
    let values: [Encodable]
    let database: Database

    init(sql: String, values: [Encodable] = [], database: Database = .shared) {
        self.sql = sql
        self.values = values
        self.database = database
    }
}

// MARK: Query Cache

extension Query {
    static var cache = Cache<String, [Codable]>()

    var key: String {
        sql + ":::" + stringValues.joined(separator: ":::")
    }

    var stringValues: [String] {
        values.map {
            ($0 as? CustomStringConvertible)?.description ?? ""
        }
    }

//    @discardableResult
//    func execute<T: Codable>() throws -> [T] {
//        if let result = Query.cache.get(key: key) as? [T] {
//            return result
//        }
//
//        let result: [T] = try database.execute(self)
//        Query.cache.set(value: result, forKey: key)
//        return result
//    }

}
