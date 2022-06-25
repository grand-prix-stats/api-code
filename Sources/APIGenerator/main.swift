import Foundation
import GPSEntities

let database = Database.shared

func run() throws {
    try database.connect()

    try CollectionGenerator<GPSCircuit>(table: "gpsCircuits", orderBy: "name").write(to: "apiv1/f1/circuits/all.json")
    try CollectionGenerator<GPSSeason>(table: "gpsSeasons", orderBy: "year").write(to: "apiv1/f1/seasons/all.json")
    try CollectionGenerator<GPSRace>(table: "gpsRaces", orderBy: "raceRef").write(to: "apiv1/f1/races/all.json")
//    try CollectionGenerator<F1Constructor>(table: "gpsConstructors", orderBy: "name").write(to: "apiv1/f1/constructors/all.json")
//    let circuits = try Query(sql: "select * from gpsCircuits order by name", database: database).execute() as [F1Circuit]
//    let csv = try serializeCSV(items: circuits)
//    print(csv)

    
}

try run()
