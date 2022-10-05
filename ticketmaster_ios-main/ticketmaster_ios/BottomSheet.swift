//
//  BottomSheet.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 3/11/22.
//

import SwiftUI

struct BottomSheet<Content : View>: ContainerView {
    @Environment(\.colorScheme) var currentMode
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        
        
        VStack(content: content).padding()
//        }
//        VStack{
//            Text("scp-5000: why?")
//        }
        .padding(.horizontal)
        .padding(.top, 20)
        .background(currentMode == .dark ? .black : .white)
//        .background(.green)
        .cornerRadius(25, corners: [.topLeft, .topRight])
        
    }
}

protocol ContainerView: View {
    associatedtype Content
    init(content: @escaping () -> Content)
}

extension ContainerView {
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.init(content: content)
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(content: {
            VStack{
                Text("scp-5000: why?")
            }
        })
    }
}
