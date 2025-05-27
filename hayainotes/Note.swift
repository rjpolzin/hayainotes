import Foundation
import SwiftData

@Model
class Note {
    var title: String
    var content: String
    var dateCreated: Date

    init(title: String, content: String, dateCreated: Date = .now) {
        self.title = title
        self.content = content
        self.dateCreated = dateCreated
    }
}

