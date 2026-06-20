//
//  ContentView.swift
//  OuRigin
//
//  Created by Abigail Metanoia Melody on 17/04/26.
//

import SwiftUI



//VIEW
struct MainScreen: View {
    //PARA STATE VAR (UPDATABLE VARIABLE)
    @State private var selectedContact: Contact? = nil
    @State private var selectedFilter: String? = "All"
    @State private var searchText = ""
    @State private var showAddContact = false
    @State private var contactToDelete: Contact?
    @State private var showDeleteAlert = false

    @State var user: User
    
    //DATA KONTAK
    @State var contacts: [Contact] = [
        Contact(
            firstName: "Farhan",
            lastName: "Ridwan",
            phoneNumber: "81233948202",
            email: "farhan@gmail.com",
            nation: "Indonesia",
            nationFlag: "🇮🇩",
            phoneCode:"+62",
            tag: "ADA",
        ),
        Contact(
            firstName: "Robin",
            lastName: "Van Resie",
            phoneNumber: "612320938402",
            email: "robin@gmail.com",
            nation: "Netherlands",
            nationFlag: "🇳🇱",
            phoneCode:"+31",
            tag: "SMAN 15",

        ),
        Contact(
            firstName: "Aobin",
            lastName: "Van",
            phoneNumber: "61233042834023",
            email: "robin@gmail.com",
            nation: "Brazil",
            nationFlag: "🇧🇷",
            phoneCode:"+55",
            tag: "Friend",

        ),
        Contact(
            firstName: "Abhinaya",
            lastName: "Setyawan",
            phoneNumber: "61232398403482",
            email: "abie@gmail.com",
            nation: "Brazil",
            nationFlag: "🇧🇷",
            phoneCode:"+55",
            tag: "Boyfriend",
        ),
        Contact(
            firstName: "Bani",
            lastName: "Lewi",
            phoneNumber: "61232398403482",
            email: "bani@gmail.com",
            nation: "Germany",
            nationFlag: "🇩🇪",
            phoneCode:"+49",
            tag: "Boyfriend",

        ),
        Contact(
            firstName: "Artem",
            lastName: "Numerouno",
            phoneNumber: "61238129381",
            email: "robin@gmail.com",
            nation: "Italy",
            nationFlag: "🇮🇹",
            phoneCode:"+39",
            tag: "PT CAHAYA",
        )
    ]
    
    
    //FUNCTION
    func deleteContact(at offsets: IndexSet, key: String) {
        let contactsInSection = groupedContacts[key] ?? []
        
        for offset in offsets {
            let contact = contactsInSection[offset]
            
            if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
                contacts.remove(at: index)
            }
        }
    }
    
    func flag(from countryCode: String) -> String {
        countryCode
            .unicodeScalars
            .map { 127397 + $0.value }
            .compactMap { UnicodeScalar($0) }
            .map { String($0) }
            .joined()
    }
    
    func getNation(from code: String) -> Nations? {
        nations.first { $0.code == code }
    }
    
    
    //PARA VAR VAR
    var sortedContacts: [Contact] {
        filteredContacts.sorted {
            $0.firstName < $1.firstName
        }
    }
    
    var groupedContacts: [String: [Contact]] {
        Dictionary(grouping: sortedContacts) {
            $0.sectionTitle.uppercased()
        }
    }
    
    var filteredContacts: [Contact] {
        var result = contacts

        // FILTER CHIP
        if let filter = selectedFilter, filter != "All" {
            result = result.filter {
                $0.phoneCode == filter
            }
        }

        // SEARCH
        if !searchText.isEmpty {
            result = result.filter {
                $0.fullName.lowercased().contains(searchText.lowercased())
            }
        }

        return result
    }
    
    var nationFilters: [NationFilter] {
        let grouped = Dictionary(grouping: contacts, by: { $0.phoneCode })
        
        let mapped = grouped.map { (code, _) in
            let nationFromCode = getNation(from: code)
            
            return NationFilter(
                name: nationFromCode?.name ?? "Unknown",
                flag: nationFromCode?.flag ?? "🌍",
                code: code
            )
        }
        
        let sorted = mapped.sorted { $0.name < $1.name }
        
        return [NationFilter(name: "All", flag: "🌎", code: "All")] + sorted
    }
    
    var localFriendsCount: Int {
        contacts.filter { $0.nation == user.nation }.count
    }

    var globalFriendsCount: Int {
        contacts.filter { $0.nation != user.nation }.count
    }

    var nationsCount: Int {
        Set(contacts.map { $0.nation }).count
    }
    
    var userContactBinding: Binding<Contact> {
        Binding(
            get: {
                user.asContact
            },
            set: { newValue in
                user.name = newValue.firstName
                user.lastname = newValue.lastName
                user.phoneNumber = newValue.phoneNumber
                user.nation = newValue.nation
                user.nationFlag = newValue.nationFlag
                user.imageData = newValue.imageData
                user.email = newValue.email
                user.phoneCode = newValue.phoneCode
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack{
                LinearGradient(
                    colors: [.blue.opacity(0.5), .white, .blue.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack{
                    
                    Text("OuRigin🌎")
                        .bold()
                        .font(.system(size: 36))
                        .padding(5)
                        .foregroundStyle(.blue)
                
                    //INFO CARD
                    HStack{
                        Cards(icon: "local_friends", title: "Local Friends", value: "\(localFriendsCount)", color: .white)
                        Cards(icon: "global_friends", title: "Global Friends", value: "\(globalFriendsCount)", color: .white)
                        Cards(icon: "countries", title: "Nations", value: "\(nationsCount)", color: .white)
                    }
                    
                    // FILTER CHIP
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(nationFilters) { nation in
                                FilterChip(
                                    text: "\(nation.flag) \(nation.name)",
                                    selected: selectedFilter == nation.code
                                ) {
                                    selectedFilter = nation.code
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(10)
                    
                    //SEARCH
                    .searchable(text: $searchText, prompt: "Search contacts...")
                    .saturation(1.5)
                    .autocorrectionDisabled(true)
                    
                    if groupedContacts.isEmpty {
                        Text("No contacts found")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    else{
                        List {
                            //User Section
                            Section(header: Text("My Card")) {
                                NavigationLink {
                                    DetailContact(contact: userContactBinding)
                                } label: {
                                    ContactRow(contact: user.asContact)
                                }
                                .padding(.horizontal,5)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .fill(Color.white.opacity(0.7))
//                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
//                                        
//                                )
                                .glassEffect(in: RoundedRectangle(cornerRadius: 15))
                            }.listRowBackground(Color.clear)
                            
                            ForEach(groupedContacts.keys.sorted(), id: \.self) { key in
                                Section(header: Text(key)) {
                                    ForEach(groupedContacts[key] ?? []) { contact in
                                        
                                        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
                                            NavigationLink {
                                                DetailContact(contact: $contacts[index])
                                            } label: {
                                                ContactRow(contact: contact)
                                            }
                                        }

                                    //ONDELETE STATE
                                    }.onDelete { indexSet in
                                        if let first = indexSet.first {
                                            let contact = groupedContacts[key]?[first]
                                            contactToDelete = contact
                                            showDeleteAlert = true
                                        }
                                    }
                                }
                                .sectionIndexLabel(key)
                            }
                            .padding(.horizontal,5)
                            .glassEffect(in: RoundedRectangle(cornerRadius: 15))
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.insetGrouped)
                        .listSectionIndexVisibility(.visible)
                        .scrollContentBackground(.hidden)
                        
                        //ADD CONTACTS
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    showAddContact = true
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    }

                    
                }
                
            }
                
        }

        .textInputAutocapitalization(.never)
        .sheet(isPresented: $showAddContact) {
            AddContactView(contacts: $contacts)
        }
        
        
        .alert("Delete Contact", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let contact = contactToDelete,
                   let index = contacts.firstIndex(of: contact) {
                    contacts.remove(at: index)
                }
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this contact?")
        }
            
    }
}

#Preview {
    MainScreen(user: User(
        name: "Abigail",
        lastname : "Metanoia",
        email: "abigailmetanoia17@gmail.com",
        phoneNumber: "812345678",
        nation: "Indonesia",
        nationFlag: "🇮🇩",
        imageData: nil,
        phoneCode:"+62"
    ))
}

//MODEL
struct User {
    var id = UUID()
    var name: String
    var lastname : String
    var email: String
    var phoneNumber: String
    var nation: String
    var nationFlag: String
    var imageData: Data?
    var phoneCode: String
    
    var initials: String {
        String(name.prefix(1))
    }
}

extension User {
    var asContact: Contact {
        Contact(
            firstName: name,
            lastName: lastname,
            phoneNumber: phoneNumber,
            email: email,
            nation: nation,
            nationFlag: nationFlag,
            phoneCode: phoneCode,
            tag: "Me",
            imageData: imageData,
        )
    }
}



struct Contact: Identifiable, Hashable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    
    //NATIONALITY
    var nation: String
    var nationFlag: String
    
    //PHONE ORIGIN
    var phoneCode: String
    var phoneFlag: String {
        nations.first { $0.code == phoneCode }?.flag ?? "🌍"
    }
    
    var tag: String
    var imageData: Data?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var initials: String {
        String(firstName.prefix(1) + lastName.prefix(1))
    }
    
    var sectionTitle: String {
        String(firstName.prefix(1))
    }
}

//COMPONENT
struct ContactRow: View {
    var contact: Contact
    
    var body: some View {
        HStack {
            
            ZStack {
                if let data = contact.imageData,
                   let uiImage = UIImage(data: data) {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.9))
                    
                    Text(contact.initials)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(contact.fullName)
                    .font(.headline)
                
                Text(contact.phoneCode + contact.phoneNumber)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(contact.phoneFlag)
        }
        .padding()
        
        
        
    }
}

//REUSABLE COMPONENTS
struct Cards: View {
    @State private var isPressed = false
    var icon: String
    var title: String
    var value: String
    var color : Color
    
    var body: some View {
        
        VStack(spacing: 10) {
            HStack{
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                Text(value)
                    .fontWeight(.black)
                    .font(.system(size: 28))
            }
            
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 14))
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isPressed ? Color.blue.opacity(0.25) : Color.white.opacity(0.2))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isPressed ? Color.blue : Color.white.opacity(0.5), lineWidth: 1)
        )
        .glassEffect(in: RoundedRectangle(cornerRadius: 15))
        .fontDesign(.rounded)

    }
}

struct NationFilter: Identifiable {
    let id = UUID()
    let name: String
    let flag: String
    let code: String
}

struct FilterChip: View {
    var text: String
    var selected: Bool
    var action: () -> Void
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(selected ? Color.blue.opacity(0.25) : Color.white.opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(selected ? Color.blue : Color.white.opacity(0.2), lineWidth: 1)
            )
            .glassEffect(in: RoundedRectangle(cornerRadius: 15))
            .onTapGesture {
                action()
            }
            
    }
}

struct MovingBlobBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Circle()
                .fill(Color.blue.opacity(0.6))
                .frame(width: 300)
                .blur(radius: 80)
//                .offset(x: animate ? -100 : 100, y: -150)
                .offset(x: 120, y: -150)

            Circle()
                .fill(Color.blue.opacity(0.6))
                .frame(width: 250)
                .blur(radius: 80)
//                .offset(x: animate ? 120 : -120, y: 200)
                .offset(x: -120, y: 200)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

