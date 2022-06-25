//
//  ExampleModels.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 1/26/19.
//

import Foundation
import GPSEntities

struct Exception: Error, LocalizedError {
    let message: String
    var localizedDescription: String {
        return message
    }
}

protocol ExampleModelable {
    static var exampleJSON: String { get }
}

extension ExampleModelable where Self: Decodable {
    static func makeExampleInstance() throws -> Self {
        guard let data = exampleJSON.data(using: .utf8) else {
            throw Exception(message: "Failed to make instance of \(Self.self)")
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}

extension GPSCircuit: ExampleModelable {
    static let exampleJSON = """
    {
        "name" : "Circuit de Monaco",
        "circuitRef" : "monaco",
        "location" : "Monte-Carlo",
        "races" : 66
    }
    """
}
