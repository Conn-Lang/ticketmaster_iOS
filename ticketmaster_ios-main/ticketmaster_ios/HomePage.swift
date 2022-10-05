//
//  HomePage.swift
//  ticketmaster_ios
//
//  Created by Dylan Bolter on 10/4/21.
//

import SwiftUI
import CodeScanner
import GoogleSignIn

struct HomePage: View {
    @Environment(\.colorScheme) var currentMode
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var orientation = UIDevice.current.orientation
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    let isAdmin: Bool
    let teacherEmail: String
    let idToken: String
    
    
    @State var isShowingTickets = false
    @State var isShowingSendTickets = false
    @State var isShowingNameList = false
    @State var isShowingGiven = false
    @State var isShowingBadges = false
    @State var isShowingNoIdWarning = false
    @State var usingRaffleURL = false
    @State var isShowingNoTicketsGiven = false
    @State var isShowingScanner = false
    
    @State var isShowingAdminPage = false
    @State var isShowingRaffle = false
    @State var isShowingTeacherRaffle = false
    @State var isShowingAllTickets = false
    
    @State var isShowingTransition = false
    @State var isShowingTransitionTicket = false
    @State var isShowingTransitionArrow = false
    @State var isShowingTransitionEye = false
    @State var isShowingTransitionAdmin = false
    
    @State var tickets: [Ticket] = []
    @State var students: [TicketStudent] = []
    @State var items = Items(items: [])
    @State var badges: [Badge] = []
    @State var allTeacherTicketArray: [AllTeacherTicket] = []
    @State var allStudentTicketArray: [AllStudentTicket] = []
    @State var nameSearches: [NameSearch] = []
    
    @State var studentId = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var student = Student()
    
