//
//  ContentView.swift
//  ToDoList
//
//  Created by 박민우 on 1/17/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var content: String = ""
    @State var editingContent: String = ""
    @State var date: Date = Date()
    @State var editing: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var works: [Work]
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("TODO")
                    .font(.largeTitle)
                    .bold()
                HStack {
                    TextField("추가하실 일을 작성해주세요.", text: $content)
                        .foregroundStyle(.black)
                    Button(action: {
                        content = ""
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.gray)
                    })
                    
                    Button(action: {
                        if !content.isEmpty {
                            addWork()
                        }
                        
                    }, label: {
                        Image(systemName: "plus")
                            .bold()
                    })
                    NavigationLink(destination: Results(name: content)) {
                        Image(systemName: "magnifyingglass")
                            .bold()
                    }
                }
                .padding()
                .foregroundStyle(.green)
                .border(Color.green, width: 4)
                .frame(maxWidth: .infinity)
                List {
                    ForEach(works) { work in
                        VStack {
                            HStack {
                                Button(action: {
                                    toggleIsDone(work)
                                }, label: {
                                    if work.isDone {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                    } else {
                                        Image(systemName:
                                                "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                    }
                                })
                                if work.isEditing {
                                    TextField("", text: $editingContent)
                                        .onSubmit {
                                            // 엔터 키 눌렀을 때 실행할 코드
                                            work.isEditing = false
                                            work.content = editingContent
                                            editingContent = ""
                                        }
                                } else {
                                    Text(work.content ?? "")
                                        .onLongPressGesture(minimumDuration: 0.5) {
                                            work.isEditing = true
                                            editingContent = work.content ?? ""
                                        }
                                }
                                Spacer()
                            }
                            
                            Text(work.date, style: .date)
                                .font(.caption)
                                .italic()
                        }
                    }
                    .onDelete(perform: deleteWork)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
    
    func toggleIsDone(_ work: Work) {
        work.isDone = !work.isDone
    }
    
    func addWork() {
        withAnimation {
            
            let newWork = Work(content: content, date: Date())
            modelContext.insert(newWork)
        }
    }
    
    func deleteWork(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(works[index])
            }
        }
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Work.self, inMemory: true)
}
