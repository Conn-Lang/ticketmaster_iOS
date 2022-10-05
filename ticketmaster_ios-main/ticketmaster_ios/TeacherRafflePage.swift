//
//  TeacherRafflePage.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 1/24/22.
//

import SwiftUI

struct TeacherRafflePage: View {
    @Environment(\.colorScheme) var currentMode
    let idToken: String
    
    @State private var startDate = Date().startOfWeek()
    @State private var endDate = Date()
    
    @State private var showingAlert = false
    
    @State private var winningTeacher = Teacher(teacher_email: "", first_name: "", last_name: "")
    @State private var winnerHidden = true
    
    let pGreen = Color(UIColor(named: "pGreen")!)
    
    var body: some View {
        Text("Teacher Raffle")
            .font(Font.custom("TradeWinds", size: 70))
            .offset(y: -20)
        
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
            
            Button("Begin Raffle", action: {
                do {
                    winningTeacher = try startRaffle(dates: [startDate, endDate], completion: { _ in winnerHidden = false})
                } catch {
                    showingAlert = true
                    print("error")
                }
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
        }.overlay(RoundedRectangle(cornerRadius: 10).stroke(currentMode == .dark ? .white : .black, lineWidth: 2)).padding().offset(y: -40).labelStyle(.titleOnly)//VStack
        
        VStack {
            Text("The winner is...")
                .font(Font.custom("TradeWinds", size: 45))
            Text("\(winningTeacher.first_name) \(winningTeacher.last_name)")
                .font(Font.system(size: 45))
        }.padding().offset(y: -30).opacity(winnerHidden ? 0 : 1)//VStack
        
    }//body
    
    func startRaffle(dates: [Date], completion: @escaping (Bool) -> Void) throws -> Teacher {
        winningTeacher = Teacher(teacher_email: "", first_name: "", last_name: "")
        
        let urlString = Constants.baseUrl + "/tickets/teacherraffle?start=\(convertDateToString(date: dates[0]))&end=\(convertDateToString(date: dates[1]))"
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Teacher.self, from: data)
                    winningTeacher = decodedData
                    completion(true)
                
                }catch{
                    print("Must Be Backend's Fault :)")
                    print(error)
                    completion(false)
                }
            }else{
                completion(false)
            }
        }.resume()
        return winningTeacher
    }//Start Raffle
    
    private func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }//Convert Date to String
}//TeacherRafflePage

//struct TeacherRafflePage_Previews: PreviewProvider {
//    static var previews: some View {
//        TeacherRafflePage()
//    }
//}
