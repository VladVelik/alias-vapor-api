import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "What do you want?"
    }
    
    try app.register(collection: UsersController())
    try app.register(collection: RoomsController())
    try app.register(collection: TeamsController())
    try app.register(collection: ParticipantsController())
}
