//
//  CollectionGenerator.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 2/2/19.
//

import Foundation

struct CollectionGenerator<Model: Codable> {
    let tableName: String
//    let fileName: String

    func load() throws -> [Model] {
        let sql = "select * from \(tableName)"
        return try Query(sql: sql, database: database).execute() as [Model]
    }
}
