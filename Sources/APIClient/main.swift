import Foundation
import GrandPrixStatsKit

let semaphore = DispatchSemaphore(value: 0)
CircuitsAPI().f1Circuits { (circuits) in
    circuits.compactMap { $0.name }.sorted().forEach { print($0) }
    semaphore.signal()
}
semaphore.wait()

let semaphore2 = DispatchSemaphore(value: 0)
CircuitsAPI().f1Circuits(year: 2018) { (circuits) in
    circuits.compactMap { $0.name }.sorted().forEach { print($0) }
    semaphore2.signal()
}
semaphore2.wait()

