import GPSModels

public struct CircuitsAPI {

    public init() {}

    public func f1Circuits(completion: @escaping ([F1Circuit]) -> Void) {
        let client = Client<[F1Circuit]>()
        client.get("/f1/circuits.json") { (circuits) in
            completion(circuits ?? [])
        }
    }

    public func f1Circuits(year: Int, completion: @escaping ([F1Circuit]) -> Void) {
        let client = Client<[F1Circuit]>()
        client.get("/f1/season/\(year)/circuits.json") { (circuits) in
            completion(circuits ?? [])
        }
    }

}
