//
//  Results.swift
//  ToDoList
//
//  Created by 박민우 on 1/17/25.
//

import SwiftUI
import SwiftData
struct Results: View {
    var name: String
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var matches: [Work] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(matches) { work in
                    HStack {
                        Text(work.content ?? "Not Found")
                        Spacer()
                        Text(work.date, style: .date)
                    }
                }
            }
            .navigationTitle("Results")
        }
        .task {
            let descriptor = FetchDescriptor<Work>(predicate: #Predicate<Work> { work in
                work.content?.contains(name) ?? false
            })
            do {
                matches = try modelContext.fetch(descriptor)
            } catch {
                print("Error fetching works: \(error)")
                matches = []
            }
        }
    }
}
#Preview {
    Results(name: "test")
        .modelContainer(for: Work.self, inMemory: true)
}
