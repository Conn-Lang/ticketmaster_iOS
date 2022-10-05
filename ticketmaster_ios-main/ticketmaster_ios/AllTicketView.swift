//
//  AllTicketView.swift
//  ticketmaster_ios
//
//  Created by Dylan Bolter on 1/20/22.
//

import SwiftUI

struct AllTicketView: View {
    @Environment(\.colorScheme) var currentMode
    @State var isShowingTeachers: Bool = true
    
    let allTickets: [AllTeacherTicket]
    let allStudentTickets: [AllStudentTicket]
    let fontSize = CGFloat(30)
    let pGreen = Color(UIColor(named: "pGreen")!)
    
    var body: some View {
        
        VStack {
            Text(isShowingTeachers ? "Showing Teachers" : "Showing Students").font(.system(size: 25))
                .foregroundColor(isShowingTeachers ? pGreen : currentMode == .dark ? .white : .black)
            Toggle("View", isOn: $isShowingTeachers)
                .labelsHidden()
        }.padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 2)
                    .foregroundColor(isShowingTeachers ? pGreen : currentMode == .dark ? .white : .black)
            )
        
        Text("All tickets").font(Font.custom("TradeWinds", size: 45))
        if isShowingTeachers {
            List{
                ForEach(allTickets, id: \.self) { teacher in
                    HStack{
                        Text("\(teacher.teacher_email)").font(.system(size: fontSize))
                        Spacer()
                        Text("Total Tickets Given: \(teacher.count)").font(.system(size: fontSize))
                    }.padding()
                }//ForEach
            }
        } else {
            List{
                ForEach(allStudentTickets, id: \.self) { student in
                    HStack{
                        Text("\(student.first_name) \(student.last_name)").font(.system(size: fontSize))
                        Spacer()
                        Text("Total Tickets Given: \(student.count)").font(.system(size: fontSize))
                    }.padding()
                }//ForEach
            }
        }
        
    }//View
}
