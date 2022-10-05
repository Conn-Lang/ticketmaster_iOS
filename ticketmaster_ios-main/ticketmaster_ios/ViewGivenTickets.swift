//
//  ViewGivenTickets.swift
//  ticketmaster_ios
//
//  Created by Dylan Bolter on 11/12/21.
//

import SwiftUI

struct ViewGivenTickets: View {
    @Environment(\.colorScheme) var currentMode
    
    
    @State var studentId = ""
    
    let tickets: [Ticket]
    let students: [TicketStudent]
    
    var body: some View {
        
        VStack {
            
            Text("Given Tickets").font(Font.custom("TradeWinds", size: 40)).fontWeight(.bold)
            
            List {
                ForEach(tickets, id: \.self) { ticket in
                    HStack {
                        Spacer()
                        VStack {
                            Text("Given to:  \(ticket.first_name) \(ticket.last_name)").font(.system(size: 20))
                            Text("Date Given: \(convertStringToDate(date:ticket.ticket_timestamp), style: .date)").font(.system(size: 20))
                            Text("Description: \(ticket.ticket_description)").font(.system(size: 20)).lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                            
                                HStack{
                                    Text("Respectful")
                                        .font(.system(size: 20))
                                        .foregroundColor(currentMode == .dark ? .white : .black)
                                    Image(systemName: ticket.respectful ? "checkmark.square": "square")
                                        .foregroundColor(currentMode == .dark ? .white : .black)
                                    Text("Responsible")
                                        .font(.system(size: 20))
                                        .foregroundColor(currentMode == .dark ? .white : .black)
                                    Image(systemName: ticket.responsible ? "checkmark.square": "square")
                                        .foregroundColor(currentMode == .dark ? .white : .black)
                                    Text("Involved")
                                        .font(.system(size: 20))
                                        .foregroundColor(currentMode == .dark ? .white : .black)
                                    Image(systemName: ticket.involved ? "checkmark.square": "square")
                                        .foregroundColor(currentMode == .dark ? .white : .black)
                                }.padding()
                        }.frame(width: 500, height: 150).padding().background(.gray).border(currentMode == .dark ? .white : .black, width: 4).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
        }
    }
    
    
    private func convertStringToDate(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let convertedDate = dateFormatter.date(from: date) {
            return convertedDate
        }
        return Date(timeIntervalSinceReferenceDate: 0)
    }//convert string to date function
    
}

