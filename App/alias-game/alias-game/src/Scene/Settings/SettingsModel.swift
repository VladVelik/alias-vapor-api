//
//  SettingsModel.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

enum SettingsModel {
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum Auth {
        struct Request {
            let username: String
            let password: String
            
        }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum MainMenu {
        struct Request {}
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
