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
    public let date: Date
    public let time: TimeInterval?
    public let circuitRef: String
    public let circuitName: String
    public let winningDriverRef: String?
    public let winningConstrucrotRef: String?
    public let winningConstructorName: String?
    public let winningConstructorColor: String?
}
