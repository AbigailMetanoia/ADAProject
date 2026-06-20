//
//  ContentView.swift
//  OuRigin
//
//  Created by Abigail Metanoia Melody on 17/04/26.
//

import SwiftUI


//VIEW
struct OnboardingScreen_2: View {
    @State private var showAlert = false
    @State private var goToMain = false
    @State private var alertMessage = ""
    
    @State private var name = ""
    @State private var email = ""
    @State private var lastname = ""
    @State private var selectedNation: Nations = nations.first!
    @State private var showPicker = false
    
    var phoneNumber: String
    var phoneCode: String
    var nationName: String
    var nationFlag: String
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(
                    colors: [.blue.opacity(0.5), .white, .white.opacity(0.2)],
                    startPoint: .topLeading ,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack{
                    VStack{
                        Text("Please Fill Your Information Below")
                            .font(.system(size: 21))
                            .bold()
                    }.padding(20)
                    
                    VStack {
                        
                        // EMAIL
                        TextField("Email", text: $email)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        // NAMA
                        TextField("Your Name", text: $name)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            )


                    }
                    .padding(.horizontal)
                    
                    
                    Button {
                        if email.isEmpty {
                            alertMessage = "Email is required"
                            showAlert = true
                        } else if !isValidEmail(email) {
                            alertMessage = "Invalid email format"
                            showAlert = true
                        } else if name.isEmpty {
                            alertMessage = "Name is required"
                            showAlert = true
                        } else {
                            goToMain = true
                        }
                    } label: {
                        Text("Continue")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .padding()
                    
                    Text("Your information is used for verification.")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundStyle(.white)
                        .opacity(0.4)
                        .alert("Invalid Input", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text(alertMessage)
                        }
                        .alert("Input Required", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text("Please enter your name and email first.")
                        }
                        .navigationDestination(isPresented: $goToMain) {
                            MainScreen(user: User(
                                name: name,
                                lastname: lastname,
                                email: email,
                                phoneNumber: phoneNumber,
                                nation: nationName,
                                nationFlag: nationFlag,
                                phoneCode: phoneCode

                            ))
                        }
                    
                }
            }
            
        }
    }
}



#Preview {
    OnboardingScreen_2(phoneNumber: "12361726318", phoneCode: "+62", nationName: "Indonesia", nationFlag: "🇮🇩")
}


//FUNCTION
func isValidEmail(_ email: String) -> Bool {
    return email.contains("@") && email.contains(".")
}

