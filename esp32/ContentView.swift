import SwiftUI


struct ActiveTextStyle: ViewModifier {
    var isActive : Bool

    func body(content: Content) -> some View {
        content
            .font(isActive ? .title.bold() : .title2.bold())
            .foregroundStyle(isActive ? .black : .gray.opacity(0.5))
            .padding(.horizontal, isActive ? 15 : 10)
    }
}


struct LedResponse: Codable {
    let success: Bool
    let message: String
    let mode: Int?
}



struct ContentView: View {
    
    @State private var isLedOn : Bool = false
    @AppStorage("mode") private var mode : Int = 1
    @Namespace private var animation
    @State private var workItem: DispatchWorkItem? = nil
    

    var body: some View {
        
        ZStack {
            Color(isLedOn ? .green : .red).ignoresSafeArea().animation(.easeInOut, value: isLedOn)
            
            VStack (spacing: 20) {
                
                Spacer()
                
                Button(action: {
                    self.isLedOn.toggle()
                    sendLedRequestDebounce(turnOn: self.isLedOn, mode: self.mode)
                    
                }) {
                    Circle()
                        .fill(.white.opacity(0.8))
                        .frame(maxWidth: 240)
                        .shadow(color: .black.opacity(0.4), radius: 25)
                        .padding()
                    
                }
                
                Spacer()
                
                HStack {
                    Button {
                        withAnimation(.easeInOut) {mode = 1}
                        sendLedRequestDebounce(turnOn: self.isLedOn, mode: self.mode)
                    } label: {
                        Text("1")
                            .modifier(ActiveTextStyle(isActive: mode == 1))
                            .background{
                                if mode == 1 {
                                    Capsule().fill(Color.gray.opacity(0.4)).matchedGeometryEffect(id: "modeHighlight", in: animation)
                                }
                            }
                    }
                    
                    Button {
                        withAnimation(.easeInOut) {mode = 2}
                        sendLedRequestDebounce(turnOn: self.isLedOn, mode: self.mode)
                    } label: {
                        Text("2")
                            .modifier(ActiveTextStyle(isActive: mode == 2))
                            .background{
                                if mode == 2 {
                                    Capsule().fill(Color.gray.opacity(0.4)).matchedGeometryEffect(id: "modeHighlight", in: animation)
                                }
                            }
                        
                    }
                    
                    Button {
                        withAnimation(.easeInOut) {mode = 3}
                        sendLedRequestDebounce(turnOn: self.isLedOn, mode: self.mode)
                    } label: {
                        Text("3")
                            .modifier(ActiveTextStyle(isActive: mode == 3))
                            .background{
                                if mode == 3 {
                                    Capsule().fill(Color.gray.opacity(0.4)).matchedGeometryEffect(id: "modeHighlight", in: animation)
                                }
                            }
                    }
                }.padding(.horizontal, 10)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .frame(maxWidth: 240)
                    .shadow(color: .black.opacity(0.3), radius: 10)
                    .padding(10)
            }
        }
    }
        
    
    func sendLedRequestDebounce(turnOn: Bool, mode: Int) {
        workItem?.cancel()
        
        let item = DispatchWorkItem {
            sendLedRequest(turnOn: turnOn, mode: mode)
        }
        
        workItem = item
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
    }
    
    
    
    func sendLedRequest(turnOn: Bool, mode: Int) {
        
        if let baseURL = URL(string: "YOUR_IP_ADDRES") {
            
            var URLComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            URLComponents?.queryItems = [
                URLQueryItem(name: "turnOn", value: turnOn ? "on" : "off"),
                URLQueryItem(name: "mode", value: "\(mode)")
            ]
            
            
            guard let URL = URLComponents?.url else {
                print("Invalid URL!")
                return
            }
            
            
            var request = URLRequest(url: URL)
            request.httpMethod = "GET"
            
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("[Network Error] : ", error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("[Network Error] : Invalid response type.")
                    return
                }
                
                if httpResponse.statusCode != 200 {
                    print("[Network Error] : Status code is not 200.")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(LedResponse.self, from: data)
                    print("Response: \(decoded.message)")
                } catch {
                    print("JSON decoding failed.")
                }
                
                
            }.resume()
            
        } else {
            print("Invalid URL!")
        }
    }
    

}

#Preview {
    ContentView()
}
