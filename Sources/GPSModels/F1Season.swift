//
//  F1Season.swift
//  GPSModels
//
//  Created by Eneko Alonso on 7/8/19.
//

import Foundation

public struct F1Season: Codable {
    let year: Int
    let rounds: Int
    let startDate: Date
    let endDate: Date
    let driversChampionRef: String?
    let constructorsChampionRef: String?
    let constructorChamtionsColor: String?
}
