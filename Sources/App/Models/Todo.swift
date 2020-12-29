import Fluent
import Vapor

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @OptionalField(key: "subtitle")
    var subtitle: String?

    @Field(key: "createdDate")
    var createdDate: Date

    @Field(key: "isDone")
    var isDone: Bool

    init() { }

    init(id: UUID? = nil,
         title: String,
         subtitle: String?,
         createdDate: Date,
         isDone: Bool) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.createdDate = createdDate
        self.isDone = isDone
    }
}
