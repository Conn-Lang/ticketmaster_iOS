//
//  Student.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 11/2/21.
//

import Foundation

struct Items: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    var items: [UserInfo]
    struct UserInfo: Decodable, Comparable {
        static func < (lhs: Items.UserInfo, rhs: Items.UserInfo) -> Bool {
            
            guard let a = Int(lhs.period), let b = Int(rhs.period) else {
                print("fail")
                return false
            }
            return a > b
        }
        
        var id: Int
        var photoid: Int
        var grade: Int
        var name: String
        var period: String
        var course: String
        var room: String
    }

}



class Student: Codable, Identifiable, Hashable {
    static func == (lhs: Student, rhs: Student) -> Bool {
        if(lhs.student_id == rhs.student_id) {
            return true
        }
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(student_id)
    }
    
    var first_name: String
    var last_name: String
    var student_id: String
    var grade_level: Int
    var photo_id: Int
    var photo_url: String
    
    init(first_name: String, last_name: String, student_id: String, grade: Int, photo_id: Int, photo_url: String){
        self.first_name = first_name
        self.last_name = last_name
        self.student_id = student_id
        self.grade_level = grade
        self.photo_id = photo_id
        self.photo_url = photo_url
    }
    init() {
        first_name = "Loading"
        last_name = "Ticket"
        student_id = "00000"
        grade_level = 0
        photo_id = 0
        photo_url = ""
    }
}

class TicketStudent: Codable, Identifiable, Hashable {
    static func == (lhs: TicketStudent, rhs: TicketStudent) -> Bool {
        if(lhs.student_id == rhs.student_id) {
            return true
        }
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(student_id)
    }
    
    var first_name: String
    var last_name: String
    var student_id: String
    var grade_level: Int
    
    init(firstName: String, lastName: String, studentId: String, grade: Int){
        self.first_name = firstName
        self.last_name = lastName
        self.student_id = studentId
        self.grade_level = grade
    }
    init() {
        first_name = "John"
        last_name = "Doe"
        student_id = "00000"
        grade_level = 0
    }
}

class Admin: Codable, Identifiable, Equatable{
    static func == (lhs: Admin, rhs: Admin) -> Bool {
        if lhs.email == rhs.email {
            return true
        }
        return false
    }
    
    var email: String
    
    init(email: String) {
        self.email = email
    }
    
}

struct NameSearch: Decodable {
    
    var student_id: String
    var grade_level: Int
    var first_name: String
    var last_name: String
    var student_email: String
    var has_ninety_attendance: Bool
    var has_fines: Bool
    var school_id: Int
    
}

struct Teacher: Decodable {
    
    var teacher_email: String
    var first_name: String
    var last_name: String
    
}
