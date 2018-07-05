import Foundation
import MySQL
import GPSModels
import DotEnv

let env = DotEnv(withFile: ".env")

struct GPSDB: ConnectionOption {
    let host: String = env.get("DB_HOST") ?? "localhost"
    let port: Int = env.getAsInt("DB_PORT") ?? 3306
    let user: String = env.get("DB_USER") ?? ""
    let password: String = env.get("DB_PASS") ?? ""
    let database: String = env.get("DB_NAME") ?? ""
}

let pool = ConnectionPool(options: GPSDB())
let rows: [F1Circuit] = try pool.execute { conn in
	try conn.query("SELECT * FROM gps_circuits;")
}

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let data = try encoder.encode(rows)
if let json = String.init(data: data, encoding: .utf8) {
    print(json)
}
