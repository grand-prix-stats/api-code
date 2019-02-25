//
//  Spec.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 2/24/19.
//

import Foundation
import Swiftgger
import GPSModels

let openAPIBuilder = OpenAPIBuilder(
    title: "Grand Prix Stats API",
    version: "1.0",
    description: "Grand Prix Stats static JSON API",
    contact: APIContact(name: "Grand Prix Stats", url: URL(string: "https://grandprixstats.org")),
    license: APILicense(name: "Apache 2.0", url: URL(string: "http://www.apache.org/licenses/LICENSE-2.0.html"))
)

func generateSpec() throws {
    let server = APIServer(url: "/api/v1/f1")
    _ = openAPIBuilder.add(server)

    let allCircuitsResponse = APIResponse(code: "200", description: "Success", array: F1Circuit.self)
    let allCircuits = APIAction(method: .get,
                                route: "/circuits.json",
                                summary: "List of all Formula 1® circuits",
                                description: "Returns a list of all Formula 1® circuits",
                                parameters: nil,
                                request: nil,
                                responses: [allCircuitsResponse],
                                authorization: false)
    let singleCircuit = APIAction(method: .get,
                                  route: "/circuits/{circuitRef}.json",
                                  summary: "Retrieve a circuit by reference Id",
                                  description: "Returns a single circuit",
                                  parameters: [APIParameter(name: "circuitRef",
                                                            description: "Reference of the circuit",
                                                            required: true)],
                                  request: nil, responses: [APIResponse(code: "200", description: "Success", object: F1Circuit.self)],
                                  authorization: false)
    _ = openAPIBuilder.add(APIController(name: "F1 Circuit", description: "Circuits where Formula 1® races are held", actions: [
        allCircuits,
        singleCircuit
        ]))

    _ = openAPIBuilder.add([
        APIObject(object: try F1Circuit.makeExampleInstance())
        ])
    let document = openAPIBuilder.built()
    print(try serializeJSON(item: document))
}
