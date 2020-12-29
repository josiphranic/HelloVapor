import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.delete(use: delete)
            todo.put(use: update)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        todo.id = nil
        return todo.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let newTodo = try req.content.decode(Todo.self)
        let todoId = req.parameters.get("todoID") ?? ""
        // TODO
        let todoUUID = UUID(uuidString: todoId)!
        return Todo.query(on: req.db)
            .set(\.$title, to: newTodo.title)
            .set(\.$subtitle, to: newTodo.subtitle)
            .set(\.$createdDate, to: newTodo.createdDate)
            .set(\.$isDone, to: newTodo.isDone)
            .filter(\.$id == todoUUID)
            .update()
            .transform(to: .ok)
    }
}
