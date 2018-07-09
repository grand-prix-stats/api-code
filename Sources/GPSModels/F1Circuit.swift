
public struct F1Circuit: Codable {
    public let circuitRef: String
    public let name: String
}

public struct F1Race: Codable {
    public let raceRef: String
    public let year: Int
    public let round: Int
    public let circuitRef: String

    public var circuit: F1Circuit?
}
