//
//  Nations.swift
//  OuRigin_White
//
//  Created by Abigail Metanoia Melody on 23/04/26.
//

import Foundation

struct Nations: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let flag: String
    let code: String
    
    var displayName: String {
        "\(flag) \(name)"
    }
}

// GLOBAL DATA (bisa dipakai di semua View)
let nations: [Nations] = [
    Nations(name: "Indonesia", flag: "🇮🇩", code: "+62"),
    Nations(name: "Singapore", flag: "🇸🇬", code: "+65"),
    Nations(name: "Malaysia", flag: "🇲🇾", code: "+60"),
    Nations(name: "Thailand", flag: "🇹🇭", code: "+66"),
    Nations(name: "Philippines", flag: "🇵🇭", code: "+63"),
    Nations(name: "Vietnam", flag: "🇻🇳", code: "+84"),
    Nations(name: "Japan", flag: "🇯🇵", code: "+81"),
    Nations(name: "South Korea", flag: "🇰🇷", code: "+82"),
    Nations(name: "China", flag: "🇨🇳", code: "+86"),
    Nations(name: "India", flag: "🇮🇳", code: "+91"),

    Nations(name: "Germany", flag: "🇩🇪", code: "+49"),
    Nations(name: "Netherlands", flag: "🇳🇱", code: "+31"),
    Nations(name: "France", flag: "🇫🇷", code: "+33"),
    Nations(name: "Italy", flag: "🇮🇹", code: "+39"),
    Nations(name: "Spain", flag: "🇪🇸", code: "+34"),
    Nations(name: "United Kingdom", flag: "🇬🇧", code: "+44"),

    Nations(name: "United States", flag: "🇺🇸", code: "+1"),
    Nations(name: "Canada", flag: "🇨🇦", code: "+1"),
    Nations(name: "Brazil", flag: "🇧🇷", code: "+55"),
    Nations(name: "Mexico", flag: "🇲🇽", code: "+52"),

    Nations(name: "Australia", flag: "🇦🇺", code: "+61"),
    Nations(name: "New Zealand", flag: "🇳🇿", code: "+64")
]
