import GPSEntities

public struct CircuitsAPI {

    public init() {}

    public func f1Circuits(completion: @escaping ([GPSCircuit]) -> Void) {
        let client = Client<[GPSCircuit]>()
        client.get("/f1/circuits.json") { (circuits) in
            completion(circuits ?? [])
        }
    }

    public func f1Circuits(year: Int, completion: @escaping ([GPSCircuit]) -> Void) {
        let client = Client<[GPSCircuit]>()
        client.get("/f1/season/\(year)/circuits.json") { (circuits) in
            completion(circuits ?? [])
        }
    }

}
