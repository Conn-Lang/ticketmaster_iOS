//
//  ContentView.swift
//  ticketmaster_ios
//
//  Created by Dylan Bolter on 9/28/21.
//

import SwiftUI
struct ContentView: View {
    @State private var isPresented = false
    
    var body: some View {
//        Button(":)") {
//            self.isPresented = true
//        }.sheet(isPresented: $isPresented) {
//            UIApp()
//        }.hidden()
        WelcomePage()
        

    }
}
