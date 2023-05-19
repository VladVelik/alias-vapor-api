//
//  AuthorizationModel.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

enum AuthorizationModel {
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum Registration {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum MainMenu {
        struct Request {
            let username: String
            let password: String
        }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    struct User: Decodable {
        var id: String
        var username: String
        var email: String
        var login_status: Bool
    }
}
