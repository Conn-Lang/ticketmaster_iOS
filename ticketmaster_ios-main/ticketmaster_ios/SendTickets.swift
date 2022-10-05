//
//  SendTickets.swift
//  ticketmaster_ios
//
//  Created by Dylan Bolter on 10/11/21.
//

import SwiftUI

struct SendTickets: View {
    @Environment(\.colorScheme) var currentMode
    
    @State var descriptionText = ""
    @State var respectfulIsChecked:Bool = false
    @State var responsibleIsChecked:Bool = false
    @State var involvedIsChecked:Bool = false
    @State var errorMessage = ""
    
    @FocusState private var studentFieldIsFocued: Bool
    @FocusState private var teacherFieldIsFocued: Bool
    @FocusState private var descriptionFieldIsFocued: Bool
    
    @State var showingAlert = false
    @State var showingSucess = false
    @State var isShowingTickets = false
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    let student_id: String
    let teacherEmail: String
    let idToken: String
    let student: Student
    
    var body: some View {
        let pGreen = Color(UIColor(named: "pGreen")!)
        
        VStack {
            HStack{
                Spacer()
                NavigationLink(destination: ViewTickets(student: student, idToken: idToken), isActive: $isShowingTickets) {
                    Button("View Tickets", action: {
                        self.isShowingTickets = true
                    }).font(Font.custom("TradeWinds", size: 25))
                        .padding()
                        .foregroundColor(.black)
                        .background(pGreen)
                        .cornerRadius(80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 80)
                                .stroke(currentMode == .dark ? .white : .black, lineWidth: 4)
                        )
                        .padding(.trailing, 15).padding(.bottom, 25)
                }
            }
            
            VStack {
                Text("Sending to: \(student.first_name) \(student.last_name)")
                Text("Send Ticket").font(.custom("TradeWinds", size: 40)).padding(.top, 45)
                VStack {
                    HStack{
                        Text("Description: ").font(.system(size: 25.0))
                        TextEditor(text: $descriptionText)
                            .font(.system(size: 25.0))
                            .border(currentMode == .dark ? .white : .black, width: 2)
                            .focused($descriptionFieldIsFocued)
                            .ignoresSafeArea(.keyboard)
                    }.padding() //Description Box HStack
                    HStack {
                        Button(action: toggleRespectful) {
                            HStack{
                                Text("Respectful")
                                    .font(.system(size: 30))
                                    .foregroundColor(currentMode == .dark ? .white : .black)
                                Image(systemName: respectfulIsChecked ? "checkmark.square": "square")
                                    .foregroundColor(currentMode == .dark ? .white : .black)
                            }.padding()
                        }// Respectful Checkbox
                        Button(action: toggleResponsible) {
                            HStack{
                                Text("Responsible")
                                    .font(.system(size: 30))
                                    .foregroundColor(currentMode == .dark ? .white : .black)
                                Image(systemName: responsibleIsChecked ? "checkmark.square": "square")
                                    .foregroundColor(currentMode == .dark ? .white : .black)
                            }.padding()
                        }// Responsible Checkbox
                        Button(action: toggleInvolved) {
                            HStack{
                                Text("Involved")
                                    .font(.system(size: 30))
                                    .foregroundColor(currentMode == .dark ? .white : .black)
                                Image(systemName: involvedIsChecked ? "checkmark.square": "square")
                                    .foregroundColor(currentMode == .dark ? .white : .black)
                            }.padding()
                        }// Involved Checkbox
                    }
                }.border(.black, width: 4).padding().offset(y:-35) // Input Section VStack
                
                Button("Send Ticket", action: {
                    let ticket = Ticket(student_id: student_id, first_name: "", last_name: "", ticket_timestamp: "10", ticket_id: 10, ticket_description: descriptionText, teacher_email: teacherEmail, respectful: respectfulIsChecked, responsible: responsibleIsChecked, involved: involvedIsChecked)
                    self.sendTicket(ticket: ticket)
                    
                    studentFieldIsFocued = false
                    teacherFieldIsFocued = false
                    descriptionFieldIsFocued = false
                })
                    .padding()
                    .background(pGreen)
                    .foregroundColor(.black)
                    .font(.custom("TradeWinds", size: 50))
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(currentMode == .dark ? .white : .black, lineWidth: 4)
                    )
                    .offset(y:-55)
                    .alert("Ticket Sent",isPresented: $showingSucess) {
                        Button("OK", role: .cancel) { self.descriptionText = ""; self.respectfulIsChecked = false; self.responsibleIsChecked = false; self.involvedIsChecked = false}
                    }
            }.ignoresSafeArea(.keyboard)//Content
        }.ignoresSafeArea(.keyboard).onTapGesture {
            self.hideKeyboard()
        }
        
    }//View
    
    func toggleRespectful() {
        respectfulIsChecked = !respectfulIsChecked
        studentFieldIsFocued = false
        teacherFieldIsFocued = false
        descriptionFieldIsFocued = false
    }
    func toggleResponsible() {
        responsibleIsChecked = !responsibleIsChecked
        studentFieldIsFocued = false
        teacherFieldIsFocued = false
        descriptionFieldIsFocued = false
    }
    func toggleInvolved() {
        involvedIsChecked = !involvedIsChecked
        studentFieldIsFocued = false
        teacherFieldIsFocued = false
        descriptionFieldIsFocued = false
    }
    
    func sendTicket(ticket: Ticket) {
        guard let encoded = try? JSONEncoder().encode(ticket)
        else{
            print("failed to encode")
            return
        }
        
        let url = URL(string: Constants.baseUrl + "/tickets")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        self.showingSucess = true
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            if let decodedRequest = try? JSONDecoder().decode(Ticket.self, from:data) {
                print(decodedRequest)
            }
        }.resume()
    }
    
}//View

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
