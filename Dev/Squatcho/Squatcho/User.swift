//
//  User.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/20/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit
import CoreLocation

enum UserStatus {
    case leader
    case member
    case pending
    case null
}

class User {
    var id: String
    var emailAddress: String
    var teamName: String
    
    var phoneString: String
    //var phoneNumber: PhoneNumber
    var firstName: String
    var lastName: String
    var userStatus: UserStatus
    var currentLocation:CLLocationCoordinate2D //maybe dont need to store this in model?
    var signUpDate: Date
    
    init() {
        id = ""
        emailAddress = ""
        team = ""
        phoneString = ""
        firstName = ""
        lastName = ""
        userStatus = .null
        currentLocation = CLLocationCoordinate2D()
        signUpDate = Date()
    }
    
    init(email:String, id: String, status: UserStatus) {
        self.id = id
        emailAddress = email
        teamName = ""
        phoneString = ""
        firstName = ""
        lastName = ""
        userStatus = status
        currentLocation = CLLocationCoordinate2D()
        signUpDate = Date()
    }
    
    init(email:String, id: String, status: UserStatus, team: String) {
        self.id = id
        emailAddress = email
        teamName = team
        phoneString = ""
        firstName = ""
        lastName = ""
        userStatus = status
        currentLocation = CLLocationCoordinate2D()
        signUpDate = Date()
    }
    
    func changeStatus(to new:UserStatus) {
        userStatus = new
    }
    
    func updateCurrentLocation(lat:CLLocationDegrees, long:CLLocationDegrees) {
        currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func getSignUpDate() -> String {
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        let dateString = formatter.string(from: signUpDate) // October 8, 2016 at 10:48:53 PM
        return dateString
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    
    func isPwdLenth(password: String , confirmPassword : String) -> Bool {
        if password.characters.count <= 7 && confirmPassword.characters.count <= 7{
            return true
        }else{
            return false
        }
    }
    
    func format(phoneNumber sourcePhoneNumber: String) -> PhoneNumber? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        let phoneNum = PhoneNumber(country: leadingOne, area: areaCode, first3: prefix, last4: suffix)
        return phoneNum
        // return leadingOne + areaCode + prefix + "-" + suffix
    }

}

extension String.CharacterView {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

struct PhoneNumber {
    var countryCode: String
    var areaCode: String
    var firstThree: String
    var lastFour: String
    
    init(country:String, area:String, first3:String, last4:String) {
        countryCode = country
        areaCode = area
        firstThree = first3
        lastFour = last4
    }
    
    func toString() -> String {
        return "+\(countryCode) (\(areaCode)) \(firstThree)-\(lastFour)"
    }
}
