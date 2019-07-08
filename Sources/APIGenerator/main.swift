import Foundation
import MySQL
import GPSModels

let database = Database.shared

func run() throws {
    try database.connect()

    try CollectionGenerator<F1Circuit>(table: "gpsCircuits", orderBy: "name").write(to: "apiv1/f1/circuits/all.json")
    try CollectionGenerator<F1Race>(table: "gpsRaces", orderBy: "raceRef").write(to: "apiv1/f1/races/all.json")
//    try CollectionGenerator<F1Constructor>(table: "gpsConstructors", orderBy: "name").write(to: "apiv1/f1/constructors/all.json")
//    let circuits = try Query(sql: "select * from gpsCircuits order by name", database: database).execute() as [F1Circuit]
//    let csv = try serializeCSV(items: circuits)
//    print(csv)

    
}

try run()
