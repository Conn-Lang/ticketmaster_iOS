//
//  BadgesPage.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 1/4/22.
//

import SwiftUI

struct BadgesPage: View {
    @Environment(\.colorScheme) var currentMode
    
    let student: Student
    let badges: [Badge]
    let studentId: String
    
    let const: CGFloat = 90/400
    let pGreen = Color(UIColor(named: "pGreen")!)
    
    var body: some View {
        
        VStack {
            Text("Badges").font(Font.custom("TradeWinds", size: 60)).fontWeight(.bold)
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
                ForEach(badges) { badge in
                    HStack{
//                        Spacer()
                        HStack {
                            Image("\(determineBadge(badgeId: badge.badge_id))")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400.0*const, height: 550.0*const)
                                .padding(.horizontal, 80)
                            Text("\(badge.badge_name)")
                                .font(Font.system(size: 25))
                        }//VStack
//                        Spacer()
                    }//HStack
                }//ForEach
            }//List
        }//VStack
    }
    
    func determineBadge(badgeId: Int) -> String {
        if [6, 10, 14, 18, 20].contains(badgeId) {
            return "gold-badge"
        } else if [3,4,5, 9, 13, 17].contains(badgeId) {
            return "silver-badge"
        } else {
            return "bronze-badge"
        }
    }//Determine Badge
}

struct BadgesPage_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self){
            BadgesPage(student: Student(), badges: [
                Badge(badge_id: 0, badge_name: "1 Ticket", badge_image: "assets/test.jpg"),
                Badge(badge_id: 3, badge_name: "25 Tickets", badge_image: "assets/test.jpg"),
                Badge(badge_id: 6, badge_name: "250 Tickets", badge_image: "assets/test.jpg"),
                Badge(badge_id: 7, badge_name: "1 Respectful Ticket", badge_image: ""),
                Badge(badge_id: 10, badge_name: "25 Respectful Tickets", badge_image: ""),
                Badge(badge_id: 11, badge_name: "1 Responsible Tickets", badge_image: ""),
                Badge(badge_id: 14, badge_name: "25 Responsible Tickets", badge_image: ""),
                Badge(badge_id: 15, badge_name: "1 Involved Ticket", badge_image: ""),
                Badge(badge_id: 18, badge_name: "25 Involved Tickets", badge_image: ""),
                Badge(badge_id: 19, badge_name: "1 Raffle Won", badge_image: ""),
                Badge(badge_id: 20, badge_name: "5 Raffles Won", badge_image: "")
            ], studentId: "61977").preferredColorScheme($0)
        }
    }
}
