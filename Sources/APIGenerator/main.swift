import Foundation
import MySQL
import GPSModels
import DotEnv

enum GeneratorError: Error {
    case notFound
    case serializationError
}

let env = DotEnv(withFile: ".env")

struct GPSDB: ConnectionOption {
    let host: String = env.get("DB_HOST") ?? "localhost"
    let port: Int = env.getAsInt("DB_PORT") ?? 3306
    let user: String = env.get("DB_USER") ?? ""
    let password: String = env.get("DB_PASS") ?? ""
    let database: String = env.get("DB_NAME") ?? ""
}

func encode<T: Encodable>(rows: T) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(rows)
    guard let json = String.init(data: data, encoding: .utf8) else {
        throw GeneratorError.serializationError
    }
    return json
}

func loadCircuits(pool: ConnectionPool) throws -> [String: F1Circuit] {
    let rows: [F1Circuit] = try pool.execute { conn in
        try conn.query("SELECT * FROM gps_circuits;")
    }
    return Dictionary(uniqueKeysWithValues: rows.map { ($0.circuitRef, $0) })
}

func loadCircuits(refs: [String], pool: ConnectionPool) throws -> [String: F1Circuit] {
    let rows: [F1Circuit] = try pool.execute { conn in
        try conn.query("SELECT * FROM gps_circuits WHERE circuitRef in (?);", [QueryParameterArray(refs)])
    }
    return Dictionary(uniqueKeysWithValues: rows.map { ($0.circuitRef, $0) })
}

func loadRaces(pool: ConnectionPool) throws -> [String: F1Race] {
    let rows: [F1Race] = try pool.execute { conn in
        try conn.query("SELECT raceRef, year, round, circuitRef FROM gps_races;")
    }
    return Dictionary(uniqueKeysWithValues: rows.map { ($0.raceRef, $0) })
}

func loadRaces(year: Int, pool: ConnectionPool) throws -> [String: F1Race] {
    let rows: [F1Race] = try pool.execute { conn in
        try conn.query("SELECT raceRef, year, round, circuitRef FROM gps_races WHERE year = ?;", [year])
    }
    return Dictionary(uniqueKeysWithValues: rows.map { ($0.raceRef, $0) })
}

let pool = ConnectionPool(options: GPSDB())

var races = try loadRaces(year: 2018, pool: pool)
let circuits = try loadCircuits(refs: races.map { $0.value.circuitRef }, pool: pool)
for race in races.values {
    races[race.raceRef]?.circuit = circuits[race.circuitRef]
}
print(try encode(rows: races))
