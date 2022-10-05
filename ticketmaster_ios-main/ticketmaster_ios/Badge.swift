//
//  Badge.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 1/4/22.
//
import Foundation

class Badge: Codable, Identifiable{
    
    static func == (lhs: Badge, rhs: Badge) -> Bool {
        lhs.badge_id == rhs.badge_id &&
        lhs.badge_name == rhs.badge_name &&
        lhs.badge_image == rhs.badge_image
    }
    
    var badge_id: Int
    var badge_name: String
    var badge_image: String
    
    init(badge_id: Int, badge_name: String, badge_image: String){
        self.badge_id = badge_id
        self.badge_name = badge_name
        self.badge_image = badge_image
    }
}
