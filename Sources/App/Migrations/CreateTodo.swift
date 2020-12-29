import Fluent

struct CreateTodo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos")
            .field(.id, .uuid, .identifier(auto: true))
            .field("title", .string, .required)
            .field("subtitle", .string)
            .field("createdDate", .date, .required)
            .field("isDone", .bool, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos").delete()
    }
}
