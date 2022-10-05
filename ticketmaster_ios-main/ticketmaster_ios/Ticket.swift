//
// Ticket.swift
// ticketmaster_ios
//
// Created by Hayden Langston on 10/14/21.
//
import Foundation

struct Ticket: Codable, Hashable{
    static func == (lhs: Ticket, rhs: Ticket) -> Bool {
        lhs.student_id == rhs.student_id &&
        lhs.ticket_timestamp == rhs.ticket_timestamp &&
        lhs.ticket_id == rhs.ticket_id &&
        lhs.ticket_description == rhs.ticket_description &&
        lhs.respectful == rhs.respectful &&
        lhs.responsible == rhs.responsible &&
        lhs.involved == rhs.involved
    }
    
    var student_id: String
    var first_name: String
    var last_name: String
    var ticket_timestamp: String
    var ticket_id: Int
    var ticket_description: String
    var teacher_email: String
    var respectful: Bool
    var responsible: Bool
    var involved: Bool
    
}

struct AllTeacherTicket: Codable, Hashable {
    var teacher_email: String
    var count: String
}

struct AllStudentTicket: Codable, Hashable {
    var student_id: String
    var first_name: String
    var last_name: String
    var count: String
}
