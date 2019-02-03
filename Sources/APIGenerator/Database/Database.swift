//
//  Database.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 1/26/19.
//

import MySQL
import DotEnv

protocol DatabaseType {
    func connect() throws
    func execute<T: Codable>(_ query: Query) throws -> [T]
}

class Database: DatabaseType {

    static let shared = Database()
    let env = DotEnv(withFile: ".env")

    var connection: MySQLConnection?

    enum Error: Swift.Error {
        case notConnected
        case noData
    }

    func connect() throws {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        connection = try MySQLConnection.connect(config: .init(
            hostname: env.get("DB_HOST") ?? "localhost",
            port: env.getAsInt("DB_PORT") ?? 3306,
            username: env.get("DB_USER") ?? "",
            password: env.get("DB_PASS") ?? "",
            database: env.get("DB_NAME") ?? "",
            characterSet: .utf8mb4_unicode_ci,
            transport: .unverifiedTLS
            ), on: group).wait()
        connection?.logger = DatabaseLogger(database: .mysql, handler: PrintLogHandler())
    }

    @discardableResult
    func execute<T: Codable>(_ query: Query) throws -> [T] {
        guard let connection = connection else {
            throw Error.notConnected
        }
        return try connection.raw(query.sql).binds(query.values).all(decoding: T.self).wait()
    }

}