    var body: some View {
        
        let pGreen = Color(UIColor(named: "pGreen")!)

        
        GeometryReader { bounds in
            ZStack {
                VStack {
                    
                    Text("Pirate Code")
                        .font(Font.custom("TradeWinds", size: 70))
                    
                    HStack{
                        TextField("Enter First Name", text: $firstName)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 25, design: .default))
                            .offset(x: 45)
                        TextField("Enter Last Name", text: $lastName)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 25, design: .default))
                            .offset(x: 45)
                        NavigationLink(destination: SendTickets(student_id: studentId, teacherEmail: teacherEmail, idToken: idToken, student: student), isActive: $isShowingSendTickets){
                            Button("Scan", action: {
                                self.isShowingScanner = true
                            }).sheet(isPresented: $isShowingScanner, content: {
                                CodeScannerView(codeTypes: [.code128, .code39], simulatedData: "61977", completion: self.handleScan)
                            })
                                .padding()
                                .font(Font.custom("TradeWinds", size: 25))
                                .foregroundColor(.black)
                                .background(pGreen)
                                .cornerRadius(80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 80)
                                        .stroke(currentMode == .dark ? .white : .black, lineWidth: 4)
                                )
                        }
                    }
                        .padding()
                    
                    
                    Divider()
                        .frame(height: 5)
                        .background(.gray)
                        .padding()
                    
                    VStack(spacing: 10) {
                        HStack(spacing: 20) {

                            
//                            NavigationLink(destination: NameSearchList(students: nameSearches, idToken: idToken, teacherEmail: teacherEmail), isActive: $isShowingNameList) {
                                Button(orientation.isLandscape ? "Find Student" : "Find\nStudent", action: {
                                    getTicketsByName(completion: {showing in isShowingNameList = true})
                                    print("\(student.first_name), \(student.last_name), \(student.student_id)")
                                })
                                .font(Font.custom("TradeWinds", size: 40))
                                .frame(maxWidth: orientation.isLandscape ? 400 : 500, maxHeight: orientation.isLandscape ? 75 : 130)

                                .padding()
                                .font(Font.custom("TradeWinds", size: 25))
                                .foregroundColor(.black)
                                .background(pGreen)
                                .cornerRadius(80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 80)
                                        .stroke(currentMode == .dark ? .white : .black, lineWidth: 4)
                                )
                                    .offset(x: 5)
//                            }.onAppear(perform: {
//                                self.firstName = ""
//                                self.lastName = ""
//                            })
                            
                        }//HStack
                        
                        HStack(spacing: 20) {
                            NavigationLink(destination: ViewGivenTickets(tickets: tickets, students: students), isActive: $isShowingGiven){
                                Button(orientation.isLandscape ? "View Given" : "View\nGiven", action: {
                                    print("view given clicked")
                                    self.isShowingTransitionEye.toggle()
                                    self.isShowingTransitionArrow.toggle()
                                    self.isShowingTransitionTicket.toggle()
                                    withAnimation{
                                        self.isShowingTransition.toggle()
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(650), execute: {
                                        self.getGiven(completion: {showing in isShowingGiven = true})
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                                            self.isShowingTransition.toggle()
                                            self.isShowingTransitionEye.toggle()
                                            self.isShowingTransitionArrow.toggle()
                                            self.isShowingTransitionTicket.toggle()
                                        })
                                    })
                                })
                                    .font(Font.custom("TradeWinds", size: 40))
                                    .frame(maxWidth: orientation.isLandscape ? 400 : 500, maxHeight: orientation.isLandscape ? 75 : 130)
                                    .padding()
                                    .background(pGreen)
                                    .foregroundColor(.black)
                                    .cornerRadius(80)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 80)
                                            .stroke(currentMode == .dark ? .white : .black, lineWidth: 4)
                                    )
                                    .offset(x: 5)
                            }
                        }//HStack
                    }//VStack

                        
                        if isAdmin {
                            Button("Admin Functions", action: {
                                isShowingAdminPage.toggle()
                            })
                                .font(Font.custom("TradeWinds", size: 45))
                                .frame(maxWidth: 400, maxHeight: orientation.isLandscape ? 75 : 97)
                                .padding()
                                .background(Color(red: 191/255, green: 191/255, blue: 191/255))
                                .cornerRadius(40)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(currentMode == .dark ? .white : .black, lineWidth: 3)
                                )
                                .offset(y: orientation.isLandscape ? 0 : 5)
                        }//isAdmin
                        
                        Text("Logged in as: \(teacherEmail)")
                            .font(Font.system(size: 35, design: .default))
                            .offset(y: orientation.isLandscape ? 40 : 75)
                        
                    }.offset(y: -35).navigationViewStyle(StackNavigationViewStyle()).edgesIgnoringSafeArea(.bottom).onReceive(orientationChanged) { _ in
                        self.orientation = UIDevice.current.orientation
                    }//VStack
            
                    VStack{
                        
                        Spacer()
                        
                        BottomSheet(content: {
                            Group{
                                HStack{
                                    NavigationLink(destination: RaffleTickets(tickets: tickets, idToken: idToken), isActive: $isShowingRaffle){
                                        Button("Raffle Tickets", action: {
                                            self.isShowingTransitionAdmin.toggle()
                                            self.isShowingTransitionTicket.toggle()
                                            withAnimation{
                                                self.isShowingTransition.toggle()
                                                self.isShowingAdminPage.toggle()
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(650), execute: {
                                                self.isShowingRaffle = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                                                    self.isShowingTransitionAdmin.toggle()
                                                    self.isShowingTransitionTicket.toggle()
                                                    self.isShowingTransition.toggle()
                                                })
                                            })
                                        })
                                            .font(Font.custom("TradeWinds", size: 40))
                                            .frame(maxWidth: 400, maxHeight: orientation.isLandscape ? 75 : 97)
                                            .padding()
                                            .background(Color(red: 191/255, green: 191/255, blue: 191/255))
                                            .cornerRadius(40)
                                            .foregroundColor(.black)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 40)
                                                    .stroke(currentMode == .dark ? .white : .black, lineWidth: 3)
                                            )
                                    }//Nav Link 1
                                    
                                    NavigationLink(destination: TeacherRafflePage(idToken: idToken), isActive: $isShowingTeacherRaffle){
                                        Button("Raffle Teachers", action: {
                                            self.isShowingTransitionAdmin.toggle()
                                            withAnimation{
                                                self.isShowingTransition.toggle()
                                                self.isShowingAdminPage.toggle()
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(650), execute: {
                                                self.isShowingTeacherRaffle = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                                                    self.isShowingTransition.toggle()
                                                    self.isShowingTransitionAdmin.toggle()
                                                })
                                            })
                                        })
                                            .font(Font.custom("TradeWinds", size: 40))
                                            .frame(maxWidth: 400, maxHeight: orientation.isLandscape ? 75 : 97)
                                            .padding()
                                            .background(Color(red: 191/255, green: 191/255, blue: 191/255))
                                            .cornerRadius(40)
                                            .foregroundColor(.black)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 40)
                                                    .stroke(currentMode == .dark ? .white : .black, lineWidth: 3)
                                            )
                                    }//Nav Link 2
                                }//HStack
                            
                                NavigationLink(destination: AllTicketView(allTickets: allTeacherTicketArray, allStudentTickets: allStudentTicketArray), isActive: $isShowingAllTickets) {
                                    Button("All Tickets", action: {
                                        self.isShowingTransitionAdmin.toggle()
                                        self.isShowingTransitionEye.toggle()
                                        withAnimation{
                                            self.isShowingTransition.toggle()
                                            self.isShowingAdminPage.toggle()
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(650), execute: {
                                            getAllTickets(completion: {showing in isShowingAllTickets = true})
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                                                self.isShowingTransition.toggle()
                                                self.isShowingTransitionAdmin.toggle()
                                                self.isShowingTransitionEye.toggle()
                                            })
                                        })
                                    })
                                        .font(Font.custom("TradeWinds", size: 40))
                                        .frame(maxWidth: 300, maxHeight: orientation.isLandscape ? 75 : 97)
                                        .padding()
                                        .background(Color(red: 191/255, green: 191/255, blue: 191/255))
                                        .cornerRadius(40)
                                        .foregroundColor(.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 40)
                                                .stroke(currentMode == .dark ? .white : .black, lineWidth: 3)
                                        )
                                }//Nav Link 3
                            
                            }.frame(maxWidth: .infinity)//Group
                        }//content
                        ).offset(y: self.isShowingAdminPage ? 0 : UIScreen.main.bounds.height)//Bottom Sheet: Admin Page
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).background(self.isShowingAdminPage ? (currentMode == .dark ? Color(white: 0.37).opacity(0.3) : .black.opacity(0.3)) : .clear).onTapGesture {
                        self.isShowingAdminPage.toggle()
                    }//VStack
                    ZStack {
                        VStack{
                                Spacer()
                                
                                BottomSheet(content: {
                                    List{
                                        ForEach (nameSearches.indices, id: \.self) {i in
                                            Button("\(nameSearches[i].first_name) \(nameSearches[i].last_name)", action: {
                                                
                                            }).padding().foregroundColor(currentMode == .dark ? .white : .black)
                                            .background(NavigationLink(destination: SendTickets(student_id: studentId, teacherEmail: teacherEmail, idToken: idToken, student: student), isActive: $isShowingSendTickets) {EmptyView()}.hidden())
                                            .onTapGesture {
                                                self.studentId = nameSearches[i].student_id
                                                self.getStudent(completion: {showing in
                                                    self.isShowingTransitionArrow.toggle()
                                                    self.isShowingTransitionTicket.toggle()
                                                    withAnimation {
                                                        self.isShowingTransition.toggle()
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(650), execute: {
                                                        self.isShowingSendTickets = true
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                                                            self.isShowingTransition.toggle()
                                                            self.isShowingTransitionArrow.toggle()
                                                            self.isShowingTransitionTicket.toggle()
                                                        })
                                                    })
                                                })
                                            }
                                        }
                                    }.frame(maxWidth: .infinity, maxHeight: 660)
                                }//content
                                ).offset(y: self.isShowingNameList ? 0 : UIScreen.main.bounds.height)//Bottom Sheet: Name List
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).background(self.isShowingNameList ? (currentMode == .dark ? Color(white: 0.37).opacity(0.3) : .black.opacity(0.3)) : .clear).onTapGesture {
                            self.isShowingNameList.toggle()
                        }//VStack
                    }//ZStack
                        
                    if (isShowingTransition) {
                        ZStack{
                            Rectangle()
                                .fill(currentMode == .dark ? .black : .white)
                                .ignoresSafeArea()
                                .offset(y: -20)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .transition(.opacity)
                            Image("piratepete")
                                .transition(.scale)
                            Group {
                                if (isShowingTransitionTicket) {
                                    Rectangle()
                                        .fill(currentMode == .dark ? .black : Color(red: 191/255, green: 191/255, blue: 191/255))
                                        .frame(width: 188, height: 78)
                                        .border(currentMode == .dark ? .white : .black, width: 1)
                                        .frame(width: 200, height: 90)
                                        .background(currentMode == .dark ? .black : Color(red: 191/255, green: 191/255, blue: 191/255))
                                        .border(currentMode == .dark ? .white : .black, width: 3)
                                    Text("Ticket")
                                        .font(Font.custom("TradeWinds", size: 55))
                                }
                                if (isShowingTransitionArrow) {
                                    Arrow()
                                        .scale(0.13)
                                        .stroke(lineWidth: 5)
                                        .fill(currentMode == .dark ? .white : .black)
                                        .rotationEffect(.degrees(90))
                                        .offset(x: 155)
                                }
                                if (isShowingTransitionEye) {
                                    Group{
                                        Eye()
                                            .stroke(lineWidth: 3)
                                            .frame(width: 120, height: 120)
                                        Circle()
                                            .stroke(lineWidth: 3)
                                            .frame(width: 60)
                                        Circle()
                                            .frame(width: 30)
                                    }.offset(x: 85, y: -85)
                                }
                                if (isShowingTransitionAdmin) {
                                    ZStack{
                                        Circle()
                                            .stroke(currentMode == .dark ? .white : .black, lineWidth: 7)
                                            .frame(width: 85)
                                        Circle()
                                            .stroke(.red, lineWidth: 3)
                                            .frame(width: 85)
                                        StrokeText(text: "A", width: 1.8, color: currentMode == .dark ? .white : .black)
                                            .foregroundColor(.red)
                                            .font(Font.system(size: 80))
                                            .offset(y: -3)
                                    }.offset(x: 115, y: 245)
                                }
                            }.offset(x: 125, y: -150)
                        }.transition(.scale)
                    }//isShowingTransition
                
            }.ignoresSafeArea().animation(.default, value: isShowingAdminPage).animation(.default, value: isShowingNameList)//ZStack
            
        }.onAppear(perform: {
            self.firstName = ""
            self.lastName = ""
        }).navigationBarBackButtonHidden(true).navigationBarItems(leading: Button("Sign Out", action: {
            GIDSignIn.sharedInstance.signOut()
            self.mode.wrappedValue.dismiss()
        }))
        
        
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            self.studentId = code.string.components(separatedBy: "")[0]
            self.getStudent(completion: {showing in isShowingSendTickets = showing})
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    
    func getTicketsByName(completion: @escaping (Bool) -> Void) {
        print("get tickets by name function")
        var urlString = ""
        if(self.lastName == ""){
            urlString = Constants.baseUrl + "/students/search?first_name=\(firstName.trimmingCharacters(in: .whitespacesAndNewlines))"
        }else if (self.firstName == "") {
            urlString = Constants.baseUrl + "/students/search?last_name=\(lastName.trimmingCharacters(in: .whitespacesAndNewlines))"
        }
        
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
//                    print("working on getting tickets")
                    let decodedData = try JSONDecoder().decode([NameSearch].self, from: data)
                    self.nameSearches = decodedData
                    completion(true)
                }catch{
                    print(error)
                    completion(false)
                }
            }else{
                completion(false)
            }
            
        }
        task.resume()
    }//get tickets function
    
    func getGiven(completion: @escaping (Bool) -> Void){
        print("get given function")
        let urlString = Constants.baseUrl + "/tickets?teacher_email=\(teacherEmail)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        self.clearTickets()
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
                    print("working on getting tickets")
                    let decodedData = try JSONDecoder().decode([Ticket].self, from: data)
                    self.tickets = decodedData
                    completion(true)
                }catch{
                    print(error)
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
        task.resume()
    }//Get given tickets
    
    func getStudent(completion: @escaping (Bool) -> Void) {
        print("get student function")
        let urlString = Constants.baseUrl + "/students/schedule/\(studentId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        print("running")
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Student.self, from: data)
                    print(decodedData)
                    self.student = decodedData
                    completion(true)
                }catch{
                    print(error)
                    completion(false)
                }
            }
            
        }
        task.resume()
    }
    
    func getBadges(completion: @escaping (Bool) -> Void) {
        print("getting badges function")
        let urlString = Constants.baseUrl + "/tickets/badges/\(studentId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        self.clearBadges()
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([Badge].self, from: data)
                    self.badges = decodedData
                    completion(true)
                }catch{
                    print(error)
                    completion(false)
                }
            }
        }//URL Session
        task.resume()
    }//Get Badges
    
    func getAllTickets(completion: @escaping (Bool) -> Void) {
        print("getting all tickets function")
        let urlString = Constants.baseUrl + "/tickets/teachers/count"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([AllTeacherTicket].self, from: data)
                    print(decodedData)
                    self.allTeacherTicketArray = decodedData
                    self.getAllStudentTickets()
                    completion(true)
                }catch{
                    print(error)
                    completion(false)
                }
            }
        }//URL Session
        task.resume()
    } //get all tickets
    
    func getAllStudentTickets() {
        print("getting all student tickets function")
        let urlString = Constants.baseUrl + "/tickets/students/count"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([AllStudentTicket].self, from: data)
                    self.allStudentTicketArray = decodedData
                    allStudentTicketArray.sort {
                        $1.count < $0.count
                    }
                }catch{
                    print(error)
                }
            }
        }//URL Session
        task.resume()
    }//get all student tickets
    
    func clearData() {
        self.student = Student()
    }//Clear data
    
    func clearTickets() {
        self.tickets = []
    }
    
    func clearBadges() {
        self.badges = []
    }
    

}

struct Arrow: Shape {
    // 1.
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            // 2.
            path.addLines( [
                CGPoint(x: width * 0.4, y: height * 0.8),
                CGPoint(x: width * 0.4, y: height * 0.4),
                CGPoint(x: width * 0.25, y: height * 0.4),
                CGPoint(x: width * 0.5, y: height * 0.1),
                CGPoint(x: width * 0.75, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height * 0.8)
                
            ])
            // 3.
            path.closeSubpath()
        }
    }
}

struct Eye: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}
