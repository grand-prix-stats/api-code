import Foundation
import MySQL
import GPSModels
import Swiftgger

let database = Database.shared

let openAPIBuilder = OpenAPIBuilder(
    title: "Grand Prix Stats API",
    version: "1.0",
    description: "Grand Prix Stats static JSON API",
    contact: APIContact(name: "Grand Prix Stats", url: URL(string: "https://grandprixstats.org")),
    license: APILicense(name: "Apache 2.0", url: URL(string: "http://www.apache.org/licenses/LICENSE-2.0.html"))
)

func run() throws {
    print("Connecting to database...")
    try database.connect()
    let sql = "select * from gpsCircuits"
    let circuits = try Query(sql: sql, database: database).execute() as [F1Circuit]
    print(try serialize(item: circuits))
}

func serialize<T: Encodable>(item: T) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(item)
    return String(data: data, encoding: .utf8) ?? ""
}

//try run()

struct Exception: Error, LocalizedError {
    let message: String
    var localizedDescription: String {
        return message
    }
}

let server = APIServer(url: "/api/v1/f1")
_ = openAPIBuilder.add(server)

let allCircuitsResponse = APIResponse(code: "200", description: "Success", array: F1Circuit.self)
let allCircuits = APIAction(method: .get,
                            route: "/circuits/all.json",
                            summary: "List of all Formula 1® circuits",
                            description: "Retrieve a list of all Formula 1® circuits",
                            parameters: nil,
                            request: nil,
                            responses: [allCircuitsResponse],
                            authorization: false)
_ = openAPIBuilder.add(APIController(name: "F1 Circuit", description: "Circuits where Formula 1® races are held", actions: [allCircuits]))

_ = openAPIBuilder.add([
    APIObject(object: try F1Circuit.makeExampleInstance())
])
let document = openAPIBuilder.built()
print(try serialize(item: document))
