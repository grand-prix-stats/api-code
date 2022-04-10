//
//  CollectionGenerator.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 2/2/19.
//

import Foundation
import MySQLKit

/// Simple collection generator to load SQL tables and dump to JSON or CSV files
/// Warning: this type is prone to SQL injection, use with caution
struct CollectionGenerator<Model: Codable> {
    let table: String
    let orderBy: String

    func load() throws -> [Model] {
        let sql = "select * from \(table) order by \(orderBy)"
//        return try Query(sql: sql, database: database).execute() as [Model]
        return try Database.shared.sql.raw(SQLQueryString(sql)).all(decoding: Model.self).wait()
    }

    func write(to filename: String) throws {
        let rows = try load()
        let json = try serializeJSON(item: rows)
        let filepath = URL(fileURLWithPath: filename)
        let directory = filepath.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        try json.write(to: filepath, atomically: true, encoding: .utf8)
    }
}
