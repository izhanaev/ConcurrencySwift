//
//  ContentView.swift
//  ConcurrencySwift
//
//  Created by Ильяс Жанаев on 04.08.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataProcessor = DataProcessor()

    var body: some View {
        NavigationView {
            List(dataProcessor.tasks) { task in
                VStack(alignment: .leading) {
                    Text("Task ID: \(task.id)")
                        .font(.headline)
                    Text("Data: \(task.data.map { String($0) }.joined(separator: ", "))")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Tasks")
            .refreshable {
                await dataProcessor.fetchTasks()
            }
        }
    }
}
