//
//  User.swift
//  alias-game
//
//  Created by Никита Лисунов on 18.05.2023.
//

final class User {
    // MARK: - Fields
    static let shared: User = User()
    
    public var username: String = ""
    public var id: String = ""
    public var password: String = ""
    var roomID: String = ""
    var teamID: String = ""
    var role: String = ""

    
    // MARK: - LifeCycle
    private init() { }
}
