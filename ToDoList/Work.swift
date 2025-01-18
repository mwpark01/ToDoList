//
//  Work.swift
//  ToDoList
//
//  Created by 박민우 on 1/17/25.
//

import Foundation
import SwiftData

@Model
final class Work {
    var content: String?
    var date: Date
    var isDone: Bool
    var isEditing: Bool = false
    init(content: String, date: Date, isDone: Bool = false) {
        self.content = content
        self.date = date
        self.isDone = isDone
    }
}

