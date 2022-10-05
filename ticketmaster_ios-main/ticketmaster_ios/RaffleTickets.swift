//
//  RaffleTickets.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 10/21/21.
//

import SwiftUI

struct RaffleTickets: View {
    @Environment(\.colorScheme) var currentMode
    let tickets: [Ticket]
    let idToken: String
    
    @State private var startDate = Date().startOfWeek()
    @State private var endDate = Date()
    @State var studentId = ""
    @State var winningTicket = Ticket(student_id: "", first_name: "", last_name: "", ticket_timestamp: "", ticket_id: 0, ticket_description: "", teacher_email: "", respectful: false, responsible: false, involved: false)
    @State var winningStudent = Student()
    @State var isShowingWinner = false
    @State var showingAlert = false
    @State var isShowingAllWinnerAlert = false
    @State var selectedParameter = "all"
    
    let pGreen = Color(UIColor(named: "pGreen")!)
    enum RaffleTicketsError: Error {
        case validTicketsEmpty
        case endDateAfterStartDate
    }
    
    var body: some View {
        
        let buttonTextSize = 28
        
        Text("Student Raffle")
            .font(Font.custom("TradeWinds", size: 70))
        
        VStack {

            Text("Select a start and end date")
                .font(Font.custom("TradeWinds", size: 50))
                .padding(.bottom, 30)
                .padding(.top, 20)
            
            Divider()
            
            HStack{
                Text("Start Date:")
                    .font(Font.custom("TradeWinds", size: 30))
                    .padding()
                
                DatePicker("", selection: $startDate, displayedComponents: [.date])
                    .padding()
                    .labelsHidden()
                    .transformEffect(.init(scaleX: 1.2, y: 1.2))
                    .offset(y:-7)
                    
            }//HStack
            
            Divider()
            
            HStack{
                Text("End Date:")
                    .font(Font.custom("TradeWinds", size: 30))
                    .padding()
                
                DatePicker("", selection: $endDate, displayedComponents: [.date])
                    .padding()
                    .labelsHidden()
                    .transformEffect(.init(scaleX: 1.2, y: 1.2))
                    .offset(y:-7)
            }//HStack
            
            Divider()
            
            HStack{
                Button("Respectful", action: {
                    self.selectedParameter = "respectful"
                }).font(Font.custom("TradeWinds", size: CGFloat(buttonTextSize)))
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(pGreen)
                    .cornerRadius(40)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(currentMode == .dark ? .white : .black, lineWidth: 3))
                
                Button("Responsible", action: {
                    self.selectedParameter = "responsible"
                }).font(Font.custom("TradeWinds", size: CGFloat(buttonTextSize)))
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(pGreen)
                    .cornerRadius(40)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(currentMode == .dark ? .white : .black, lineWidth: 3))
                
                Button("Involved", action: {
                    self.selectedParameter = "involved"
                }).font(Font.custom("TradeWinds", size: CGFloat(buttonTextSize)))
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(pGreen)
                    .cornerRadius(40)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(currentMode == .dark ? .white : .black, lineWidth: 3))
                
                Button("All Tickets", action: {
                    self.selectedParameter = "all"
                }).font(Font.custom("TradeWinds", size: CGFloat(buttonTextSize)))
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(pGreen)
                    .cornerRadius(40)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(currentMode == .dark ? .white : .black, lineWidth: 3))
            }//Parameter buttons
            
            Text("Selected Pool: \(selectedParameter)").font(Font.custom("TradeWinds", size: 25))
            
//            NavigationLink(destination: RaffleWinner(winningTicket: winningTicket, winningStudent: winningStudent), isActive: $isShowingWinner){
            Button("Begin Raffle", action: {
                
                do {
                    winningTicket = try startRaffle(dates: [startDate, endDate], completion: {showing in isShowingWinner = showing})
                } catch {
                    showingAlert = true
                    print("error")
                }
            })
                .sheet(isPresented: $isShowingWinner, content: {
                    RaffleWinner(winningTicket: winningTicket, winningStudent: winningStudent)
                })
                .font(Font.custom("TradeWinds", size: 40))
                .foregroundColor(Color.black)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(pGreen)
                .cornerRadius(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(currentMode == .dark ? .white : .black, lineWidth: 3)
                )
                .padding(.top, 15)
                .padding(.bottom, 20)
                
                .alert("Please make sure that you use a valid start and end date and that there are tickets within that timeframe", isPresented: $showingAlert, actions: {
                    Button("OK", role: .cancel) {}
                })
                .alert("All the tickets are winners", isPresented: $isShowingAllWinnerAlert, actions: {
                    Button("OK", role: .cancel) {}
                })
//            }
            
        }.overlay(RoundedRectangle(cornerRadius: 10).stroke(currentMode == .dark ? .white : .black, lineWidth: 2)).padding().offset(y: -30).labelStyle(.titleOnly)//VStack
    }//body
    
    private func startRaffle(dates: [Date], completion: @escaping (Bool) -> Void) throws -> Ticket {
        print("Starting raffle with start date \(dates[0]) and end date \(dates[1])")

        self.clearData()
        var urlString = ""
        if(selectedParameter == "all") {
            urlString = Constants.baseUrl + "/tickets/raffle?start=\(convertDateToString(date: dates[0]))&end=\(convertDateToString(date: dates[1]))"
        }else {
            urlString = Constants.baseUrl + "/tickets/raffle?start=\(convertDateToString(date: dates[0]))&end=\(convertDateToString(date: dates[1]))&\(selectedParameter)=true"
        }
        
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Ticket.self, from: data)
                    print(decodedData)
                    self.winningTicket = decodedData
                    self.getWinningStudent()
                    completion(true)
                
                }catch{
                    print("All the tickets have won")
                    self.isShowingAllWinnerAlert = true
                    completion(false)
                }
            }else{
                completion(false)
            }
        }.resume()
        return winningTicket
    }//start raffle
    
    private func convertStringToDate(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let convertedDate = dateFormatter.date(from: date) {
            return convertedDate
        }
        return Date(timeIntervalSinceReferenceDate: 0)
    }//convert string to date function
    
    private func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }
    
    func getWinningStudent() {
        print(winningTicket.student_id)
        let urlString = Constants.baseUrl + "/students/schedule/\(winningTicket.student_id)"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) {data, _, error in
                if let data = data {
                    do{
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(Student.self, from: data)
                        print(decodedData)
                        self.winningStudent = decodedData
                        
                    }catch{
                        print("went to catch")
                        print(error)
                    }
                }
                
            }.resume()
        }//Get data
    
    func clearData() {
        self.winningStudent = Student()
    }//Clear date
    
}//RaffleTickets

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
    static let iso8601UTC: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
}

extension Date {
    func startOfWeek(using calendar: Calendar = .iso8601) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
}
