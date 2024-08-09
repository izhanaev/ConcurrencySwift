//
//  DataProcessor.swift
//  ConcurrencySwift
//
//  Created by Ильяс Жанаев on 09.08.2024.
//

import Foundation

class DataProcessor: ObservableObject {
    @Published var tasks: [TaskModel] = []
    
    private let serverURL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    init() {
        Task {
            await fetchTasks()
        }
    }
    
    func fetchTasks() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: serverURL.appendingPathComponent("/tasks"))
            
            let fetchedTasks = try JSONDecoder().decode([TaskModel].self, from: data)
            
            DispatchQueue.main.async {
                self.tasks = fetchedTasks
            }
            
            await processTasks()
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func processTasks() async {
        for task in tasks {
            let resultData = await performComputation(on: task.data)
            let result = Result(taskId: task.id, resultData: resultData)
            await sendResult(result)
        }
    }
    
    func performComputation(on data: [Int]) async -> [Int] {
        return data.sorted()
    }
    
    func sendResult(_ result: Result) async {
        do {
            var request = URLRequest(url: serverURL.appendingPathComponent("/results"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(result)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Result sent successfully for task \(result.taskId)")
            } else {
                print("Failed to send result for task \(result.taskId)")
            }
        } catch {
            print("Error sending result: \(error)")
        }
    }
}
