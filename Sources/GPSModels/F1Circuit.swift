
public struct F1Circuit: Codable {
    public let circuitRef: String
    public let name: String
    public let location: String
    public let country: String
    public let countryFlag: String
    public let countryCode: String
    public let lat: Double
    public let lng: Double
    public let alt: Int?
    public let url: String
    public let races: Int
    public let totalDrivers: Int
    public let winningDrivers: Int
    public let podiumDrivers: Int
    public let mostWinsDriver: String?
    public let mostWinsDriverWins: Int?
    public let totalConstructors: Int
    public let winningConstructors: Int
    public let podiumConstructors: Int
    public let mostWinsConstructor: String?
    public let mostWinsCondtructorWins: Int?
}
