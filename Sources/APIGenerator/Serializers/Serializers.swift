//
//  Serializers.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 2/24/19.
//

import Foundation

func serializeJSON<T: Encodable>(item: T) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(item)
    return String(data: data, encoding: .utf8) ?? ""
}

func serializeCSV<T: Encodable>(items: [T]) throws -> String {
    guard let first: T = items.first else {
        return ""
    }
    let headers = Mirror(reflecting: first).children.map { $0.label ?? "" }
    let rows = items.map { item -> String in
        let properties = Mirror(reflecting: item).children
        let values = headers.map { header -> String in
            guard let value = properties.first(where: { $0.label == header })?.value else {
                return ""
            }
            return unwrapToString(value).replacingOccurrences(of: "\"", with: "\\\"")
        }
        return csvRow(columns: values)
    }
    return ([csvRow(columns: headers)] + rows).joined(separator: "\n")
}

func csvRow(columns: [String]) -> String {
    return columns.map { "\"\($0)\"" }.joined(separator: ",")
}

func unwrapToString<T>(_ value: T) -> String {
    let mirror = Mirror(reflecting: value)
    guard mirror.displayStyle == .optional else {
        return String(describing: value)
    }
    guard let unwrapped = mirror.children.first else {
        return ""
    }
    return unwrapToString(unwrapped.value)
}
