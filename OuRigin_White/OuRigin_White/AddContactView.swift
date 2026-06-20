//
//  ContentView.swift
//  OuRigin
//
//  Created by Abigail Metanoia Melody on 17/04/26.
//

import SwiftUI
import PhotosUI

//VIEW
struct AddContactView: View {
    //Dynamic Variable
    @Binding var contacts: [Contact]
    @State var isEditing: Bool = false
    @State private var searchText = ""
    @State private var selectedPhoneNation: Nations = nations.first!
    @State private var selectedNation: Nations = nations.first!
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var showPicker = false
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var tag = ""
    
    @State private var isUserTypingCode = true
    @State private var isNationManuallyChanged = false
    
    
    //VARIABEL
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
    
    
    //FUNCTION
    func getNation(from code: String) -> Nations? {
        nations.first { $0.code == code }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                //UPLOAD PHOTO
                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(imageData == nil ? "Upload Photo" : "Change Photo")
                                    .foregroundColor(.primary)
                                
                                Text("Tap to select from gallery")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            ZStack {
                                if let data = imageData,
                                   let uiImage = UIImage(data: data) {
                                    
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                    
                                    Text("\(firstName.prefix(1))\(lastName.prefix(1))")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        }
                    }
                }
                
                //NAMA
                Section(header: Text("Basic Info")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    
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
                        TextField("Phone Number", text: $phone)
                            .keyboardType(.numberPad)
                            .onChange(of: phone) { _, newValue in
                                let numbersOnly = newValue.filter(\.isNumber)

                                if numbersOnly != newValue {
                                    phone = numbersOnly
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
                                            phone = strippedNumber

                                            isUserTypingCode = false
                                            return
                                        }
                                    }
                                }

                                if numbersOnly.count > 13 {
                                    phone = String(numbersOnly.prefix(13))
                                }
                            }
                            .padding(10)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    
                }
                
                //EMAIL
                Section(header: Text("Details")) {
                    TextField("Email", text: $email)
                    
                    nationPicker
                    
                    TextField("Tag", text: $tag)
                }
            }
            .navigationTitle("Add Contact")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let newContact = Contact(
                            firstName: firstName,
                            lastName: lastName,
                            phoneNumber: phone,
                            email: email,
                            nation: selectedNation.name,// dari picker nation
                            nationFlag: selectedNation.flag,
                            phoneCode: selectedPhoneNation.code, // dari phone
                            tag: tag,
                            imageData: imageData 
                        )
                        contacts.append(newContact)
                        dismiss()
                    }
                    .disabled(firstName.isEmpty || phone.isEmpty)
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        imageData = data
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

        }
    }
}

#Preview {
    AddContactView(contacts: .constant([]))
}

