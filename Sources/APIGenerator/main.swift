import Foundation
import MySQL
import GPSModels
import DotEnv

let env = DotEnv(withFile: ".env")

let database = Database.shared

func run() throws {
    print("Connecting to database...")
    try database.connect()
    let sql = "select * from gps_circuits"
    let circuits = try Query(sql: sql, database: database).execute() as [F1Circuit]

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(circuits)
    if let json = String.init(data: data, encoding: .utf8) {
        print(json)
    }
}

try run()
