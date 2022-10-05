//
//  WelcomePage.swift
//  ticketmaster_ios
//
//  Created by Hayden Langston on 10/4/21.
//

import SwiftUI
import GoogleSignIn

//This might help https://paulallies.medium.com/google-sign-in-swiftui-2909e01ea4ed

struct WelcomePage: View {
    @Environment(\.colorScheme) var currentMode
    @State var orientation = UIDevice.current.orientation
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    @State var isShowingStuAccWarning = false
    @State var isLoggedIn = false
    @State var isAdmin = false
    
    @State var idToken = ""
    @State var admins: [String] = []
    @State var emailAddress: String? = ""
    
    let pGreen = Color(UIColor(named: "pGreen")!)
    let signInConfig = --------------------------------------------------------------------------
    //This variable is specific to the Pattonville School District. Since the servers are still running, this variable has been scrubbed for the security of the system.

    var body: some View {
    
        let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController
        
        NavigationView{
            
            VStack{
                ZStack {
                    Text("Welcome")
                        .font(Font.custom("TradeWinds", size: orientation.isLandscape ? 200 : 150))
                        .foregroundColor(currentMode == .dark ? .white : .black)
                    Text("Welcome")
                        .font(Font.custom("TradeWinds", size: orientation.isLandscape ? 200 : 150))
                        .foregroundColor(pGreen)
                        .offset(x: -7, y: -7)
                }.offset(y: orientation.isLandscape ? -20 : -40)
                
                NavigationLink(destination: HomePage(isAdmin: isAdmin, teacherEmail: emailAddress!, idToken: idToken), isActive: $isLoggedIn) {
                    Button("Log in", action: {
                        print("attempting sign in")
                        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: rootVC ?? UIViewController()) {user, error in
                            guard error == nil else {return}
                            guard let user = user else {return}
                            
                            self.emailAddress = user.profile?.email
                            self.idToken = user.authentication.idToken!
                            getAdmins(completion: {_ in
                                self.isAdmin = admins.contains(emailAddress!)
                                self.isLoggedIn = true
                            })
                        }
                        
                    })
                        .padding(.horizontal, 50)
                        .font(Font.custom("TradeWinds", size: 110))
                        .foregroundColor(.black).background(pGreen)
                        .cornerRadius(80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 80)
                                .stroke(currentMode == .dark ? .white : .black, lineWidth: 5)
                        )
//                        .offset(y: orientation.isLandscape ? -130 : -40)
                        .offset(y: orientation.isLandscape ? -80 : -40)
                        .alert("Invalid account: students do not have access to this app", isPresented: $isShowingStuAccWarning){
                            Button("OK", role: .cancel) {}
                        }
                }
                
                
                Image("piratepete")
                    .resizable()
                    .if(orientation.isLandscape) { view in
                        view.frame(width: 300.0, height: 300.0)
                    }
                    .scaledToFit()
                    .offset(y: orientation.isLandscape ? -110 : -70)
            }
            
        }.navigationViewStyle(StackNavigationViewStyle()).onReceive(orientationChanged) { _ in
            self.orientation = UIDevice.current.orientation
        }.onAppear(perform: {
            GIDSignIn.sharedInstance.restorePreviousSignIn {user, error in
                if(error != nil && user == nil){
                    self.isLoggedIn = false
                }else {
                    // Show the app's signed-in state.
                      self.emailAddress = user?.profile?.email
                      self.idToken = user?.authentication.idToken ?? ""
                      getAdmins(completion: {_ in
                          self.isAdmin = admins.contains(emailAddress!)
                          self.isLoggedIn = true
                      })
                }
            }
        })
    }
    
    func getAdmins(completion: @escaping (Bool) -> Void){
        let urlString = Constants.baseUrl + "/admins"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
                    print("working on getting admins")
                    let decodedData = try JSONDecoder().decode([Admin].self, from: data)
                    for admin in decodedData {
                        self.admins.append(admin.email)
                    }
                    completion(true)
                }catch{
                    print(error)
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
//
//struct WelcomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomePage()
//    }
//}
