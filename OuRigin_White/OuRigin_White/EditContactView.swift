//
//  ContentView.swift
//  OuRigin
//
//  Created by Abigail Metanoia Melody on 17/04/26.
//

import SwiftUI
import PhotosUI


//VIEW
struct EditContactView: View {
    //Dynamic Value
    @State var isEditing: Bool = false
    @Binding var contact: Contact
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedCountryCode: String = ""
    @State private var selectedFlag: String = ""
    
    @State private var showAlert = false
    @State private var goToMain = false
    @State private var alertMessage = ""
    @State private var searchText = ""
    
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var showPicker = false
    
    @State private var isUserTypingCode = true
    @State private var isNationManuallyChanged = false
    
    
    //NATIONS LIST
    @State private var selectedNation: Nations = nations.first!
    @State private var selectedPhoneNation: Nations = nations.first!

    var nationPicker: some View {
        Picker("Nation", selection: $selectedNation) {
            ForEach(nations) { item in
                Text(item.displayName)
                    .tag(item)
            }
        }
        .onChange(of: selectedNation) { _, _ in
            isNationManuallyChanged = true
        }
    }
    
    //FUNCTION
    func getNation(from code: String) -> Nations? {
        nations.first { $0.code == code }
    }
    
    var filteredNations: [Nations] {
        if searchText.isEmpty {
            return nations
        } else {
            return nations.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.contains(searchText) ||
                $0.flag.contains(searchText)
            }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                // INFORMASI
                Section{
                    TextField("First Name", text: $contact.firstName)
                    TextField("Last Name", text: $contact.lastName)
                    // COUNTRY PICKER BUTTON
                    HStack{
                        Button {
                            showPicker = true
                        } label: {
                            HStack(spacing: 6) {
                                Text(selectedPhoneNation.flag)
                                Text(selectedPhoneNation.code)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                            
                            // PHONE NUMBER
                            TextField("Phone Number", text: $contact.phoneNumber)
                                .keyboardType(.numberPad)
                                .onChange(of: contact.phoneNumber) { _, newValue in
                                    let numbersOnly = newValue.filter(\.isNumber)

                                    if numbersOnly != newValue {
                                        phoneNumber = numbersOnly
                                        return
                                    }

                                    if numbersOnly.isEmpty {
                                        isUserTypingCode = true
                                    }

                                    // detect kalau user belum pilih manual
                                    if isUserTypingCode {
                                        for nation in nations.sorted(by: { $0.code.count > $1.code.count }) {
                                            let cleanCode = nation.code.replacingOccurrences(of: "+", with: "")

                                            if numbersOnly.hasPrefix(cleanCode) && numbersOnly.count > cleanCode.count {

                                                selectedPhoneNation = nation
                                                
                                                if !isNationManuallyChanged {
                                                    selectedNation = nation
                                                }
                                                
                                                let strippedNumber = String(numbersOnly.dropFirst(cleanCode.count))
                                                phoneNumber = strippedNumber

                                                isUserTypingCode = false
                                                return
                                            }
                                        }
                                    }

                                    if numbersOnly.count > 13 {
                                        phoneNumber = String(numbersOnly.prefix(13))
                                    }
                                }
                                .padding(10)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                }
                
                //UPLOAD FOTO
                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(contact.imageData == nil ? "Upload Photo" : "Change Photo")
                                    .foregroundColor(.primary)
                                
                                Text("Tap to select from gallery")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            // THUMBNAIL
                            ZStack {
                                if let data = contact.imageData,
                                   let uiImage = UIImage(data: data) {
                                    
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                    
                                    Text(contact.initials)
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        }
                        .padding(.vertical, 4)
                    }

                }
                
                // EMAIL
                Section(header: Text("Email")) {
                    TextField("Enter email", text: $contact.email)
                        .keyboardType(.emailAddress)
                }
                
                // NATION (DROPDOWN)
                Section(header: Text("Nation")) {
                    Picker("Select Nation", selection: $selectedNation) {
                        ForEach(nations) { item in
                            Text(item.displayName)
                                .tag(item)
                        }
                    }
                
                    // Update flag otomatis
                    .onChange(of: selectedNation) { _, newValue in
                        contact.nation = newValue.name
                        contact.nationFlag = newValue.flag
                    }
                    .onAppear {
                        if let match = nations.first(where: { $0.name == contact.nation }) {
                            selectedNation = match
                        }
                    }
                }
                
                // TAG
                Section(header: Text("Tag")) {
                    TextField("Enter tag", text: $contact.tag)
                }
            }
            .navigationTitle("Edit Contact")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        contact.phoneCode = selectedPhoneNation.code
                        dismiss()
                    }
                }
            }
            
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        contact.imageData = data
                    }
                }
            }
            
            .sheet(isPresented: $showPicker) {
                NavigationStack {
                    List(filteredNations) { country in
                        Button {
                            selectedPhoneNation = country
                            isUserTypingCode = false
                            showPicker = false
                        } label: {
                            HStack {
                                Text(country.flag)
                                Text(country.name)
                                Spacer()
                                Text(country.code)
                                    .foregroundColor(.secondary)
                            }
                        }                    }
                    .navigationTitle("Select Country")
                    .searchable(text: $searchText, prompt: "Search country or code")
                }
            }
            .onAppear {
                // Sync phone code
                if let match = nations.first(where: { $0.code == contact.phoneCode }) {
                    selectedPhoneNation = match
                }
                
                // Sync nation (kalau belum)
                if let match = nations.first(where: { $0.name == contact.nation }) {
                    selectedNation = match
                }
            }
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
            imageData: nil,
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
            imageData: nil,
        )
    ))
}



