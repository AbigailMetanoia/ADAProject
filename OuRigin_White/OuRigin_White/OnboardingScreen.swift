//
//  ContentView.swift
//  OuRigin
//
//  Created by Abigail Metanoia Melody on 17/04/26.
//

import SwiftUI


//VIEW
struct OnboardingScreen: View {
    //Para Dynamic Variable
    @State private var showAlert = false
    @State private var goToMain = false
    @State private var alertMessage = ""
    @State private var searchText = ""
    
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var selectedNation: Nations = nations.first!
    @State private var showPicker = false
    @State private var isVisible = false
    @State private var isRotating = false
    
    var filteredNations: [Nations] {
        if searchText.isEmpty {
            return nations
        } else {
            return nations.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
//                LinearGradient(
//                    colors: [.white, .gray.opacity(0.2)],
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
                AnimatedGradientBackground()
                .ignoresSafeArea()
                VStack{
                    Image("onboarding_image")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 350, maxHeight: 350)
                        .padding()
                        .scaleEffect(isVisible ? 1 : 0.7)
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
                        .onAppear {
                            isVisible = true
                        }
                    VStack(alignment: .center, spacing: 5){
                        Text("Welcome to")
                            .font(.system(size: 24))
                            .bold()
                        Text("OuRigin🌎")
                            .font(.system(size: 58))
                            .bold()
                        Text("From local roots to global connections.")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundStyle(.black.opacity(0.5))
                    }.padding(20)

                    HStack {
                        
                        // NATIONS PICKER
                        Button {
                            showPicker = true
                        } label: {
                            HStack(spacing: 6) {
                                Text(selectedNation.flag)
                                Text(selectedNation.code)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            )

                        }
                        
                        // TEXTFIELD
                        TextField("Enter Your Phone Number", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .onChange(of: phoneNumber) { _, newValue in
                                // 1. Ambil angka saja
                                let numbersOnly = newValue.filter(\.isNumber)
                                
                                if numbersOnly != newValue {
                                    phoneNumber = numbersOnly
                                    return
                                }
                                
                                // 2. Detect kode negara
                                for nation in nations.sorted(by: { $0.code.count > $1.code.count }){
                                    let cleanCode = nation.code.replacingOccurrences(of: "+", with: "")
                                    
                                    if numbersOnly.hasPrefix(cleanCode) && numbersOnly.count > cleanCode.count {
                                        
                                        // Update negara
                                        selectedNation = nation
                                        
                                        // Ambil sisa nomor tanpa kode
                                        let strippedNumber = String(numbersOnly.dropFirst(cleanCode.count))
                                        
                                        phoneNumber = strippedNumber
                                        return
                                    }
                                }
                                
                                // 3. Limit panjang
                                if numbersOnly.count > 13 {
                                    phoneNumber = String(numbersOnly.prefix(13))
                                }
                            }
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
                        if phoneNumber.isEmpty {
                            showAlert = true
                        } else if phoneNumber.count < 10 {
                            alertMessage = "Phone number must be at least 10 digits"
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
                    
                    Text("Your number is used for verification and contact categorization.")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black.opacity(0.5))
                        .padding(.horizontal)
                        .opacity(0.6)
                        .sheet(isPresented: $showPicker) {
                            NavigationStack {
                                List(filteredNations) { nation in
                                    Button {
                                        selectedNation = nation
                                        showPicker = false
                                    } label: {
                                        HStack {
                                            Text(nation.flag)
                                            Text(nation.name)
                                            Spacer()
                                            Text(nation.code)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .navigationTitle("Select Country")
                                .searchable(text: $searchText, prompt: "Search country or code")
                            }
                        }
                        .alert("Invalid Input", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text(alertMessage)
                        }
                        .alert("Input Required", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text("Please enter your phone number first.")
                        }
                        .navigationDestination(isPresented: $goToMain) {
                            OnboardingScreen_2(
                                phoneNumber: phoneNumber,
                                phoneCode: selectedNation.code,
                                nationName: selectedNation.name,
                                nationFlag: selectedNation.flag

                            )
                        }
                    
                }
            }
            
        }
    }
}

#Preview {
    OnboardingScreen()
}

struct AnimatedGradientBackground: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            colors: [.blue.opacity(0.5), .white, .white.opacity(0.2)],
            startPoint: animate ? .topLeading : .topLeading,
            endPoint: animate ? .bottomTrailing : .bottomTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}
