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

    func connect() throws {
        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none
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
}
