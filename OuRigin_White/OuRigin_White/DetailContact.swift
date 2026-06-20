//
//  ContentView.swift
//  OuRigin
//
//  Created by Abigail Metanoia Melody on 17/04/26.
//

import SwiftUI



//VIEW
struct DetailContact: View {
    @Binding var contact: Contact
    @State private var goToEdit = false
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                LinearGradient(
                    colors: [.blue.opacity(0.5), .white, .blue.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack(spacing: 24) {
                    
                    // PROFILE
                    VStack(spacing: 12) {
                        ZStack {
                            if let data = contact.imageData,
                               let uiImage = UIImage(data: data) {
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                
                                Text(contact.initials)
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        )
                        
                        VStack(spacing: 4) {
                            Text(contact.fullName)
                                .font(.title2)
                                .bold()
                            
                            Text(contact.phoneFlag + " " + contact.phoneCode + contact.phoneNumber)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top)
                    
                    
                    // INFO CARD
                    VStack(spacing: 0) {
                        
                        DetailRow(
                            icon: "envelope.fill",
                            title: "Email",
                            value: contact.email
                        )
                        
                        Divider()
                        
                        DetailRow(
                            icon: "globe",
                            title: "Nation",
                            value: "\(contact.nation) \(contact.nationFlag)"
                        )
                        
                        Divider()
                        
                        DetailRow(
                            icon: "tag.fill",
                            title: "Tag",
                            value: contact.tag
                        )
                    }
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }
            }
            


        }
        .safeAreaInset(edge: .bottom) {
            
            Button {
                goToEdit = true
            } label: {
                Text("Edit Contact")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding()
        }
        .navigationTitle("Detail Contact")
        .navigationBarTitleDisplayMode(.inline)

        .sheet(isPresented: $goToEdit) {
            EditContactView(contact: $contact)
        }
    }
}

#Preview {
    DetailContact(contact: .constant(
        Contact(
            firstName: "Farhan",
            lastName: "Ridwan",
            phoneNumber: "8123456789",
            email: "farhan@gmail.com",
            nation: "Indonesia",
            nationFlag: "🇮🇩",
            phoneCode: "+62",
            tag: "Friend",
        )
    ))
}


#Preview {
    EditContactView(contact: .constant(
        Contact(
            firstName: "Farhan",
            lastName: "Ridwan",
            phoneNumber: "8123456789",
            email: "farhan@gmail.com",
            nation: "Indonesia",
            nationFlag: "🇮🇩",
            phoneCode: "+62",
            tag: "Friend",
        )
    ))
}


//MODEL
struct DetailRow: View {
    
    var icon: String
    var title: String
    var value: String
    
    var body: some View {
        
        HStack {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .frame(width: 20)
                
                Text(title)
            }
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
