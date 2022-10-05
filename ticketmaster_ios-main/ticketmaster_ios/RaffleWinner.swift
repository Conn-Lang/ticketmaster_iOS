//
//  RaffleWinner.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 10/29/21.
//

import SwiftUI

struct RaffleWinner: View {
    @Environment(\.colorScheme) var currentMode
    @State var orientation = UIDevice.current.orientation
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    var winningTicket: Ticket
    var winningStudent: Student
    
    let pGreen = Color(UIColor(named: "pGreen")!)
    
    var body: some View {
        VStack {
            Text("The Winning Student is . . .")
                .fontWeight(.bold)
                .font(Font.custom("TradeWinds", size: orientation.isLandscape ? 30 : 60))
            HStack {
                Image("piratepete")
                    .resizable()
                    .padding()
                    .frame(width: 200.0, height: 200.0)
                    .scaledToFit()
                    .offset(y: -50)
                
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: winningStudent.photo_url), scale: 2) {phase in
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
                                        .stroke(.yellow, lineWidth: 5)
                                )
                                .shadow(color: currentMode == .dark ? .white : .black, radius: 7)
                                .padding()
                                .scaledToFit()
                                .offset(y: -50)
                                
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
                                .padding()
//                                .padding(.bottom, 132.5)
//                                .padding(.top, 54)
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
                
                Image("piratepete")
                    .resizable()
                    .padding()
                    .frame(width: 200.0, height: 200.0)
                    .scaledToFit()
                    .offset(y: -50)
            }// HStack
            
            Text("\(winningStudent.first_name) \(winningStudent.last_name)")
                .font(Font.custom("TradeWinds", size: 45))
                .offset(y: -90)
            
            Text("ID Number: \(winningTicket.student_id)")
                .font(Font.custom("TradeWinds", size: 35))
                .offset(y: -90)
            
            Text("Grade: \(winningStudent.grade_level)")
                .font(Font.custom("TradeWinds", size: 25))
                .offset(y: -90)
            
            VStack {
                Text("Description:")
                    .font(.system(size: 35))
                
                Divider()
                
                Text("\(winningTicket.ticket_description)")
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .lineLimit(10)
            }.padding().overlay(RoundedRectangle(cornerRadius: 3).stroke(currentMode == .dark ? .white : .black, lineWidth: 2)).offset(y: -110).frame(width: 640)//VStack
        }.frame(maxWidth: .infinity, maxHeight: .infinity).border(.black, width: 5)//VStack
    }

}

