//
//  Screen1View.swift
//  MyBaliApp
//
//  Created by Ivan on 03/03/26.
//

import SwiftUI

struct Screen1View: View {
    
    @State private var searchText = ""
    @State private var selectedFilter: String? = nil
    
    var filteredKos: [Kos] {
        
        kosList.filter { kos in
            
            let matchSearch =
            searchText.isEmpty ||
            kos.title.lowercased().contains(searchText.lowercased())
            
            let matchFilter: Bool
            
            switch selectedFilter {
            case "Near ADA":
                matchFilter = kos.distance <= 600
                
            case "< 1.5 mio":
                matchFilter = kos.price <= 1.5
                
            case "Female":
                matchFilter = kos.gender == "Female"
                
            case "Mixed":
                matchFilter = kos.gender == "Mixed"
                
            default:
                matchFilter = true
            }
            
            return matchSearch && matchFilter
        }
    }
    
    var body: some View {
        
        NavigationStack{
            
            VStack(alignment: .leading) {
                
                // HEADER
                HStack {
                    VStack(alignment: .leading) {
                        Text("ADAKos")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Find your comfortable place near the Academy!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
//                    
//                    ZStack {
//                        Circle()
//                            .fill(.secondary.opacity(0.3))
//                            .frame(width: 40, height: 40)
//                            .shadow(radius: 5)
//                            .glassEffect()
//                        
//                        Image(systemName: "person.fill")
//                            .foregroundColor(.white)
//                    }
                }.padding()
                
                
                // SEARCH BAR
                HStack{
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $searchText)
                        
//                        Image(systemName: "mic")
//                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(Capsule())
                    .glassEffect()
                    
                    
//                    ZStack {
//                        Circle()
//                            .fill(.white)
//                            .frame(width: 45, height: 45)
//                            .glassEffect()
//
//                        Image(systemName: "line.3.horizontal.decrease")
//                            .foregroundColor(.gray)
//                    }
                }.padding()
                
                
                // FILTER CHIP
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 15) {
                        FilterChip(
                            text: "Near ADA",
                            selected: selectedFilter == "Near ADA"
                        ) {
                            selectedFilter = "Near ADA"
                        }
                        
                        FilterChip(
                            text: "< 1.5 mio",
                            selected: selectedFilter == "< 1.5 mio"
                        ) {
                            selectedFilter = "< 1.5 mio"
                        }
                        
                        FilterChip(
                            text: "Female",
                            selected: selectedFilter == "Female"
                        ) {
                            selectedFilter = "Female"
                        }
                        FilterChip(
                            text: "Mixed",
                            selected: selectedFilter == "Mixed"
                        ) {
                            selectedFilter = "Mixed"
                        }
                    }
                }.padding(.horizontal)
            
                
                

                
                
                // CARD LIST
                ScrollView {
                    // TITLE
                    Text("Recommendations")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 10) {
                        
                        ForEach(filteredKos) { kos in
                            
                            NavigationLink {
                                Screen2View(kos: kos)
                            } label: {
                                KosCard(
                                    image: kos.image,
                                    title: kos.title,
                                    distance: "\(kos.distance)m from Academy",
                                    price: "\(kos.price) mio / month",
                                    info: "\(kos.gender) - \(kos.facilities)"
                                )
                            }
                        }
                    }
                }.padding()
                
            }
        }
    }
    
    //COMPONENTS
    struct FilterChip: View {
        
        var text: String
        var selected: Bool
        var action: () -> Void
        
        var body: some View {
            Text(text)
                .foregroundStyle(selected ? .white : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(selected ? Color.blue : Color.white)
                        .shadow(radius: 2)
                )
                .onTapGesture {
                    action()
                }
        }
    }
    
    struct KosCard: View {
        
        var image: String
        var title: String
        var distance: String
        var price: String
        var info: String
        
        var body: some View {
            
            HStack(spacing: 5) {
                
                
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 150)
                    .clipped()
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 20
                        )
                    )
                
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text(title)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                    
                    HStack(spacing: 5) {
                        Image(systemName: "figure.walk")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text(distance)
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                    
                    Text(price)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .bold()
                    
                    Text(info)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    
                }.padding()
                
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .padding()
                
            }
            .frame(height: 150)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(5)
            .shadow(radius: 4)
            .fixedSize(horizontal: true, vertical: false)
            
        }
    }
}


#Preview {
    Screen1View()

}
