//
//  ViewTickets.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 10/12/21.
//

import SwiftUI

struct ViewTickets: View {
    @Environment(\.colorScheme) var currentMode
    
    @State var emptyString = ""
    @State var lightGrey = Color(red: 191/255, green: 191/255, blue: 191/255)
    @State var studentPhotoId = 0
    @State var firstName = ""
    @State var lastName = ""
    @State var isShowingSend = false
    @State var tickets: [Ticket] = []
    
    let student: Student
    let idToken: String
    let pGreen = Color(UIColor(named: "pGreen")!)
    
    var body: some View {

                
        VStack{
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: student.photo_url), scale: 2) {phase in
                    if let image = phase.image {
                        image
                            .clipShape(RoundedRectangle(cornerRadius: 40).size(width: 200, height: 266.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 45)
                                    .size(width: 210, height: 276.5)
                                    .stroke(currentMode == .dark ? .white : .black, lineWidth: 5)
                                    .offset(x: -5, y: -5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .size(width: 200, height: 266.5)
                                    .stroke(pGreen, lineWidth: 5)
                            ).shadow(color: currentMode == .dark ? .white : .black, radius: 7)
                            
                            .padding(.top, -50)
                    } else if phase.error != nil {
                        Image("404error")
                            .resizable()
                            .frame(width: 389, height: 95)
                            .padding(.all, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .size(width: 409, height: 115)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .padding(.bottom, 30)
                            .padding(.top, -30)
                    } else {
                        ProgressView()
                            .padding(.bottom, 132.5)
                            .padding(.top, 54)
                    }
                }
                    
            } else {
                // Fallback on earlier versions
                Image("404error")
                    .resizable()
                    .frame(width: 389, height: 95)
                    .padding(.all, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .size(width: 409, height: 115)
                            .stroke(.black, lineWidth: 3)
                    )
                    .padding(.bottom, 30)
                    .padding(.top, -30)
            }
            
            Text("Name: \(student.first_name) \(student.last_name)")
            Text("Grade: \(student.grade_level)")
            
            List {
                ForEach(tickets, id: \.self) { ticket in
                    HStack {
                        Spacer()
                        VStack {
                            Text("This ticket was given out by: \(ticket.teacher_email)").font(.system(size: 20))
                            Text("Date Given: \(convertStringToDate(date:ticket.ticket_timestamp), style: .date)").font(.system(size: 20))
                            Text("Description: \(ticket.ticket_description)").font(.system(size: 20)).lineLimit(nil)
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
                    }//HStack
                }//ForEach
            }//List
        }.onAppear() {
            print("running get tickets")
            self.getTickets()
        }
    }//body
    
    func getTickets() {
        let urlString = Constants.baseUrl + "/tickets/student/\(student.student_id)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("parsing")
            if let data = data {
                do{
                    let decodedData = try JSONDecoder().decode([Ticket].self, from: data)
                    self.tickets = decodedData
                    
                }catch{
                    print(error)
                }
            }
            
        }
        task.resume()
    }//Get Tickets
    
    
}//ViewTickets

private func convertStringToDate(date:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .init(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let convertedDate = dateFormatter.date(from: date) {
        return convertedDate
    }
    return Date(timeIntervalSinceReferenceDate: 0)
}//convert string to date function

