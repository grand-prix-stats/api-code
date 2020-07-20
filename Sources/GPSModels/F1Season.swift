//
//  F1Season.swift
//  GPSModels
//
//  Created by Eneko Alonso on 7/8/19.
//

import Foundation

public struct F1Season: Codable {
    public let year: Int
    public let rounds: Int
    public let startDate: Date
    public let endDate: Date
    public let driversChampionRef: String?
    public let constructorsChampionRef: String?
    public let constructorChamtionsColor: String?
}
