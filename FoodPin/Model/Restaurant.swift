//
//  Restaurant.swift
//  FoodPin
//
//  Created by  He on 2025/11/30.
//

import Foundation

struct Restaurant: Hashable {
    enum Rating: String {
        case awesome
        case good
        case okay
        case bad
        case terrible
        
        var image: String {
            switch self {
            case .awesome: 
                return "love"
            case .good:
                return "cool"
            case .okay:
                return "happp"
            case .bad:
                return "sad"
            case .terrible:
                return "angry"
            }
        }
    }
    
    var name: String = ""
    var type: String = ""
    var location: String = ""
    var phone: String = ""
    var description: String = ""
    var image: String = ""
    var isFavorite: Bool = false
    var rating: Rating?
}
