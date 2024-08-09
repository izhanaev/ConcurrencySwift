//
//  TaskModel.swift
//  ConcurrencySwift
//
//  Created by Ильяс Жанаев on 09.08.2024.
//

import Foundation

struct TaskModel: Codable, Identifiable {
    let id: String
    let data: [Int]
}
