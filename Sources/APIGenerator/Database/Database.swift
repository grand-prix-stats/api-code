//
//  Database.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 1/26/19.
//

import Foundation
import MySQLKit
import DotEnv

protocol DatabaseType {
    func connect() throws
//    func execute<T: Codable>(_ query: Query) throws -> [T]
}

class Database: DatabaseType {
    static let shared = Database()
    let env = DotEnv(withFile: ".env")
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    var eventLoopGroup: EventLoopGroup!
    var pools: EventLoopGroupConnectionPool<MySQLConnectionSource>!

    init() {
        encoder.dateEncodingStrategy = .secondsSince1970
        decoder.dateDecodingStrategy = .secondsSince1970
    }

    var sql: SQLDatabase {
        mysql.sql(encoder: .init(json: encoder), decoder: .init(json: decoder))
    }

    var mysql: MySQLDatabase {
        pools.database(logger: .init(label: "con.grandprixstats.api"))
    }

//    enum Error: Swift.Error {
//        case notConnected
//        case noData
//    }
//
    func connect() throws {
        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none
//
        //        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        //        let configuration = MySQLConfiguration(
        //            hostname: env.get("DB_HOST") ?? "localhost",
        //            port: env.getAsInt("DB_PORT") ?? 3306,
        //            username: env.get("DB_USER") ?? "",
        //            password: env.get("DB_PASS") ?? "",
        //            database: env.get("DB_NAME") ?? ""
        //            //,
        ////            characterSet: .utf8mb4_unicode_ci,
        ////            transport: .unverifiedTLS
        ////            tlsConfiguration: TLSConfiguration.
        //        )
        ////        connection = try MySQLConnection.connect( on: group).wait()
        //        connection = try MySQLConnection.connect(
        //            to: .init(
        //                ipAddress: env.get("DB_HOST") ?? "localhost",
        //                port: env.getAsInt("DB_PORT") ?? 3306
        //            ),
        //            username: env.get("DB_USER") ?? "",
        //            database: env.get("DB_NAME") ?? "",
        //            password: env.get("DB_PASS") ?? "",
        //            on: group
        //        ).wait()
        ////        connection?.logger = DatabaseLogger(database: .mysql, handler: PrintLogHandler())
//
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let configuration = MySQLConfiguration(
            hostname: env.get("DB_HOST") ?? "localhost",
            port: env.getAsInt("DB_PORT") ?? 3306,
            username: env.get("DB_USER") ?? "",
            password: env.get("DB_PASS") ?? "",
            database: env.get("DB_NAME") ?? "",
            tlsConfiguration: tls
        )
        pools = .init(
            source: .init(configuration: configuration),
            maxConnectionsPerEventLoop: 2,
            requestTimeout: .seconds(30),
            logger: .init(label: "codes.vapor.mysql"),
            on: eventLoopGroup
        )
    }
//
    //    @discardableResult
    //    func execute<T: Codable>(_ query: Query) throws -> [T] {
    ////        guard let connection = connection else {
    ////            throw Error.notConnected
    ////        }
    ////        return try connection.raw(query.sql).binds(query.values).all(decoding: T.self).wait()
    //        mysql.query(query.sql, query.values).
    //    }
//
    //    @discardableResult
    //    func execute2(_ query: Query) throws {
    //        guard let connection = connection else {
    //            throw Error.notConnected
    //        }
    //        return try connection.raw(query.sql).binds(query.values).all().wait()
    //    }
//
}
