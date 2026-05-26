//
//  Screen2View.swift
//  MyBaliApp
//
//  Created by Ivan on 03/03/26.
//

import SwiftUI

struct Screen2View: View {
    var kos: Kos
    @Environment(\.openURL) var openURL
    @State private var isSaved = false
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                
                // HEADER IMAGE
                ZStack(alignment: .top) {
                    
                    Image(kos.image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 290)
                        .clipped()
                        .clipShape(
                            UnevenRoundedRectangle(
                                bottomLeadingRadius: 30,
                                bottomTrailingRadius: 30
                            )
                        )
                        .shadow(radius: 4)
                    
                    HStack{
                        
//                        // BACK BUTTON
//                        CircleButton(icon: "chevron.left")
                        
                        Spacer()
                        
                        //SHARE AND LIKE BUTTON
                        HStack(spacing: 10) {
                            CircleButton(icon: "square.and.arrow.up")
                            CircleButton(icon: "heart")
                        }
                    }
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // TITLE
                    VStack{
                        
                        HStack{
                            
                            Text(kos.title)
                                .font(.title)
                                .bold()
                            
                            Spacer()
                        }
                        
                        HStack {
                            
                            HStack(spacing: 5) {
                                Image(systemName: "figure.walk")
                                    .foregroundColor(.secondary)
                                
                                Text("\(kos.distance)m from Academy")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)

                                
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Capsule())
                            
                            Spacer()
                            
                            Text("\(kos.price) mio/month")
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green.opacity(0.2))
                                .clipShape(Capsule())
                        }
                    }
                    
                    
                    // FACILITIES
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Facilities")
                            .font(.title3)
                            .bold()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                
                                FacilityItem(icon: "wifi", title: "Wi-Fi")
                                FacilityItem(icon: "fork.knife", title: "Kitchen")
                                FacilityItem(icon: "air.conditioner.horizontal", title: "AC")
                                FacilityItem(icon: "figure.pool.swim", title: "Pool")
                                FacilityItem(icon: "table.furniture", title: "Desk")
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    // ADDRESS
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Adress")
                            .font(.title3)
                            .bold()
                        
                        HStack {
                            
                            HStack(spacing: 10) {
                                Image(systemName: "house")
                                Text("Jl. Jimbaran no 5A")
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button {
                                if let url = URL(string: "https://maps.google.com"){
                                    openURL(url)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "map")
                                    Text("Google Map")
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                        }
                        
                        Divider()
                    }
                    
                    
                    // CONTACTS
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Contacts")
                            .font(.title3)
                            .bold()
                        
                        HStack {
                            
                            HStack(spacing: 10) {
                                Image(systemName: "phone")
                                Text("08521983410")
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button {
                            } label: {
                                HStack {
                                    Image(systemName: "phone.circle")
                                    Text("Whatssapp")
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                        }
                        
                        Divider()
                    }
                    
                    
                    // ADD ON
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Adds On")
                            .font(.title3)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("- Car Park 50k/month")
                            Text("- Electricity 2.5k/kwh")
                            Text("- No Pets")
                        }
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            
            
            // SAVE OFFLINE BUTTON
            VStack{
                
                Spacer()
                

                Button {

                    let defaults = UserDefaults.standard
                    var saved = defaults.stringArray(forKey: "savedKos") ?? []

                    if saved.contains(kos.title) {
                        saved.removeAll { $0 == kos.title }
                        isSaved = false
                    } else {
                        saved.append(kos.title)
                        isSaved = true
                    }

                    defaults.set(saved, forKey: "savedKos")

                } label: {
                    HStack {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        Text(isSaved ? "Saved" : "Save Offline")
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()
                .onAppear {
                    let defaults = UserDefaults.standard
                    let saved = defaults.stringArray(forKey: "savedKos") ?? []

                    if saved.contains(kos.title) {
                        isSaved = true
                    }
                }
            }
        }
    }
}

//COMPONENTS
struct FacilityItem: View {
    
    var icon: String
    var title: String
    
    var body: some View {
        
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
            
            Text(title)
                .font(.caption)
        }
        .frame(width: 65, height: 65)
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CircleButton: View {
    
    var icon: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.3))
                .frame(width: 40, height: 40)
                .glassEffect()
            
            Image(systemName: icon)
                .foregroundColor(.white)
        }
    }
}



#Preview {
    Screen2View(kos: kosList[0])
}
