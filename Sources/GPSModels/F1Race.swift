//
//  F1Race.swift
//  GPSModels
//
//  Created by Eneko Alonso on 7/7/19.
//

import Foundation

public struct F1Race: Codable {
    public let raceRef: String
    public let year: Int
    public let round: Int
    public let circuitRef: String
    public let circuitName: String
}